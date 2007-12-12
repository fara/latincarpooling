CREATE PROCEDURE sps_xml_paises ()
RETURNING LVARCHAR


DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

--Encabezado
LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE vehiculos SYSTEM "/home/dtd/paises.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/paisesencontrados.xsl" ?>';
LET result = result || "<paisesEncontrados>";
--Fin encabezado



FOREACH SELECT genxml("pais", pais)
        INTO ressql
        FROM pais


        LET result = result || ressql;
END FOREACH;

LET result = result || "</paisesEncontrados>";

RETURN result;
END PROCEDURE;