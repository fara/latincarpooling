-- Este procedimento debe correrse por unica vez y realiza la carga de los
-- datos requeridos para las pruebas.

create procedure dbo.spi_datos_tests ();
    --Agregamos el usuario de prueba
    if not exists (select 1
                from usuario
                where uio_id = 666) then
        INSERT INTO usuario (uio_id,
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
                '1234-6543                ',
                '1234-3333                ',
                '011-15-5899-5955         ',
                'M',
                't',
                'Thames',
                666,
                1,
                'F   ',
                '1124                ',
                '34555666   ',
                'Argentino                ',
                'f',
                1,
                3832080,
                't');
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

