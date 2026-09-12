# EducaParaTodos

Proyecto académico de la asignatura **Desarrollo Web II de IPCHILE**, correspondiente a la evaluación del módulo 3, desarrollado por Gonzalo Tapia Vergara.

La propuesta consiste en desarrollar una plataforma web para una organización sin fines de lucro que ofrece cursos gratuitos a comunidades desfavorecidas. Permitirá consultar cursos y sus lecciones, registrar inscripciones y administrar usuarios y cursos.

## Objetivo

Aplicar los contenidos del curso mediante una aplicación web organizada en modelos, vistas y controladores, utilizando Java Persistence API (JPA) para el mapeo objeto-relacional y JPQL para las consultas y operaciones masivas.

## Funcionalidades previstas

- Crear, consultar, editar y eliminar usuarios y cursos, según las reglas del proyecto.
- Corregir el nombre y el correo electrónico de los usuarios.
- Añadir y quitar inscripciones manualmente, incluyendo matrículas tardías.
- Organizar las lecciones de cada curso.
- Buscar cursos por tema, nivel de dificultad y popularidad.
- Ejecutar actualizaciones y eliminaciones masivas de usuarios o cursos según criterios definidos.
- Incorporar páginas de inicio, búsqueda, perfil de usuario y detalle de curso.
- Adaptar las pantallas a dispositivos móviles y computadores.

La definición de popularidad, los campos editables de los cursos y los criterios de las operaciones masivas se establecerán durante el diseño del modelo de datos.

## Tecnologías propuestas

De acuerdo con los apuntes de la asignatura, se considera utilizar:

- Java y Servlets para procesar las solicitudes.
- JSP, HTML y CSS para las vistas.
- JPA para gestionar la persistencia.
- JPQL para consultar y modificar los datos.
- Git y GitHub para registrar el desarrollo.

El entorno inicial utiliza IntelliJ IDEA, JDK 21 con compilación para Java 17, Maven y Apache Tomcat 10.1.59. La base de datos se configurará en una etapa posterior.

## Desarrollo por etapas

1. Definir los requisitos y el alcance.
2. Preparar la estructura del proyecto y una primera página ejecutable.
3. Implementar las entidades y la conexión a la base de datos.
4. Desarrollar las operaciones CRUD de usuarios.
5. Desarrollar la gestión de cursos y lecciones.
6. Incorporar inscripciones y búsquedas con JPQL.
7. Implementar las operaciones masivas.
8. Revisar el diseño, probar el sistema y completar la documentación.

## Ejecución

Este avance contiene la portada en JSP y estilos adaptativos. El catálogo, las inscripciones y la base de datos se incorporarán en etapas posteriores.

### Desde IntelliJ IDEA

1. Abrir el proyecto y cargar los cambios de Maven.
2. Seleccionar JDK 21 como SDK y como JRE del ejecutor de Maven.
3. En la ventana Maven, utilizar **Execute Maven Goal** y ejecutar `package cargo:run`.
4. Esperar el inicio de Tomcat y abrir <http://localhost:8080/educaparatodos/>.
5. Para detenerlo, pulsar Stop en la ejecución.

La primera ejecución requiere internet para descargar las herramientas y Tomcat. No hace falta instalar Tomcat por separado. Se utiliza el puerto 8080, que debe estar libre, y el servidor solo escucha en el equipo local.

Si Maven está instalado en la terminal, ejecutar:

```text
mvn package cargo:run
```

Después de modificar la página, detener y volver a ejecutar para reconstruirla. Los archivos generados quedan en `target/`, excluido de Git.

### Archivos iniciales

- `pom.xml`: compilación, empaquetado web e inicio de Tomcat.
- `src/main/webapp/index.jsp`: portada.
- `src/main/webapp/css/styles.css`: estilos adaptativos.
- `src/main/webapp/WEB-INF/web.xml`: página de inicio de la aplicación.

## Documentación de entrega

La entrega incluirá el código fuente y un documento explicativo con el diseño, el funcionamiento, capturas de las vistas y ejemplos de consultas JPQL ejecutadas.

## Material de referencia

- Enunciado de la evaluación EPE3.
- Apunte del módulo 1: Introducción a HTML5, CSS y GitHub.
- Apunte del módulo 2: Servlets, Java Beans y Java Persistence API.
- Apunte del módulo 3: Java Persistence API y patrón de arquitectura de software MVC.

- [Biblioteca_crud_test, de Sakhura](https://github.com/Sakhura/Biblioteca_crud_test): referencia conceptual para organizar el CRUD y sus pruebas.
- [EducaParaTodos de referencia, de Sakhura](https://github.com/Sakhura/educaParaTodos_ejemplo): orientación sobre el entorno web del módulo 3.
