drop procedure sps_mensajes_envi;
create procedure sps_mensajes_envi
(
    id_rem     integer

) returns INTEGER, INTEGER, BOOLEAN, DATE, VARCHAR;

        define dest   like mensaje.mje_uio_id_dest;
        define id_mje like mensaje.mje_id;
        define leido like mensaje.mje_fueleido;
        define fecha like mensaje.mje_fecha;
        define asunto like mensaje.mje_asunto;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_rem) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario remitente. [28]';
       return -1, -1, 'f', 0000-00-00, '';
    end if;
        
	FOREACH
        SELECT mje_uio_id_dest, mje_id, mje_fueleido, mje_fecha, mje_asunto 
	INTO dest, id_mje, leido, fecha, asunto
        FROM mensaje
        WHERE
            mje_uio_id_rem = id_rem
	ORDER BY mje_fecha

        RETURN dest, id_mje, leido, fecha, asunto WITH RESUME;
    END FOREACH;

end procedure
document
'Fecha de Creacion: 2007-11-05                                                          ',
'                                                                                       ',
'Autor:             GMarcello                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_rem            ID del remitente                                  ',
'                                                                                       ',
'Descripcion:       Devuelve la lista de mensajes enviados por el remitente             ',
'                   ordenada por fecha.                                                 ',
'                                                                                       ',
'Resultados:        Destinatario, ID del mensaje, marca de lectura, fecha y asunto      ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                    -	No existe el usuario remitente   .                              ',
'                                                                                       ',
'                                                                                       ',
with listing in 'informix_warn'
;
