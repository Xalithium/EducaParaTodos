package cl.ipchile.educaparatodos.controlador;

import cl.ipchile.educaparatodos.dao.InscripcionDAO;
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

@WebServlet("/inscripciones")
public class InscripcionServlet extends HttpServlet {
    private EntityManagerFactory fabrica;
    private InscripcionDAO inscripciones;
    private UsuarioDAO usuarios;

    @Override
    public void init() {
        fabrica = Persistence.createEntityManagerFactory("educaparatodosPU");
        inscripciones = new InscripcionDAO(fabrica);
        usuarios = new UsuarioDAO(fabrica);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long alumnoId = idRequerido(request.getParameter("alumno"));
            var alumno = usuarios.buscar(alumnoId);
            if (alumno == null) {
                response.sendError(404, "No se encontró el alumno.");
                return;
            }
            request.setAttribute("alumno", alumno);
            request.setAttribute("inscripciones", inscripciones.delUsuario(alumnoId));
            request.setAttribute("disponibles", inscripciones.disponibles(alumnoId));
            request.getRequestDispatcher("/WEB-INF/vistas/inscripciones.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            response.sendError(400, e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudieron consultar las inscripciones", e);
            response.sendError(503, "No pudimos cargar las inscripciones. Intenta nuevamente.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            Long alumnoId = idRequerido(request.getParameter("alumno"));
            Long cursoId = idRequerido(request.getParameter("curso"));
            String accion = request.getParameter("accion");
            if ("inscribir".equals(accion)) {
                inscripciones.inscribir(alumnoId, cursoId);
                request.getSession().setAttribute("mensaje", "Inscripción activada correctamente.");
            } else if ("retirar".equals(accion)) {
                inscripciones.retirar(alumnoId, cursoId);
                request.getSession().setAttribute("mensaje", "Inscripción retirada. Se conservan los datos.");
            } else {
                throw new IllegalArgumentException("La acción no es válida.");
            }
            response.sendRedirect(request.getContextPath() + "/inscripciones?alumno=" + alumnoId);
            return;
        } catch (IllegalArgumentException e) {
            response.setStatus(400);
            request.setAttribute("error", e.getMessage());
        } catch (PersistenceException e) {
            log("No se pudo guardar la inscripción", e);
            response.setStatus(503);
            request.setAttribute("error", "No pudimos guardar la inscripción. Intenta nuevamente.");
        }
        doGet(request, response);
    }

    private Long idRequerido(String valor) {
        try {
            long id = Long.parseLong(valor);
            if (id > 0) return id;
        } catch (NumberFormatException e) {
            // Se informa cualquier identificador inválido con el mismo mensaje.
        }
        throw new IllegalArgumentException("Selecciona un alumno y un curso válidos.");
    }

    @Override
    public void destroy() {
        if (fabrica != null && fabrica.isOpen()) fabrica.close();
    }
}