package cl.ipchile.educaparatodos.dao;

import cl.ipchile.educaparatodos.modelo.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.List;
import java.time.LocalDate;
import cl.ipchile.educaparatodos.util.Validacion;

public class UsuarioDAO {
    private final EntityManagerFactory fabrica;

    public UsuarioDAO(EntityManagerFactory fabrica) {
        this.fabrica = fabrica;
    }

    public List<Usuario> listar() {
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return manejador.createQuery("SELECT u FROM Usuario u ORDER BY u.nombre, u.id", Usuario.class)
                    .getResultList();
        }
    }

    public Usuario buscar(Long id) {
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return manejador.find(Usuario.class, id);
        }
    }

    public void guardar(Long id, String nombre, String correo, boolean activo) {
        nombre = Validacion.texto(nombre, "nombre", 100);
        correo = Validacion.correo(correo);
        try (EntityManager manejador = fabrica.createEntityManager()) {
            var transaccion = manejador.getTransaction();
            try {
                transaccion.begin();
                long existentes = manejador.createQuery(
                        "SELECT COUNT(u) FROM Usuario u WHERE u.correo = :correo AND u.id <> :id", Long.class)
                        .setParameter("correo", correo).setParameter("id", id == null ? -1L : id).getSingleResult();
                if (existentes > 0) {
                    throw new IllegalArgumentException("Ese correo ya está registrado. Revisa el listado de alumnos.");
                }
                if (id == null) {
                    manejador.persist(new Usuario(nombre, correo, LocalDate.now()));
                } else {
                    Usuario alumno = manejador.find(Usuario.class, id);
                    if (alumno == null) {
                        throw new IllegalArgumentException("No se encontró el alumno.");
                    }
                    alumno.setNombre(nombre);
                    alumno.setCorreo(correo);
                    alumno.setActivo(activo);
                }
                transaccion.commit();
            } catch (RuntimeException e) {
                if (transaccion.isActive()) {
                    transaccion.rollback();
                }
                throw e;
            }
        }
    }
}
