drop procedure spu_costo_fijo_tramo
;
create procedure spu_costo_fijo_tramo
(
    id_tramo   integer,
    vigente_desde date,
    costo_fijo numeric(6,2)
) returns integer;

    if not exists (select 1
                    from tramo t
                    where t.tra_id = id_tramo) then
       RAISE EXCEPTION -746, 0, 'No existe el tramo. [4]';
       return -1;
    end if;

    if vigente_desde is null then
       RAISE EXCEPTION -746, 0, 'No se indico la fecha de inicio de la vigencia. [10]';
       return -1;
    end if;

    if costo_fijo is null then
       RAISE EXCEPTION -746, 0, 'No se indico el costo fijo del tramo. [13]';
       return -1;
    end if;

    if costo_fijo <= 0 then
       RAISE EXCEPTION -746, 0, 'El costo fijo del tramo debe ser mayor a cero. [14]';
       return -1;
    end if;

    if exists (select 1
                from costofijotramo c
                where c.cft_tra_id = id_tramo
                and c.cft_vigentedesde = vigente_desde) then
       update costofijotramo
       set cft_costofijo = costo_fijo
       where cft_tra_id = id_tramo
       and cft_vigentedesde = vigente_desde;
    else
    begin

        define vigencia_hasta like costofijotramo.cft_vigentedesde;
        define vigencia_anterior like costofijotramo.cft_vigentehasta;

        let vigencia_hasta = (select min(c.cft_vigentedesde)
                            from costofijotramo c
                            where c.cft_tra_id = id_tramo
                            and c.cft_vigentedesde > vigente_desde);

        if vigencia_hasta is not null then
            let vigencia_hasta = vigencia_hasta - 1 units day;
        end if;

        --Modificamos la vigencia anterior a la actual.
        let vigencia_anterior = (select max(c.cft_vigentedesde)
                            from costofijotramo c
                            where c.cft_tra_id = id_tramo
                            and c.cft_vigentedesde < vigente_desde);

        if vigencia_anterior is not null then
            update costofijotramo
            set cft_vigentehasta = vigente_desde - 1 units day
            where cft_tra_id = id_tramo
            and cft_vigentedesde = vigencia_anterior;
        end if;

        insert into costofijotramo
        (cft_tra_id, cft_vigentedesde, cft_costofijo, cft_vigentehasta) values
        (id_tramo, vigente_desde, costo_fijo, vigencia_hasta);

    end;
    end if;
    return 0;

end procedure
document
'Fecha de Creacion: 2007-11-03                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                           id_tramo           ID del tramo.                                    ',    
'                   vigente_desde      Comienzo de la vigencia                          ',
'                   costo_fijo         Costo fijo del tramo en dolares.                 ',
'                                                                                       ',
'Descripcion:       Ingresa un nuevo costo fijo para el tramo pasado por parámetro,     ',
'                   si ya existe un costo fijo vigente para dicho tramo, le actualiza   ',
'                   la fecha fin de vigencia de dicha instancia con la fecha inicio de  ',
'                   vigencia (parámetro) - 1 y luego inserta el nuevo costo fijo.       ',
'                   Si existe un costo fijo para ese tramo con esa vigencia, lo         ',
'                   actualiza.                                                          ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el tramo.                                               ',
'                   - No se indicó la fecha de inicio de la vigencia.                   ',
'                   - No se indicó el costo fijo.                                       ',
'                   - El costo fijo debe ser mayor a cero.                              ',
'                                                                                       '
with listing in 'informix_warn'
;
