drop procedure sps_mensaje;
create procedure sps_mensaje
(
    id_dest     LIKE mje_uio_id_dest,
    id_rem      LIKE mje_uio_id_rem,
    id_mje      LIKE mje_id    

) RETURNING DATE, VARCHAR, BOOLEAN, BLOB;

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

    if not exists (select 1
                    from mensaje m
                    where m.mje_id = id_mje) then
       RAISE EXCEPTION -746, 0, 'No existe el mensaje. [30]';
       return -1;
    end if;

    
    begin
        define fecha like mensaje.mje_fecha;
        define asunto like mensaje.mje_asunto;
        define leido like mensaje.mje_fueleido;
        define texto like mensaje.mje_texto;
        
        SELECT mje_fecha, mje_asunto, mje_fueleido, mje_texto
        INTO fecha, asunto, leido, texto
        FROM mensaje
        WHERE mje_id = id_mje
    end;
RETURN fecha, asunto, leido, texto;
end procedure
document
'Fecha de Creacion: 2007-11-05                                                          ',
'                                                                                       ',
'Autor:             GMarcello                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_dest            ID del detinatario                               ',
'                   id_rem             ID del remitente                                 ',
'                   id_mje             ID del mensaje                                   ',
'                                                                                       ',
'Descripcion:       Muestra la información del mensaje                                  ',
'                                                                                       ',
'Resultados:        Fecha, asunto, marca de lectura y texto del mensaje                 ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                    -	No existe el usuario remitente.                                 ',
'                    -	No existe el usuario destinatario.                              ',
'                    -	No existe el mensaje.                                        ',
'                                                                                       ',
'                                                                                       ',
with listing in 'informix_warn'
;
