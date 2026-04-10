SELECT u.nombre, l.titulo, t.tipo, t.fecha_operacion 
FROM transacciones t
JOIN usuarios u ON t.id_usuario = u.id_usuario
JOIN libros l ON t.id_libro = l.id_libro;