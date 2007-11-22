-- Scripts TEST
-- Ver si existe un viaje conductor con ese id
SELECT * FROM viajeconductor, viaje WHERE vje_id = vcr_vje_id AND vcr_vje_id = 1000;
SELECT * FROM viajepasajeropend, viaje WHERE vje_id = vpp_vje_id AND vpp_vje_id = 1001;

-- Inserto un viaje de pasajero de prueba para probar si recibe los mensajes
insert into viaje(vje_id, vje_fechamenor, vje_fechamayor, vje_tipoviaje, vje_rdo_id)
    values(1001, '10-02-2007', '10-05-2007', 'P', 1);

insert into viajepasajeropend(vpp_importemaximo, vpp_vje_id, vpp_uio_id)
    values(100, 1001, 666);

-- Ver los mensajes agregados
SELECT mje_id, mje_asunto, mje_texto FROM mensaje;

-- Insertar el viaje con unos valores
EXECUTE PROCEDURE spu_viaje_conductor (
     1000, 666, 1, '10-01-2007', '10-06-2007', 10,
     10, 20, 200)
;

-- Actualizar los datos del viaje
EXECUTE PROCEDURE spu_viaje_conductor (
     1000, 666, 1, '10-05-2007', '10-07-2007', 10,
     5, 21, 300)
;

-- Mensaje con fechas fuera de rango
EXECUTE PROCEDURE spu_viaje_conductor (
     1002, 666, 1, '10-10-2007', '10-17-2007', 10,
     5, 21, 300)
;

-- Borrar todo
DELETE FROM viaje WHERE vje_id = 1001;
DELETE FROM viajepasajeropend WHERE vpp_vje_id = 1001;
DELETE FROM viaje WHERE vje_id = 1000;
DELETE FROM viajeconductor WHERE vcr_vje_id = 1000;
DELETE FROM viaje WHERE vje_id = 1002;
DELETE FROM viajeconductor WHERE vcr_vje_id = 1002;
DELETE FROM mensaje WHERE mje_id > 1;

-- Auxiliares
-- EXECUTE PROCEDURE.spu_informar_pasajeros
-- (id_viaje,lugares,lugares_libres,importe,importe_total);
EXECUTE PROCEDURE spu_informar_pasajeros(1000,10,10,20,200);

