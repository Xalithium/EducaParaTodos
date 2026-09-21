<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="EducaParaTodos: una iniciativa para acercar la educación gratuita a más personas.">
    <title>EducaParaTodos | Aprender abre oportunidades</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al contenido</a>
<header class="site-header">
    <a class="brand" href="${pageContext.request.contextPath}/" aria-label="EducaParaTodos, inicio">
        <span class="brand-mark" aria-hidden="true">e.</span> EducaParaTodos
    </a>
    <nav aria-label="Navegación principal">
        <a href="#como-funciona">Cómo funciona</a>
        <a href="#nosotros">Nuestra misión</a>
        <a href="${pageContext.request.contextPath}/alumnos">Alumnos</a>
        <a href="${pageContext.request.contextPath}/cursos">Cursos</a>
    </nav>
</header>
<main id="contenido">
    <section class="hero" aria-labelledby="titulo">
        <div class="hero-copy">
            <p class="intro">Educación gratuita, más oportunidades</p>
            <h1 id="titulo">Siempre hay algo<br>nuevo por aprender.</h1>
            <p class="lead">Un espacio para desarrollar tus habilidades y avanzar a tu ritmo. Porque el acceso a la educación puede cambiar una historia.</p>
            <a class="button" href="#como-funciona">Conoce cómo funcionará <span aria-hidden="true">→</span></a>
        </div>
        <aside class="welcome" aria-labelledby="bienvenida">
            <span class="book" aria-hidden="true">A · B · C</span>
            <h2 id="bienvenida">Tu próximo paso<br>comienza aquí.</h2>
            <p>Estamos preparando nuestros primeros cursos gratuitos.</p>
            <p class="availability">Próximamente podrás consultar el catálogo y conocer sus contenidos.</p>
        </aside>
    </section>
    <section class="steps-section" id="como-funciona" aria-labelledby="pasos">
        <h2 id="pasos">Un camino sencillo para aprender</h2>
        <p>Así podrás participar cuando estén disponibles los cursos.</p>
        <ol class="steps">
            <li><h3>Encuentra tu curso</h3><p>Explora los temas y elige el nivel que se ajuste a lo que quieres aprender.</p></li>
            <li><h3>Inscríbete</h3><p>Solicita tu inscripción para acceder a las lecciones del curso.</p></li>
            <li><h3>Avanza a tu ritmo</h3><p>Consulta los contenidos y vuelve a ellos cuando lo necesites.</p></li>
        </ol>
    </section>
    <section class="mission" id="nosotros" aria-labelledby="mision">
        <h2 id="mision">La educación debe estar al alcance de todos.</h2>
        <p>EducaParaTodos es una iniciativa sin fines de lucro que busca acercar cursos gratuitos a comunidades con menos oportunidades de acceso a la educación.</p>
    </section>
</main>
<footer>EducaParaTodos · Educación gratuita y accesible</footer>
</body>
</html>
