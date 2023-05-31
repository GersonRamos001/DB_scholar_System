create DATABASE sistema_escolar;

USE sistema_escolar;

CREATE SCHEMA UsuariosSistema;

CREATE TABLE UsuariosSistema.roles (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE UsuariosSistema.usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_rol INT,
    nombre_usuario VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT u_nombre_usuario UNIQUE (nombre_usuario),
    CONSTRAINT FK_usuario_rol FOREIGN KEY (id_rol)
    REFERENCES UsuariosSistema.roles(id_rol)
);


CREATE TABLE niveles_educativos (
    id_nivel_educativo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE facultades (
    id_facultad INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
);

CREATE TABLE especializaciones (
    id_especializacion INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE periodos (
    id_periodo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME,
    fecha_modificacion DATETIME,
);

CREATE TABLE tipo_calificaciones (
    id_tipo_calificacion INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE carreras (
    id_carrera INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    id_facultad INT NOT NULL,
    CONSTRAINT fk_carrera_facultad FOREIGN KEY (id_facultad) REFERENCES facultades(id_facultad)
); 

CREATE TABLE asignaturas (
    id_asignatura INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creditos INT NOT NULL,
    id_carrera INT,
    CONSTRAINT fk_asignatura_carrera FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera)
);


-- sp crear usuario al ingresar nuevo estudiante
CREATE TABLE persona (
    id_persona INT PRIMARY KEY IDENTITY(1, 1),
    nombres VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    nacionalidad VARCHAR(50),
    email VARCHAR(100),
    telefono VARCHAR(20),
    celular VARCHAR(20),
    direccion VARCHAR(200),
    CONSTRAINT enum_persona_sexo CHECK (sexo = 'M' OR sexo = 'F')
);
CREATE INDEX idx_persona_nombres ON persona(nombres);
CREATE INDEX idx_persona_apellido_paterno ON persona(apellido_paterno);



CREATE TABLE profesores (
    id_profesor INT PRIMARY KEY,
    id_facultad INT,
    id_especializacion INT,
    fecha_ingreso DATE,
    salario DECIMAL(10, 2),
    activo TINYINT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT fk_profesor_persona FOREIGN KEY (id_profesor) REFERENCES persona(id_persona),
    CONSTRAINT fk_profesor_facultad FOREIGN KEY (id_facultad) REFERENCES facultades(id_facultad),
    CONSTRAINT fk_profesor_especializacion FOREIGN KEY (id_especializacion) REFERENCES especializaciones(id_especializacion)
);

CREATE TABLE estudiante (
    id_estudiante INT PRIMARY KEY,
    carnet CHAR(8) UNIQUE,
    id_carrera INT,
    id_nivel_educativo INT,
	activo TINYINT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT fk_estudiante_persona FOREIGN KEY (id_estudiante) REFERENCES persona(id_persona),
    CONSTRAINT fk_estudiante_carrera FOREIGN KEY (id_carrera) REFERENCES carreras(id_carrera),
    CONSTRAINT fk_estudiante_nivel_educativo FOREIGN KEY (id_nivel_educativo) REFERENCES niveles_educativos(id_nivel_educativo)
);



CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    id_departamento INT,
    fecha_ingreso DATE,
    salario DECIMAL(10, 2),
    activo TINYINT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT fk_empleado_persona FOREIGN KEY (id_empleado) REFERENCES persona(id_persona),
    CONSTRAINT fk_empleado_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);



CREATE TABLE grupos (
    id_grupo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    id_asignatura INT ,
    id_profesor INT,
    hora_inicio TIME,
    hora_fin TIME,
    ubicacion VARCHAR(200) NOT NULL,
    CONSTRAINT fk_grupo_asignatura FOREIGN KEY (id_asignatura) REFERENCES asignaturas(id_asignatura),
    CONSTRAINT fk_grupo_profesor FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
    CONSTRAINT chk_grupo_hora_inicio_hora_fin CHECK (hora_fin > hora_inicio)
);

CREATE TABLE estudiantes_grupos (
    id_estudiante_grupo INT PRIMARY KEY IDENTITY(1,1),
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    CONSTRAINT fk_estudiante_grupo_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    CONSTRAINT fk_estudiante_grupo_grupo FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
);

CREATE TABLE calificaciones (
    id_calificacion INT PRIMARY KEY IDENTITY(1,1),
    id_estudiante_grupo INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_periodo INT NOT NULL,
    id_tipo_calificacion INT NOT NULL,
    calificacion DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_calificacion_estudiante_grupo FOREIGN KEY (id_estudiante_grupo) REFERENCES estudiantes_grupos(id_estudiante_grupo),
    CONSTRAINT fk_calificacion_asignatura FOREIGN KEY (id_asignatura) REFERENCES asignaturas(id_asignatura),
    CONSTRAINT fk_calificacion_periodo FOREIGN KEY (id_periodo) REFERENCES periodos(id_periodo),
    CONSTRAINT fk_calificacion_tipo_calificacion FOREIGN KEY (id_tipo_calificacion) REFERENCES tipo_calificaciones(id_tipo_calificacion),
    CONSTRAINT chh_calificacion CHECK (calificacion >= 0)
);


INSERT INTO UsuariosSistema.roles (nombre_rol)
VALUES ('administrador'), ('estudiante'), ('profesor');

-- Crear la tabla numbers
CREATE TABLE numbers (
    number INT PRIMARY KEY
);

-- Insertar usuarios
INSERT INTO UsuariosSistema.usuarios (id_rol, nombre_usuario, contrasena, fecha_creacion, fecha_modificacion)
SELECT
    -- Generar un n�mero aleatorio entre 1 y 3 para seleccionar un rol
    FLOOR(RAND() * 3) + 1 AS id_rol,
    -- Generar un nombre de usuario aleatorio
    CONCAT('usuario', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS nombre_usuario,
    -- Establecer una contrase�a temporal para todos los usuarios
    'password123' AS contrasena,
    GETDATE() AS fecha_creacion,
    GETDATE() AS fecha_modificacion
FROM
    -- Utilizar la cl�usula VALUES para generar una secuencia de n�meros del 1 al 10
    (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)) AS numbers(number);


INSERT INTO niveles_educativos (nombre)
VALUES ('EDUCACION PRIMARIA'), ('SEGUNDARIA'), ('BACHILLERATO');

INSERT INTO facultades (nombre)
VALUES ('FACULTAD DE INGENIERIA'),('FACULTAD DE CIENCIAS SOCIALES'),('FACULTAD DE MEDICINA'),('FACULTAD DE ARTES Y HUMANIDADES');

INSERT INTO especializaciones (nombre)
VALUES ('Psicolog�a Cl�nica'),('Medicina Interna'),('Ingenier�a de Software');

INSERT INTO periodos (nombre, fecha_creacion, fecha_modificacion)
VALUES 
  ('PERIODO 1-2020', '2023-01-01', '2023-01-01'),
  ('PERIODO 2-2020', '2023-02-15', '2023-03-10'),
  ('PERIODO 1-2021', '2023-04-01', '2023-04-15'),
  ('PERIODO 2-2021', '2023-06-01', '2023-06-30'),
  ('PERIODO 1-2022', '2023-09-01', '2023-09-30');

INSERT INTO tipo_calificaciones (nombre)
VALUES 
  ('Examen'),
  ('Tarea'),
  ('Proyecto'),
  ('Participaci�n'),
  ('Evaluaci�n final');


  INSERT INTO carreras (nombre, id_facultad)
VALUES
  ('Ingenier�a Civil', 1),
  ('Medicina', 2),
  ('Psicolog�a', 3),
  ('Administraci�n de Empresas', 4),
  ('Derecho', 1),
  ('Arquitectura', 2),
  ('Enfermer�a', 3),
  ('Contabilidad', 4),
  ('Educaci�n', 1),
  ('Ciencias de la Computaci�n', 2);


    INSERT INTO asignaturas (nombre, descripcion, creditos, id_carrera)
VALUES
  ('Matem�ticas', 'Asignatura de matem�ticas b�sicas', 4, 1),
  ('Historia', 'Asignatura de historia universal', 3, 2),
  ('Programaci�n', 'Asignatura de programaci�n en C++', 5, 3),
  ('Econom�a', 'Asignatura de principios de econom�a', 3, 4),
  ('Literatura', 'Asignatura de literatura contempor�nea', 3, 1),
  ('F�sica', 'Asignatura de f�sica cl�sica', 4, 2),
  ('Qu�mica', 'Asignatura de qu�mica org�nica', 4, 3),
  ('Contabilidad', 'Asignatura de contabilidad financiera', 3, 4),
  ('Educaci�n F�sica', 'Asignatura de educaci�n f�sica y deportes', 2, 1),
  ('Ingl�s', 'Asignatura de ingl�s avanzado', 3, 2);


  INSERT INTO persona (nombres, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, email, telefono, celular, direccion)
VALUES
    ('Juan', 'L�pez', 'Garc�a', '1990-05-15', 'M', 'Mexicana', 'juan.lopez@example.com', '555-1234', '555-5678', 'Calle Principal 123'),
    ('Mar�a', 'Mart�nez', 'Hern�ndez', '1992-09-20', 'F', 'Mexicana', 'maria.martinez@example.com', '555-5678', '555-9012', 'Avenida Central 456'),
    ('Pedro', 'Gonz�lez', 'Ram�rez', '1988-02-10', 'M', 'Mexicana', 'pedro.gonzalez@example.com', '555-9012', '555-3456', 'Calle Secundaria 789'),
    ('Ana', 'Hern�ndez', 'L�pez', '1995-07-03', 'F', 'Mexicana', 'ana.hernandez@example.com', '555-3456', '555-7890', 'Avenida Principal 123'),
    ('Carlos', 'D�az', 'G�mez', '1991-11-28', 'M', 'Mexicana', 'carlos.diaz@example.com', '555-7890', '555-2345', 'Calle Central 456'),
    ('Laura', 'Torres', 'Vargas', '1987-04-12', 'F', 'Mexicana', 'laura.torres@example.com', '555-2345', '555-6789', 'Avenida Secundaria 789'),
    ('Luis', 'Rojas', 'P�rez', '1993-08-17', 'M', 'Mexicana', 'luis.rojas@example.com', '555-6789', '555-0123', 'Calle Principal 123'),
    ('Fernanda', 'Mendoza', 'Guzm�n', '1989-01-05', 'F', 'Mexicana', 'fernanda.mendoza@example.com', '555-0123', '555-4567', 'Avenida Central 456'),
    ('Javier', 'Vargas', 'Hern�ndez', '1996-06-21', 'M', 'Mexicana', 'javier.vargas@example.com', '555-4567', '555-8901', 'Calle Secundaria 789'),
    ('Mariana', 'Ortega', 'Luna', '1994-10-31', 'F', 'Mexicana', 'mariana.ortega@example.com', '555-8901', '555-2345', 'Avenida Principal 123'),
    ('Gabriel', 'S�nchez', 'Delgado', '1986-03-08', 'M', 'Mexicana', 'gabriel.sanchez@example.com', '555-2345', '555-6789', 'Calle Central 456'),
    ('Michael', 'Johnson', 'Smith', '1991-05-25', 'M', 'Estadounidense', 'michael.johnson@example.com', '555-1234', '555-5678', '123 Main St'),
    ('Jennifer', 'Williams', 'Brown', '1989-08-12', 'F', 'Estadounidense', 'jennifer.williams@example.com', '555-5678', '555-9012', '456 Elm St'),
    ('Christopher', 'Jones', 'Davis', '1992-02-18', 'M', 'Estadounidense', 'christopher.jones@example.com', '555-9012', '555-3456', '789 Oak St'),
    ('Jessica', 'Miller', 'Johnson', '1990-07-05', 'F', 'Estadounidense', 'jessica.miller@example.com', '555-3456', '555-7890', '321 Maple Ave'),
    ('Matthew', 'Anderson', 'Taylor', '1988-11-30', 'M', 'Estadounidense', 'matthew.anderson@example.com', '555-7890', '555-2345', '654 Pine St'),
    ('Sarah', 'Thomas', 'Clark', '1993-04-15', 'F', 'Estadounidense', 'sarah.thomas@example.com', '555-2345', '555-6789', '987 Cedar Ave'),
    ('Daniel', 'Martin', 'Miller', '1987-09-22', 'M', 'Estadounidense', 'daniel.martin@example.com', '555-6789', '555-0123', '789 Birch St'),
    ('Emily', 'Moore', 'Lewis', '1995-01-08', 'F', 'Estadounidense', 'emily.moore@example.com', '555-0123', '555-4567', '654 Oak Ave'),
    ('Ryan', 'Jackson', 'Lee', '1991-06-23', 'M', 'Estadounidense', 'ryan.jackson@example.com', '555-4567', '555-8901', '321 Maple St'),
    ('Amanda', 'Harris', 'Wilson', '1989-10-12', 'F', 'Estadounidense', 'amanda.harris@example.com', '555-8901', '555-2345', '987 Cedar Ave'),
    ('Brandon', 'Brown', 'Harris', '1994-03-05', 'M', 'Estadounidense', 'brandon.brown@example.com', '555-2345', '555-6789', '123 Main St'),
    ('Ashley', 'Davis', 'Anderson', '1988-07-28', 'F', 'Estadounidense', 'ashley.davis@example.com', '555-6789', '555-0123', '456 Elm St'),
	('Alejandro', 'G�mez', 'Hern�ndez', '1992-07-12', 'M', 'Mexicana', 'alejandro.gomez@example.com', '555-1234', '555-5678', 'Calle Principal 123'),
    ('Isabella', 'Rodr�guez', 'D�az', '1994-03-25', 'F', 'Mexicana', 'isabella.rodriguez@example.com', '555-5678', '555-9012', 'Avenida Central 456'),
    ('Santiago', 'S�nchez', 'Vargas', '1990-09-02', 'M', 'Mexicana', 'santiago.sanchez@example.com', '555-9012', '555-3456', 'Calle Secundaria 789'),
    ('Valentina', 'Torres', 'L�pez', '1993-11-19', 'F', 'Mexicana', 'valentina.torres@example.com', '555-3456', '555-7890', 'Avenida Principal 123'),
    ('Diego', 'Hern�ndez', 'Gonz�lez', '1991-05-07', 'M', 'Mexicana', 'diego.hernandez@example.com', '555-7890', '555-2345', 'Calle Central 456'),
    ('Ximena', 'Mart�nez', 'Ram�rez', '1988-08-14', 'F', 'Mexicana', 'ximena.martinez@example.com', '555-2345', '555-6789', 'Avenida Secundaria 789'),
    ('Emilio', 'L�pez', 'Rojas', '1994-02-23', 'M', 'Mexicana', 'emilio.lopez@example.com', '555-6789', '555-0123', 'Calle Principal 123'),
    ('Camila', 'Gonz�lez', 'Mendoza', '1996-09-28', 'F', 'Mexicana', 'camila.gonzalez@example.com', '555-0123', '555-4567', 'Avenida Central 456'),
    ('Joaqu�n', 'Mendoza', 'Vargas', '1990-12-07', 'M', 'Mexicana', 'joaquin.mendoza@example.com', '555-4567', '555-8901', 'Calle Secundaria 789'),
    ('Sof�a', 'Hern�ndez', 'Ortega', '1989-07-26', 'F', 'Mexicana', 'sofia.hernandez@example.com', '555-8901', '555-2345', 'Avenida Principal 123'),
	('Carlos', 'Hern�ndez', 'L�pez', '1990-05-15', 'M', 'Salvadore�a', 'carlos.hernandez@example.com', '555-1234', '555-5678', 'Calle Principal 123'),
    ('Ana', 'Gonz�lez', 'Mart�nez', '1992-09-20', 'F', 'Salvadore�a', 'ana.gonzalez@example.com', '555-5678', '555-9012', 'Avenida Central 456'),
    ('Luis', 'L�pez', 'Ram�rez', '1988-02-10', 'M', 'Salvadore�a', 'luis.lopez@example.com', '555-9012', '555-3456', 'Calle Secundaria 789'),
    ('Mar�a', 'Hern�ndez', 'Gonz�lez', '1995-07-03', 'F', 'Salvadore�a', 'maria.hernandez@example.com', '555-3456', '555-7890', 'Avenida Principal 123'),
    ('Javier', 'D�az', 'G�mez', '1991-11-28', 'M', 'Salvadore�a', 'javier.diaz@example.com', '555-7890', '555-2345', 'Calle Central 456'),
    ('Sof�a', 'Torres', 'Vargas', '1987-04-12', 'F', 'Salvadore�a', 'sofia.torres@example.com', '555-2345', '555-6789', 'Avenida Secundaria 789'),
    ('Diego', 'Rojas', 'P�rez', '1993-08-17', 'M', 'Salvadore�a', 'diego.rojas@example.com', '555-6789', '555-0123', 'Calle Principal 123'),
    ('Valeria', 'Mendoza', 'Guzm�n', '1989-01-05', 'F', 'Salvadore�a', 'valeria.mendoza@example.com', '555-0123', '555-4567', 'Avenida Central 456'),
    ('Gabriela', 'Vargas', 'Hern�ndez', '1996-06-21', 'F', 'Salvadore�a', 'gabriela.vargas@example.com', '555-4567', '555-8901', 'Calle Secundaria 789'),
    ('Daniel', 'Ortega', 'Luna', '1994-10-31', 'M', 'Salvadore�a', 'daniel.ortega@example.com', '555-8901', '555-2345', 'Avenida Principal 123'),
    ('Fernando', 'S�nchez', 'Delgado', '1986-03-08', 'M', 'Salvadore�a', 'fernando.sanchez@example.com', '555-2345', '555-6789', 'Calle Central 456');


INSERT INTO profesores (id_profesor, id_facultad, id_especializacion, fecha_ingreso, salario)
VALUES
    (1, 1, 1, '2010-01-01', 5000.00),
    (2, 2, 3, '2012-05-15', 5500.00),
    (3, 1, 2, '2008-09-30', 4800.00),
    (4, 3, 1, '2015-03-20', 5200.00),
    (5, 2, 2, '2011-07-10', 5300.00),
    (6, 1, 3, '2009-02-28', 5100.00),
    (7, 3, 2, '2014-06-25', 5400.00),
    (8, 2, 1, '2013-10-12', 4900.00),
    (9, 3, 3, '2016-12-05', 5600.00),
    (10, 1, 1, '2007-04-18', 4700.00);


INSERT INTO estudiante (id_estudiante, carnet, id_carrera, id_nivel_educativo)
VALUES
    (10, 'CARNET10', 1, 1),
    (11, 'CARNET11', 2, 2),
    (12, 'CARNET12', 1, 2),
    (13, 'CARNET13', 3, 1),
    (14, 'CARNET14', 2, 1),
    (15, 'CARNET15', 1, 3),
    (16, 'CARNET16', 3, 2),
    (17, 'CARNET17', 2, 3),
    (18, 'CARNET18', 3, 3),
    (19, 'CARNET19', 1, 1),
    (20, 'CARNET20', 2, 2),
    (21, 'CARNET21', 1, 2),
    (22, 'CARNET22', 3, 1),
    (23, 'CARNET23', 2, 1),
    (24, 'CARNET24', 1, 3);


INSERT INTO departamentos (id_departamento, nombre_departamento)
VALUES
    (1, 'Contabilidad'),
    (2, 'Recursos Humanos'),
    (3, 'Ventas'),
    (4, 'Marketing'),
    (5, 'Operaciones'),
    (6, 'Desarrollo de Software'),
    (7, 'Atenci�n al Cliente'),
    (8, 'Log�stica'),
    (9, 'Administraci�n'),
    (10, 'Finanzas');

INSERT INTO empleados (id_empleado, id_departamento, fecha_ingreso, salario)
VALUES
    (24, 1, '2020-01-15', 2500.00),
    (25, 2, '2019-05-20', 2800.00),
    (26, 3, '2021-03-10', 2200.00),
    (27, 4, '2018-09-02', 3000.00),
    (28, 5, '2017-11-28', 2700.00),
    (29, 6, '2022-02-14', 3200.00),
    (30, 7, '2019-08-17', 2400.00),
    (31, 8, '2020-06-21', 2600.00),
    (32, 9, '2016-10-31', 2900.00),
    (33, 10, '2017-04-12', 3100.00);


	INSERT INTO grupos (nombre, capacidad, id_asignatura, id_profesor, hora_inicio, hora_fin, ubicacion)
VALUES
    ('Grupo A', 30, 1, 1, '09:00:00', '11:00:00', 'Aula 101'),
    ('Grupo B', 25, 2, 2, '13:00:00', '15:00:00', 'Aula 102'),
    ('Grupo C', 20, 3, 3, '10:30:00', '12:30:00', 'Aula 201'),
    ('Grupo D', 35, 4, 4, '14:30:00', '16:30:00', 'Aula 202'),
    ('Grupo E', 30, 5, 5, '08:00:00', '10:00:00', 'Aula 301'),
    ('Grupo F', 25, 6, 6, '12:00:00', '14:00:00', 'Aula 302'),
    ('Grupo G', 20, 7, 7, '11:00:00', '13:00:00', 'Aula 401'),
    ('Grupo H', 35, 8, 8, '15:00:00', '17:00:00', 'Aula 402'),
    ('Grupo I', 30, 9, 9, '09:30:00', '11:30:00', 'Aula 501'),
    ('Grupo J', 25, 10, 10, '13:30:00', '15:30:00', 'Aula 502');

	INSERT INTO estudiantes_grupos (id_estudiante, id_grupo)
VALUES
    (10, 1),
    (11, 2),
    (12, 3),
    (13, 4),
    (14, 5),
    (15, 6),
    (16, 7),
    (17, 8),
    (18, 9),
    (19, 10);

	INSERT INTO calificaciones (id_estudiante_grupo, id_asignatura, id_periodo, id_tipo_calificacion, calificacion)
VALUES
    (1, 1, 1, 1, 8.5),
    (2, 2, 1, 1, 7.2),
    (3, 3, 1, 1, 9.1),
    (4, 4, 1, 1, 6.8),
    (5, 5, 1, 1, 7.9),
    (6, 6, 1, 1, 8.3),
    (7, 7, 1, 1, 9.5),
    (8, 8, 1, 1, 7.6),
    (9, 9, 1, 1, 8.8),
    (10, 10, 1, 1, 6.5);


	--VISTAS

CREATE VIEW vista_estudiantes_matriculados AS
SELECT e.id_estudiante, e.carnet, e.id_carrera, p.nombres, p.apellido_paterno, p.apellido_materno
FROM estudiante e
JOIN persona p ON e.id_estudiante = p.id_persona;

SELECT *
FROM vista_estudiantes_matriculados
WHERE id_carrera = 1    -- <id_carrera_especifico>

CREATE VIEW vista_estudiantes_por_materias AS
SELECT p.id_persona, p.nombres, p.apellido_paterno, p.apellido_materno, a.id_asignatura, a.nombre
FROM persona p
JOIN estudiante e ON p.id_persona = e.id_estudiante
JOIN estudiantes_grupos eg ON e.id_estudiante = eg.id_estudiante
JOIN grupos g ON eg.id_grupo = g.id_grupo
JOIN asignaturas a ON g.id_asignatura = a.id_asignatura;

SELECT *
FROM vista_estudiantes_por_materias;
