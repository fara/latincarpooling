-- Scripts TEST
-- Información de ayuda
SELECT * FROM recorrido;

-- La ciudad origen no existe. [20]
EXECUTE PROCEDURE sps_buscar_viaje(0, 3435548);

-- La ciudad destino no existe. [21]
EXECUTE PROCEDURE sps_buscar_viaje(3435548, 0);

-- Buscar los viajes
EXECUTE PROCEDURE sps_buscar_viaje(3435548, 3427687);

