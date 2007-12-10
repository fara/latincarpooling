-- Procedimiento que genera un documento XML con los recorridos que van a del ciudad origen a la
-- ciudad destino.
--
drop procedure sps_xml_mostrar_recorridos
;
create procedure sps_xml_mostrar_recorridos(

        ciudadorigen like ciudad.cad_id,
        ciudaddestino like ciudad.cad_id,
        idusuario like usuario.uio_id,
        idvehiculo like vehiculo.vlo_id,
        paisorigen like pais.pis_id,
        idsesion integer,
        fechahoy date
) returning lvarchar;
    define costoKmCombustible numeric(9,6);
    DEFINE result LVARCHAR;
    DEFINE ressql LVARCHAR;
    define cantidadrecorridos integer;
    define menordistancia integer;
    define menorcostototal numeric(8,2);

    if not exists (select 1
                    from ciudad
                    where cad_id = ciudadorigen) then
       RAISE EXCEPTION -746, 0, 'No existe la ciudad origen. [31]';
    end if;

    if not exists (select 1
                    from ciudad
                    where cad_id = ciudaddestino) then
       RAISE EXCEPTION -746, 0, 'No existe la ciudad destino. [32]';
    end if;

    if not exists (select 1 from usuario u
                    where u.uio_id = idusuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
    end if;

    if idvehiculo > 0
    and not exists (select 1
                   from vehiculo
                    where vlo_uio_id = idusuario
                    and vlo_id = idvehiculo) then
       RAISE EXCEPTION -746, 0, 'No existe el vehiculo. [33]';
    end if;

    if not exists (select 1
                   from pais
                    where pis_id = paisorigen) then
       RAISE EXCEPTION -746, 0, 'No existe el pais de origen. [34]';
    end if;

    if idsesion is null then
       RAISE EXCEPTION -746, 0, 'No se indico el ID de la sesion. [35]';
    end if;

    --Llamamos al procedimiento que genera los recorridos.
     execute procedure sp_calcular_recorrido (
         ciudadorigen,
         ciudaddestino,
         idsesion) into cantidadrecorridos;

     --Calculamos el valor de cada Km de combustible.
     if idvehiculo > 0 then
       --Si tenemos un vehiculo...
      SELECT vlo_consumo * pce_preciolitro / 100
      into costoKmCombustible
      from vehiculo
      inner join preciocombustible
              on vlo_cle_id = pce_cle_id
              and pce_pis_id = paisorigen
              and pce_vigentedesde <= fechahoy
              and (pce_vigentehasta >= fechahoy or pce_vigentehasta is null)
      where vlo_uio_id = idusuario
      and vlo_id = idvehiculo;
    else
      --Si somos pasajeros...
      SELECT pce_preciolitro * 7 / 100
      into costoKmCombustible
      from preciocombustible
      where pce_cle_id = 1
      and pce_pis_id = paisorigen
      and pce_vigentedesde <= fechahoy
      and (pce_vigentehasta >= fechahoy or pce_vigentehasta is null);
    end if;

    if costoKmCombustible is null then
       let costoKmCombustible = 0;
    end if

    create temp table recorridosencontrados (
        idrecorrido integer not null,
        descripcion lvarchar,
        distancia integer,
        costofijo numeric(8,2),
        costototal numeric(10,2),
        mascorto char(1),
        masbarato char(1)
    );

    insert into recorridosencontrados (
        idrecorrido,
        descripcion,
        distancia,
        costofijo,
        costototal,
        mascorto,
        masbarato)
    select r.rdo_id,
           max(f_descripcion_recorrido(r.rdo_id)),
           sum(nvl(t.tra_distancia,0)),
           sum(nvl(c.cft_costofijo,0)),
           0,   --costo total.
           'N', --mas corto
           'N'  --mas barato
    from recorrido r
    inner join ordenrecorrido oro
          on oro.oro_rdo_id = r.rdo_id
    inner join tramo t
          on t.tra_id = oro.oro_tra_id
    left join costofijotramo c
         on t.tra_id = c.cft_tra_id
         and c.cft_vigentedesde <= fechahoy
         and (c.cft_vigentehasta is null or c.cft_vigentehasta >= fechahoy)
    inner join ciudad c_origen
          on c_origen.cad_id = t.tra_cad_id1
    inner join ciudad c_destino
          on c_destino.cad_id = t.tra_cad_id2
    where r.rdo_cad_id_origen = ciudadOrigen
    and r.rdo_cad_id_destino = ciudadDestino
    group by r.rdo_id;

    update recorridosencontrados
    set costototal = distancia * costoKmCombustible + costofijo;

    select min(distancia),
        min(costototal)
    into menordistancia,
        menorcostototal
    from recorridosencontrados;

    update recorridosencontrados
    set masbarato = 'S'
    where costototal = menorcostototal;

    update recorridosencontrados
    set mascorto = 'S'
    where distancia = menordistancia;

    -- Generamos el documento XML con los datos de la tabla temporal.
    select genxmlhdr2("recorridosencontrados",
                "select idrecorrido, descripcion, distancia, costofijo, costototal, mascorto, masbarato FROM recorridosencontrados",
                "\usr\home\sa505103\recorridos.dtd",
                "\usr\home\sa505103\recorridos.xsl")
    into result
    from systables
    where tabid = 1;

    drop table recorridosencontrados;

    RETURN result;
end procedure
;

--Ejemplo de uso.
{
execute procedure sps_xml_mostrar_recorridos(
        3435548, --Centro
        3841490, --Pergamino
        13, --arobirosa
        1,
        1,
        1234,
        '03/12/2007'
);
}

--Ejemplo de salida
{
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE recorridosencontrados SYSTEM "\usr\home\sa505103\recorridos.dtd">
<?xml-stylesheet type="text/xsl" href="\usr\home\sa505103\recorridos.xsl" ?>
<recorridosencontrados>
        <row>
                <idrecorrido>225</idrecorrido>
                <descripcion>Centro - Tortuguitas - Pilar - Solis - San Antonio de Areco - Duggan - Capitan Sarmiento - Arrecifes - Pergamino</descripcion>
                <distancia>215</distancia>
                <costofijo>9.5500000000</costofijo>
                <costototal>163.4900000000</costototal>
                <mascorto>N</mascorto>
                <masbarato>N</masbarato>
        </row>
        <row>
                <idrecorrido>226</idrecorrido>
                <descripcion>Centro - Canuelas - Lujan - San Andres de Giles - Carmen de Areco - Chacabuco - Junin - Rojas - Pergamino</descripcion>
                <distancia>396</distancia>
                <costofijo>3.4000000000</costofijo>
                <costototal>286.9400000000</costototal>
                <mascorto>N</mascorto>
                <masbarato>N</masbarato>
        </row>
        <row>
                <idrecorrido>227</idrecorrido>
                <descripcion>Centro - Pilar - Solis - San Antonio de Areco - Duggan - Capitan Sarmiento - Arrecifes - Pergamino</descripcion>
                <distancia>202</distancia>
                <costofijo>11.3000000000</costofijo>
                <costototal>155.9300000000</costototal>
                <mascorto>S</mascorto>
                <masbarato>S</masbarato>
        </row>
</recorridosencontrados>
}
