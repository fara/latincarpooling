--drop PROCEDURE sps_xml_regiones;
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
        order by ron_nombre

        LET result = result || ressql;
END FOREACH;

--Cierro el xml
LET result = result || "</regiones>";

RETURN result;
END PROCEDURE;

--EXECUTE PROCEDURE sps_xml_regiones(1);
{
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE region SYSTEM "/home/dtd/regiones.dtd">
<?xml-stylesheet type="text/xsl" href="/home/xsl/regiones.xsl" ?>
<regiones>
        <region>
                <ron_id>1</ron_id>
                <ron_nombre>Buenos Aires, Prov.</ron_nombre>
        </region>
        <region>
                <ron_id>2</ron_id>
                <ron_nombre>Catamarca</ron_nombre>
        </region>
        <region>
                <ron_id>3</ron_id>
                <ron_nombre>Chaco</ron_nombre>
        </region>
        <region>
                <ron_id>4</ron_id>
                <ron_nombre>Chubut</ron_nombre>
        </region>
        <region>
                <ron_id>5</ron_id>
                <ron_nombre>Cordoba</ron_nombre>
        </region>
        <region>
                <ron_id>6</ron_id>
                <ron_nombre>Corrientes</ron_nombre>
        </region>
        <region>
                <ron_id>7</ron_id>
                <ron_nombre>Distrito Federal</ron_nombre>
        </region>
        <region>
                <ron_id>8</ron_id>
                <ron_nombre>Entre Rios</ron_nombre>
        </region>
        <region>
                <ron_id>9</ron_id>
                <ron_nombre>Formosa</ron_nombre>
        </region>
        <region>
                <ron_id>10</ron_id>
                <ron_nombre>Jujuy</ron_nombre>
        </region>
        <region>
                <ron_id>11</ron_id>
                <ron_nombre>La Pampa</ron_nombre>
        </region>
        <region>
                <ron_id>12</ron_id>
                <ron_nombre>La Rioja</ron_nombre>
        </region>
        <region>
                <ron_id>13</ron_id>
                <ron_nombre>Mendoza</ron_nombre>
        </region>
        <region>
                <ron_id>14</ron_id>
                <ron_nombre>Misiones</ron_nombre>
        </region>
        <region>
                <ron_id>15</ron_id>
                <ron_nombre>Neuquen</ron_nombre>
        </region>
        <region>
                <ron_id>16</ron_id>
                <ron_nombre>Rio Negro</ron_nombre>
        </region>
        <region>
                <ron_id>17</ron_id>
                <ron_nombre>Salta</ron_nombre>
        </region>
        <region>
                <ron_id>18</ron_id>
                <ron_nombre>San Juan</ron_nombre>
        </region>
        <region>
                <ron_id>19</ron_id>
                <ron_nombre>San Luis</ron_nombre>
        </region>
        <region>
                <ron_id>20</ron_id>
                <ron_nombre>Santa Cruz</ron_nombre>
        </region>
        <region>
                <ron_id>21</ron_id>
                <ron_nombre>Santa Fe</ron_nombre>
        </region>
        <region>
                <ron_id>22</ron_id>
                <ron_nombre>Santiago del Estero</ron_nombre>
        </region>
        <region>
                <ron_id>23</ron_id>
                <ron_nombre>Tierra del Fuego</ron_nombre>
        </region>
        <region>
                <ron_id>24</ron_id>
                <ron_nombre>Tucuman</ron_nombre>
        </region>
</regiones>
}
