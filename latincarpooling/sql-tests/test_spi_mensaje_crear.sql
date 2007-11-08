--   No existe el usuario destino.
execute procedure spi_mensaje_crear (665, 666, 'testing', null);

--   No existe el usuario remitente
execute procedure spi_mensaje_crear (666, 665, 'testing', null);

--   No se indico el asunto del mensaje
execute procedure spi_mensaje_crear (666, 666, NULL , null);

--   Ejecuta OK
execute procedure spi_mensaje_crear (666, 666, 'testing' , null);
