-- No existe el usuario destino
execute procedure spu_mensaje_leido(665,666,10);

-- No existe el usuario remitente
execute procedure spu_mensaje_leido(666,665,10);

-- No existe el mensaje
execute procedure spu_mensaje_leido(666,666,50);

-- Ejecuta OK
execute procedure spu_mensaje_leido(666,666,1);

-- lo muestro
select * from mensaje where mje_id = 1;
