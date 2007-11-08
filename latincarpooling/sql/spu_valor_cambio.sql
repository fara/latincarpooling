drop procedure spu_valor_cambio
;
create procedure spu_valor_cambio
(
    id_moneda   integer,
    vigente_desde date,
    valor_dolar numeric(12,7)
) returns integer;

    if not exists (select 1
                    from moneda m
                    where m.mda_id = id_moneda) then
       RAISE EXCEPTION -746, 0, 'No existe la moneda. [9]';
       return -1;
    end if;

    if vigente_desde is null then
       RAISE EXCEPTION -746, 0, 'No se indico la fecha de inicio de la vigencia. [10]';
       return -1;
    end if;

    if valor_dolar is null then
       RAISE EXCEPTION -746, 0, 'No se indico el tipo de cambio. [11]';
       return -1;
    end if;

    if valor_dolar <= 0 then
       RAISE EXCEPTION -746, 0, 'El tipo de cambio debe ser mayor a cero. [12]';
       return -1;
    end if;

    if exists (select 1
                from valorcambio vc
                where vc.vco_mda_id = id_moneda
                and vc.vco_vigentedesde = vigente_desde) then
       update valorcambio
       set vco_valordolar = valor_dolar
       where vco_mda_id = id_moneda
       and vco_vigentedesde = vigente_desde;
    else
    begin

        define vigencia_hasta like valorcambio.vco_vigentedesde;
        define vigencia_anterior like valorcambio.vco_vigentehasta;

        let vigencia_hasta = (select min(vc.vco_vigentedesde)
                            from valorcambio vc
                            where vc.vco_mda_id = id_moneda
                            and vc.vco_vigentedesde > vigente_desde);

        if vigencia_hasta is not null then
            let vigencia_hasta = vigencia_hasta - 1 units day;
        end if;

        --Modificamos la vigencia anterior a la actual.
        let vigencia_anterior = (select max(vc.vco_vigentedesde)
                            from valorcambio vc
                            where vc.vco_mda_id = id_moneda
                            and vc.vco_vigentedesde < vigente_desde);

        if vigencia_anterior is not null then
            update valorcambio
            set vco_vigentehasta = vigente_desde - 1 units day
            where vco_mda_id = id_moneda
            and vco_vigentedesde = vigencia_anterior;
        end if;

        insert into valorcambio
        (vco_mda_id, vco_vigentedesde, vco_valordolar, vco_vigentehasta) values
        (id_moneda, vigente_desde, valor_dolar, vigencia_hasta);

    end;
    end if;

    return 0;
end procedure
document
'Fecha de Creacion: 2007-10-15                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_moneda          ID de la moneda.                                 ',
'                   vigente_desde      Comienzo de la vigencia                          ',
'                   valor_dolar        Valor del Dolar                                  ',
'                                                                                       ',
'Descripcion:       Ingresa un nuevo valor de cambio para la moneda pasada por parámetro,',
'                           si existe un valor de cambio vigente para dicha moneda, le actualiza',
'                   la fecha fin de vigencia de dicha instancia con la fecha inicio de  ',
'                   vigencia (parámetro) - 1 y luego inserta el nuevo tipo de cambio.   ',
'                   Si existe un valor de cambio para esa moneda con esa vigencia, lo   ',
'                   actualiza.                                                          ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe la moneda.                                              ',
'                   - No se indicó la fecha de inicio de la vigencia.                   ',
'                   - No se indicó el tipo de cambio.                                   ',
'                   - El valor dólar debe ser mayor a cero.                             ',
'                                                                                       '
with listing in 'informix_warn'
;
