package cl.ipchile.educaparatodos;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

class PersistenciaTest {

    @Test
    void consultaLasEntidadesConJpa() {
        try (EntityManagerFactory fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
             EntityManager manejador = fabrica.createEntityManager()) {

            assertDoesNotThrow(() -> contar(manejador, "Usuario"));
            assertDoesNotThrow(() -> contar(manejador, "Curso"));
            assertDoesNotThrow(() -> contar(manejador, "Leccion"));
            assertDoesNotThrow(() -> contar(manejador, "Inscripcion"));
        }
    }

    private long contar(EntityManager manejador, String entidad) {
        return manejador.createQuery("SELECT COUNT(e) FROM " + entidad + " e", Long.class)
                .getSingleResult();
    }
}
