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
    <a href="${pageContext.request.contextPath}/lecciones?curso=${curso.id}">← Volver a lecciones</a>
    <h1>${not empty leccion or not empty param.id ? 'Editar lección' : 'Añadir lección'}</h1>
    <p><c:out value="${curso.titulo}" /></p>
    <c:if test="${not empty error}">
        <p class="notice" role="alert"><c:out value="${error}" /></p>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/lecciones" class="edit-form">
        <input type="hidden" name="curso" value="${curso.id}">
        <input type="hidden" name="id" value="<c:out value='${enviado ? param.id : leccion.id}'/>">
        <label for="titulo">Título</label>
        <input id="titulo" name="titulo" required maxlength="150" value="<c:out value='${enviado ? param.titulo : leccion.titulo}'/>">
        <label for="orden">Orden dentro del curso</label>
        <input id="orden" name="orden" type="number" min="1" max="1000" required value="<c:out value='${enviado ? param.orden : empty leccion ? 1 : leccion.orden}'/>">
        <label for="contenido-leccion">Contenido</label>
        <textarea id="contenido-leccion" name="contenido" rows="12" required maxlength="10000"><c:out value="${enviado ? param.contenido : leccion.contenido}" /></textarea>
        <p>Escribe texto sencillo. Se conservarán los saltos de línea.</p>
        <label for="activa">Estado</label>
        <select id="activa" name="activa" required>
            <option value="true" ${(enviado ? param.activa == 'true' : empty leccion or leccion.activa) ? 'selected' : ''}>Activa</option>
            <option value="false" ${(enviado ? param.activa == 'false' : not empty leccion and not leccion.activa) ? 'selected' : ''}>Inactiva</option>
        </select>
        <div class="actions">
            <button class="button" type="submit">Guardar lección</button>
            <a href="${pageContext.request.contextPath}/lecciones?curso=${curso.id}">Cancelar</a>
        </div>
    </form>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
