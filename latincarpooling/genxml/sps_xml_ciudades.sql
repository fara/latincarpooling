--DROP PROCEDURE sps_xml_ciudades;

CREATE PROCEDURE sps_xml_ciudades (
        idregion integer,
        nombreinicial varchar(255) --Primera parte del nombre.
)
RETURNING LVARCHAR
        DEFINE result LVARCHAR;

    let nombreinicial = upper(nombreinicial);

    execute function genxmlhdr('ciudades','select first 30 cad_id, cad_nombre from ciudad where cad_ron_id = ' || idregion::lvarchar || ' and upper(cad_nombre) like ''' || nvl(nombreinicial,'') || '%''')
    into result;

    RETURN result;
END PROCEDURE;

--EXECUTE PROCEDURE sps_xml_ciudades(1, 'are');
{
<?xml version="1.0" encoding="ISO-8859-1" ?>
<ciudades>
        <row>
                <cad_id>3841517</cad_id>
                <cad_nombre>Peralta</cad_nombre>
        </row>
        <row>
                <cad_id>3430043</cad_id>
                <cad_nombre>Peralta Ramos</cad_nombre>
        </row>
        <row>
                <cad_id>3430035</cad_id>
                <cad_nombre>Pereyra</cad_nombre>
        </row>
        <row>
                <cad_id>3841493</cad_id>
                <cad_nombre>Perez Millan</cad_nombre>
        </row>
        <row>
                <cad_id>3841490</cad_id>
                <cad_nombre>Pergamino</cad_nombre>
        </row>
</ciudades>
}