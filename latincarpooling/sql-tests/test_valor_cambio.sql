/* Realiza el testeo de los siguientes procedimientos:
        spu_valor_cambio

   Nota: Verificar la configuracion de las fechas.
*/

--Muestra los distintos tipos de cambio del peso argentino.
select *
from valorcambio
where vco_mda_id = 1
order by vco_vigentedesde
;

-- Reporta que no existe la moneda.
execute procedure spu_valor_cambio (99, null, 4.00);

--Reporta que no se indico la fecha de inicio de la vigencia.
execute procedure spu_valor_cambio (1, null, 3.10);

--Reporta que no se indico el tipo de cambio.
execute procedure spu_valor_cambio (1, '10-28-2007', null);

--Reporta que el tipo de cambio debe ser mayor a cero.
execute procedure spu_valor_cambio (1, '10-28-2007', -3.14);

--Inserta el tipo de cambio al 28/10/2007.
execute procedure spu_valor_cambio (1, '10-28-2007', 3.19);

--Inserta el tipo de cambio al 01/01/2001
execute procedure spu_valor_cambio (1, '01-01-2001', 1);

--Inserta el tipo de cambio al 01/01/2008
execute procedure spu_valor_cambio (1, '01-01-2008', 5.5);

--Inserta el tipo de cambio al 01/03/2002
execute procedure spu_valor_cambio (1, '01-03-2002', 2.1);

--Muestra los distintos tipos de cambio.
select *
from valorcambio
where vco_mda_id = 1
order by vco_vigentedesde
;

execute procedure spu_valor_cambio (1, '01-03-2003', 2.1);



--Actualiza el tipo de cambio al 28/10/2007.
execute procedure spu_valor_cambio (1, '10-28-2007', 3.21);

--Muestra los distintos tipos de cambio.
select *
from valorcambio
where vco_mda_id = 1
order by vco_vigentedesde
;

select *
from moneda
