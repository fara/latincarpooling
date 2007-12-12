CREATE PROCEDURE sps_xml_regiones (idpais integer)
RETURNING LVARCHAR

DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

--Encabezado
LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE region SYSTEM "/home/dtd/regiones.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/regiones.xsl" ?>';
LET result = result || "<regiones>";
--Fin encabezado


    FOREACH SELECT genxml('region', row(ron_id, ron_nombre))
        INTO ressql
        FROM region
	where ron_pis_id = idpais
  
        LET result = result || ressql;

END FOREACH;
LET result = result || "</regiones>";

RETURN result;
END PROCEDURE;