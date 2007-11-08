-- sps_buscar_viaje
drop procedure sps_buscar_viaje;

create procedure sps_buscar_viaje
(
    id_ciudad_origen LIKE ciudad.cad_id,
    id_ciudad_destino LIKE ciudad.cad_id
) RETURNING integer;

    DEFINE id_viaje LIKE viaje.vje_id;

    if not exists (select 1 from ciudad where cad_id = id_ciudad_origen) then
       RAISE EXCEPTION -746, 0, 'La ciudad origen no existe. [20]';
       return;
    end if;

    if not exists (select 1 from ciudad where cad_id = id_ciudad_destino) then
       RAISE EXCEPTION -746, 0, 'La ciudad destino no existe. [21]';
       return;
    end if;

    FOREACH
        SELECT vje_id INTO id_viaje
        FROM viaje, viajeconductor, recorrido
        WHERE
            vje_id = vcr_vje_id AND vje_rdo_id = rdo_id AND
            rdo_cad_id_origen = id_ciudad_origen AND
            rdo_cad_id_destino = id_ciudad_destino

        RETURN id_viaje WITH RESUME;
    END FOREACH;

end procedure
document
'Fecha de Creacion: 2007-11-02                                                          ',
'                                                                                       ',
'Autor:             JCapanegra                                                          ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_ciudad_origen      Ciudad inicial del viaje.                     ',
'                   id_ciudad_destino     Ciudad final del viaje.                       ',
'                                                                                       ',
'Descripcion:       Realiza la búsqueda de los viajes de conductores que existen        ',
'                   registrados entre las ciudades especificadas.                       ',
'                                                                                       ',
'Resultados:        Id de los viajes que existen entre ambas ciudades.                  ',
'                   Si no hay ninguno, no devuelve ninguna fila.                        ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - La ciudad origen no existe. [20]                                  ',
'                   - La ciudad destino no existe. [21]                                 ',
'                                                                                       '
with listing in 'informix_warn'
;
