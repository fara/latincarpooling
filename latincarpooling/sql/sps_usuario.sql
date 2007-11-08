drop procedure sps_usuario;
create procedure sps_usuario
(
    id_usuario integer
) returning int, char(50), char(50), char(20), varchar(255), varchar(255), char(25), char(25), char(25), char(1), boolean, varchar(100), int, char(4), char(20), char(11), char(25), boolean, int, int, boolean, blob, smallint, smallint;

    DEFINE id int;
    DEFINE nombre char(50);
    DEFINE apellido char(50);
    DEFINE nombreusuario char(20);
    DEFINE contrasena varchar(255);
    DEFINE email varchar(255);
    DEFINE telpersonal char(25);
    DEFINE tellaboral char(25);
    DEFINE telcelular char(25);
    DEFINE sexo char(1);
    DEFINE esfumador boolean;
    DEFINE calle varchar(100);
    DEFINE callealtura int;
    DEFINE departamento char(4);
    DEFINE codigopostal char(20);
    DEFINE numerodoc char(11);
    DEFINE nacionalidad char(25);
    DEFINE info_visible boolean;
    DEFINE tdo_id int;
    DEFINE cad_id int;
    DEFINE mailverificado boolean;
    DEFINE foto blob;
    DEFINE chequeofrec smallint;
    DEFINE piso smallint;

    if id_usuario is null or id_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el id de usuario. [3]';
       return;
    end if;

    if not exists (select 1
                    from usuario u
                    where u.uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return;
    end if;

    FOREACH
        SELECT uio_id,uio_nombre,uio_apellido,uio_nombreusuario,uio_contrasena,
                uio_email,uio_telpersonal,uio_tellaboral,uio_telcelular,uio_sexo,
                uio_esfumador,uio_calle,uio_callealtura,uio_departamento,uio_codigopostal,
                uio_numerodoc,uio_nacionalidad,uio_info_visible,uio_tdo_id,uio_cad_id,
                uio_mailverificado,uio_foto,uio_chequeofrec,uio_piso
        INTO id,nombre,apellido,nombreusuario,contrasena,
                email,telpersonal,tellaboral,telcelular,sexo,
                esfumador,calle,callealtura,departamento,codigopostal,
                numerodoc,nacionalidad,info_visible,tdo_id,cad_id,
                mailverificado,foto,chequeofrec,piso
        FROM usuario
        WHERE uio_id = id_usuario
        RETURN id,nombre,apellido,nombreusuario,contrasena,
                email,telpersonal,tellaboral,telcelular,sexo,
                esfumador,calle,callealtura,departamento,codigopostal,
                numerodoc,nacionalidad,info_visible,tdo_id,cad_id,
                mailverificado,foto,chequeofrec,piso
        WITH RESUME;
    END FOREACH;

end procedure
document
'Fecha de Creacion: 2007-11-03                                                          ',
'                                                                                       ',
'Autor:             faramendi                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario                  ID de usuario                           ',
'                                                                                       ',
'Descripcion:       Selecciona todos los datos del usuario que tiene el id indicado.    ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario                                              ',
'                                                                                       '
with listing in 'informix_warn';
