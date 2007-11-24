drop procedure spd_vehiculo;
create procedure spd_vehiculo
(
    id_vehiculo integer,
    id_usuario integer
) returns integer;

--  VALIDACION DE PARAMETROS OBLIGATORIOS
    if id_usuario is null or id_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el id de usuario. [3]';
       return -1;
    end if;
    if id_vehiculo is null or id_vehiculo = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el id de vehiculo. [3]';
       return -1;
    end if;

    if not exists (select 1 from vehiculo v
                    where v.vlo_uio_id = id_usuario
                    and v.vlo_id = id_vehiculo) then
       RAISE EXCEPTION -746, 0, 'No existe el vehiculo. [1]';
       return -1;
    end if;

    delete from vehiculo
    where vlo_uio_id = id_usuario and vlo_id = id_vehiculo;

    return 0;
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
'Descripcion:       Elimina el vehículo del usuario indicado.                           ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el vehiculo                                             ',
'                                                                                       '
with listing in 'informix_warn';
