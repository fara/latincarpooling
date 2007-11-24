/* Realiza el testeo de los siguientes procedimientos:
        spu_precio_combustible

   Nota: Verificar la configuracion de las fechas.
*/


--Muestra los precio del gasoil en dolares en argentina.
select *
from preciocombustible
where pce_cle_id = 3
and pce_pis_id = 1
order by pce_vigentedesde
;

--Reporta que no existe el combustible.
execute procedure dbo.spu_precio_combustible (99, 1, '10-29-2007', 1.0)
;

--Reporta que no existe el pais.
execute procedure dbo.spu_precio_combustible (3, 99, '10-29-2007', 1.0)
;

--Reporta que no se indico la fecha de inicio de la vigencia.
execute procedure dbo.spu_precio_combustible (3, 1, null, 1.0)
;

--Reporta que no se indico el precio del litro de combustible.
execute procedure dbo.spu_precio_combustible (3, 1, '10-29-2007', null)
;

--Reporta que el precio del litro de combustible debe ser mayor a cero.
execute procedure dbo.spu_precio_combustible (3, 1, '10-29-2007', -3.14)
;

--Inserta el precio del combustible al 29/10/2007.
execute procedure dbo.spu_precio_combustible (3, 1, '10-29-2007', 0.50)
;

--Inserta el precio del combustible al 01/01/2001
execute procedure dbo.spu_precio_combustible (3, 1, '01-01-2001', 0.25)
;

--Inserta el precio del combustible al 01/01/2008
execute procedure dbo.spu_precio_combustible (3, 1, '01-01-2008', 0.95)
;

--Inserta el precio del combustible al 01/03/2002
execute procedure dbo.spu_precio_combustible (3, 1, '03-01-2002', 0.27)
;

--Muestra los precio del gasoil en dolares en argentina.
select *
from preciocombustible
where pce_cle_id = 3
and pce_pis_id = 1
order by pce_vigentedesde
;

--Actualiza el precio del combustible al 29/10/2007.
execute procedure dbo.spu_precio_combustible (3, 1, '10-29-2007', 0.54)
;

--Muestra los precio del gasoil en dolares en argentina.
select *
from preciocombustible
where pce_cle_id = 3
and pce_pis_id = 1
order by pce_vigentedesde
;

--Agregamos otros precios
execute procedure dbo.spu_precio_combustible (1, 1, '01-01-2000', 1)
execute procedure dbo.spu_precio_combustible (1, 1, '01-01-2003', 3.58)
;

