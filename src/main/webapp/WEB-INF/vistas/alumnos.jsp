<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Alumnos | EducaParaTodos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
    <a class="brand" href="${pageContext.request.contextPath}/">
        <span class="brand-mark" aria-hidden="true">e.</span> EducaParaTodos
    </a>
    <nav aria-label="Navegación principal">
        <a href="${pageContext.request.contextPath}/">Inicio</a>
        <a href="${pageContext.request.contextPath}/alumnos" aria-current="page">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <p class="intro">Administración</p>
    <h1>Alumnos</h1>
    <p>Consulta los alumnos registrados y su estado.</p>
    <a class="button" href="${pageContext.request.contextPath}/alumnos?accion=nuevo">Registrar alumno</a>
    <c:if test="${not empty sessionScope.mensaje}">
        <p class="notice" role="status"><c:out value="${sessionScope.mensaje}" /></p>
        <c:remove var="mensaje" scope="session" />
    </c:if>
    <c:choose>
        <c:when test="${not empty error}">
            <p class="notice" role="alert"><c:out value="${error}" /></p>
            <a href="${pageContext.request.contextPath}/alumnos">Volver a intentar</a>
        </c:when>
        <c:when test="${empty alumnos}">
            <p class="notice">Todavía no hay alumnos registrados.</p>
        </c:when>
        <c:otherwise>
            <div class="table-container" role="region" aria-label="Listado de alumnos" tabindex="0">
                <table>
                    <caption>Alumnos registrados</caption>
                    <thead>
                    <tr>
                        <th scope="col">Nombre</th>
                        <th scope="col">Correo electrónico</th>
                        <th scope="col">Fecha de registro</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="alumno" items="${alumnos}">
                        <tr>
                            <th scope="row"><c:out value="${alumno.nombre}" /></th>
                            <td><c:out value="${alumno.correo}" /></td>
                            <td><c:out value="${alumno.fechaRegistro}" /></td>
                            <td>${alumno.activo ? 'Activo' : 'Inactivo'}</td>
                            <td><a href="${pageContext.request.contextPath}/alumnos?accion=editar&amp;id=${alumno.id}">Editar</a> · <a href="${pageContext.request.contextPath}/inscripciones?alumno=${alumno.id}">Cursos</a></td>
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