package cl.ipchile.educaparatodos.dao;

import cl.ipchile.educaparatodos.modelo.*;
import java.time.LocalDate;
import jakarta.persistence.*;
import java.util.List;

public class InscripcionDAO {
    private final EntityManagerFactory fabrica;

    public InscripcionDAO(EntityManagerFactory fabrica) {
        this.fabrica = fabrica;
    }

    public List<Curso> disponibles(Long usuarioId) {
        try (EntityManager em = fabrica.createEntityManager()) {
            return em.createQuery("SELECT c FROM Curso c WHERE c.activo = true AND NOT EXISTS "
                    + "(SELECT i.id FROM Inscripcion i WHERE i.usuario.id = :usuario AND i.curso = c AND i.activa = true) "
                    + "ORDER BY c.titulo", Curso.class).setParameter("usuario", usuarioId).getResultList();
        }
    }
    public List<Inscripcion> delUsuario(Long id) {
        EntityManager em = fabrica.createEntityManager();
        try { return em.createQuery("SELECT i FROM Inscripcion i JOIN FETCH i.curso WHERE i.usuario.id = :id ORDER BY i.fechaInscripcion DESC, i.id DESC", Inscripcion.class).setParameter("id", id).getResultList(); }
        finally { em.close(); }
    }
    public List<Inscripcion> delCurso(Long id) {
        EntityManager em = fabrica.createEntityManager();
        try { return em.createQuery("SELECT i FROM Inscripcion i JOIN FETCH i.usuario WHERE i.curso.id = :id ORDER BY i.usuario.nombre", Inscripcion.class).setParameter("id", id).getResultList(); }
        finally { em.close(); }
    }
    public void inscribir(Long usuarioId, Long cursoId) {
        EntityManager em = fabrica.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Usuario u = em.find(Usuario.class, usuarioId);
            Curso c = em.find(Curso.class, cursoId);
            if (u == null || c == null) throw new IllegalArgumentException("Selecciona un usuario y un curso existentes.");
            if (!u.isActivo()) throw new IllegalArgumentException("Activa al usuario antes de inscribirlo.");
            if (!c.isActivo()) throw new IllegalArgumentException("Activa el curso antes de inscribir alumnos.");
            List<Inscripcion> anteriores = em.createQuery(
                    "SELECT i FROM Inscripcion i WHERE i.usuario.id = :usuario AND i.curso.id = :curso", Inscripcion.class)
                    .setParameter("usuario", usuarioId).setParameter("curso", cursoId).getResultList();
            if (anteriores.isEmpty()) {
                em.persist(new Inscripcion(u, c, LocalDate.now()));
            } else {
                Inscripcion inscripcion = anteriores.get(0);
                if (inscripcion.isActiva()) {
                    throw new IllegalArgumentException("El alumno ya está inscrito en ese curso.");
                }
                inscripcion.setActiva(true);
            }
            tx.commit();
        } catch (RuntimeException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }
    public void retirar(Long usuarioId, Long cursoId) {
        EntityManager em = fabrica.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int total = em.createQuery("UPDATE Inscripcion i SET i.activa = false WHERE i.usuario.id = :usuario AND i.curso.id = :curso AND i.activa = true")
                    .setParameter("usuario", usuarioId).setParameter("curso", cursoId).executeUpdate();
            if (total == 0) throw new IllegalArgumentException("La inscripción ya está retirada o no existe.");
            tx.commit();
        } catch (RuntimeException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally { em.close(); }
    }
}
