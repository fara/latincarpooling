--DROP PROCEDURE sps_xml_vehiculos;

CREATE PROCEDURE sps_xml_vehiculos
(
    id_usuario  integer
)
RETURNING LVARCHAR
DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE vehiculos SYSTEM "/home/dtd/vehiculos.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/vehiculos.xsl" ?>';
LET result = result || "<vehiculosdelusuario>";


FOREACH SELECT genxml("vehiculo",
        row(vlo_id,
                vlo_modelo,
                vlo_color,
                vlo_patente,
                vlo_cle_id,
                vlo_consumo,
                vlo_tieneac,
                vlo_asientos))
        INTO ressql
        FROM vehiculo
        WHERE vlo_uio_id = id_usuario
  LET result = result || ressql;
END FOREACH;
LET result = result || "</vehiculosdelusuario>";
RETURN result;
END PROCEDURE;

--EXECUTE PROCEDURE sps_xml_vehiculos(13);
--SE trunca el resultado, pero es un tema del WinSQL.
