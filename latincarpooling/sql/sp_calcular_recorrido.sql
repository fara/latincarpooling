lujan - junin


create procedure sp_calcular_recorrido
(
    id_ciudad_origen integer,
    id_ciudad_destino integer,
    id_sesion integer
) RETURNING integer;


        DEFINE id_tramo integer;
        DEFINE cnt integer;
        DEFINE nueva_cad_origen_id integer;
        DEFINE id_recorrido_1 integer;
        DEFINE id_recorrido_2 integer;
        DEFINE itr integer;
        DEFINE flag integer;
        DEFINE orden_tramo integer;
        DEFINE cant_recorridos integer;

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

        select count(*) into cant_recorridos
        from
					recorrido
				where
					rdo_cad_id_origen = id_ciudad_origen
					and rdo_cad_id_destino = id_ciudad_destino;
				
				if cant_recorridos > 1
				then
								delete from t_control_ciudad where sesion_id = id_sesion;
								return cant_recorridos;
				end if;
        

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
                        nvl(max(oro_rdo_id),0) + 1 into id_recorrido_1
                from
                        t_orden_recorrido
                where 
                        sesion_id = id_sesion;
                
                select
                        nvl(max(oro_rdo_id),0) into id_recorrido_2
                from
                        ordenrecorrido;
                				

                insert into ordenrecorrido
                (
                        oro_rdo_id,
                        oro_tra_id,
                        oro_ordentramo
                ) values (id_recorrido_1 + id_recorrido_2, id_tramo, itr);
                
                insert into recorrido
                (
                				rdo_id,
                				rdo_cad_id_origen,
                				rdo_cad_id_destino
                ) values (id_recorrido_1 + id_recorrido_2,id_ciudad_origen, id_ciudad_destino);

                delete from t_control_ciudad where cad_id = id_ciudad_origen and sesion_id = id_sesion;

--                return id_recorrido_1;
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
                execute procedure sp_calcular_recorrido_recursivo(nueva_cad_origen_id,id_ciudad_destino, itr + 1, id_sesion) into id_recorrido_1 ;

                if id_recorrido_1 <> -1
                then
                        insert into t_orden_recorrido
                        (
                                oro_rdo_id,
                                oro_tra_id,
                                oro_ordentramo,
                                sesion_id
                        )
                        values (id_recorrido_1, id_tramo, itr, id_sesion);
                        let flag = id_recorrido_1;
                        delete from t_control_ciudad where cad_id <> id_ciudad_origen and sesion_id = id_sesion;
                end if;

        end foreach;

        if flag = -1
        then
                delete from t_orden_recorrido where sesion_id = id_sesion;
        end if;
        
        delete from t_control_ciudad where sesion_id = id_sesion;
        
				select
					nvl(max(oro_rdo_id),0) into id_recorrido_2
				from
					ordenrecorrido;
        
        foreach
        				select
        								oro_rdo_id, oro_tra_id, oro_ordentramo into  id_recorrido_1, id_tramo, orden_tramo
								from
												t_orden_recorrido
								where
												sesion_id = id_sesion
								
                insert into ordenrecorrido
                (
                        oro_rdo_id,
                        oro_tra_id,
                        oro_ordentramo
                ) values (id_recorrido_1 + id_recorrido_2, id_tramo, orden_tramo);
                
        end foreach;

        foreach
        				select
        								oro_rdo_id into  id_recorrido_1
								from
												t_orden_recorrido
								where
												sesion_id = id_sesion
								group by oro_rdo_id
								
                insert into recorrido
                (
                        rdo_id,
                        rdo_cad_id_origen,
                        rdo_cad_id_destino
                ) values (id_recorrido_1 + id_recorrido_2, id_ciudad_origen, id_ciudad_destino);
                
        end foreach;
        
        delete from t_orden_recorrido where sesion_id = id_sesion;
        return flag;    

end procedure 