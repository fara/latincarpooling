drop procedure dbo.spi_mensaje_crear;
create procedure dbo.spi_mensaje_crear
(
     id_dest     integer,
     id_rem      integer,
     asunto      varchar,
     texto       blob
)
returns integer;
         define nuevo_id like mensaje.mje_id;
         define ultimo_id like mensaje.mje_id;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_dest) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario destino. [27]';
       return -1;
    end if;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_rem) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario remitente. [28]';
       return -1;
    end if;

    if asunto is null then
       RAISE EXCEPTION -746, 0, 'No se indico el asunto del mensaje. [29]';
       return -1;
    end if;


  --obtengo el último id de mensaje cargado
        let ultimo_id = (select max(mje_id) from mensaje);

  --lo incremento en 1
        let nuevo_id = ultimo_id + 1;


         INSERT INTO dbo.mensaje
         (mje_id, mje_fecha, mje_asunto, mje_texto, mje_fueleido,mje_uio_id_dest, mje_uio_id_rem)
         values (nuevo_id, today, asunto, texto, 'f', id_dest, id_rem);


    return nuevo_id;
end procedure