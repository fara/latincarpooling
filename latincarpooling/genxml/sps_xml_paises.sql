--drop PROCEDURE sps_xml_paises ();
CREATE PROCEDURE sps_xml_paises ()
RETURNING LVARCHAR

DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

--Encabezado
LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE paises SYSTEM "/home/dtd/paises.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/paises.xsl" ?>';
LET result = result || "<paises>";
--Fin encabezado


FOREACH SELECT genxml("pais", pais)
        INTO ressql
        FROM pais

        LET result = result || ressql;
END FOREACH;

--Cierro el xml
LET result = result || "</paises>";

RETURN result;
END PROCEDURE;

--EXECUTE PROCEDURE sps_xml_paises();
{
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE paises SYSTEM "/home/dtd/paises.dtd">
<?xml-stylesheet type="text/xsl" href="/home/xsl/paises.xsl" ?>
<paises>
        <pais>
                <pis_id>1</pis_id>
                <pis_nombre>Argentina</pis_nombre>
                <pis_mda_id>1</pis_mda_id>
        </pais>
</paises>
}
