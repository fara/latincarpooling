drop procedure sps_verificar_usuario
;
create procedure sps_verificar_usuario
(
    nombre_usuario char(20),
    contrasena_hash char(255)

) returning integer;

    define id_usuario integer;

    if nombre_usuario is null or nombre_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se ingreso un usuario. [6]';
       return 0;
    end if;

    if contrasena_hash is null or contrasena_hash = '' then
       RAISE EXCEPTION -746, 0, 'No se ingreso la contraseña. [7]';
       return 0;
    end if;

    let id_usuario = (select u.uio_id
        from usuario u
        where u.uio_nombreusuario = nombre_usuario
        and u.uio_contrasena = contrasena_hash);

    if id_usuario is null then
        let id_usuario = 0;
    end if;

    return id_usuario;

end procedure
document
'Fecha de Creacion: 2007-10-15                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   nombre_usuario      Nombre del usuario.                             ',
'                   contrasena_hash     Hash MD5 de la contraseña                       ',
'                                                                                       ',
'Descripcion:       Verifica que el nombre de usuario y la contraseña indicada sean las ',
'                   correctas con respecto a la información almacenada.                 ',
'                                                                                       ',
'Resultados:        ID del usuario si la informacion es correcta.                       ',
'                   Cero en otro caso.                                                  ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No se ingresó un usuario.                                         ',
'                   - No se ingresó la contraseña.                                      ',
'                                                                                       '
with listing in 'informix_warn'
;

