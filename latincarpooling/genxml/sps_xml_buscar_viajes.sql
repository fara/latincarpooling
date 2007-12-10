--DROP PROCEDURE sps_xml_buscar_viajes;

CREATE PROCEDURE sps_xml_buscar_viajes (
        ciudadOrigen integer,
        ciudadDestino integer,
        cantidadLibres integer,
        fechaDesde date,
        fechaHasta date
)
RETURNING LVARCHAR
DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE viajeEncontrados SYSTEM "/home/dtd/viajerncontrados.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/viajeencontrados.xsl" ?>';
LET result = result || "<viajesEncontrados>";

FOREACH SELECT first 20 genxml("viaje",
                row(v.vje_id,
                    v.vje_fechamenor,
                    v.vje_fechamayor,
                    vc.vcr_uio_id,
                    vc.vcr_importe,
                    vc.vcr_importeviaje,
                    vc.vcr_lugareslibres,
                    u.uio_id,
                    u.uio_nombreusuario,
                    u.uio_sexo,
                    u.uio_esfumador))
        INTO ressql
        from viaje v
        inner join recorrido r
                on v.vje_rdo_id = r.rdo_id
        and ((r.rdo_cad_id_origen = ciudadOrigen and r.rdo_cad_id_destino = ciudadDestino)
            or (r.rdo_cad_id_origen = ciudadDestino and r.rdo_cad_id_destino = ciudadOrigen))
        inner join viajeconductor vc
            on v.vje_id = vc.vcr_vje_id
            and vc.vcr_lugareslibres >= cantidadLibres
        inner join usuario u
                on vc.vcr_uio_id = u.uio_id
        where v.vje_tipoviaje = 'C'
        and not (v.vje_fechamenor > fechaHasta)
        and not (v.vje_fechamayor < fechaDesde)

  LET result = result || ressql;
END FOREACH;
LET result = result || "</viajesEncontrados>";
RETURN result;
END PROCEDURE;

/*
EXECUTE PROCEDURE sps_xml_buscar_viajes(
        3435548, --Centro
        3429248, --Areco
        1,
        '01-01-2007',
        '01-01-2008');

<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE viajeEncontrados SYSTEM "/home/dtd/viajerncontrados.dtd">
<?xml-stylesheet type="text/xsl" href="/home/xsl/viajeencontrados.xsl" ?>
<viajesEncontrados>
        <viaje>
                <vje_id>19</vje_id>
                <vje_fechamenor>12/22/2007</vje_fechamenor>
                <vje_fechamayor>12/24/2007</vje_fechamayor>
                <vcr_uio_id>13</vcr_uio_id>
                <vcr_importe>14.0000000000</vcr_importe>
                <vcr_importeviaje>0.0000000000</vcr_importeviaje>
                <vcr_lugareslibres>2</vcr_lugareslibres>
                <uio_id>13</uio_id>
                <uio_nombreusuario>arobirosa           </uio_nombreusuario>
                <uio_sexo>M</uio_sexo>
                <uio_esfumador>f</uio_esfumador>
        </viaje>
</viajesEncontrados>
*/
