-- Este procedimento debe correrse por unica vez y realiza la carga de los
-- datos requeridos para las pruebas.

create procedure dbo.spi_datos_tests ();
    --Agregamos el usuario de prueba
    if not exists (select 1
                from usuario
                where uio_nombreusuario = 'test') then
       INSERT INTO usuario(
            uio_id,
            uio_nombre,
            uio_apellido,
            uio_nombreusuario,
            uio_contrasena,
            uio_email,
            uio_chequeofrec,
            uio_telpersonal,
            uio_tellaboral,
            uio_telcelular,
            uio_sexo,
            uio_esfumador,
            uio_calle,
            uio_callealtura,
            uio_piso,
            uio_departamento,
            uio_codigopostal,
            uio_numerodoc,
            uio_nacionalidad,
            uio_info_visible,
            uio_tdo_id,
            uio_cad_id,
            uio_mailverificado)
    VALUES (666,
            'tester',
            'tester',
            'tester',
            'guionbajo',
            'tester at tester.com',
            3,
            '1234-6543',
            '1234-3333',
            '011-15-5899-5955',
            'M',
            '\1', --True
            'Thames',
            666,
            6,
            'F',
            '1124',
            '34555666',
            'Argentino',
            0,
            1,
            3832080,
            '\1'); --True
    end if;

end procedure
document
'Fecha de Creacion: 2007-10-28                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                                                                                       ',
'Descripcion:       Carga los datos de prueba del sistema.                              ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                                                                                       '
with listing in 'informix_warn'
;
execute procedure dbo.spi_datos_tests()
;
drop procedure dbo.spi_datos_tests
;



select *
from usuario;

       INSERT INTO dbo.usuario(
            uio_id,
            uio_nombre,
            uio_apellido,
            uio_nombreusuario,
            uio_contrasena,
            uio_email,
            uio_chequeofrec,
            uio_telpersonal,
            uio_tellaboral,
            uio_telcelular,
            uio_sexo,
            uio_esfumador,
            uio_calle,
            uio_callealtura,
            uio_piso,
            uio_departamento,
            uio_codigopostal,
            uio_numerodoc,
            uio_nacionalidad,
            uio_info_visible,
            uio_tdo_id,
            uio_cad_id,
            uio_mailverificado)
    VALUES (666,
            'tester',
            'tester',
            'tester',
            'guionbajo',
            'tester@tester.com',
            3,
            '1234-6543',
            '1234-3333',
            '011-15-5899-5955',
            'M',
            1, --true
            'Thames',
            666,
            6,
            'F',
            '1124',
            '34555666',
            'Argentino',
            0,
            1,
            3832080,
            -1); --true

load


insert into usuario (
        usuario.uio_id, usuario.uio_nombre, usuario.uio_apellido, usuario.uio_nombreusuario, usuario.uio_contrasena, usuario.uio_email, usuario.uio_chequeofrec, usuario.uio_telpersonal, usuario.uio_tellaboral, usuario.uio_telcelular, usuario.uio_sexo, usuario.uio_esfumador, usuario.uio_calle, usuario.uio_callealtura, usuario.uio_piso, usuario.uio_departamento, usuario.uio_codigopostal, usuario.uio_numerodoc, usuario.uio_nacionalidad, usuario.uio_info_visible, usuario.uio_tdo_id, usuario.uio_cad_id, usuario.uio_mailverificado, usuario.uio_foto
from dbo.usuario usuario


LOAD from 'E:\usuarios.dat' DELIMITER '|'
insert into dbo.usuario (
        uio_id,
        uio_nombre,
        uio_apellido,
        uio_nombreusuario,
        uio_contrasena,
        uio_email,
        uio_chequeofrec,
        uio_telpersonal,
        uio_tellaboral,
        uio_telcelular,
        uio_sexo,
        uio_esfumador,
        uio_calle,
        uio_callealtura,
        uio_piso,
        uio_departamento,
        uio_codigopostal,
        uio_numerodoc,
        uio_nacionalidad,
        uio_info_visible,
        uio_tdo_id,
        uio_cad_id,
        uio_mailverificado,
        uio_foto);


