select r.rdo_id,
       oro.oro_ordentramo,
       c_origen.cad_nombre cad_origen,
       c_destino.cad_nombre cad_destino
from recorrido r
inner join ordenrecorrido oro
        on oro.oro_rdo_id = r.rdo_id
inner join tramo t
        on t.tra_id = oro.oro_tra_id
inner join ciudad c_origen
        on c_origen.cad_id = t.tra_cad_id1
inner join ciudad c_destino
        on c_destino.cad_id = t.tra_cad_id2
where r.rdo_cad_id_origen = 3427916 --solis
and r.rdo_cad_id_destino = 3434975 --duggan
union
select r.rdo_id,
       -oro.oro_ordentramo,
       c_origen.cad_nombre cad_origen,
       c_destino.cad_nombre cad_destino
from recorrido r
inner join ordenrecorrido oro
        on oro.oro_rdo_id = r.rdo_id
inner join tramo t
        on t.tra_id = oro.oro_tra_id
inner join ciudad c_origen
        on c_origen.cad_id = t.tra_cad_id1
inner join ciudad c_destino
        on c_destino.cad_id = t.tra_cad_id2
where r.rdo_cad_id_origen = 3434975 --duggan
and r.rdo_cad_id_destino = 3427916 --solis
order by r.rdo_id asc,
       oro.oro_ordentramo asc



update recorrido
set rdo_cad_id_origen = 3427916,
        rdo_cad_id_destino = 3434975
where rdo_id = 200

select *
from recorrido
where rdo_id = 200

select *
from ordenrecorrido
where oro_rdo_id = 200


select *
from tramo
where tra_id = 4

--Muestra las escalas de un recorrido.




rdo_id  rdo_cad_id_origen       rdo_cad_id_destino
13      3841490 3844834
       select *
       from recorrido

       select *
       from ciudad
       where cad_nombre like '%Areco%'

3429248 San Antonio de Areco

select *
from tramo
where tra_cad_id1 = 3429248 or tra_cad_id2 = 3429248

select *
from ciudad
where cad_id = 3434975

tra_id  tra_cad_id1     tra_cad_id2     tra_distancia
4       3427916 3429248 15
5       3429248 3434975 20

select *
from recorrido

insert into recorrido
values (201, 3434975, 3427916)

insert into ordenrecorrido
values (201,4,2)

select *
from ordenrecorrido



select v.vje_id,
        v.vje_fechamenor,
        v.vje_fechamayor,
        vc.vcr_uio_id,
        vc.vcr_importe,
        vc.vcr_importeviaje,
        vc.vcr_lugareslibres,
        u.uio_id,
        u.uio_nombreusuario,
        u.uio_sexo,
        u.uio_esfumador
from viaje v
inner join recorrido r
on v.vje_rdo_id = r.rdo_id
        and ((r.rdo_cad_id_origen = 3865436 and r.rdo_cad_id_destino = 3435690)
        or (r.rdo_cad_id_origen = 3435690 and r.rdo_cad_id_destino = 3865436))
inner join viajeconductor vc
        on v.vje_id = vc.vcr_vje_id
        and vc.vcr_lugareslibres >= 1
inner join usuario u
        on vc.vcr_uio_id = u.uio_id
where (v.vje_fechamenor <= '18/11/2007'
        or v.vje_fechamayor >= '18/11/2007')
        and v.vje_tipoviaje = 'C'


select *
from viaje
