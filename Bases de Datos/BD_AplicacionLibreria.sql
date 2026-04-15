-- 1. CREACIÓN DE BASE DE DATOS

DROP DATABASE IF EXISTS libreria;
CREATE DATABASE libreria;
USE libreria;


-- 2. MODELO RELACIONAL (CON HERENCIA)



-- TABLA PERSONA (HERENCIA)
-- Para la Web
CREATE TABLE persona (
    id_persona INT AUTO_INCREMENT,
    tipo ENUM('cliente','empleado') NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni CHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    PRIMARY KEY (id_persona),
    CHECK (dni REGEXP '^[0-9]{8}[A-Z]$')
);


-- SUBCLASE CLIENTE

CREATE TABLE cliente (
    id_cliente INT,
    descuento DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES persona(id_persona)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (descuento >= 0 AND descuento <= 50)
);


-- SUBCLASE EMPLEADO

CREATE TABLE empleado (
    id_empleado INT,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_empleado) REFERENCES persona(id_persona)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (salario > 0)
);


-- EDITORIAL

CREATE TABLE editorial (
    id_editorial INT AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (id_editorial)
);


-- AUTOR

CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_autor)
);


-- CATEGORIA

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (id_categoria)
);


-- LIBRO

CREATE TABLE libro (
    id_libro INT AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    precio DECIMAL(6,2) NOT NULL,
    stock INT DEFAULT 0,
    id_editorial INT,
    id_categoria INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_editorial) REFERENCES editorial(id_editorial),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CHECK (precio > 0)
);


-- RELACIÓN N:N LIBRO-AUTOR

CREATE TABLE libro_autor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor) ON DELETE CASCADE
);


-- PEDIDO

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT,
    fecha DATE DEFAULT current_timestamp,
    total DECIMAL(8,2) DEFAULT 0,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);



-- 3. INSERTS (DATOS INICIALES)
-- Los Datos se los pedi a la IA


INSERT INTO persona (tipo,nombre,apellidos,dni,email) VALUES
('empleado','Ana','Lopez','12345678A','ana@mail.com'),
('cliente','Luis','Perez','23456789B','luis@mail.com');

INSERT INTO empleado VALUES (1,'gerente',2000);
INSERT INTO cliente VALUES (2,5);

INSERT INTO editorial (nombre) VALUES ('Planeta');
INSERT INTO categoria (nombre) VALUES ('Novela');

INSERT INTO autor (nombre) VALUES ('Gabriel Garcia Marquez');

INSERT INTO libro (titulo,isbn,precio,stock,id_editorial,id_categoria)
VALUES ('Cien años de soledad','123-1234567890',20,10,1,1);

INSERT INTO libro_autor VALUES (1,1);

INSERT INTO pedido (id_cliente,total) VALUES (2,20);
INSERT INTO linea_pedido (id_pedido,id_libro,cantidad) VALUES (1,1,1);


-- 4. CRUD


-- UPDATE
UPDATE libro SET stock = stock - 1 WHERE id_libro = 1;

-- DELETE
DELETE FROM linea_pedido WHERE id_linea = 1;

-- SELECT
SELECT * FROM libro;


-- 5. CONSULTAS AVANZADAS


-- GROUP BY + SUM
SELECT l.titulo, SUM(lp.cantidad) AS vendidos
FROM libro l
JOIN linea_pedido lp ON l.id_libro = lp.id_libro
GROUP BY l.titulo;

-- AVG
SELECT AVG(precio) FROM libro;

-- SUBCONSULTA
SELECT nombre FROM persona
WHERE id_persona IN (
    SELECT id_cliente FROM pedido
);

-- JOIN
SELECT p.nombre, l.titulo
FROM persona p
JOIN pedido pe ON p.id_persona = pe.id_cliente
JOIN linea_pedido lp ON pe.id_pedido = lp.id_pedido
JOIN libro l ON lp.id_libro = l.id_libro;


-- 6. VISTAS

CREATE VIEW vista_libros AS
SELECT titulo, precio, stock FROM libro;


-- 7. USUARIOS Y SEGURIDAD por si acaso

CREATE USER 'usuario_lectura'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'usuario_admin'@'localhost' IDENTIFIED BY 'admin123';

