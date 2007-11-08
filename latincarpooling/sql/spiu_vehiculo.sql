drop procedure spiu_vehiculo;
create procedure spiu_vehiculo
(
    id_usuario          int,
    id_vehiculo         int,
    modelo              varchar(30),
    color               varchar(20),
    patente             varchar(10),
    id_combustible      integer,
    consumo             decimal,
    tiene_aire          boolean,
    cantidad_asientos   smallint
) returns integer;

--  VALIDACIONES DE PARAMETROS OBLIGATORIOS
    if id_usuario is null then
       RAISE EXCEPTION -746, 0, 'No se indico el ID de usuario. [3]';
       return -1;
    end if;
    if id_vehiculo is null then
       RAISE EXCEPTION -746, 0, 'No se indico el ID de vehiculo. [3]';
       return -1;
    end if;
    if modelo is null or modelo = '' then
        RAISE EXCEPTION -746, 0, 'No se indico el modelo. [3]';
       return -1;
    end if;
    if color is null or color = '' then
        RAISE EXCEPTION -746, 0, 'No se indico el color. [3]';
       return -1;
    end if;
    if patente is null or patente = '' then
        RAISE EXCEPTION -746, 0, 'No se indico la patente. [3]';
       return -1;
    end if;
    if id_combustible is null then
        RAISE EXCEPTION -746, 0, 'No se indico el ID de combustible. [3]';
       return -1;
    end if;
    if consumo is null then
        RAISE EXCEPTION -746, 0, 'No se indico el consumo. [3]';
       return -1;
    end if;
    if tiene_aire is null then
        RAISE EXCEPTION -746, 0, 'No se indico si tiene aire acondicionado. [3]';
       return -1;
    end if;
    if cantidad_asientos is null then
        RAISE EXCEPTION -746, 0, 'No se indico la cantidad de asientos. [3]';
       return -1;
    end if;

--  VALIDO QUE EXISTA EL USUARIO
    if not exists (select 1 from usuario u
                    where u.uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return -1;
    end if;

--  VALIDO QUE NO EXISTA EL VEHICULO
    if exists (select 1 from vehiculo v
                    where v.vlo_id = id_vehiculo) then
       RAISE EXCEPTION -746, 0, 'Ya existe el vehiculo. [1]';
       return -1;
    end if;

--  VALIDO QUE EXISTA EL COMBUSTIBLE
    if not exists (select 1 from combustible c
                    where c.cle_id = id_combustible) then
       RAISE EXCEPTION -746, 0, 'No existe el combustible. [1]';
       return -1;
    end if;

    if exists (select 1 from vehiculo v
                where v.vlo_id = id_vehiculo
                and v.vlo_uio_id = id_usuario) then
        begin
       update vehiculo
       set
            vlo_modelo = modelo,
            vlo_color = color,
            vlo_patente = patente,
            vlo_cle_id = id_combustible,
            vlo_consumo = consumo,
            vlo_tieneac = tiene_aire,
            vlo_asientos = cantidad_asientos
       where vlo_id = id_vehiculo
       and vlo_uio_id = id_usuario;
       end;
    else
        begin
        insert into vehiculo
        (vlo_id,
        vlo_uio_id,
        vlo_modelo,
        vlo_color,
        vlo_patente,
        vlo_cle_id,
        vlo_consumo,
        vlo_tieneac,
        vlo_asientos
        ) values
        (id_vehiculo,
        id_usuario,
        modelo,
        color,
        patente,
        id_combustible,
        consumo,
        tiene_aire,
        cantidad_asientos);
        end;
    end if;

    return 0;
end procedure
document
'Fecha de Creacion: 2007-11-03                                                          ',
'                                                                                       ',
'Autor:             faramendi                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario          ID del usuario                                  ',
'                   id_vehiculo         ID del vehiculo                                 ',
'                   modelo              Modelo del vehiculo                             ',
'                   color               Color del vehiculo                              ',
'                   patente             Patente del vehiculo                            ',
'                   id_combustible      ID del combustible                              ',
'                   consumo             Consumo del vehiculo                            ',
'                   tiene_aire          Si el vehiculo tiene Aire Acondicionado         ',
'                   cantidad_asientos   Cantidad de asientos del vehiculo               ',
'                                                                                       ',
'Descripcion:       Si se indica un id se modificarán las propiedades del ese vehículo, ',
'                   en caso de no proporcionar uno se creará un nuevo vehículo y su id  ',
'                   será devuelto.                                                      ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No existe el usuario.                                             ',
'                   - No existe el vehiculo.                                            ',
'                                                                                       '
with listing in 'informix_warn';
