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
    <form method="get" action="${pageContext.request.contextPath}/cursos" class="edit-form course-filters">
        <div>
            <label for="tema">Tema o título</label>
            <input id="tema" name="tema" value="<c:out value='${param.tema}'/>">
        </div>
        <div>
            <label for="nivel">Nivel</label>
            <select id="nivel" name="nivel">
                <option value="">Todos</option>
                <c:forEach var="nivel" items="${['Básico', 'Intermedio', 'Avanzado']}">
                    <option value="${nivel}" ${param.nivel == nivel ? 'selected' : ''}>${nivel}</option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label for="minimo">Mínimo de inscritos</label>
            <input id="minimo" name="minimo" type="number" min="0" value="<c:out value='${empty param.minimo ? 0 : param.minimo}'/>">
        </div>
        <div>
            <label for="orden">Ordenar por</label>
            <select id="orden" name="orden">
                <option value="titulo">Título</option>
                <option value="popularidad" ${param.orden == 'popularidad' ? 'selected' : ''}>Más inscritos</option>
            </select>
        </div>
        <div class="actions">
            <button class="button" type="submit">Filtrar</button>
            <a href="${pageContext.request.contextPath}/cursos">Limpiar filtros</a>
        </div>
    </form>
    <p>La cantidad de inscritos considera las inscripciones activas.</p>
    <c:choose>
        <c:when test="${not empty error}">
            <p class="notice" role="alert"><c:out value="${error}" /></p>
            <a href="${pageContext.request.contextPath}/cursos">Volver a intentar</a>
        </c:when>
        <c:when test="${empty cursos}">
            <p class="notice">No se encontraron cursos con estos criterios.</p>
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
                        <th scope="col">Inscritos</th><th scope="col">Estado</th>
                        <th scope="col">Acciones</th>

                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="curso" items="${cursos}">
                        <tr>
                            <th scope="row"><c:out value="${curso.titulo}" /></th>
                            <td><c:out value="${curso.tema}" /></td>
                            <td><c:out value="${curso.nivel}" /></td>
                            <td>${empty cantidades[curso.id] ? 0 : cantidades[curso.id]}</td>
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