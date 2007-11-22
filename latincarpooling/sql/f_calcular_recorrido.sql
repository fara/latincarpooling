--drop FUNCTION FCALCULARRECORRIDO
CREATE FUNCTION SA505103.FCALCULARRECORRIDO
(
    id_ciudad_origen integer,
    id_ciudad_destino integer,
    id_sesion integer
) RETURNING integer;

        /*return sps_calcular_recorrido(id_ciudad_origen, id_ciudad_destino , id_sesion)*/

end function
;

/*
--En db2
create FUNCTION DB2ADMIN.FCALCULARRECORRIDO (integer, integer, integer)
RETURNS integer
AS TEMPLATE
DETERMINISTIC
NO EXTERNAL ACTION

CREATE FUNCTION MAPPING MAPCALCULARRECORRIDOT FOR FCALCULARRECORRIDO
SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'FCALCULARRECORRIDO')

-- En PHP
select sa505103.FCALCULARRECORRIDO(3430988,3853354,2), count(*) from USUARIO

*/
