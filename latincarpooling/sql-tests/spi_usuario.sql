-- Eliminar todos los usuarios
delete from usuario;

-- Insertar primer usuario -> Ok
execute procedure spi_usuario('Fernando', 'Aramendi', 'faramendi', 'faramendi', 'faramendi@gmail.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);

-- Insertar el mismo usuario (mismo alias) -> Ya existe el usuario
execute procedure spi_usuario('Fernando', 'Aramendi', 'faramendi', 'faramendi', 'faramendi@gmail.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);

-- Inserta con parametros nulos -> No se inidicó el -nombreparametro-
execute procedure spi_usuario(null, 'Aramendi', null, 'faramendi', 'faramendi@gmail.com',
1, '4290-4657', '15-5122-4888', '4779-6800', 'f', 'M', 'Medrano', 951, 3, '-', '1842', 3436521, 1, '30526985', 
'Argentino', 't', null);