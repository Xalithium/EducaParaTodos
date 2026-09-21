package cl.ipchile.educaparatodos.controlador;

import cl.ipchile.educaparatodos.dao.UsuarioDAO;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/alumnos")
public class UsuarioServlet extends HttpServlet {
    private EntityManagerFactory fabrica;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
        usuarioDAO = new UsuarioDAO(fabrica);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("nuevo".equals(request.getParameter("accion"))) {
            request.getRequestDispatcher("/WEB-INF/vistas/alumno-form.jsp").forward(request, response);
            return;
        }
        try {
            if ("editar".equals(request.getParameter("accion"))) {
                Long id = leerId(request.getParameter("id"));
                if (id == null) {
                    throw new IllegalArgumentException("Falta identificar al alumno.");
                }
                var alumno = usuarioDAO.buscar(id);
                if (alumno == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró el alumno.");
                    return;
                }
                request.setAttribute("alumno", alumno);
                request.getRequestDispatcher("/WEB-INF/vistas/alumno-form.jsp").forward(request, response);
                return;
            }
            request.setAttribute("alumnos", usuarioDAO.listar());
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo consultar el listado de alumnos", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("error", "No pudimos cargar los alumnos. Intenta nuevamente en unos momentos.");
        }
        request.getRequestDispatcher("/WEB-INF/vistas/alumnos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        request.setAttribute("enviado", true);
        try {
            Long id = leerId(request.getParameter("id"));
            String estado = request.getParameter("activo");
            if (id != null && !"true".equals(estado) && !"false".equals(estado)) {
                throw new IllegalArgumentException("Selecciona un estado válido.");
            }
            usuarioDAO.guardar(id, request.getParameter("nombre"), request.getParameter("correo"),
                    "true".equals(estado));
            request.getSession().setAttribute("mensaje", id == null ? "Alumno registrado correctamente." : "Datos del alumno actualizados.");
            response.sendRedirect(request.getContextPath() + "/alumnos");
            return;
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo guardar el alumno", e);
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            request.setAttribute("error", "No pudimos guardar el alumno. Intenta nuevamente en unos momentos.");
        }
        request.getRequestDispatcher("/WEB-INF/vistas/alumno-form.jsp").forward(request, response);
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
        throw new IllegalArgumentException("El identificador del alumno no es válido.");
    }
    @Override
    public void destroy() {
        if (fabrica != null && fabrica.isOpen()) {
            fabrica.close();
        }
    }
}