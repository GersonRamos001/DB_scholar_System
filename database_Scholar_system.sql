create DATABASE SistemaEscolar1;

use SistemaEscolar1;

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo char(1) NOT NULL,  --CONSTRAIN MISSING ONLY 'M' O 'F'
    nacionalidad VARCHAR(50),
    ciudad_origen VARCHAR(50),
    codigo_postal VARCHAR(10),
    email VARCHAR(100), -- podriamos validar email con sp
    telefono VARCHAR(20),
   -- celular VARCHAR(20),
    direccion VARCHAR(200),
    id_nivel_educativo INT,
	--ADD EMAIL SCHOLAR
    CONSTRAINT enum_estudiante_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    -- CONSTRAINT chk_estudiante_telefono CHECK (telefono LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]')
    CONSTRAINT chk_estudiante_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_estudiante_codgio_postal CHECK (ISNUMERIC(codigo_postal) = 1),
    CONSTRAINT chk_estudiante_fecha_nacimiento CHECK (YEAR(fecha_nacimiento) > YEAR(GETDATE()))
);




CREATE TABLE NivelEducativo (
    id_nivel_educativo INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Modificar la tabla Estudiante para hacer referencia a NivelEducativo
ALTER TABLE Estudiante
ADD FOREIGN KEY (id_nivel_educativo) REFERENCES NivelEducativo(id_nivel_educativo);

-- rename a Docente (?)
CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo char(1) NOT NULL,
    email VARCHAR(100),  
    telefono VARCHAR(20),
    --celular VARCHAR(20),
    direccion VARCHAR(200),
    especialidad VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    activo TINYINT NOT NULL DEFAULT 1,
    CONSTRAINT enum_profesor_sexo CHECK (sexo = 'M' OR sexo = 'F'),
    -- CONSTRAINT chk_profesor_telefono CHECK (telefono LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]')
    CONSTRAINT chk_profesor_celular CHECK (celular LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]'),
    CONSTRAINT chk_profesor_codgio_postal CHECK (ISNUMERIC(codigo_postal) = 1),
    CONSTRAINT chk_profesor_fecha_nacimiento CHECK (YEAR(fecha_nacimiento) > YEAR(GETDATE()))
);


CREATE TABLE Asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creditos INT NOT NULL
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
-- Agregamos la clave for�nea a la tabla Tipo_Calificacion
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

CREATE TABLE Editorial (
    id_editorial INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    CONSTRAINT chk_editorial_telefono CHECK (telefono LIKE '[1-9][1-9][1-9][1-9]-[1-9][1-9][1-9][1-9]')
);


CREATE TABLE Biblioteca (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    id_editorial INT,
    descripcion TEXT,
    fecha_publicacion DATE,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial)
);


CREATE TABLE Estado (
    id_estado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Prestamo (
    id_prestamo INT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    -- mora int not null -- Dias de mora del prestamo (?)
    id_estado INT NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    FOREIGN KEY (id_libro) REFERENCES Biblioteca(id_libro),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado),
    CONSTRAINT chk_prestamo_fecha_prestamo_fecha_devolucion CHECK (fecha_prestamo > fecha_devolucion)
    -- CONSTAINT chk_prestamo_mora CHECK (mora >= 0)
);

-- Agregar algunos datos de ejemplo
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (1, 'Primaria');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (2, 'Secundaria');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (3, 'Bachiller');
INSERT INTO NivelEducativo (id_nivel_educativo, nombre) VALUES (4, 'Universidad');