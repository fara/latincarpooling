drop procedure spu_precio_combustible
;
create procedure spu_precio_combustible
(
    id_combustible   integer,
    id_pais     integer,
    vigente_desde date,    
    precio_litro numeric(7,4)    
) returns integer;

    if not exists (select 1
                    from combustible c
                    where c.cle_id = id_combustible) then
       RAISE EXCEPTION -746, 0, 'No existe el combustible. [15]';
       return -1;
    end if;
    
    if not exists (select 1
                    from pais p
                    where p.pis_id = id_pais) then
       RAISE EXCEPTION -746, 0, 'No existe el pais. [16]';
       return -1;
    end if;

    if vigente_desde is null then
       RAISE EXCEPTION -746, 0, 'No se indico la fecha de inicio de la vigencia. [10]';
       return -1;
    end if;

    if precio_litro is null then
       RAISE EXCEPTION -746, 0, 'No se indico el precio del litro de combustible. [17]';
       return -1;
    end if;

    if precio_litro <= 0 then
       RAISE EXCEPTION -746, 0, 'El precio del litro de combustible debe ser mayor a cero. [18]';
       return -1;
    end if;

    if exists (select 1
                from preciocombustible pc
                where pc.pce_cle_id = id_combustible
                and pc.pce_pis_id = id_pais
                and pc.pce_vigentedesde = vigente_desde) then
       update preciocombustible
       set pce_preciolitro = precio_litro
       where pce_cle_id = id_combustible
       and pce_pis_id = id_pais
       and pce_vigentedesde = vigente_desde;
    else
    begin
        define vigencia_hasta like preciocombustible.pce_vigentedesde;
        define vigencia_anterior like preciocombustible.pce_vigentehasta;

        let vigencia_hasta = (select min(pc.pce_vigentedesde)
                            from preciocombustible pc
                            where pc.pce_cle_id = id_combustible
                            and pc.pce_pis_id = id_pais
                            and pc.pce_vigentedesde > vigente_desde);

        if vigencia_hasta is not null then
            let vigencia_hasta = vigencia_hasta - 1 units day;
        end if;

        --Modificamos la vigencia anterior a la actual.
        let vigencia_anterior = (select max(pc.pce_vigentedesde)
                            from preciocombustible pc
                            where pc.pce_cle_id = id_combustible
                            and pc.pce_pis_id = id_pais
                            and pc.pce_vigentedesde < vigente_desde);

        if vigencia_anterior is not null then
            update preciocombustible
            set pce_vigentehasta = vigente_desde - 1 units day
            where pce_cle_id = id_combustible
            and pce_pis_id = id_pais
            and pce_vigentedesde = vigencia_anterior;
        end if;

        insert into preciocombustible
        (pce_cle_id, pce_pis_id, pce_vigentedesde, pce_preciolitro, pce_vigentehasta) values
        (id_combustible, id_pais, vigente_desde, precio_litro, vigencia_hasta);
    end;
    end if;
        
    return 0;
end procedure
document
'Fecha de Creacion: 2007-10-28                                                          ',
'                                                                                       ',
'Autor:             ARobirosa                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_moneda          ID de la moneda.                                 ',
'                   id_pais            ID del pais.                                     ',
'                   vigente_desde      Comienzo de la vigencia                          ',
'                   precio_litro       Precio del litro de combustible                  ',
'                                                                                       ',
'Descripcion:       Ingresa un nuevo valor de combustible para el id combustible y país ',
'                       pasado por parámetro. Si existe un valor de combustible vigente para',
'                       dicho combustible y país, le actualiza la fecha fin de vigencia de  ',
'                   dicha instancia con la fecha inicio de vigencia (parámetro) - 1 y   ',
'                   luego inserta el nuevo tipo de cambio. Si existe un valor de        ',
'                   combustible para ese país con esa vigencia, lo actualiza.           ',
'                                                                                       ',
'Resultados:        Cero si no hay errores.                                             ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el combustible.                                         ',
'                   - No existe el país.                                                ',
'                   - Debe indicar la fecha de inicio de la vigencia.                   ',
'                   - Debe indicar el precio del litro de combustible.                  ',
'                   - El precio del litro de combustible debe ser mayor a cero.         ',
'                                                                                       '
with listing in 'informix_warn'
;
