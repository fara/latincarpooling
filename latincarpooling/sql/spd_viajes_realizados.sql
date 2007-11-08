drop procedure spd_viajes_realizados
;
create procedure spd_viajes_realizados
(
    fecha_corte date
) returns integer;

    if fecha_corte > today then
       RAISE EXCEPTION -746, 0, 'La fecha indicada es mayor a la actual. [8]';
       return -1;
    end if;

    delete from viajeconductor
    where exists (select 1
                from viaje v
                where viajeconductor.vcr_vje_id = v.vje_id
                and v.vje_fechamayor < fecha_corte);

    delete from viajepasajeropend
    where exists (select 1
                 from viaje v
                where viajepasajeropend.vpp_vje_id = v.vje_id
                and v.vje_fechamayor < fecha_corte);

    delete from viaje
    where vje_fechamayor < fecha_corte;

    return 0;
end procedure
document
'Fecha de Creacion: 2007-10-15                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   fecha_corte         Fecha de Corte.                                 ',
'                                                                                       ',
'Descripcion:       Elimina todos los viajes que fueron realizados con anterioridad a   ',
'                   la fecha de corte.                                                  ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - La fecha indicada es mayor a la actual.                           ',
'                                                                                       '
with listing in 'informix_warn'
;
