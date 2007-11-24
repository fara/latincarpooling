drop procedure spd_usuario_mensajeria;
create procedure spd_usuario_mensajeria
(
    id_usuario integer,
    id_programa integer
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

    if not exists (select 1
               from usuariomensajeria um
               where um.uma_id = id_programa
               and um.uma_uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el nombre de usuario para ese usuario y programa de mensajería. [5]';
       return -1;
    end if;

    delete from usuariomensajeria
    where uma_id = id_programa
    and uma_uio_id = id_usuario;

   return 0;
end procedure
document
'Fecha de Creacion: 2007-10-15                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario          ID del usuario.                                 ',
'                   id_programa         ID del programa.                                ',
'                                                                                       ',
'Descripcion:       Elimina los datos de un usuario de mensajería para el programa y el ',
'                           usuario indicados.                                          ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario.                                             ',
'                   - No existe el programa de mensajeria.                              ',
'                   - No existe el nombre de usuario para ese usuario y programa de     ',
'                     mensajería.                                                       ',
'                                                                                       '
with listing in 'informix_warn';

