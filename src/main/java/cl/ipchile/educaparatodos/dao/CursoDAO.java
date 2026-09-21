package cl.ipchile.educaparatodos.dao;

import cl.ipchile.educaparatodos.modelo.Curso;
import cl.ipchile.educaparatodos.modelo.Leccion;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.List;
import java.time.LocalDate;
import cl.ipchile.educaparatodos.util.Validacion;

public class CursoDAO {
    private final EntityManagerFactory fabrica;

    public CursoDAO(EntityManagerFactory fabrica) {
        this.fabrica = fabrica;
    }

    public List<Curso> listar(String tema, String nivel, int minimo, String orden) {
        if (minimo < 0) throw new IllegalArgumentException("El mínimo de inscritos no puede ser negativo.");
        if (!nivel.isEmpty()) Validacion.nivel(nivel);
        try (EntityManager manejador = fabrica.createEntityManager()) {
            String jpql = "SELECT c FROM Curso c LEFT JOIN c.inscripciones i ON i.activa = true "
                    + "WHERE (LOWER(c.tema) LIKE :tema OR LOWER(c.titulo) LIKE :tema) "
                    + "AND (:nivel = '' OR c.nivel = :nivel) "
                    + "GROUP BY c HAVING COUNT(i) >= :minimo ";
            jpql += "popularidad".equals(orden)
                    ? "ORDER BY COUNT(i) DESC, c.titulo, c.id" : "ORDER BY c.titulo, c.id";
            return manejador.createQuery(jpql, Curso.class)
                    .setParameter("tema", "%" + tema.strip().toLowerCase(java.util.Locale.ROOT) + "%")
                    .setParameter("nivel", nivel).setParameter("minimo", (long) minimo).getResultList();
        }
    }

    public java.util.Map<Long, Long> cantidadesInscritos() {
        try (EntityManager manejador = fabrica.createEntityManager()) {
            var filas = manejador.createQuery(
                    "SELECT i.curso.id, COUNT(i) FROM Inscripcion i WHERE i.activa = true GROUP BY i.curso.id", Object[].class)
                    .getResultList();
            java.util.Map<Long, Long> cantidades = new java.util.HashMap<>();
            for (Object[] fila : filas) {
                cantidades.put((Long) fila[0], (Long) fila[1]);
            }
            return cantidades;
        }
    }
    public Curso buscar(Long id) {
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return manejador.find(Curso.class, id);
        }
    }
    public Curso guardar(Long id, String titulo, String descripcion, String tema, String nivel, boolean activo) {
        titulo = Validacion.texto(titulo, "título", 150);
        descripcion = Validacion.texto(descripcion, "descripción", 2000);
        tema = Validacion.texto(tema, "tema", 80);
        if (id == null) nivel = Validacion.nivel(nivel);
        EntityManager em = fabrica.createEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Curso c;
            if (id == null) {
                c = new Curso(titulo, descripcion, tema, nivel, LocalDate.now());
                c.setActivo(activo);
                em.persist(c);
            } else {
                c = em.find(Curso.class, id);
                if (c == null) throw new IllegalArgumentException("No se encontró el curso.");
                c.setTitulo(titulo);
                c.setDescripcion(descripcion);
                c.setTema(tema);
                c.setActivo(activo);
                // La dificultad del curso se fija al crearlo.
            }
            tx.commit();
            return c;
        } catch (RuntimeException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }
    public List<Leccion> lecciones(Long cursoId) {
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return manejador.createQuery("SELECT l FROM Leccion l WHERE l.curso.id = :curso ORDER BY l.orden, l.id", Leccion.class)
                    .setParameter("curso", cursoId).getResultList();
        }
    }
    public Leccion leccion(Long id) {
        EntityManager em = fabrica.createEntityManager();
        try {
            List<Leccion> lista = em.createQuery("SELECT l FROM Leccion l JOIN FETCH l.curso WHERE l.id = :id", Leccion.class).setParameter("id", id).getResultList();
            return lista.isEmpty() ? null : lista.get(0);
        } finally { em.close(); }
    }
    public Leccion guardarLeccion(Long id, Long cursoId, String titulo, String contenido, int orden, boolean activa) {
        titulo = Validacion.texto(titulo, "título", 150);
        contenido = Validacion.texto(contenido, "contenido", 10000);
        if (orden < 1 || orden > 1000) throw new IllegalArgumentException("El orden debe estar entre 1 y 1000.");
        EntityManager em = fabrica.createEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Curso c = em.find(Curso.class, cursoId);
            if (c == null) throw new IllegalArgumentException("No se encontró el curso.");
            long repetidas = em.createQuery(
                    "SELECT COUNT(l) FROM Leccion l WHERE l.curso.id = :curso AND l.orden = :orden AND l.id <> :id", Long.class)
                    .setParameter("curso", cursoId).setParameter("orden", orden)
                    .setParameter("id", id == null ? -1L : id).getSingleResult();
            if (repetidas > 0) {
                throw new IllegalArgumentException("Ya existe una lección con ese orden en el curso. Elige otro número.");
            }
            Leccion l;
            if (id == null) {
                l = new Leccion(c, titulo, contenido, orden);
                em.persist(l);
            } else {
                l = em.find(Leccion.class, id);
                if (l == null || !l.getCurso().getId().equals(cursoId)) throw new IllegalArgumentException("La lección no pertenece a este curso.");
                l.setTitulo(titulo); l.setContenido(contenido); l.setOrden(orden);
            }
            l.setActiva(activa);
            tx.commit();
            return l;
        } catch (RuntimeException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }
}
