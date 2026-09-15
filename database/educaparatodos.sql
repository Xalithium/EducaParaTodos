-- Base de datos inicial del proyecto EducaParaTodos.
-- Al ejecutar este archivo, la base se crea nuevamente con datos de prueba.

DROP DATABASE IF EXISTS educaparatodos_gt;

CREATE DATABASE educaparatodos_gt
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE educaparatodos_gt;

CREATE TABLE usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    fecha_registro DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_usuario_correo UNIQUE (correo)
);

CREATE TABLE curso (
    id_curso BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    tema VARCHAR(80) NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE leccion (
    id_leccion BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_curso BIGINT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    orden INT NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_leccion_curso_orden UNIQUE (id_curso, orden),
    CONSTRAINT fk_leccion_curso FOREIGN KEY (id_curso)
        REFERENCES curso (id_curso)
        ON DELETE RESTRICT,
    CONSTRAINT chk_leccion_orden CHECK (orden > 0)
);

CREATE TABLE inscripcion (
    id_inscripcion BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_curso BIGINT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_inscripcion_usuario_curso UNIQUE (id_usuario, id_curso),
    CONSTRAINT fk_inscripcion_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT,
    CONSTRAINT fk_inscripcion_curso FOREIGN KEY (id_curso)
        REFERENCES curso (id_curso)
        ON DELETE RESTRICT
);

INSERT INTO usuario (nombre, correo, fecha_registro, activo) VALUES
    ('Ana Pérez', 'ana.perez@example.com', '2024-03-12', TRUE),
    ('Benjamín Soto', 'benjamin.soto@example.com', '2024-05-18', TRUE),
    ('Camila Rojas', 'camila.rojas@example.com', '2024-08-07', TRUE),
    ('Diego Morales', 'diego.morales@example.com', '2024-11-21', TRUE),
    ('Elena Fuentes', 'elena.fuentes@example.com', '2025-01-14', TRUE),
    ('Felipe Contreras', 'felipe.contreras@example.com', '2025-03-26', TRUE),
    ('Gabriela Muñoz', 'gabriela.munoz@example.com', '2025-06-09', TRUE),
    ('Héctor Silva', 'hector.silva@example.com', '2025-09-17', TRUE),
    ('Isidora Vargas', 'isidora.vargas@example.com', '2025-12-03', TRUE),
    ('Javier Torres', 'javier.torres@example.com', '2026-02-11', TRUE),
    ('Karen Díaz', 'karen.diaz@example.com', '2026-05-22', TRUE),
    ('Luis Herrera', 'luis.herrera@example.com', '2026-08-04', TRUE),
    ('María González', 'maria.gonzalez@example.com', '2024-02-08', FALSE),
    ('Nicolás Castro', 'nicolas.castro@example.com', '2024-06-30', FALSE),
    ('Olivia Reyes', 'olivia.reyes@example.com', '2025-04-19', FALSE);

INSERT INTO curso (titulo, descripcion, tema, nivel, fecha_publicacion, activo) VALUES
    ('Alfabetización digital básica',
     'Herramientas esenciales para utilizar un computador e internet de forma segura.',
     'Tecnología', 'Básico', '2025-03-10', TRUE),
    ('Comunicación efectiva',
     'Técnicas sencillas para expresar ideas y escuchar activamente.',
     'Comunicación', 'Intermedio', '2025-07-15', TRUE),
    ('Emprendimiento comunitario',
     'Planificación y organización de iniciativas que respondan a necesidades locales.',
     'Emprendimiento', 'Avanzado', '2026-03-02', TRUE),
    ('Bienestar y autocuidado',
     'Hábitos cotidianos para cuidar la salud física y emocional.',
     'Bienestar', 'Básico', '2024-08-20', FALSE);

INSERT INTO leccion (id_curso, titulo, contenido, orden, activa) VALUES
    (1, 'Conocer el computador', 'Partes principales del computador y su utilidad.', 1, TRUE),
    (1, 'Navegar de forma segura', 'Recomendaciones básicas para utilizar internet.', 2, TRUE),
    (1, 'Utilizar el correo electrónico', 'Creación, envío y organización de mensajes.', 3, TRUE),
    (2, 'Escucha activa', 'Prácticas para comprender antes de responder.', 1, TRUE),
    (2, 'Expresar una idea', 'Organización de mensajes claros y breves.', 2, TRUE),
    (2, 'Resolver desacuerdos', 'Estrategias respetuosas para buscar acuerdos.', 3, TRUE),
    (3, 'Detectar una necesidad', 'Observación de problemas y oportunidades de la comunidad.', 1, TRUE),
    (3, 'Definir una propuesta', 'Descripción del propósito y las personas beneficiadas.', 2, TRUE),
    (3, 'Organizar los recursos', 'Plan simple de tareas, tiempos y recursos disponibles.', 3, TRUE),
    (4, 'Crear una rutina saludable', 'Pequeños hábitos que pueden mantenerse en el tiempo.', 1, TRUE),
    (4, 'Reconocer el estrés', 'Señales frecuentes y acciones básicas de autocuidado.', 2, TRUE),
    (4, 'Construir redes de apoyo', 'Identificación de personas y organizaciones cercanas.', 3, TRUE);

INSERT INTO inscripcion (id_usuario, id_curso, fecha_inscripcion, activa) VALUES
    (1, 1, '2025-03-15', TRUE),
    (2, 1, '2025-03-17', TRUE),
    (3, 1, '2025-03-20', TRUE),
    (4, 1, '2025-04-02', TRUE),
    (5, 1, '2025-04-18', TRUE),
    (6, 1, '2025-05-06', TRUE),
    (7, 1, '2025-06-12', TRUE),
    (8, 1, '2025-09-20', TRUE),
    (9, 1, '2025-12-08', TRUE),
    (10, 1, '2026-02-14', TRUE),
    (1, 2, '2025-07-18', TRUE),
    (2, 2, '2025-07-19', TRUE),
    (3, 2, '2025-07-22', TRUE),
    (4, 2, '2025-08-01', TRUE),
    (5, 2, '2025-08-05', TRUE),
    (6, 2, '2025-08-11', TRUE),
    (7, 2, '2025-08-20', TRUE),
    (1, 3, '2026-03-05', TRUE),
    (2, 3, '2026-03-06', TRUE),
    (3, 3, '2026-03-11', TRUE),
    (4, 3, '2026-03-16', TRUE),
    (1, 4, '2024-08-25', FALSE),
    (2, 4, '2024-08-27', FALSE),
    (13, 4, '2024-09-03', FALSE);
