package cl.ipchile.educaparatodos.controlador;

import cl.ipchile.educaparatodos.dao.CursoDAO;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/lecciones")
public class LeccionServlet extends HttpServlet {
    private EntityManagerFactory fabrica;
    private CursoDAO cursos;

    @Override
    public void init() {
        fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
        cursos = new CursoDAO(fabrica);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            var curso = cursos.buscar(idRequerido(request.getParameter("curso")));
            if (curso == null) {
                response.sendError(404, "No se encontró el curso.");
                return;
            }
            request.setAttribute("curso", curso);
            String accion = request.getParameter("accion");
            if ("editar".equals(accion)) {
                var leccion = cursos.leccion(idRequerido(request.getParameter("id")));
                if (leccion == null || !leccion.getCurso().getId().equals(curso.getId())) {
                    response.sendError(404, "No se encontró la lección en este curso.");
                    return;
                }
                request.setAttribute("leccion", leccion);
            }
            if ("editar".equals(accion) || "nuevo".equals(accion)) {
                request.getRequestDispatcher("/WEB-INF/vistas/leccion-form.jsp").forward(request, response);
            } else {
                request.setAttribute("lecciones", cursos.lecciones(curso.getId()));
                request.getRequestDispatcher("/WEB-INF/vistas/lecciones.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            response.sendError(400, e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudieron cargar las lecciones", e);
            response.sendError(503, "No pudimos cargar las lecciones. Intenta nuevamente.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("enviado", true);
        try {
            Long cursoId = idRequerido(request.getParameter("curso"));
            var curso = cursos.buscar(cursoId);
            if (curso == null) {
                response.sendError(404, "No se encontró el curso.");
                return;
            }
            request.setAttribute("curso", curso);
            String valorId = request.getParameter("id");
            Long id = valorId == null || valorId.isBlank() ? null : idRequerido(valorId);
            String estado = request.getParameter("activa");
            if (!"true".equals(estado) && !"false".equals(estado)) {
                throw new IllegalArgumentException("Selecciona un estado válido.");
            }
            int orden;
            try {
                orden = Integer.parseInt(request.getParameter("orden"));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("El orden debe ser un número entero entre 1 y 1000.");
            }
            cursos.guardarLeccion(id, cursoId, request.getParameter("titulo"),
                    request.getParameter("contenido"), orden, "true".equals(estado));
            request.getSession().setAttribute("mensaje", "Lección guardada correctamente.");
            response.sendRedirect(request.getContextPath() + "/lecciones?curso=" + cursoId);
            return;
        } catch (IllegalArgumentException e) {
            response.setStatus(400);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo guardar la lección", e);
            response.setStatus(503);
            request.setAttribute("error", "No pudimos guardar la lección. Intenta nuevamente.");
        }
        if (request.getAttribute("curso") == null) {
            response.sendError(response.getStatus(), "No se pudo consultar el curso.");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/vistas/leccion-form.jsp").forward(request, response);
    }

    private Long idRequerido(String valor) {
        try {
            long id = Long.parseLong(valor);
            if (id > 0) return id;
        } catch (NumberFormatException e) {
            // Cualquier identificador inválido muestra el mismo mensaje.
        }
        throw new IllegalArgumentException("El identificador no es válido.");
    }

    @Override
    public void destroy() {
        if (fabrica != null && fabrica.isOpen()) fabrica.close();
    }
}