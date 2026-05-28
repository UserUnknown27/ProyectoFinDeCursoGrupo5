-- ============================================================================
-- 1. CONFIGURACIÓN Y ESTRUCTURAS DE USUARIOS
-- ============================================================================

DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca;
USE biblioteca;

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
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    edad INT,
    descuento DECIMAL(5,2) DEFAULT 0,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (edad >= 0 AND edad <= 120),
    CHECK (descuento >= 0 AND descuento <= 50)
);

CREATE TABLE empleado (
    id_empleado INT,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    telefono INT,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_empleado) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (salario > 0)
);

-- ============================================================================
-- 2. CATÁLOGO Y CARACTERÍSTICAS DE PRODUCTOS
-- ============================================================================

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
    id_empleado INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_editorial) REFERENCES editorial(id_editorial),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    CHECK (precio > 0),
    CHECK (stock >= 0)
);

CREATE TABLE libro_autor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor) ON DELETE CASCADE
);

-- ============================================================================
-- 3. OPERACIONES TRANSACCIONALES (COMPRAS Y ALQUILERES)
-- ============================================================================

CREATE TABLE pago_libro (
    id_pago_libro INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha DATE DEFAULT (CURRENT_DATE),
    metodo_pago VARCHAR(50),
    monto_iva FLOAT DEFAULT 0,
    total DECIMAL(8,2) DEFAULT 0,
    PRIMARY KEY (id_pago_libro),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_compra (
    id_detalle_compra INT AUTO_INCREMENT,
    id_pago_libro INT NOT NULL,
    id_libro INT NOT NULL,
    precio_libro DECIMAL(8,2) NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id_detalle_compra),
    FOREIGN KEY (id_pago_libro) REFERENCES pago_libro(id_pago_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
    CHECK (cantidad > 0),
    CHECK (precio_libro > 0)
);

CREATE TABLE pago_alquiler (
    id_pago_alquiler INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha DATE DEFAULT (CURRENT_DATE),
    metodo_pago VARCHAR(50),
    monto_iva FLOAT DEFAULT 0,
    PRIMARY KEY (id_pago_alquiler),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_alquiler (
    id_detalle_alquiler INT AUTO_INCREMENT,
    id_pago_alquiler INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    precio_alquiler DECIMAL(8,2) NOT NULL,
    estado_libro VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_detalle_alquiler),
    FOREIGN KEY (id_pago_alquiler) REFERENCES pago_alquiler(id_pago_alquiler) ON DELETE CASCADE,
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
    CHECK (fecha_fin > fecha_inicio),
    CHECK (precio_alquiler > 0)
);

-- ============================================================================
-- 4. OPTIMIZACIÓN Y PROGRAMACIÓN (VISTAS, ÍNDICES Y RUTINAS)
-- ============================================================================

CREATE VIEW vista_libros AS
SELECT titulo, precio AS precio_venta, stock FROM libro;

CREATE VIEW vista_clientes_contacto AS
SELECT nombre_completo, email, telefono FROM usuario WHERE tipo = "cliente";

CREATE INDEX idx_libro_titulo ON libro(titulo);
CREATE INDEX idx_usuario_nombre ON usuario(nombre_completo);

DELIMITER //

CREATE FUNCTION totalLibros()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM libro;
    RETURN total;
END //

CREATE FUNCTION pedidosActivos(p_cliente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM pago_libro WHERE id_cliente = p_cliente;
    RETURN total;
END //

CREATE FUNCTION puedePedirMas(p_cliente INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM pago_libro WHERE id_cliente = p_cliente;
    
    IF total < 3 THEN
        RETURN "SI";
    ELSE
        RETURN "NO";
    END IF;
END //

CREATE PROCEDURE insertar_libro(
    IN p_titulo VARCHAR(200),
    IN p_isbn VARCHAR(20),
    IN p_precio DECIMAL(6,2),
    IN p_stock INT,
    IN p_editorial INT,
    IN p_categoria INT,
    IN p_empleado INT
)
BEGIN
    INSERT INTO libro (titulo, isbn, precio, stock, id_editorial, id_categoria, id_empleado)
    VALUES (p_titulo, p_isbn, p_precio, p_stock, p_editorial, p_categoria, p_empleado);
END //

CREATE TRIGGER tg_validar_stock_update
BEFORE UPDATE ON libro
FOR EACH ROW
BEGIN
    IF NEW.stock < 0 THEN
        SET NEW.stock = 0;
    END IF;
END //

DELIMITER ;

-- ============================================================================
-- 5. SEGURIDAD, ROLES Y PRIVILEGIOS
-- ============================================================================

CREATE ROLE IF NOT EXISTS "rol_administrador";
CREATE ROLE IF NOT EXISTS "rol_empleado";

CREATE USER IF NOT EXISTS "daniel"@"localhost" IDENTIFIED BY "daniel";
CREATE USER IF NOT EXISTS "gloria"@"localhost" IDENTIFIED BY "gloria";
CREATE USER IF NOT EXISTS "alejandro"@"localhost" IDENTIFIED BY "alejandro";

GRANT "rol_administrador" TO "alejandro"@"localhost";
GRANT "rol_empleado" TO "daniel"@"localhost", "gloria"@"localhost";

GRANT ALL PRIVILEGES ON libreria.* TO "rol_administrador";

GRANT SELECT, INSERT, UPDATE, DELETE ON libreria.libro TO "rol_empleado";
GRANT SELECT, INSERT, UPDATE, DELETE ON libreria.pago_libro TO "rol_empleado";
GRANT SELECT, INSERT, UPDATE, DELETE ON libreria.detalle_compra TO "rol_empleado";
GRANT SELECT, INSERT, UPDATE, DELETE ON libreria.cliente TO "rol_empleado";
GRANT SELECT ON libreria.vista_libros TO "rol_empleado";
GRANT SELECT ON libreria.vista_clientes_contacto TO "rol_empleado";
GRANT EXECUTE ON PROCEDURE libreria.insertar_libro TO "rol_empleado";

FLUSH PRIVILEGES;

SET DEFAULT ROLE "rol_administrador" TO "alejandro"@"localhost";
SET DEFAULT ROLE "rol_empleado" TO "daniel"@"localhost", "gloria"@"localhost";

-- ============================================================================
-- 6. CARGA DE DATOS (INSERCIONES)
-- ============================================================================

INSERT INTO usuario (id_usuario, tipo, nombre_completo, dni, email, contraseña) VALUES
(1, "empleado", "Ana López", "12345678A", "ana@libreria.com", "hash_ana_2024"),
(2, "empleado", "Carlos Ruiz", "23456789B", "carlos@libreria.com", "hash_carlos_2024"),
(3, "cliente", "Sofía Torres", "34567890C", "sofia@gmail.com", "hash_sofia_2024"),
(4, "cliente", "Pablo Navarro", "45678901D", "pablo@gmail.com", "hash_pablo_2024"),
(5, "cliente", "Elena Moreno", "56789012E", "elena@hotmail.com", "hash_elena_2024");

INSERT INTO empleado (id_empleado, cargo, salario, telefono) VALUES
(1, "gerente", 2000.00, 600111222),
(2, "dependiente", 1400.00, 600333444);

INSERT INTO cliente (id_cliente, fecha_registro, edad, descuento) VALUES
(3, "2024-01-15", 28, 5.00),
(4, "2024-03-10", 35, 0.00),
(5, "2024-05-20", 22, 10.00);

INSERT INTO editorial (nombre) VALUES ("Planeta"), ("Alfaguara"), ("Salamandra");
INSERT INTO categoria (nombre) VALUES ("Realismo mágico"), ("Terror"), ("Novela"), ("Historia"), ("Thriller");
INSERT INTO autor (nombre) VALUES ("Gabriel García Márquez"), ("Stephen King"), ("Haruki Murakami"), ("Ken Follett"), ("Umberto Eco");

INSERT INTO libro (id_libro, isbn, titulo, precio, stock, id_editorial, id_categoria, id_empleado) VALUES
(1, "9780000000001", "Cien años de soledad", 20.00, 10, 1, 1, 1),
(2, "9780000000002", "It", 22.90, 8, 2, 2, 1),
(3, "9780000000003", "Tokio blues", 17.95, 12, 1, 3, 2),
(4, "9780000000004", "Los pilares de la Tierra", 24.00, 6, 2, 4, 2),
(5, "9780000000005", "El nombre de la rosa", 21.50, 4, 3, 5, 1);

INSERT INTO libro_autor (id_libro, id_autor) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO pago_libro (id_pago_libro, id_cliente, fecha, metodo_pago, monto_iva, total) VALUES
(1, 3, "2025-03-10", "tarjeta", 4.14, 37.95),
(2, 4, "2025-04-05", "efectivo", 5.04, 24.00),
(3, 5, "2025-05-01", "tarjeta", 3.75, 22.90);

INSERT INTO detalle_compra (id_pago_libro, id_libro, precio_libro, cantidad) VALUES
(1, 1, 20.00, 1),
(1, 3, 17.95, 1),
(2, 4, 24.00, 1),
(3, 2, 22.90, 1);

INSERT INTO pago_alquiler (id_pago_alquiler, id_cliente, fecha, metodo_pago, monto_iva) VALUES
(1, 3, "2025-04-01", "tarjeta", 0.63),
(2, 4, "2025-05-10", "efectivo", 0.85);

INSERT INTO detalle_alquiler (id_pago_alquiler, id_libro, fecha_inicio, fecha_fin, precio_alquiler, estado_libro) VALUES
(1, 5, "2025-04-01", "2025-04-15", 3.00, "bueno"),
(2, 1, "2025-05-10", "2025-05-24", 3.50, "bueno");

-- ============================================================================
-- 7. CONSULTAS Y COMPROBACIONES DE VERIFICACIÓN
-- ============================================================================

UPDATE libro SET stock = stock - 1 WHERE id_libro = 1;

SELECT * FROM libro;

SELECT id_cliente, COUNT(id_pago_libro) AS total_compras
FROM pago_libro
GROUP BY id_cliente;

SELECT AVG(precio) FROM libro;

SELECT nombre_completo FROM usuario
WHERE id_usuario IN (
    SELECT id_cliente FROM pago_libro
);

SELECT u.nombre_completo, l.titulo, dc.cantidad, dc.precio_libro
FROM usuario u
JOIN pago_libro p ON u.id_usuario = p.id_cliente
JOIN detalle_compra dc ON p.id_pago_libro = dc.id_pago_libro
JOIN libro l ON dc.id_libro = l.id_libro;

SELECT * FROM vista_libros;
SELECT totalLibros();
SELECT id_cliente, puedePedirMas(id_cliente) FROM cliente;
