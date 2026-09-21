<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inscripciones | EducaParaTodos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
    <a class="brand" href="${pageContext.request.contextPath}/admin">
        <span class="brand-mark" aria-hidden="true">e.</span> EducaParaTodos
    </a>
    <nav aria-label="Navegación principal">
        <a href="${pageContext.request.contextPath}/admin">Panel</a>
        <a href="${pageContext.request.contextPath}/alumnos" aria-current="page">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
        <a href="${pageContext.request.contextPath}/operaciones">Operaciones masivas</a>
        <a href="${pageContext.request.contextPath}/">Volver al sitio</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <a href="${pageContext.request.contextPath}/alumnos">← Volver a alumnos</a>
    <h1>Cursos del alumno</h1>
    <h2><c:out value="${alumno.nombre}" /></h2>
    <p><c:out value="${alumno.correo}" /> · ${alumno.activo ? 'Activo' : 'Inactivo'}</p>
    <c:if test="${not empty error}">
        <p class="notice" role="alert"><c:out value="${error}" /></p>
    </c:if>
    <c:if test="${not empty sessionScope.mensaje}">
        <p class="notice" role="status"><c:out value="${sessionScope.mensaje}" /></p>
        <c:remove var="mensaje" scope="session" />
    </c:if>
    <c:choose>
        <c:when test="${not alumno.activo}">
            <p class="notice">Para añadir una inscripción, activa primero al alumno desde Editar.</p>
        </c:when>
        <c:when test="${empty disponibles}">
            <p class="notice">No hay otros cursos activos disponibles para inscribir.</p>
        </c:when>
        <c:otherwise>
            <form method="post" action="${pageContext.request.contextPath}/inscripciones" class="edit-form">
                <input type="hidden" name="alumno" value="${alumno.id}">
                <input type="hidden" name="accion" value="inscribir">
                <label for="curso">Añadir un curso</label>
                <select id="curso" name="curso" required>
                    <option value="">Selecciona un curso</option>
                    <c:forEach var="curso" items="${disponibles}">
                        <option value="${curso.id}" ${param.curso == curso.id ? 'selected' : ''}><c:out value="${curso.titulo}" /></option>
                    </c:forEach>
                </select>
                <p>Si la inscripción estaba retirada, se reactivará conservando su fecha original.</p>
                <button type="submit" class="button">Inscribir alumno</button>
            </form>
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${empty inscripciones}">
            <p class="notice">Este alumno todavía no tiene inscripciones.</p>
        </c:when>
        <c:otherwise>
            <div class="table-container" role="region" aria-label="Inscripciones del alumno" tabindex="0">
                <table>
                    <caption>Inscripciones</caption>
                    <thead><tr><th scope="col">Curso</th><th scope="col">Fecha de inscripción</th><th scope="col">Estado</th><th scope="col">Acciones</th></tr></thead>
                    <tbody>
                    <c:forEach var="inscripcion" items="${inscripciones}">
                        <tr>
                            <th scope="row"><c:out value="${inscripcion.curso.titulo}" /><c:if test="${not inscripcion.curso.activo}"> (curso inactivo)</c:if></th>
                            <td><c:out value="${inscripcion.fechaInscripcion}" /></td>
                            <td>${inscripcion.activa ? 'Activa' : 'Retirada'}</td>
                            <td>
                                <c:if test="${inscripcion.activa}">
                                    <form method="post" action="${pageContext.request.contextPath}/inscripciones">
                                        <input type="hidden" name="alumno" value="${alumno.id}">
                                        <input type="hidden" name="curso" value="${inscripcion.curso.id}">
                                        <input type="hidden" name="accion" value="retirar">
                                        <button type="submit" class="button">Retirar inscripción</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
