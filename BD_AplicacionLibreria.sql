CREATE DATABASE gestion_libreria;
USE gestion_libreria;

-- 1. Usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    rol ENUM('cliente', 'empleado') NOT NULL
);

-- 2. Libros
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100),
    precio DECIMAL(10, 2),
    stock INT DEFAULT 0,
    categoria VARCHAR(50)
);

-- 3. Transacciones
CREATE TABLE transacciones (
    id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_libro INT,
    tipo ENUM('compra', 'renta') NOT NULL,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);