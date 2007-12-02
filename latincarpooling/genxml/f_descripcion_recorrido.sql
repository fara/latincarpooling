-- Funcion que devuelve un string con la descripcion de los nodos
-- de un recorrido.
-- Si el recorrido no existe, devuelve un string vacio.
--
drop function f_descripcion_recorrido
;
create function f_descripcion_recorrido
(
        idrecorrido like recorrido.rdo_id
) returning lvarchar;
        return f_descripcion_ordenrecorrido(idrecorrido, 1);
end function
;

-- Funcion que devuelve un string conteniendo el nombre de las
-- ciudades del tramo. Si el primero, devuelve las dos ciudades.
--
--
drop function f_descripcion_ordenrecorrido
;
create function f_descripcion_ordenrecorrido
(
        idrecorrido like recorrido.rdo_id,
        idordentramo like ordenrecorrido.oro_ordentramo
) returning lvarchar;
  define cad_nombre_origen like ciudad.cad_nombre;
  define cad_nombre_destino like ciudad.cad_nombre;
  define descripcionfinal lvarchar;

  select c_origen.cad_nombre cad_origen,
         c_destino.cad_nombre cad_destino
  into  cad_nombre_origen,
        cad_nombre_destino
  from ordenrecorrido oro
  inner join tramo t
        on t.tra_id = oro.oro_tra_id
  inner join ciudad c_origen
        on c_origen.cad_id = t.tra_cad_id1
  inner join ciudad c_destino
        on c_destino.cad_id = t.tra_cad_id2
  where oro.oro_rdo_id = idrecorrido
  and oro.oro_ordentramo = idordentramo;

  --Si no encontramos el tramo, salimos.
  if cad_nombre_origen is null then
      return '';
  end if;

   let descripcionfinal = f_descripcion_ordenrecorrido (idrecorrido, idordentramo + 1);

   if idordentramo = 1 then
         let descripcionfinal = cad_nombre_origen || ' - ' || cad_nombre_destino || descripcionfinal;
   else
         let descripcionfinal = ' - ' || cad_nombre_destino || descripcionfinal;
   end if;

   return descripcionfinal;
end function
;
--Ejemplo
--select f_descripcion_recorrido(203) from systables where tabid = 1

