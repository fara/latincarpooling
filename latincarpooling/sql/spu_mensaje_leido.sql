drop procedure spu_mensaje_leido;
create procedure spu_mensaje_leido
(
    id_dest     integer,
    id_rem      integer,
    id_mje      integer    

) returns integer;

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
        update mensaje
        set mje_fueleido = 't'
	where mje_id = id_mje;
    end;
RETURN 0;
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
'Descripcion:       Marca un mensaje como leído                                         ',
'                                                                                       ',
'Resultados:        Cero si no hay errores                                              ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                    -	No existe el usuario remitente.                                 ',
'                    -	No existe el usuario destinatario.                              ',
'                    -	No existe el mensaje.                                           ',
'                                                                                       ',
'                                                                                       ',
with listing in 'informix_warn'
;
