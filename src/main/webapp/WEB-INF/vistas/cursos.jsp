<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cursos | EducaParaTodos</title>
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
        <a href="${pageContext.request.contextPath}/alumnos">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos" aria-current="page">Cursos</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <p class="intro">Administración</p>
    <h1>Cursos</h1>
    <p>Consulta los cursos disponibles y su estado.</p>
    <a class="button" href="${pageContext.request.contextPath}/cursos?accion=nuevo">Crear curso</a>
    <c:if test="${not empty sessionScope.mensaje}">
        <p class="notice" role="status"><c:out value="${sessionScope.mensaje}" /></p>
        <c:remove var="mensaje" scope="session" />
    </c:if>
    <c:choose>
        <c:when test="${not empty error}">
            <p class="notice" role="alert"><c:out value="${error}" /></p>
            <a href="${pageContext.request.contextPath}/cursos">Volver a intentar</a>
        </c:when>
        <c:when test="${empty cursos}">
            <p class="notice">Todavía no hay cursos disponibles.</p>
        </c:when>
        <c:otherwise>
            <div class="table-container" role="region" aria-label="Listado de cursos" tabindex="0">
                <table>
                    <caption>Cursos disponibles</caption>
                    <thead>
                    <tr>
                        <th scope="col">Título</th>
                        <th scope="col">Tema</th>
                        <th scope="col">Nivel</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Acciones</th>

                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="curso" items="${cursos}">
                        <tr>
                            <th scope="row"><c:out value="${curso.titulo}" /></th>
                            <td><c:out value="${curso.tema}" /></td>
                            <td><c:out value="${curso.nivel}" /></td>
                            <td>${curso.activo ? 'Activo' : 'Inactivo'}</td>
                            <td><a href="${pageContext.request.contextPath}/cursos?accion=editar&amp;id=${curso.id}">Editar</a> · <a href="${pageContext.request.contextPath}/lecciones?curso=${curso.id}">Lecciones</a></td>
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