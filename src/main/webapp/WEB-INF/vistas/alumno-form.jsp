<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty alumno or not empty param.id ? 'Editar alumno' : 'Registrar alumno'} | EducaParaTodos</title>
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
    <a href="${pageContext.request.contextPath}/alumnos">← Volver a alumnos</a>
    <h1>${not empty alumno or not empty param.id ? 'Editar alumno' : 'Registrar alumno'}</h1>
    <p>Completa el nombre y el correo electrónico. El correo debe ser único.</p>
    <c:if test="${not empty error}">
        <p class="notice" role="alert"><c:out value="${error}" /></p>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/alumnos" class="edit-form">
        <input type="hidden" name="id" value="<c:out value='${enviado ? param.id : alumno.id}'/>">
        <label for="nombre">Nombre completo</label>
        <input id="nombre" name="nombre" required maxlength="100" autocomplete="name" value="<c:out value='${enviado ? param.nombre : alumno.nombre}'/>">
        <label for="correo">Correo electrónico</label>
        <input id="correo" name="correo" required type="email" maxlength="150" autocomplete="email" value="<c:out value='${enviado ? param.correo : alumno.correo}'/>">
        <c:if test="${not empty alumno or not empty param.id}">
            <label for="activo">Estado</label>
            <select id="activo" name="activo" required aria-describedby="ayuda-estado">
                <option value="true" ${(enviado ? param.activo == 'true' : alumno.activo) ? 'selected' : ''}>Activo</option>
                <option value="false" ${(enviado ? param.activo == 'false' : not alumno.activo) ? 'selected' : ''}>Inactivo</option>
            </select>
            <p id="ayuda-estado">Al desactivar al alumno se conservan sus datos e inscripciones.</p>
        </c:if>
        <div class="actions">
            <button class="button" type="submit">Guardar alumno</button>
            <a href="${pageContext.request.contextPath}/alumnos">Cancelar</a>
        </div>
    </form>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>