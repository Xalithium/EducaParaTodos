<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Desinscribir un curso | EducaParaTodos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css?v=2">
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
    <a class="brand" href="${pageContext.request.contextPath}/admin"><span class="brand-mark" aria-hidden="true">e.</span> EducaParaTodos</a>
    <nav aria-label="Navegación principal">
        <a href="${pageContext.request.contextPath}/admin">Panel</a>
        <a href="${pageContext.request.contextPath}/alumnos">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
        <a href="${pageContext.request.contextPath}/operaciones" aria-current="page">Operaciones masivas</a>
        <a href="${pageContext.request.contextPath}/">Volver al sitio</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <a href="${pageContext.request.contextPath}/operaciones">← Volver a operaciones</a>
    <h1>Desinscribir un curso</h1>
    <p>Selecciona un curso para retirar todas sus inscripciones activas. Los registros y sus fechas se conservarán.</p>
    <c:if test="${not empty error}"><p class="notice" role="alert"><c:out value="${error}" /></p></c:if>
    <c:choose>
        <c:when test="${empty cursos}">
            <p class="notice">No hay cursos con alumnos inscritos.</p>
        </c:when>
        <c:otherwise>
            <form method="post" action="${pageContext.request.contextPath}/operaciones?tipo=inscripciones" class="edit-form">
                <input type="hidden" name="accion" value="revisar">
                <input type="hidden" name="operacion" value="retirarInscripciones">
                <label for="curso">Curso</label>
                <select id="curso" name="curso" required>
                    <option value="">Selecciona un curso</option>
                    <c:forEach var="curso" items="${cursos}">
                        <option value="${curso.id}" ${param.curso == curso.id ? 'selected' : ''}><c:out value="${curso.titulo}" /></option>
                    </c:forEach>
                </select>
                <button type="submit" class="button">Revisar inscripciones</button>
            </form>
        </c:otherwise>
    </c:choose>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
