drop procedure sps_mensajes_recib;
create procedure sps_mensajes_recib
(
    id_dest     integer

) returns INTEGER, INTEGER, BOOLEAN, DATE, VARCHAR;

        define rem   like mensaje.mje_uio_id_rem;
        define id_mje like mensaje.mje_id;
        define leido like mensaje.mje_fueleido;
        define fecha like mensaje.mje_fecha;
        define asunto like mensaje.mje_asunto;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_dest) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario destino. [27]';
       return -1, 0, 'f', 0000-00-00, '';
    end if;



        FOREACH
        SELECT mje_uio_id_rem, mje_id, mje_fueleido, mje_fecha, mje_asunto
        INTO rem, id_mje, leido, fecha, asunto
        FROM mensaje
        WHERE
            mje_uio_id_dest = id_dest
        ORDER BY mje_fecha

        RETURN rem, id_mje, leido, fecha, asunto WITH RESUME;
    END FOREACH;

end procedure
document
'Fecha de Creacion: 2007-11-05                                                          ',
'                                                                                       ',
'Autor:             GMarcello                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_dest            ID del detinatario                               ',
'                                                                                       ',
'Descripcion:       Devuelve la lista de mensajes recibidos por el destinatario         ',
'                   ordenada por fecha.                                                 ',
'                                                                                       ',
'Resultados:        Remitente, ID del mensaje, marca de lectura, fecha y asunto         ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                    -  No existe el usuario destinatario.                              ',
'                                                                                       ',
'                                                                                       '
with listing in 'informix_warn'
;
