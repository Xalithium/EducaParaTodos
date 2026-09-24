package cl.ipchile.educaparatodos.controlador;

import cl.ipchile.educaparatodos.dao.CursoDAO;
import cl.ipchile.educaparatodos.dao.InscripcionDAO;
import cl.ipchile.educaparatodos.dao.MasivasDAO;
import cl.ipchile.educaparatodos.dao.UsuarioDAO;
import cl.ipchile.educaparatodos.modelo.Curso;
import cl.ipchile.educaparatodos.modelo.Inscripcion;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/operaciones")
public class MasivasServlet extends HttpServlet {
    private EntityManagerFactory fabrica;
    private MasivasDAO operaciones;
    private UsuarioDAO alumnos;
    private CursoDAO cursos;
    private InscripcionDAO inscripciones;

    @Override
    public void init() {
        fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
        operaciones = new MasivasDAO(fabrica);
        alumnos = new UsuarioDAO(fabrica);
        cursos = new CursoDAO(fabrica);
        inscripciones = new InscripcionDAO(fabrica);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        if (tipo == null || tipo.isBlank()) {
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones.jsp").forward(request, response);
        } else if ("alumnos".equals(tipo)) {
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones-alumnos.jsp").forward(request, response);
        } else if ("cursos".equals(tipo)) {
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones-cursos.jsp").forward(request, response);
        } else if ("inscripciones".equals(tipo)) {
            try {
                request.setAttribute("cursos", cursos.listar("", "", 1, "titulo"));
            } catch (PersistenceException e) {
                log("No se pudieron consultar los cursos para desinscribir", e);
                response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                request.setAttribute("error", "No pudimos consultar los cursos. Comprueba que MySQL esté iniciado.");
                request.getRequestDispatcher("/WEB-INF/vistas/operaciones.jsp").forward(request, response);
                return;
            }
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones-inscripciones.jsp").forward(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", "La operación no es válida.");
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            String accion = request.getParameter("accion");
            if ("revisar".equals(accion)) {
                revisar(request, response);
            } else if ("confirmar".equals(accion)) {
                confirmar(request, response);
            } else {
                throw new IllegalArgumentException("La acción no es válida.");
            }
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (PersistenceException e) {
            log("No se pudo ejecutar la operación masiva", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("error", "No pudimos completar la operación. Intenta nuevamente.");
            request.getRequestDispatcher("/WEB-INF/vistas/operaciones.jsp").forward(request, response);
        }
    }

    private void revisar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String operacion = request.getParameter("operacion");
        LocalDate fecha = null;
        int maximo = 0;
        Long cursoId = null;
        List<Long> ids;

        if ("retirarInscripciones".equals(operacion)) {
            cursoId = leerId(request.getParameter("curso"));
            Curso curso = cursos.buscar(cursoId);
            if (curso == null) {
                throw new IllegalArgumentException("Selecciona un curso existente.");
            }
            ids = operaciones.candidatosInscripciones(cursoId);
            request.getSession().setAttribute("tituloCursoPendiente", curso.getTitulo());
        } else {
            fecha = leerFecha(request.getParameter("fecha"));
            if ("desactivarCursos".equals(operacion)) {
                maximo = leerMaximo(request.getParameter("maximo"));
            }
            ids = operaciones.candidatos(operacion, fecha, maximo);
        }

        HttpSession sesion = request.getSession();
        sesion.setAttribute("revisionPendiente", UUID.randomUUID().toString());
        sesion.setAttribute("operacionPendiente", operacion);
        sesion.setAttribute("fechaPendiente", fecha);
        sesion.setAttribute("maximoPendiente", maximo);
        sesion.setAttribute("cursoPendiente", cursoId);
        sesion.setAttribute("idsPendientes", ids);

        List<String> nombres = new ArrayList<>();
        for (Long id : ids) {
            if ("desactivarAlumnos".equals(operacion)) {
                nombres.add("#" + id + " · " + alumnos.buscar(id).getNombre());
            } else if ("desactivarCursos".equals(operacion)) {
                nombres.add("#" + id + " · " + cursos.buscar(id).getTitulo());
            } else {
                Inscripcion inscripcion = inscripciones.buscar(id);
                nombres.add("#" + id + " · " + inscripcion.getUsuario().getNombre()
                        + " (" + inscripcion.getUsuario().getCorreo() + ")");
            }
        }
        request.setAttribute("candidatos", nombres);
        request.setAttribute("urlVolver", paginaDe(operacion));
        request.getRequestDispatcher("/WEB-INF/vistas/operaciones-confirmar.jsp")
                .forward(request, response);
    }

    private void confirmar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession sesion = request.getSession();
        String revision = (String) sesion.getAttribute("revisionPendiente");
        if (revision == null || !revision.equals(request.getParameter("revision"))) {
            throw new IllegalArgumentException(
                    "Esta vista previa ya no está vigente. Revisa las coincidencias nuevamente.");
        }

        String operacion = (String) sesion.getAttribute("operacionPendiente");
        LocalDate fecha = (LocalDate) sesion.getAttribute("fechaPendiente");
        Integer maximo = (Integer) sesion.getAttribute("maximoPendiente");
        Long cursoId = (Long) sesion.getAttribute("cursoPendiente");
        @SuppressWarnings("unchecked")
        List<Long> ids = (List<Long>) sesion.getAttribute("idsPendientes");
        limpiarVistaPrevia(sesion);

        if (operacion == null || ids == null) {
            throw new IllegalArgumentException("Revisa una vista previa antes de confirmar.");
        }
        int total;
        if ("retirarInscripciones".equals(operacion)) {
            total = operaciones.retirarInscripciones(cursoId, ids);
        } else {
            if (fecha == null || maximo == null) {
                throw new IllegalArgumentException("Revisa una vista previa antes de confirmar.");
            }
            total = operaciones.ejecutar(operacion, fecha, maximo, ids);
        }
        sesion.setAttribute("mensaje", "Operación completada. Registros afectados: " + total + ".");
        response.sendRedirect(request.getContextPath() + "/operaciones");
    }

    private LocalDate leerFecha(String valor) {
        try {
            return LocalDate.parse(valor);
        } catch (DateTimeParseException | NullPointerException e) {
            throw new IllegalArgumentException("Selecciona una fecha válida.");
        }
    }

    private int leerMaximo(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException | NullPointerException e) {
            throw new IllegalArgumentException("La cantidad máxima debe ser un número entero.");
        }
    }

    private Long leerId(String valor) {
        try {
            return Long.parseLong(valor);
        } catch (NumberFormatException | NullPointerException e) {
            throw new IllegalArgumentException("Selecciona un curso válido.");
        }
    }

    private String paginaDe(String operacion) {
        return switch (operacion) {
            case "desactivarAlumnos" -> "alumnos";
            case "desactivarCursos" -> "cursos";
            case "retirarInscripciones" -> "inscripciones";
            default -> "";
        };
    }

    private void limpiarVistaPrevia(HttpSession sesion) {
        sesion.removeAttribute("revisionPendiente");
        sesion.removeAttribute("operacionPendiente");
        sesion.removeAttribute("fechaPendiente");
        sesion.removeAttribute("maximoPendiente");
        sesion.removeAttribute("cursoPendiente");
        sesion.removeAttribute("tituloCursoPendiente");
        sesion.removeAttribute("idsPendientes");
    }

    @Override
    public void destroy() {
        if (fabrica != null && fabrica.isOpen()) {
            fabrica.close();
        }
    }
}
