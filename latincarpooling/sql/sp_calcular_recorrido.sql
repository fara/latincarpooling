lujan - junin


drop procedure sp_calcular_recorrido;

create procedure sp_calcular_recorrido
(
    id_ciudad_origen integer,
    id_ciudad_destino integer,
    id_sesion integer
) RETURNING integer;


        DEFINE id_tramo integer;
        DEFINE cnt integer;
        DEFINE nueva_cad_origen_id integer;
        DEFINE id_recorrido integer;
        DEFINE itr integer;
        DEFINE flag integer;

        let itr = 1;
        let flag = -1;

        if exists (select 1 from t_control_ciudad where cad_id = id_ciudad_origen and sesion_id = id_sesion)
        then
                --RAISE EXCEPTION -746, 0, 'Ya paso por ciudad. [32]';
                return -1;
        end if;

        insert into t_control_ciudad
        (
                cad_id,
                sesion_id
        )
        values (id_ciudad_origen, id_sesion);

        select tra_id into id_tramo
        from
                tramo
        where
                tra_cad_id1 = id_ciudad_origen
                and tra_cad_id2 = id_ciudad_destino
        group by 1;


        if id_tramo is not null
        then
                --encontre el destino
                select
                        nvl(max(oro_rdo_id),0) + 1 into id_recorrido
                from
                        t_orden_recorrido
                where 
                        sesion_id = id_sesion;


                insert into t_orden_recorrido
                (
                        oro_rdo_id,
                        oro_tra_id,
                        oro_ordentramo,
                        sesion_id
                ) values (id_recorrido, id_tramo, itr, id_sesion);

                delete from t_control_ciudad where cad_id = id_ciudad_origen and sesion_id = id_sesion;

                return id_recorrido;
        end if;

        select
                cant_iteraciones into cnt
        from
                t_cantidad_iteraciones;

        -- me fijo que no supere la cantidad de iteraciones
        if itr >= cnt
        then
                --RAISE EXCEPTION -746, 0, 'Supero la cantidad de recorridos sin encontrar al destino. [19]';

                return -1;
        end if;

        -- si no lo encontre itero en toda los destinos de este origen;

        foreach
                select
                        tra_cad_id2, tra_id into nueva_cad_origen_id, id_tramo
                from
                        tramo
                where
                        tra_cad_id1 = id_ciudad_origen


                -- Llamo al sp recursivo pero ahora como origen las ciudades destino
                -- de la ciudad que me pasaron a mi por parametro
                -- si tira un error de iteracion o algo, corta aca y no realiza el insert siguiente
                execute procedure sp_calcular_recorrido_recursivo(nueva_cad_origen_id,id_ciudad_destino, itr + 1, id_sesion) into id_recorrido ;

                if id_recorrido <> -1
                then
                        insert into t_orden_recorrido
                        (
                                oro_rdo_id,
                                oro_tra_id,
                                oro_ordentramo,
                                sesion_id
                        )
                        values (id_recorrido, id_tramo, itr, id_sesion);
                        let flag = id_recorrido;
                        delete from t_control_ciudad where cad_id <> id_ciudad_origen and sesion_id = id_sesion;
                end if;

        end foreach;

        if flag = -1
        then
                delete from t_orden_recorrido where sesion_id = id_sesion;
        end if;
        
        delete from t_control_ciudad where sesion_id = id_sesion;
        
        return flag;

end procedure