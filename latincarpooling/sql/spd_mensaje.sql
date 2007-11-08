drop procedure spd_mensaje
;
create procedure spd_mensaje
(
    id_dest     integer,
    id_rem      integer,
    id_mje      integer,
    id_actual   integer

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

    if (id_dest != id_actual) then
       RAISE EXCEPTION -746, 0, 'El mensaje no puede ser borrado. Debe ser el usuario destinatario para poder hacerlo. [27]';
       return -1;
    end if;



        delete from mensaje
        where mje_id = id_mje and
              mje_uio_id_dest = id_dest and
              mje_uio_id_rem = id_rem;

    return 0;
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
'                   id_actual          ID del usuario actual                            ',
'                                                                                       ',
'Descripcion:       Borra el mensaje indicado. Solo permite que sea borrado por el      ',
'                   destinatario                                                        ',
'                                                                                       ',
'Resultados:        Cero si no hay errores                                              ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                    -  No existe el usuario remitente.                                 ',
'                    -  No existe el usuario destinatario.                              ',
'                    -  No existe el mensaje.                                           ',
'                    -  El mensaje no puede ser borrado. Debe ser el usuario            ',
'                       destinatario para poder hacerlo.                                ',
'                                                                                       ',
with listing in 'informix_warn'
;
