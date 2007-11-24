drop procedure spu_usuario_mensajeria
;
create procedure spu_usuario_mensajeria
(
    id_usuario integer,
    id_programa integer,
    nombre_usuario char(30)
) returns integer;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return -1;
    end if;

    if not exists (select 1
                    from programamensajeria p
                    where p.pma_id = id_programa) then
       RAISE EXCEPTION -746, 0, 'No existe el programa de mensajeria. [2]';
       return -1;
    end if;

    if nombre_usuario is null or nombre_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el nombre de usuario. [3]';
       return -1;
    end if;

    if exists (select 1
                from usuariomensajeria um
                where um.uma_id = id_programa
                and um.uma_uio_id = id_usuario) then
       update usuariomensajeria
       set uma_nombreusuario = nombre_usuario
       where uma_id = id_programa
       and uma_uio_id = id_usuario;
    else
        insert into usuariomensajeria
        (uma_id, uma_uio_id, uma_nombreusuario) values
        (id_programa, id_usuario, nombre_usuario);
    end if;

    return 0;
end procedure
document
'Fecha de Creacion: 2007-10-13                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario          ID del usuario.                                 ',
'                   id_programa         ID del programa.                                ',
'                   nombre_usuario      Nombre de usuario.                              ',
'                                                                                       ',
'Descripcion:       Agrega o modifica los datos de un usuario de mensajería para el     ',
'                   usuario y el programa de mensajería indicado.                       ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario.                                             ',
'                   - No existe el programa de mensajeria.                              ',
'                   - No se indicó el nombre de usuario.                                ',
'                                                                                       '
with listing in 'informix_warn'
;
