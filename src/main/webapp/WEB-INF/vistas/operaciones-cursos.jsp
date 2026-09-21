<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Desactivar cursos | EducaParaTodos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
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
    <h1>Desactivar cursos</h1>
    <p>Se desactivarán los cursos publicados antes de la fecha indicada que no superen el máximo de inscritos activos.</p>
    <c:if test="${not empty error}"><p class="notice" role="alert"><c:out value="${error}" /></p></c:if>
    <form method="post" action="${pageContext.request.contextPath}/operaciones?tipo=cursos" class="edit-form">
        <input type="hidden" name="accion" value="revisar">
        <input type="hidden" name="operacion" value="desactivarCursos">
        <label for="fecha">Publicados antes de</label>
        <input id="fecha" name="fecha" type="date" required value="<c:out value='${param.fecha}'/>">
        <p>La fecha elegida no se incluye.</p>
        <label for="maximo">Máximo de inscritos activos</label>
        <input id="maximo" name="maximo" type="number" min="0" max="100000" required value="<c:out value='${empty param.maximo ? 0 : param.maximo}'/>">
        <button type="submit" class="button">Revisar cursos</button>
    </form>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
