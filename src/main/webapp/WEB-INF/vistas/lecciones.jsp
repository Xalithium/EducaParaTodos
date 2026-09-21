<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lecciones | EducaParaTodos</title>
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
        <a href="${pageContext.request.contextPath}/alumnos">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos" aria-current="page">Cursos</a>
        <a href="${pageContext.request.contextPath}/operaciones">Operaciones masivas</a>
        <a href="${pageContext.request.contextPath}/">Volver al sitio</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <a href="${pageContext.request.contextPath}/cursos">← Volver a cursos</a>
    <h1>Lecciones</h1>
    <h2><c:out value="${curso.titulo}" /></h2>
    <p><c:out value="${curso.descripcion}" /></p>
    <a class="button" href="${pageContext.request.contextPath}/lecciones?accion=nuevo&amp;curso=${curso.id}">Añadir lección</a>
    <c:if test="${not empty sessionScope.mensaje}">
        <p class="notice" role="status"><c:out value="${sessionScope.mensaje}" /></p>
        <c:remove var="mensaje" scope="session" />
    </c:if>
    <c:if test="${empty lecciones}">
        <p class="notice">Este curso todavía no tiene lecciones.</p>
    </c:if>
    <c:forEach var="leccion" items="${lecciones}">
        <article class="lesson">
            <h2><c:out value="${leccion.orden}" />. <c:out value="${leccion.titulo}" /></h2>
            <p>Estado: ${leccion.activa ? 'Activa' : 'Inactiva'} · <a href="${pageContext.request.contextPath}/lecciones?accion=editar&amp;curso=${curso.id}&amp;id=${leccion.id}">Editar lección</a></p>
            <details>
                <summary>Ver contenido</summary>
                <p class="lesson-content"><c:out value="${leccion.contenido}" /></p>
            </details>
        </article>
    </c:forEach>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
