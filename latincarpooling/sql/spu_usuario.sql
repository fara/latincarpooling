drop procedure spu_usuario;
create procedure spu_usuario
(
    id_usuario              int,
    nombre                  char(50),
    apellido                char(50),
    alias_usuario           char(20),
    contrasena              varchar(255),
    email                   varchar(255),
    frecuencia_email        smallint,
    telefono_personal       char(25),
    telefono_celular        char(25),
    telefono_laboral        char(25),
    es_fumador              boolean,
    sexo                    char(1),
    direccion_calle         varchar(100),
    direccion_altura        int,
    direccion_piso          smallint,
    direccion_departamento  char(4),
    direccion_codigo_postal char(20),
    direccion_ciudad_id     int,
    tipo_documento_id       int,
    numero_documento        char(11),
    nacionalidad            char(25),
    publicar_datos          boolean
) returns char(20);

    DEFINE token char(20);
    DEFINE mail_viejo varchar(255);

--  VALIDACION DE PARAMETROS OBLIGATORIOS
    if nombre is null or nombre = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el nombre de usuario. [3]';
       return -1;
    end if;
    if apellido is null or apellido = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el apellido de usuario. [3]';
       return -1;
    end if;
    if alias_usuario is null or alias_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el alias de usuario. [3]';
       return -1;
    end if;
    if contrasena is null or contrasena = '' then
       RAISE EXCEPTION -746, 0, 'No se indico la contrasena de usuario. [3]';
       return -1;
    end if;
    if email is null or email = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el e-mail de usuario. [3]';
       return -1;
    end if;
    if frecuencia_email is null then
       RAISE EXCEPTION -746, 0, 'No se indico la frecuencia de mail de usuario. [3]';
       return -1;
    end if;
    if es_fumador is null then
       RAISE EXCEPTION -746, 0, 'No se indico si es fumador. [3]';
       return -1;
    end if;
    if tipo_documento_id is null then
       RAISE EXCEPTION -746, 0, 'No se indico el tipo de documento. [3]';
       return -1;
    end if;
    if numero_documento is null or numero_documento = '' then
       RAISE EXCEPTION -746, 0, 'No se indico el numero de documento. [3]';
       return -1;
    end if;
    if publicar_datos is null then
       RAISE EXCEPTION -746, 0, 'No se indico si se deben publicar datos. [3]';
       return -1;
    end if;

    if not exists (select 1 from usuario u
                    where u.uio_id = id_usuario) then
       RAISE EXCEPTION -746, 0, 'No existe el usuario. [1]';
       return -1;
    end if;

    let mail_viejo = (select u.uio_email
        from usuario u
        where uio_id = id_usuario);

   update usuario set
            uio_id = id_usuario,
            uio_nombreusuario = nombre,
            uio_apellido = apellido,
            uio_nombre = alias_usuario,
            uio_contrasena = contrasena,
            uio_email = email,
            uio_mailverificado = 'f',
            uio_chequeofrec = frecuencia_email,
            uio_telpersonal = telefono_personal,
            uio_telcelular = telefono_celular,
            uio_tellaboral = telefono_laboral,
            uio_esfumador = es_fumador,
            uio_sexo = sexo,
            uio_calle = direccion_calle,
            uio_callealtura = direccion_altura,
            uio_piso = direccion_piso,
            uio_departamento = direccion_departamento,
            uio_codigopostal = direccion_codigo_postal,
            uio_cad_id = direccion_ciudad_id,
            uio_tdo_id = tipo_documento_id,
            uio_numerodoc = numero_documento,
            uio_nacionalidad = nacionalidad,
            uio_info_visible = publicar_datos
        where uio_id = id_usuario;

    if mail_viejo = email then
        return '';   
    end if;

    return alias_usuario;
end procedure
document
'Fecha de Creacion: 2007-11-03                                                          ',
'                                                                                       ',
'Autor:             faramendi                                                           ',
'                                                                                       ',
'Parametros:                                                                            ',
'                   id_usuario                  ID de usuario                            ',
'                   nombre                      Nombre                                  ',
'                   appelido                    Apellido                                ',
'                   id_usuario                  ID de cuenta del usuario                ',
'                   contrasena                  Contrasena de cuenta del usuario        ',
'                   email                       E-Mail                                  ',
'                   frecuencia_email            Frecuencia de chequeo del mail          ',
'                   telefono_personal           Telefono personal                       ',
'                   telefono_celular            Telefono celular                        ',
'                   telefono_laboral            Telefono laboral                        ',
'                   es_fumador                  Si el usuario es fumador                ',
'                   sexo                        Sexo                                    ',
'                   direccion_calle             Domicilio - Calle                       ',
'                   direccion_altura            Domicilio - Altura                      ',
'                   direccion_piso              Domicilio - Piso                        ',
'                   direccion_departamento      Domicilio - Departamento                ',
'                   direccion_codigo_postal     Domicilio - Codigo Postal               ',
'                   direccion_ciudad_id         Domicilio - Ciudad                      ',
'                   tipo_documento_id           Tipo de documento                       ',
'                   numero_documento            Numero de documento                     ',
'                   nacionalidad                Nacionalidad                            ',
'                   publicar_datos              Si desea publicar sus datos             ',
'                                                                                       ',
'Descripcion:       Se crea un nuevo registro en la tabla de usuarios con los datos     ',
'                   proporcionados.                                                     ',
'                                                                                       ',
'Resultados:        Ninguno.                                                            ',
'                                                                                       ',
'Errores Reportados:                                                                    ',
'                   - No se indicó el nombre de usuario.                                ',
'                   - No se indicó la contraseña.                                       ',
'                   - No se indicó el email.                                            ',
'                                                                                       '
with listing in 'informix_warn';
