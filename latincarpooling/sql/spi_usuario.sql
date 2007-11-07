drop procedure dbo.spi_usuario;
create procedure dbo.spi_usuario
(
    id_usuario	            int,
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
    sexo	            char(1),
    direccion_calle         varchar(100),
    direccion_altura        int,
    direccion_piso          smallint,
    direccion_departamento  char(4),
    direccion_codigo_postal char(20),
    direccion_ciudad_id     int,
    tipo_documento_id       int,
    numero_documento        char(11),
    nacionalidad            char(25),
    publicar_datos          boolean,
    foto                    blob
) returns char(20);

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

    if exists (select 1 from usuario u
                    where u.uio_nombre = alias_usuario) then
       RAISE EXCEPTION -746, 0, 'Ya existe el usuario. [1]';
       return -1;
    end if;

   insert into usuario
        (   uio_id,
	    uio_nombreusuario,
            uio_apellido,
            uio_nombre,
            uio_contrasena,
            uio_email,
            uio_mailverificado,
            uio_chequeofrec,
            uio_telpersonal,
            uio_telcelular,
            uio_tellaboral,
            uio_esfumador,
	    uio_sexo,
            uio_calle,
            uio_callealtura,
            uio_piso,
            uio_departamento,
            uio_codigopostal,
            uio_cad_id,
            uio_tdo_id,
            uio_numerodoc,
            uio_nacionalidad,
            uio_info_visible,
            uio_foto
        ) values
        (   id_usuario,
	    nombre,
            apellido,
            alias_usuario,
            contrasena,
            email,
            'f',
            frecuencia_email,
            telefono_personal,
            telefono_celular,
            telefono_laboral,
            es_fumador,
	    sexo,
            direccion_calle,
            direccion_altura,
            direccion_piso,
            direccion_departamento,
            direccion_codigo_postal,
            direccion_ciudad_id,
            tipo_documento_id,
            numero_documento,
            nacionalidad,
            publicar_datos,
            foto);

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
'                   sexo	                Sexo			                ',
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
'                   foto                        Foto                                    ',
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
