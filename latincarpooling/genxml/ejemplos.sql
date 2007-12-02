SELECT genxml("combustible", combustible)
FROM combustible;

SELECT genxml("preciocombustible", ROW(pce_cle_id, pce_pis_id, pce_vigentedesde))
FROM preciocombustible WHERE pce_cle_id = 3;

SELECT genxml("viaje",
        ROW(v.vje_id,
                v.vje_rdo_id,
                v.vje_fechamenor,
                v.vje_fechamayor,
                c.vcr_cantlugares,
                c.vcr_lugareslibres
                )
       )
FROM viajeconductor c
inner join viaje v
on c.vcr_vje_id = v.vje_id
WHERE vcr_uio_id = 666;

SELECT genXML("preciocombustible", ROW(pce_cle_id, COUNT(*)))
FROM preciocombustible
GROUP BY pce_cle_id;

DROP PROCEDURE xmlcustomerset();

CREATE PROCEDURE xmlcustomerset()
RETURNING LVARCHAR
DEFINE result LVARCHAR;
DEFINE ressql LVARCHAR;

LET result = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
LET result = result ||
    '<!DOCTYPE customer_set SYSTEM "/home/dtd/customer_set.dtd">';
LET result = result ||
    '<?xml-stylesheet type="text/xsl" href="/home/xsl/customer_set.xsl" ?>';
LET result = result || "<customer_set>";


FOREACH SELECT genxml("usuario", usuario) INTO ressql FROM usuario
        WHERE uio_id = 666
  LET result = result || ressql;
END FOREACH;
LET result = result || "</customer_set>";
RETURN result;
END PROCEDURE;

EXECUTE PROCEDURE xmlcustomerset();

EXECUTE FUNCTION
  addxmlhdr("customer_set",
  "SELECT genxml('valorcambio', valorcambio) FROM valorcambio WHERE vco_mda_id = 1");

EXECUTE FUNCTION
  genxml("customer_set", "SELECT * FROM valorcambio where vco_mda_id = 1");

EXECUTE FUNCTION
  genxmlhdr("customer_set", "SELECT * FROM valorcambio where vco_mda_id = 1");

SELECT aggrxml(recorrido, "customer_set")
FROM recorrido
WHERE rdo_id = 1;

