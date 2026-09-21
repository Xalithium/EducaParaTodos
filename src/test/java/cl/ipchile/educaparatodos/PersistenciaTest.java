package cl.ipchile.educaparatodos;

import cl.ipchile.educaparatodos.dao.MasivasDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

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

    @Test
    void consultaLasVistasPreviasDeOperacionesMasivas() {
        try (EntityManagerFactory fabrica = Persistence.createEntityManagerFactory("educaparatodosPU")) {
            MasivasDAO operaciones = new MasivasDAO(fabrica);

            assertDoesNotThrow(() -> operaciones.candidatos(
                    "desactivarAlumnos", LocalDate.now(), 0));
            assertDoesNotThrow(() -> operaciones.candidatos(
                    "desactivarCursos", LocalDate.now(), 5));
            assertDoesNotThrow(() -> operaciones.candidatosInscripciones(1L));
        }
    }

    private long contar(EntityManager manejador, String entidad) {
        return manejador.createQuery("SELECT COUNT(e) FROM " + entidad + " e", Long.class)
                .getSingleResult();
    }
}
