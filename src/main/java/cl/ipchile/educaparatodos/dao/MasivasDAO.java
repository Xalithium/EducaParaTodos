package cl.ipchile.educaparatodos.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Query;

import java.time.LocalDate;
import java.util.List;

public class MasivasDAO {
    private final EntityManagerFactory fabrica;

    public MasivasDAO(EntityManagerFactory fabrica) {
        this.fabrica = fabrica;
    }

    private String condicion(String operacion) {
        if (operacion == null) {
            throw new IllegalArgumentException("Selecciona una operación válida.");
        }
        return switch (operacion) {
            case "desactivarAlumnos" -> "u.activo = true AND u.fechaRegistro < :fecha "
                    + "AND NOT EXISTS (SELECT i.id FROM Inscripcion i "
                    + "WHERE i.usuario = u AND i.activa = true)";
            case "desactivarCursos" -> "c.activo = true AND c.fechaPublicacion < :fecha "
                    + "AND (SELECT COUNT(i.id) FROM Inscripcion i "
                    + "WHERE i.curso = c AND i.activa = true) <= :maximo";
            default -> throw new IllegalArgumentException("Selecciona una operación válida.");
        };
    }

    private void validar(String operacion, LocalDate fecha, int maximo) {
        condicion(operacion);
        if (fecha == null || fecha.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("La fecha debe ser hoy o anterior.");
        }
        if (maximo < 0 || maximo > 100000) {
            throw new IllegalArgumentException("La cantidad máxima debe estar entre 0 y 100000.");
        }
    }

    private void agregarParametros(Query consulta, String operacion, LocalDate fecha, int maximo) {
        consulta.setParameter("fecha", fecha);
        if ("desactivarCursos".equals(operacion)) {
            consulta.setParameter("maximo", maximo);
        }
    }

    private List<Long> candidatos(EntityManager manejador, String operacion,
                                  LocalDate fecha, int maximo) {
        boolean alumnos = "desactivarAlumnos".equals(operacion);
        String jpql = alumnos ? "SELECT u.id FROM Usuario u WHERE " : "SELECT c.id FROM Curso c WHERE ";
        jpql += condicion(operacion) + (alumnos ? " ORDER BY u.id" : " ORDER BY c.id");
        var consulta = manejador.createQuery(jpql, Long.class);
        agregarParametros(consulta, operacion, fecha, maximo);
        return consulta.getResultList();
    }

    public List<Long> candidatos(String operacion, LocalDate fecha, int maximo) {
        validar(operacion, fecha, maximo);
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return candidatos(manejador, operacion, fecha, maximo);
        }
    }

    public List<Long> candidatosInscripciones(Long cursoId) {
        if (cursoId == null) {
            throw new IllegalArgumentException("Selecciona un curso.");
        }
        try (EntityManager manejador = fabrica.createEntityManager()) {
            return candidatosInscripciones(manejador, cursoId);
        }
    }

    private List<Long> candidatosInscripciones(EntityManager manejador, Long cursoId) {
        return manejador.createQuery(
                        "SELECT i.id FROM Inscripcion i "
                                + "WHERE i.curso.id = :curso AND i.activa = true ORDER BY i.id",
                        Long.class)
                .setParameter("curso", cursoId)
                .getResultList();
    }

    public int retirarInscripciones(Long cursoId, List<Long> confirmadas) {
        if (cursoId == null || confirmadas == null) {
            throw new IllegalArgumentException("Revisa una vista previa antes de confirmar.");
        }
        try (EntityManager manejador = fabrica.createEntityManager()) {
            var transaccion = manejador.getTransaction();
            try {
                transaccion.begin();
                List<Long> actuales = candidatosInscripciones(manejador, cursoId);
                if (!actuales.equals(confirmadas)) {
                    throw new IllegalArgumentException(
                            "Los datos cambiaron. Revisa una nueva vista previa antes de confirmar.");
                }
                if (actuales.isEmpty()) {
                    transaccion.commit();
                    return 0;
                }

                int total = manejador.createQuery(
                                "UPDATE Inscripcion i SET i.activa = false "
                                        + "WHERE i.curso.id = :curso AND i.activa = true AND i.id IN :ids")
                        .setParameter("curso", cursoId)
                        .setParameter("ids", actuales)
                        .executeUpdate();
                if (total != actuales.size()) {
                    throw new IllegalArgumentException(
                            "Los datos cambiaron durante la operación. No se guardaron cambios.");
                }
                transaccion.commit();
                return total;
            } catch (RuntimeException e) {
                if (transaccion.isActive()) {
                    transaccion.rollback();
                }
                throw e;
            }
        }
    }

    public int ejecutar(String operacion, LocalDate fecha, int maximo,
                        List<Long> confirmados) {
        validar(operacion, fecha, maximo);
        try (EntityManager manejador = fabrica.createEntityManager()) {
            var transaccion = manejador.getTransaction();
            try {
                transaccion.begin();
                List<Long> actuales = candidatos(manejador, operacion, fecha, maximo);
                if (!actuales.equals(confirmados)) {
                    throw new IllegalArgumentException(
                            "Los datos cambiaron. Revisa una nueva vista previa antes de confirmar.");
                }
                if (actuales.isEmpty()) {
                    transaccion.commit();
                    return 0;
                }

                boolean alumnos = "desactivarAlumnos".equals(operacion);
                String jpql = alumnos
                        ? "UPDATE Usuario u SET u.activo = false WHERE " + condicion(operacion) + " AND u.id IN :ids"
                        : "UPDATE Curso c SET c.activo = false WHERE " + condicion(operacion) + " AND c.id IN :ids";
                Query consulta = manejador.createQuery(jpql);
                agregarParametros(consulta, operacion, fecha, maximo);
                consulta.setParameter("ids", actuales);
                int total = consulta.executeUpdate();
                if (total != actuales.size()) {
                    throw new IllegalArgumentException(
                            "Los datos cambiaron durante la operación. No se guardaron cambios.");
                }
                transaccion.commit();
                return total;
            } catch (RuntimeException e) {
                if (transaccion.isActive()) {
                    transaccion.rollback();
                }
                throw e;
            }
        }
    }
}
