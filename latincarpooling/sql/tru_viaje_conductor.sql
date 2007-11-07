-- tru_viaje_conductor
-- DROP TRIGGER tru_viaje_conductor;

CREATE TRIGGER tru_viaje_conductor
UPDATE ON viajeconductor
REFERENCING NEW AS post OLD AS pre
FOR EACH ROW
    (EXECUTE PROCEDURE spu_informar_pasajeros(
        post.vcr_vje_id,
        post.vcr_uio_id,
        post.vcr_cantlugares,
        post.vcr_lugareslibres,
        post.vcr_importe,
        post.vcr_importeviaje));
