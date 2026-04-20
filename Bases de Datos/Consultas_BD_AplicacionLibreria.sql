SELECT u.nombre, l.titulo, t.tipo, t.fecha_operacion 
FROM transacciones t
JOIN usuarios u ON t.id_usuario = u.id_usuario
JOIN libros l ON t.id_libro = l.id_libro;

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