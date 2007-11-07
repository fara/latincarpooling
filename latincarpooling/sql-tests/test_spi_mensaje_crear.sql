--   No existe el usuario destino.
execute procedure dbo.spi_mensaje_crear (665, 666, 'testing', FILETOBLOB('E:\1.txt', 'server'));

--   No existe el usuario remitente
execute procedure dbo.spi_mensaje_crear (666, 665, 'testing', FILETOBLOB('E:\1.txt', 'server'));

--   No se indico el asunto del mensaje
execute procedure dbo.spi_mensaje_crear (666, 666, NULL , FILETOBLOB('E:\1.txt', 'server'));

--   Ejecuta OK
execute procedure dbo.spi_mensaje_crear (666, 666, 'testing' , FILETOBLOB('E:\1.txt', 'server'));