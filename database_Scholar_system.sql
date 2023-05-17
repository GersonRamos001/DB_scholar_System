CREATE DATABASE SistemaEscolar1;

USE SistemaEscolar1;

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    contrasena VARCHAR(50) NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
	fecha_modificacion DATETIME
);

CREATE TABLE Roles (
    id_rol INT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL
);

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
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
	carnet char(8) unique,
    telefono VARCHAR(20),
    celular VARCHAR(20),
    direccion VARCHAR(200),
    id_nivel_educativo INT,
	fecha_creacion DATETIME DEFAULT GETDATE(),
	fecha_modificacion DATETIME DEFAULT GETDATE()
    CONSTRAINT enum_estudiante_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    CONSTRAINT chk_estudiante_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_estudiante_codigo_postal CHECK (ISNUMERIC(codigo_postal) = 1),
    CONSTRAINT chk_estudiante_fecha_nacimiento CHECK (YEAR(fecha_nacimiento) > YEAR(GETDATE())),
    CONSTRAINT chk_estudiante_edad CHECK (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 0),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);


CREATE TABLE NivelEducativo (
    id_nivel_educativo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);


ALTER TABLE Estudiante
ADD FOREIGN KEY (id_nivel_educativo) REFERENCES NivelEducativo(id_nivel_educativo);

CREATE TABLE Facultad (
    id_facultad INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
);

CREATE TABLE Carrera (
    id_carrera INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_facultad INT NOT NULL,
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad)
);

ALTER TABLE Estudiante
ADD id_carrera INT,
FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera);


CREATE TABLE Especializacion (
    id_especializacion INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY,
    id_usuario INT NOT NULL,
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
	fecha_modificacion DATETIME DEFAULT GETDATE()
    CONSTRAINT enum_profesor_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    CONSTRAINT chk_profesor_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_profesor_fecha_nacimiento CHECK (DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 0),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad),
    FOREIGN KEY (id_especializacion) REFERENCES Especializacion(id_especializacion)
);




CREATE TABLE Asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creditos INT NOT NULL,
    id_carrera INT NOT NULL,
    FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera)
);

CREATE TABLE Grupo (
    id_grupo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_profesor INT NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    ubicacion VARCHAR(200) NOT NULL,
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor),
    CONSTRAINT chk_grupo_hora_inicio_hora_fin CHECK (hora_fin > hora_inicio)
);

CREATE TABLE Estudiante_Grupo (
    id_estudiante_grupo INT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);

CREATE TABLE Periodo (
    id_periodo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CONSTRAINT chk_periodo_fecha_inicio_fecha_fin CHECK (fecha_fin > fecha_inicio)
);

CREATE TABLE Tipo_Calificacion (
    id_tipo_calificacion INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Calificacion (
    id_calificacion INT PRIMARY KEY,
    id_estudiante_grupo INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_periodo INT NOT NULL,
    calificacion DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (id_estudiante_grupo) REFERENCES Estudiante_Grupo(id_estudiante_grupo),
    FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    FOREIGN KEY (id_periodo) REFERENCES Periodo(id_periodo),
    CONSTRAINT chh_calificacion CHECK (calificacion >= 0)
);

ALTER TABLE Calificacion ADD tipo_calificacion INT NOT NULL DEFAULT 0;
ALTER TABLE Calificacion ADD FOREIGN KEY (tipo_calificacion) REFERENCES Tipo_Calificacion(id_tipo_calificacion);



CREATE TABLE Evento (
id_evento INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
fecha_inicio DATETIME NOT NULL,
fecha_fin DATETIME NOT NULL,
CONSTRAINT chk_evento_fecha_inicio_fecha CHECK (fecha_fin > fecha_inicio)
);



CREATE TABLE EventoGrupo (
id_evento INT NOT NULL,
id_grupo INT NOT NULL,
PRIMARY KEY (id_evento, id_grupo),
FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);



-- Agregar algunos datos de ejemplo
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (1, 'Primaria');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (2, 'Secundaria');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (3, 'Bachiller');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (4, 'Universidad');
