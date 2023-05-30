create DATABASE sistema_escolar2;

USE sistema_escolar2;

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	fecha_modificacion DATETIME,
	CONSTRAINT uc_nombre_usuario UNIQUE (nombre_usuario) -- sp crear nombre usuario
);

CREATE TABLE roles (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE nivel_educativo (
    id_nivel_educativo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE facultad (
    id_facultad INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
);

CREATE TABLE especializacion (
    id_especializacion INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE periodo (
    id_periodo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME,
    fecha_modificacion DATETIME,
);

CREATE TABLE tipo_calificacion (
    id_tipo_calificacion INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE carrera (
    id_carrera INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    id_facultad INT NOT NULL,
    CONSTRAINT fk_carrera_facultad FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
); 

CREATE TABLE asignatura (
    id_asignatura INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creditos INT NOT NULL,
    id_carrera INT NOT NULL,
    CONSTRAINT fk_asignatura_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
);

CREATE TABLE evento (
	id_evento INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(100) NOT NULL,
	fecha_inicio DATETIME NOT NULL,
	fecha_fin DATETIME NOT NULL,
	CONSTRAINT chk_evento_fecha_inicio_fecha CHECK (fecha_fin > fecha_inicio)
);


-- sp crear usuario al ingresar nuevo estudiante
CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT,
    id_facultad INT NOT NULL,
    id_especializacion INT,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(20),
    celular VARCHAR(20),
    direccion VARCHAR(200),
    fecha_ingreso DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    activo TINYINT NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT enum_profesor_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    --CONSTRAINT chk_profesor_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    --CONSTRAINT chk_profesor_fecha_nacimiento CHECK (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 0),
    CONSTRAINT fk_profesor_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_profesor_facultad FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad),
    CONSTRAINT fk_profesor_especializacion FOREIGN KEY (id_especializacion) REFERENCES especializacion(id_especializacion)
);


-- sp crear usuario al ingresar nuevo estudiante
CREATE TABLE estudiante (
    id_estudiante INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    nacionalidad VARCHAR(50),
    ciudad_origen VARCHAR(50),
    email VARCHAR(100),
    carnet CHAR(8) UNIQUE,
    telefono VARCHAR(20),
    celular VARCHAR(20),
    direccion VARCHAR(200),
    id_carrera INT,
    id_nivel_educativo INT,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    CONSTRAINT enum_estudiante_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    CONSTRAINT fk_estudiante_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    CONSTRAINT fk_esutidante_nivel_educativo FOREIGN KEY (id_nivel_educativo) REFERENCES nivel_educativo,
    CONSTRAINT fk_estudiante_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
);



CREATE TABLE grupo (
    id_grupo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_profesor INT NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    CONSTRAINT fk_grupo_asignatura FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    CONSTRAINT fk_grupo_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    CONSTRAINT chk_grupo_hora_inicio_hora_fin CHECK (hora_fin > hora_inicio)
);

CREATE TABLE estudiante_grupo (
    id_estudiante_grupo INT PRIMARY KEY IDENTITY(1,1),
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    CONSTRAINT fk_estudiante_grupo_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    CONSTRAINT fk_estudiante_grupo_grupo FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

CREATE TABLE calificacion (
    id_calificacion INT PRIMARY KEY IDENTITY(1,1),
    id_estudiante_grupo INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_periodo INT NOT NULL,
    id_tipo_calificacion INT NOT NULL,
    calificacion DECIMAL(5, 2) NOT NULL,
    CONSTRAINT fk_calificacion_estudiante_grupo FOREIGN KEY (id_estudiante_grupo) REFERENCES estudiante_grupo(id_estudiante_grupo),
    CONSTRAINT fk_calificacion_asignatura FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura),
    CONSTRAINT fk_calificacion_periodo FOREIGN KEY (id_periodo) REFERENCES periodo(id_periodo),
    CONSTRAINT fk_calificacion_tipo_calificacion FOREIGN KEY (id_tipo_calificacion) REFERENCES tipo_calificacion(id_tipo_calificacion),
    CONSTRAINT chh_calificacion CHECK (calificacion >= 0)
);

CREATE TABLE evento_grupo (
id_evento INT NOT NULL IDENTITY(1,1),
id_grupo INT NOT NULL,
PRIMARY KEY (id_evento, id_grupo),
CONSTRAINT fk_evento_grupo_evento FOREIGN KEY (id_evento) REFERENCES evento(id_evento),
CONSTRAINT fk_evento_grupo_grupo FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);





--tabla USUARIOS

INSERT INTO usuario (nombre_usuario, contrasena, fecha_creacion, fecha_modificacion)
VALUES ('MichaelBrown', 'Brown123', '2023-05-18 10:00:00', '2023-05-18 12:30:00'),
       ('admin', 'admin123', '2023-05-18 11:30:00', NULL),
       ('JESSICA25', 'p4ssw0rd', '2023-05-18 12:00:00', '2023-05-18 14:45:00'),
       ('RobertDavis', 'password456', '2023-05-18 13:30:00', '2023-05-18 13:30:00'),
       ('12345', '54321', '2023-05-18 14:00:00', '2023-05-18 16:15:00');
	   select * from usuario

--TABLA ROLES
INSERT INTO roles (nombre_rol)
VALUES ('ADMINISTRADOR'), ('ESTUDIANTE'), ('PROFESOR');

--TABLA NIVEL EDUCATIVO

INSERT INTO nivel_educativo (nombre)
VALUES ('EDUCACION PRIMARIA'), ('SEGUNDARIA'), ('BACHILLERATO');


--TABLA FACULTAD
INSERT INTO facultad (nombre)
VALUES ('FACULTAD DE INGENIERIA');

INSERT INTO facultad (nombre)
VALUES ('FACULTAD DE CIENCIAS SOCIALES');


INSERT INTO facultad (nombre)
VALUES ('FACULTAD DE MEDICINA');

INSERT INTO facultad (nombre)
VALUES ('FACULTAD DE ARTES Y HUMANIDADES');

--TABLA ESPECIALIZACION

INSERT INTO especializacion (nombre)
VALUES ('Psicología Clínica');

INSERT INTO especializacion (nombre)
VALUES ('Medicina Interna');

INSERT INTO especializacion (nombre)
VALUES ('Ingeniería de Software');

--TABLA PERIODOS 
INSERT INTO periodo (nombre, fecha_creacion, fecha_modificacion)
VALUES 
  ('PERIODO 1', '2023-01-01', '2023-01-01'),
  ('PERIODO 2', '2023-02-15', '2023-03-10'),
  ('PERIODO 3', '2023-04-01', '2023-04-15'),
  ('PERIODO 4', '2023-06-01', '2023-06-30'),
  ('PERIODO 5', '2023-09-01', '2023-09-30');


  ---TABLA TIPO_CALIFICACION 
  INSERT INTO tipo_calificacion (nombre)
VALUES 
  ('Examen'),
  ('Tarea'),
  ('Proyecto'),
  ('Participación'),
  ('Evaluación final');

  --TABLA CARRERA 

  INSERT INTO carrera (nombre, id_facultad)
VALUES
  ('Ingeniería Civil', 1),
  ('Medicina', 2),
  ('Psicología', 3),
  ('Administración de Empresas', 4),
  ('Derecho', 1),
  ('Arquitectura', 2),
  ('Enfermería', 3),
  ('Contabilidad', 4),
  ('Educación', 1),
  ('Ciencias de la Computación', 2);


 --TABLA ASIGNATURA

  INSERT INTO asignatura (nombre, descripcion, creditos, id_carrera)
VALUES
  ('Matemáticas', 'Asignatura de matemáticas básicas', 4, 1),
  ('Historia', 'Asignatura de historia universal', 3, 2),
  ('Programación', 'Asignatura de programación en C++', 5, 3),
  ('Economía', 'Asignatura de principios de economía', 3, 4),
  ('Literatura', 'Asignatura de literatura contemporánea', 3, 1),
  ('Física', 'Asignatura de física clásica', 4, 2),
  ('Química', 'Asignatura de química orgánica', 4, 3),
  ('Contabilidad', 'Asignatura de contabilidad financiera', 3, 4),
  ('Educación Física', 'Asignatura de educación física y deportes', 2, 1),
  ('Inglés', 'Asignatura de inglés avanzado', 3, 2);


--TABLA EVENTO 
INSERT INTO evento (nombre, fecha_inicio, fecha_fin)
VALUES
  ('Conferencia de Marketing', '2023-06-15 09:00:00', '2023-06-15 12:00:00'),
  ('Exposición de Arte', '2023-07-10 10:00:00', '2023-07-15 18:00:00'),
  ('Seminario de Finanzas', '2023-08-05 14:00:00', '2023-08-06 16:00:00'),
  ('Concierto de Rock', '2023-09-20 20:00:00', '2023-09-20 23:00:00'),
  ('Charla de Emprendimiento', '2023-10-12 15:00:00', '2023-10-12 17:00:00'),
  ('Feria de Tecnología', '2023-11-08 10:00:00', '2023-11-10 18:00:00'),
  ('Taller de Fotografía', '2023-12-01 09:30:00', '2023-12-01 12:30:00'),
  ('Presentación de Teatro', '2024-01-15 19:00:00', '2024-01-15 21:00:00'),
  ('Conferencia de Salud', '2024-02-10 11:00:00', '2024-02-10 13:00:00'),
  ('Festival Gastronómico', '2024-03-25 12:00:00', '2024-03-30 22:00:00');


-------------

  --PROFESOR 

INSERT INTO profesor (id_usuario, id_facultad, id_especializacion, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, email, telefono, celular, direccion, fecha_ingreso, salario)
VALUES
  (1, 1, 1, 'Juan', 'Gómez', 'López', '1985-03-12', 'M', 'juan.gomez@example.com', '1234-5678', '9876-5432', 'Calle 123', '2010-05-20', 2500.00),
  (1, 2, 2, 'María', 'Hernández', 'Sánchez', '1990-08-25', 'F', 'maria.hernandez@example.com', '8765-4321', '2345-6789', 'Avenida 456', '2012-10-15', 2800.00),
  (3, 1, 1, 'Pedro', 'Martínez', 'González', '1982-12-05', 'M', 'pedro.martinez@example.com', '2345-6789', '7654-3210', 'Calle 789', '2015-03-08', 2900.00),
  (4, 3, 3, 'Laura', 'Pérez', 'Ramírez', '1988-06-18', 'F', 'laura.perez@example.com', '3456-7890', '6543-2109', 'Avenida 987', '2013-09-02', 2700.00),
  (5, 2, 2, 'Carlos', 'López', 'García', '1995-02-10', 'M', 'carlos.lopez@example.com', '4567-8901', '5432-1098', 'Calle 456', '2018-07-17', 3000.00),
  (1, 1, 1, 'Ana', 'González', 'Sánchez', '1987-09-20', 'F', 'ana.gonzalez@example.com', '5678-9012', '4321-0987', 'Avenida 123', '2014-12-12', 2600.00),
  (5, 3, 2, 'Miguel', 'Sánchez', 'Torres', '1984-11-30', 'M', 'miguel.sanchez@example.com', '6789-0123', '3210-9876', 'Calle 789', '2016-05-25', 2750.00),
  (1, 2, 3, 'John', 'Smith', 'Johnson', '1987-05-15', 'M', 'john.smith@example.com', '3456-7890', '3456-7890', '123 Main St', '2010-08-10', 3500.00),
  (1, 1, 2, 'Emily', 'Davis', 'Brown', '1992-09-25', 'F', 'emily.davis@example.com', '3456-7890', '3456-7890', '456 Elm St', '2012-03-18', 3200.00),
  (2, 3, 1, 'Michael', 'Johnson', 'Anderson', '1984-11-05', 'M', 'michael.johnson@example.com', '3456-7890', '3456-7890', '789 Oak Ave', '2015-06-22', 3800.00),
  (1, 2, 2, 'Jessica', 'Taylor', 'Clark', '1990-03-18', 'F', 'jessica.taylor@example.com', '3456-7890', '3456-7890', '567 Pine St', '2013-09-12', 3100.00),
  (1, 1, 1, 'William', 'Anderson', 'Wilson', '1988-07-12', 'M', 'william.anderson@example.com', '3456-7890', '3456-7890', '890 Maple Ave', '2018-02-05', 3400.00),
  (1, 3, 3, 'Sophia', 'Thomas', 'Lewis', '1995-01-29', 'F', 'sophia.thomas@example.com', '3456-7890', '3456-7890', '234 Cedar St', '2014-12-28', 3700.00),
  (5, 2, 1, 'James', 'Robinson', 'Harris', '1986-08-08', 'M', 'james.robinson@example.com', '3456-7890', '3456-7890', '901 Walnut Ave', '2016-11-15', 3300.00),
  (2, 1, 2, 'Olivia', 'Walker', 'Young', '1993-04-19', 'F', 'olivia.walker@example.com', '3456-7890', '3456-7890', '345 Oak St', '2019-05-02', 3600.00),
  (2, 3, 3, 'Benjamin', 'Hall', 'Allen', '1989-12-22', 'M', 'benjamin.hall@example.com', '3456-7890', '3456-7890', '678 Pine Ave', '2017-08-20', 3500.00),
  (2, 2, 3, 'Ivan', 'Ivanov', 'Petrovich', '1986-05-15', 'M', 'ivan.ivanov@example.com', '3456-7890', '3456-7890', '123 Main St', '2010-08-10', 3500.00),
  (3, 1, 2, 'Ekaterina', 'Smirnova', 'Ivanovna', '1992-09-25', 'F', 'ekaterina.smirnova@example.com', '3456-7890', '3456-7890', '456 Elm St', '2012-03-18', 3200.00),
  (2, 3, 1, 'Dmitry', 'Popov', 'Sergeevich', '1984-11-05', 'M', 'dmitry.popov@example.com', '3456-7890', '3456-7890', '789 Oak Ave', '2015-06-22', 3800.00),
  (2, 2, 2, 'Svetlana', 'Kuznetsova', 'Viktorovna', '1990-03-18', 'F', 'svetlana.kuznetsova@example.com', '3456-7890', '3456-7890', '567 Pine St', '2013-09-12', 3100.00),
  (3, 1, 1, 'Mikhail', 'Sokolov', 'Ilyich', '1988-07-12', 'M', 'mikhail.sokolov@example.com', '3456-7890', '3456-7890', '890 Maple Ave', '2018-02-05', 3400.00),
  (4, 3, 3, 'Anastasia', 'Kozlova', 'Alexandrovna', '1995-01-29', 'F', 'anastasia.kozlova@example.com', '3456-7890', '3456-7890', '234 Cedar St', '2014-12-28', 3700.00),
  (5, 2, 1, 'Pavel', 'Smirnov', 'Nikolaevich', '1986-08-08', 'M', 'pavel.smirnov@example.com', '3456-7890', '3456-7890', '901 Walnut Ave', '2016-11-15', 3300.00),
  (1, 1, 2, 'Maria', 'Volkova', 'Andreevna', '1993-04-19', 'F', 'maria.volkova@example.com', '3456-7890', '3456-7890', '345 Oak St', '2019-05-02', 3600.00);

  --ESTUDIANTE 

--INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, codigo_postal, email, telefono, celular, direccion, id_carrera, id_nivel_educativo)
--VALUES
--(1, 'Juan', 'Gómez', 'López', '1998-03-12', 'M', 'Mexicana', 'Ciudad de México', '12345', 'juan.gomez@example.com', '12345678', '98765432', 'Calle 123', 1, 1),
--(2, 'María', 'Hernández', 'Sánchez', '1999-08-25', 'F', 'Mexicana', 'Guadalajara', '54321', 'maria.hernandez@example.com', '87654321', '23456789', 'Avenida 456', 2, 2),
--(3, 'Pedro', 'Martínez', 'González', '1997-12-05', 'M', 'Mexicana', 'Monterrey', '98765', 'pedro.martinez@example.com', '23456789', '76543210', 'Calle 789', 1, 1),
--(4, 'Laura', 'Pérez', 'Ramírez', '2000-06-18', 'F', 'Mexicana', 'Tijuana', '56789', 'laura.perez@example.com', '34567890', '65432109', 'Avenida 987', 3, 3),
--(5, 'Carlos', 'López', 'García', '1996-02-10', 'M', 'Mexicana', 'Puebla', '87654', 'carlos.lopez@example.com', '45678901', '54321098', 'Calle 456', 2, 2),
--(6, 'Ana', 'González', 'Sánchez', '1998-09-20', 'F', 'Mexicana', 'Querétaro', '23456', 'ana.gonzalez@example.com', '56789012', '43210987', 'Avenida 123', 1, 1),
--(1, 'Miguel', 'Sánchez', 'Torres', '1995-11-30', 'M', 'Mexicana', 'Mérida', '78901', 'miguel.sanchez@example.com', '67890123', '32109876', 'Calle 789', 3, 2),
--(2, 'Isabel', 'Ramírez', 'Martínez', '1997-07-15', 'F', 'Mexicana', 'Cancún', '34567', 'isabel.ramirez@example.com', '78901234', '21098765', 'Avenida 456', 2, 3);


INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, email, carnet, telefono, celular, direccion, id_carrera, id_nivel_educativo)
VALUES (1, 'Juan', 'Gómez', 'López', '1998-03-12', 'M', 'Mexicana', 'Ciudad de México', 'juan.gomez@example.com', 'AB122022', '98765432', '12345678', 'Calle 123', 1, 1);


INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, email, carnet, telefono, celular, direccion, id_carrera, id_nivel_educativo)
VALUES (2, 'María', 'Hernández', 'Sánchez', '1999-08-25', 'F', 'Mexicana', 'Guadalajara', 'maria.hernandez@example.com', 'AB122023', '23456789', '87654321', 'Avenida 456', 2, 2);

INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, email, carnet, telefono, celular, direccion, id_carrera, id_nivel_educativo)
VALUES (3, 'Pedro', 'Martínez', 'González', '1997-12-05', 'M', 'Mexicana', 'Monterrey', 'pedro.martinez@example.com', 'AB122024', '76543210', '23456789', 'Calle 789', 1, 1);

INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, email, carnet, telefono, celular, direccion, id_carrera, id_nivel_educativo)
VALUES (4, 'Laura', 'Pérez', 'Ramírez', '2000-06-18', 'F', 'Mexicana', 'Tijuana', 'laura.perez@example.com', 'AB122025', '65432109', '34567890', 'Avenida 987', 3, 3);

INSERT INTO estudiante (id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, nacionalidad, ciudad_origen, email, carnet, telefono, celular, direccion, id_carrera, id_nivel_educativo)
VALUES (5, 'Carlos', 'López', 'García', '1996-02-10', 'M', 'Mexicana', 'Puebla', 'carlos.lopez@example.com', 'AB122026', '54321098', '45678901', 'Calle 456', 2, 2);

  --TABLAS GRUPO 
  INSERT INTO grupo (nombre, capacidad, id_asignatura, id_profesor, hora_inicio, hora_fin, ubicacion)
VALUES
  ('Grupo 1', 30, 1, 37, '09:00:00', '11:00:00', 'Aula 101'),
  ('Grupo 2', 25, 2, 38, '10:30:00', '12:30:00', 'Aula 202'),
  ('Grupo 3', 20, 3, 39, '13:00:00', '15:00:00', 'Aula 303'),
  ('Grupo 4', 35, 4, 40, '14:30:00', '16:30:00', 'Aula 404'),
  ('Grupo 5', 30, 5, 41, '16:00:00', '18:00:00', 'Aula 505'),
  ('Grupo 6', 25, 6, 42, '08:30:00', '10:30:00', 'Aula 606'),
  ('Grupo 7', 20, 7, 43, '11:00:00', '13:00:00', 'Aula 707'),
  ('Grupo 8', 35, 8, 44, '12:30:00', '14:30:00', 'Aula 808'),
  ('Grupo 9', 30, 9, 45, '15:00:00', '17:00:00', 'Aula 909'),
  ('Grupo 10', 25, 10, 46, '16:30:00', '18:30:00', 'Aula 1010');



  --TABLA ESTUDIANTE GRUPO 

  INSERT INTO estudiante_grupo (id_estudiante, id_grupo)
VALUES
  (5, 3),
  (5, 4),
  (6, 3),
  (7, 4),
  (8, 5),
  (9, 3),
  (7, 6),
  (8, 3),
  (9, 4),
  (5, 5);

    --TABLA CALIFICACION --DIO ERROR FOREIGN KEY constraint "fk_calificacion_estudiante_grupo". The conflict occurred in database "sistema_escolar2", table "dbo.estudiante_grupo", column 'id_estudiante_grupo'

  INSERT INTO calificacion (id_estudiante_grupo, id_asignatura, id_periodo, id_tipo_calificacion, calificacion)
VALUES
  (1, 1, 1, 1, 85.5),
  (1, 2, 1, 2, 92.0),
  (2, 1, 1, 1, 78.3),
  (2, 3, 1, 2, 89.7),
  (3, 1, 2, 1, 91.2),
  (3, 2, 2, 2, 85.8),
  (4, 3, 2, 1, 79.5),
  (4, 1, 2, 2, 88.0),
  (5, 2, 3, 1, 93.7),
  (5, 3, 3, 2, 81.4);

  --EVENTO GRUPO
  INSERT INTO evento_grupo (id_evento, id_grupo)
VALUES
  (1, 1),
  (1, 2),
  (2, 3),
  (2, 4),
  (3, 5),
  (3, 6),
  (4, 7),
  (4, 8),
  (5, 9),
  (5, 10);
