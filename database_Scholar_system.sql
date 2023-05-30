create DATABASE sistema_escolar;

USE sistema_escolar;

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

/*
 * Quiza en vez de la fecha de creacion y modificacion
 * serian inicio y fin (?)
 * */
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
    CONSTRAINT chk_profesor_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_profesor_fecha_nacimiento CHECK (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 0),
    CONSTRAINT fk_profesor_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_profesor_facultad FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad),
    CONSTRAINT fk_profesor_especializacion FOREIGN KEY (id_especializacion) REFERENCES especializacion(id_especializacion)
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
    codigo_postal VARCHAR(10),
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
    CONSTRAINT chk_estudiante_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_estudiante_codigo_postal CHECK (ISNUMERIC(codigo_postal) = 1),
    CONSTRAINT chk_estudiante_fecha_nacimiento CHECK (YEAR(fecha_nacimiento) < YEAR(GETDATE())),
    CONSTRAINT chk_estudiante_edad CHECK (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 0),
    CONSTRAINT fk_estudiante_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    CONSTRAINT fk_esutidante_nivel_educativo FOREIGN KEY (id_nivel_educativo) REFERENCES nivel_educativo,
    CONSTRAINT fk_estudiante_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
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


--Ejemplo para ingresar datos

INSERT INTO NivelEducativo ( nombre) VALUES ('Secundaria');
go 100

/* PRUEBA TABLAS */
-- Andres 

-- carrera
-- Se necesita una carrera primero
insert into carrera(nombre, id_facultad) values('carrera de prueba', 1)

-- especializacion
insert into especializacion(nombre) values ('especializacion de prueba')

-- asignatura
-- Se necesita una facultad primero para asignatura
insert into facultad(nombre) values ('facu de prueba')

-- PK, nombre, descripcion, creditos, FK: id_carrera
insert into Asignatura values 
('sociales', 'desc', 1, 2),
('lenguaje', 'desc', 1, 2),
('matematicas', 'desc', 1, 2),
('ciencias', 'desc', 1, 2)

-- saber en cuantas carreras esta una asignatura 
select a.nombre, COUNT(a.id_carrera)
from asignatura a
group by a.nombre 

/*
 * Si tengo una asginatura compartida entre unas 5 carreras, significa que en la tabla asignatura
 * tendre 5 veces el registro de la misma asignatura pero con diferente id_carrera (?)
 * muchas asignaturas pertenecen a muchas carreras (?)
 * 
 * Se necesitaria tabla intermedia para normalizacion tipo propuesta asi:
 * */
CREATE TABLE asginatura_carrera (
	id_asignatura INT NOT NULL,
	id_carrera INT NOT NULL,
	CONSTRAINT fk_asignatura_carrera_asignatura FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura),
	CONSTRAINT fk_asignatura_carrera_carrera FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
);
/* asi: */
/*select ac.id_asignatura, count(ac.id_carrera)
from asignatura_carrera ac
join asignatura a on a.id_asignatura = ac.id_asignatura
join carrera c on c.id_carrera = ac.id_carrera
group by ac.id_asignatura*/

/*
 * Ventajas:
 * - Esta mas normalizado
 * - Se evita duplicidad
 * Desventaja:
 * - Se requieren mas tablas para las consultas
 * */

-- calificacion
-- se necesita carrera, asignatura, periodo, tipo_calificacion y estudiante_grupo
insert into periodo(nombre, fecha_creacion, fecha_modificacion) values ('periodo de prueba', GETDATE(), null)
insert into tipo_calificacion(nombre) values ('tipo calificacion de prueba')


-- se necesita usuario para profesor 
insert into usuario(nombre_usuario, contrasena, fecha_creacion, fecha_modificacion) values ('profe1', '1234', getdate(), null)
insert into profesor(id_usuario, id_facultad, id_especializacion, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, fecha_ingreso, salario)
values(1, 1, 1 , 'profe', 'mate', 'mate2', '1970-05-23', 'M', '1999-05-18', 500.0)


-- se necesita profesor para grupo
insert into grupo(nombre, capacidad, id_asignatura, id_profesor, hora_inicio, hora_fin, ubicacion) 
values ('grupo de prueba', 5, 3, 1, '06:30', '08:10', 'mi ksita')

-- se necesita usuario y nivel_educativo para estudiante
insert into usuario(nombre_usuario, contrasena, fecha_creacion, fecha_modificacion) values ('estudiante1', '1234', getdate(), null)
insert into estudiante(id_usuario, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo, celular, codigo_postal)
values (2, 'alumno1', 'nose', 'nose2', '1999-05-18', 'F', '1234-1234', '503')

insert into estudiante_grupo(id_estudiante, id_grupo) values (1, 1)

-- y finalmente la tabla de calificacion
insert into calificacion(id_estudiante_grupo, id_asignatura, id_periodo, id_tipo_calificacion, calificacion)
values (1, 2, 1, 1, 8)

-- si quiero saber las calificaciones de un grupo de estudiantes
select * from estudiante_grupo eg
inner join calificacion c on c.id_estudiante_grupo = eg.id_estudiante_grupo


-- si quiero saber el promedio de calificacion de una asignatura en un periodo
select a.id_asignatura, avg(c.calificacion)
from asignatura a inner join calificacion c on c.id_asignatura = a.id_asignatura 
group by a.id_asignatura 
