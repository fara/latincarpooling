drop procedure sps_verificar_usuario
;
create procedure sps_verificar_usuario
(
    nombre_usuario char(20),
    contrasena_hash char(254)

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

-- INFORMIX --
--DROP FUNCTION VERIFICAR_USUARIO
CREATE FUNCTION VERIFICAR_USUARIO ( username char(20), password char(254))
RETURNING integer;
RETURN SPS_VERIFICAR_USUARIO(username, password);
END FUNCTION
;

--Probar funcion en informix
select VERIFICAR_USUARIO('tester', 'guionbajo') from systables WHERE tabid = 1;

-- DB2 --
--drop FUNCTION VERIFICAR_UIO
create FUNCTION DB2ADMIN.VERIFICAR_UIO (varchar(20), varchar(254))
RETURNS integer
AS TEMPLATE
DETERMINISTIC
--NO EXTERNAL ACTION

--DROP FUNCTION MAPPING VERIFICAR_UIO_M
CREATE FUNCTION MAPPING VERIFICAR_UIO_M FOR VERIFICAR_UIO
SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'VERIFICAR_USUARIO')
-- Tabla dummy.
CREATE NICKNAME DB2ADMIN.IFXSYSTABLES FOR IFXGUADERIO."informix"."systables";

-- VALIDACION
SELECT  VERIFICAR_UIO('tester', 'guionbajo') FROM ifxsystables where tabid = 1


