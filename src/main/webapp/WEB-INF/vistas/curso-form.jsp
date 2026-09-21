<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty curso or not empty param.id ? 'Editar curso' : 'Crear curso'} | EducaParaTodos</title>
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
    <a href="${pageContext.request.contextPath}/cursos">← Volver a cursos</a>
    <h1>${not empty curso or not empty param.id ? 'Editar curso' : 'Crear curso'}</h1>
    <c:if test="${not empty error}">
        <p class="notice" role="alert"><c:out value="${error}" /></p>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/cursos" class="edit-form">
        <input type="hidden" name="id" value="<c:out value='${enviado ? param.id : curso.id}'/>">
        <label for="titulo">Título</label>
        <input id="titulo" name="titulo" required maxlength="150" value="<c:out value='${enviado ? param.titulo : curso.titulo}'/>">
        <label for="descripcion">Descripción</label>
        <textarea id="descripcion" name="descripcion" required maxlength="2000" rows="5"><c:out value="${enviado ? param.descripcion : curso.descripcion}" /></textarea>
        <label for="tema">Tema</label>
        <input id="tema" name="tema" required maxlength="80" value="<c:out value='${enviado ? param.tema : curso.tema}'/>">
        <c:choose>
            <c:when test="${empty curso and empty param.id}">
                <label for="nivel">Nivel</label>
                <select id="nivel" name="nivel" required>
                    <option value="">Selecciona un nivel</option>
                    <c:forEach var="nivel" items="${['Básico', 'Intermedio', 'Avanzado']}">
                        <option value="${nivel}" ${param.nivel == nivel ? 'selected' : ''}>${nivel}</option>
                    </c:forEach>
                </select>
                <p>El nivel queda fijo al crear el curso.</p>
            </c:when>
            <c:otherwise>
                <p>Nivel: <strong><c:out value="${curso.nivel}" /></strong>. No se modifica.</p>
            </c:otherwise>
        </c:choose>
        <label for="activo">Estado</label>
        <select id="activo" name="activo" required aria-describedby="ayuda-estado">
            <option value="true" ${(enviado ? param.activo == 'true' : empty curso or curso.activo) ? 'selected' : ''}>Activo</option>
            <option value="false" ${(enviado ? param.activo == 'false' : not empty curso and not curso.activo) ? 'selected' : ''}>Inactivo</option>
        </select>
        <p id="ayuda-estado">Al desactivar el curso se conservan sus lecciones e inscripciones.</p>
        <div class="actions">
            <button class="button" type="submit">Guardar curso</button>
            <a href="${pageContext.request.contextPath}/cursos">Cancelar</a>
        </div>
    </form>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>