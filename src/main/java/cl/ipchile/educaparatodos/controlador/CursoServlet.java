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

@WebServlet("/cursos")
public class CursoServlet extends HttpServlet {
    private EntityManagerFactory fabrica;
    private CursoDAO cursoDAO;

    @Override
    public void init() {
        fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
        cursoDAO = new CursoDAO(fabrica);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("nuevo".equals(request.getParameter("accion"))) {
            request.getRequestDispatcher("/WEB-INF/vistas/curso-form.jsp").forward(request, response);
            return;
        }
        try {
            if ("editar".equals(request.getParameter("accion"))) {
                Long id = leerId(request.getParameter("id"));
                if (id == null) {
                    throw new IllegalArgumentException("Falta identificar al curso.");
                }
                var curso = cursoDAO.buscar(id);
                if (curso == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró el curso.");
                    return;
                }
                request.setAttribute("curso", curso);
                request.getRequestDispatcher("/WEB-INF/vistas/curso-form.jsp").forward(request, response);
                return;
            }
            request.setAttribute("cursos", cursoDAO.listar());
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo consultar el listado de cursos", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("error", "No pudimos cargar los cursos. Intenta nuevamente en unos momentos.");
        }
        request.getRequestDispatcher("/WEB-INF/vistas/cursos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("enviado", true);
        try {
            Long id = leerId(request.getParameter("id"));
            String estado = request.getParameter("activo");
            if (!"true".equals(estado) && !"false".equals(estado)) {
                throw new IllegalArgumentException("Selecciona un estado válido.");
            }
            if (id != null) {
                request.setAttribute("curso", cursoDAO.buscar(id));
            }
            cursoDAO.guardar(id, request.getParameter("titulo"), request.getParameter("descripcion"),
                    request.getParameter("tema"), request.getParameter("nivel"),
                    "true".equals(estado));
            request.getSession().setAttribute("mensaje", id == null ? "Curso registrado correctamente." : "Datos del curso actualizados.");
            response.sendRedirect(request.getContextPath() + "/cursos");
            return;
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo guardar el curso", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("error", "No pudimos guardar el curso. Intenta nuevamente en unos momentos.");
        }
        request.getRequestDispatcher("/WEB-INF/vistas/curso-form.jsp").forward(request, response);
    }
    private Long leerId(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }
        try {
            long id = Long.parseLong(valor);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException e) {
            // Se muestra el mismo mensaje para cualquier identificador inválido.
        }
        throw new IllegalArgumentException("El identificador del curso no es válido.");
    }
    @Override
    public void destroy() {
        if (fabrica != null && fabrica.isOpen()) {
            fabrica.close();
        }
    }
}