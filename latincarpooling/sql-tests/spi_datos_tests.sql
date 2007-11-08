-- Este procedimento debe correrse por unica vez y realiza la carga de los
-- datos requeridos para las pruebas.

create procedure spi_datos_tests ();
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

    --Agregamos los recorridos de prueba.
    if not exists (select 1
                from recorrido) then
       insert into recorrido
       (rdo_id, rdo_cad_id_origen, rdo_cad_id_destino)
       select tra_id, tra_cad_id1, tra_cad_id2
       from tramo;

       insert into ordenrecorrido
       (oro_rdo_id, oro_tra_id, oro_ordentramo)
       select tra_id, tra_id, 1
       from tramo;
    end if;

    --Insertamos viajes de prueba.
    if not exists (select 1
                from viaje
                where vje_id = 11) then
        insert into viaje
        (vje_id, vje_rdo_id, vje_fechamenor, vje_fechamayor, vje_tipoviaje)
        select rdo_id, rdo_id, (today - rdo_id), (today - rdo_id), 'P'
        from recorrido
        where rdo_id > 10;

        insert into viajepasajeropend
        (vpp_vje_id, vpp_importemaximo, vpp_uio_id)
        select rdo_id, 0, 666
        from recorrido
        where rdo_id > 10;

        insert into viaje
        (vje_id, vje_rdo_id, vje_fechamenor, vje_fechamayor, vje_tipoviaje)
        select rdo_id, rdo_id, (today + rdo_id), (today + rdo_id), 'C'
        from recorrido
        where rdo_id <= 10;

        insert into viajeconductor
        (vcr_vje_id, vcr_uio_id, vcr_cantlugares, vcr_importe, vcr_importeviaje, vcr_lugareslibres)
        select rdo_id, 666, 3, 0, 15, 3
        from recorrido
        where rdo_id <= 10;
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
execute procedure spi_datos_tests()
;
drop procedure spi_datos_tests
;
