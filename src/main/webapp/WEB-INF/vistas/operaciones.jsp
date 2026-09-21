<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Operaciones masivas | EducaParaTodos</title>
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
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
        <a href="${pageContext.request.contextPath}/operaciones" aria-current="page">Operaciones masivas</a>
        <a href="${pageContext.request.contextPath}/">Volver al sitio</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <p class="intro">Administración</p>
    <h1>Operaciones masivas</h1>
    <p>Selecciona la tarea que deseas realizar. Antes de cambiar datos verás una vista previa y deberás confirmarla.</p>

    <c:if test="${not empty error}">
        <p class="notice" role="alert"><c:out value="${error}" /></p>
    </c:if>
    <c:if test="${not empty sessionScope.mensaje}">
        <p class="notice" role="status"><c:out value="${sessionScope.mensaje}" /></p>
        <c:remove var="mensaje" scope="session" />
    </c:if>

    <div class="operation-menu">
        <section>
            <h2>Desactivar alumnos</h2>
            <p>Busca alumnos antiguos que no tengan inscripciones activas.</p>
            <a class="button" href="${pageContext.request.contextPath}/operaciones?tipo=alumnos">Elegir operación</a>
        </section>
        <section>
            <h2>Desactivar cursos</h2>
            <p>Busca cursos antiguos según su cantidad de inscritos activos.</p>
            <a class="button" href="${pageContext.request.contextPath}/operaciones?tipo=cursos">Elegir operación</a>
        </section>
        <section>
            <h2>Desinscribir un curso</h2>
            <p>Retira en una sola operación a todos los alumnos inscritos en un curso.</p>
            <a class="button" href="${pageContext.request.contextPath}/operaciones?tipo=inscripciones">Elegir operación</a>
        </section>
    </div>

    <section class="notice" aria-labelledby="conservacion">
        <h2 id="conservacion">Borrado lógico</h2>
        <p>Estas operaciones cambian el estado a inactivo. No borran alumnos, cursos, lecciones ni inscripciones.</p>
    </section>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
