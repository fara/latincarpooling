-- sps_usuarios_mensajeria
drop procedure dbo.sps_usuarios_mensajeria;

create procedure dbo.sps_usuarios_mensajeria
(
    id_usuario LIKE usuario.uio_id
) RETURNING CHAR(30), INTEGER, CHAR(25);

    DEFINE nombre_usuario LIKE dbo.usuariomensajeria.uma_nombreusuario;
    DEFINE id_programa LIKE dbo.programamensajeria.pma_id;
    DEFINE nombre_programa LIKE dbo.programamensajeria.pma_nombre;

    if not exists (select 1 from usuario where uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return;
    end if;

    FOREACH
        SELECT uma_nombreusuario, pma_id, pma_nombre
        INTO nombre_usuario, id_programa, nombre_programa
        FROM usuariomensajeria, programamensajeria
        WHERE
            uma_uio_id = id_usuario AND uma_id = pma_id

        RETURN nombre_usuario, id_programa, nombre_programa WITH RESUME;
    END FOREACH;

end procedure
document
'Fecha de Creacion: 2007-11-02                                                          ',
'                                                                                       ',
'Autor:             JCapanegra                                                          ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario            El usuario del que se obendran los datos de   ',
'                                         mensajería.                                   ',
'                                                                                       ',
'Descripcion:       Selecciona todos los datos de los usuarios de mensajería que tiene  ',
'                   el usuario que se indico por parámetro al procedimiento.            ',
'                                                                                       ',
'Resultados:        Las filas con los datos de los usuarios del mensajería.             ',
'                   Cada fila tiene el nombre de usuario, el id de programa y el nombre ',
'                   del programa.                                                          ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario. [1]                                  ',
'                                                                                       '
with listing in 'informix_warn'
;
