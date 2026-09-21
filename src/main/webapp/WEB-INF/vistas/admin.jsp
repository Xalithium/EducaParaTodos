<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Administración | EducaParaTodos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css?v=2">
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
    <a class="brand" href="${pageContext.request.contextPath}/admin">
        <span class="brand-mark" aria-hidden="true">e.</span> EducaParaTodos
    </a>
    <nav aria-label="Navegación de administración">
        <a href="${pageContext.request.contextPath}/admin" aria-current="page">Panel</a>
        <a href="${pageContext.request.contextPath}/alumnos">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
        <a href="${pageContext.request.contextPath}/operaciones">Operaciones masivas</a>
        <a href="${pageContext.request.contextPath}/">Volver al sitio</a>
    </nav>
</header>
<main id="contenido" class="admin-page">
    <p class="intro">Administración</p>
    <h1>Panel de administración</h1>
    <p>Selecciona una sección para gestionar la información de la plataforma.</p>

    <div class="admin-menu">
        <section>
            <h2>Alumnos</h2>
            <p>Registra alumnos, corrige sus datos y administra sus inscripciones.</p>
            <a class="button" href="${pageContext.request.contextPath}/alumnos">Gestionar alumnos</a>
        </section>
        <section>
            <h2>Cursos</h2>
            <p>Crea cursos, actualiza su información y organiza sus lecciones.</p>
            <a class="button" href="${pageContext.request.contextPath}/cursos">Gestionar cursos</a>
        </section>
        <section>
            <h2>Operaciones masivas</h2>
            <p>Actualiza varios alumnos, cursos o inscripciones con confirmación previa.</p>
            <a class="button" href="${pageContext.request.contextPath}/operaciones">Ver operaciones</a>
        </section>
    </div>
</main>
<footer>EducaParaTodos · Panel de administración</footer>
</body>
</html>
