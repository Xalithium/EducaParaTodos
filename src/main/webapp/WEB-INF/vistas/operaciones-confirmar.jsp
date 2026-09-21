<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Confirmar operación | EducaParaTodos</title>
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
    <a href="${pageContext.request.contextPath}/operaciones?tipo=${urlVolver}">← Cambiar criterio</a>
    <h1>Revisa antes de confirmar</h1>
    <c:choose>
        <c:when test="${sessionScope.operacionPendiente == 'desactivarAlumnos'}">
            <h2>Desactivar alumnos sin inscripciones activas</h2>
        </c:when>
        <c:when test="${sessionScope.operacionPendiente == 'desactivarCursos'}">
            <h2>Desactivar cursos según popularidad</h2>
            <p>Máximo de inscritos activos: <c:out value="${sessionScope.maximoPendiente}" />.</p>
        </c:when>
        <c:otherwise>
            <h2>Desinscribir alumnos del curso</h2>
            <p>Curso: <strong><c:out value="${sessionScope.tituloCursoPendiente}" /></strong>.</p>
        </c:otherwise>
    </c:choose>
    <c:if test="${sessionScope.operacionPendiente != 'retirarInscripciones'}">
        <p>Fecha anterior a <c:out value="${sessionScope.fechaPendiente}" />.</p>
    </c:if>
    <p>Coincidencias: <strong>${candidatos.size()}</strong>.</p>

    <c:choose>
        <c:when test="${empty candidatos}">
            <p class="notice">No hay coincidencias. No se harán cambios.</p>
        </c:when>
        <c:otherwise>
            <ul class="preview-list">
                <c:forEach var="nombre" items="${candidatos}">
                    <li><c:out value="${nombre}" /></li>
                </c:forEach>
            </ul>
            <c:choose>
                <c:when test="${sessionScope.operacionPendiente == 'retirarInscripciones'}">
                    <p>Estas inscripciones cambiarán a estado inactivo. Los alumnos, el curso y las fechas se conservarán.</p>
                </c:when>
                <c:otherwise>
                    <p>Todos estos registros cambiarán a estado inactivo. Sus datos relacionados se conservarán.</p>
                </c:otherwise>
            </c:choose>
            <form method="post" action="${pageContext.request.contextPath}/operaciones">
                <input type="hidden" name="accion" value="confirmar">
                <input type="hidden" name="revision" value="${sessionScope.revisionPendiente}">
                <div class="actions">
                    <button type="submit" class="button">Confirmar cambios</button>
                    <a href="${pageContext.request.contextPath}/operaciones?tipo=${urlVolver}">Cancelar</a>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
