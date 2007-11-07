drop procedure dbo.sps_vehiculos;
create procedure dbo.sps_vehiculos
(
    id_usuario  integer
) returning integer, char(30), char(30), char(30), integer, numeric(6,2), boolean, smallint;

    DEFINE id LIKE dbo.vehiculo.vlo_id;
    DEFINE modelo LIKE dbo.vehiculo.vlo_modelo;
    DEFINE color LIKE dbo.vehiculo.vlo_color;
    DEFINE patente LIKE dbo.vehiculo.vlo_patente;
    DEFINE cle_id LIKE dbo.vehiculo.vlo_cle_id;
    DEFINE consumo LIKE dbo.vehiculo.vlo_consumo;
    DEFINE tieneac LIKE dbo.vehiculo.vlo_tieneac;
    DEFINE asientos LIKE dbo.vehiculo.vlo_asientos;

    if id_usuario is null or id_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el id de usuario. [3]';
       return;
    end if;

-- VALIDO QUE EXISTA EL USUARIO
    if not exists (select 1 from usuario u
                    where u.uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return;
    end if;

    FOREACH
        SELECT vlo_uio_id, vlo_modelo, vlo_color, vlo_patente, vlo_cle_id,
            vlo_consumo, vlo_tieneac, vlo_asientos
        INTO id, modelo, color, patente, cle_id, consumo, tieneac, asientos
        FROM vehiculo
        WHERE vlo_uio_id = id_usuario
        RETURN id, modelo, color, patente, cle_id, consumo, tieneac, asientos
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
'                   id_vehiculo                 ID de vehiculo                          ',
'                                                                                       ',
'Descripcion:       Selecciona todos los datos del usuario que tiene el id indicado.    ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario                                              ',
'                                                                                       '
with listing in 'informix_warn';
