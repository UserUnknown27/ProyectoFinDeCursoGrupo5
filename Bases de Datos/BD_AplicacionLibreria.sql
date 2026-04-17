DROP DATABASE IF EXISTS libreria;
CREATE DATABASE libreria;
USE libreria;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT,
    tipo ENUM('cliente','empleado') NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    dni CHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    contraseña VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_usuario),
    CHECK (dni REGEXP '^[0-9]{8}[A-Z]$')
);

CREATE TABLE cliente (
    id_cliente INT,
    descuento DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (descuento >= 0 AND descuento <= 50)
);

CREATE TABLE empleado (
    id_empleado INT,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_empleado) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (salario > 0)
);

CREATE TABLE editorial (
    id_editorial INT AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (id_editorial)
);

CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_autor)
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (id_categoria)
);

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

CREATE TABLE libro_autor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor) ON DELETE CASCADE
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT,
    fecha DATE DEFAULT (CURRENT_DATE),
    total DECIMAL(8,2) DEFAULT 0,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

INSERT INTO usuario (tipo, nombre_completo, dni, email, contraseña) VALUES
('empleado', 'Ana Lopez', '12345678A', 'ana@mail.com', 'pass123'),
('cliente', 'Luis Perez', '23456789B', 'luis@mail.com', 'pass456');

INSERT INTO empleado (id_empleado, cargo, salario) VALUES (1, 'gerente', 2000);
INSERT INTO cliente (id_cliente, descuento) VALUES (2, 5);

INSERT INTO editorial (nombre) VALUES ('Planeta');
INSERT INTO categoria (nombre) VALUES ('Novela');
INSERT INTO autor (nombre) VALUES ('Gabriel Garcia Marquez');

INSERT INTO libro (titulo, isbn, precio, stock, id_editorial, id_categoria)
VALUES ('Cien años de soledad', '123-1234567890', 20, 10, 1, 1);

INSERT INTO pedido (id_cliente, total) VALUES (2, 20);

UPDATE libro SET stock = stock - 1 WHERE id_libro = 1;

SELECT * FROM libro;

SELECT c.id_cliente, COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente;

SELECT AVG(precio) FROM libro;

SELECT nombre_completo FROM usuario
WHERE id_usuario IN (
    SELECT id_cliente FROM pedido
);

SELECT u.nombre_completo, l.titulo
FROM usuario u
JOIN pedido p ON u.id_usuario = p.id_cliente
JOIN libro l ON l.id_libro = 1;

CREATE VIEW vista_libros AS
SELECT titulo, precio, stock FROM libro;

SELECT * FROM vista_libros;