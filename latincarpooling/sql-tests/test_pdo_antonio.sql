--Informix
CREATE FUNCTION calculo (price money, quantity smallint)
                RETURNING decimal WITH (not variant);
        RETURN price * quantity;
END FUNCTION;

select calculo(3.5,10) from combustible


drop function verificar_usuario
;
create function verificar_usuario
(
    nombre_usuario char(20),
    contrasena_hash char(255)

) returning integer;

    define id_usuario integer;

    if nombre_usuario is null or nombre_usuario = '' then
       RAISE EXCEPTION -746, 0, 'No se ingreso un usuario. [6]';
       return 0;
    end if;

    if contrasena_hash is null or contrasena_hash = '' then
       RAISE EXCEPTION -746, 0, 'No se ingreso la contraseña. [7]';
       return 0;
    end if;

    let id_usuario = (select u.uio_id
        from usuario u
        where u.uio_nombreusuario = nombre_usuario
        and u.uio_contrasena = contrasena_hash);

    if id_usuario is null then
        let id_usuario = 0;
    end if;

    return id_usuario;

end function;


select first 1 verificar_usuario('tester','guionbajo') from combustible

--DB2

--drop SERVER ifxguaderio
CREATE SERVER ifxguaderio TYPE INFORMIX
   VERSION 9
   WRAPPER informixwrapper
   OPTIONS(
      ADD node 'ol_guaderio',
      dbname 'produccion',
         IUD_APP_SVPT_ENFORCE  'Y',
        PASSWORD 'Y',
        PUSHDOWN 'Y',
        FOLD_ID 'N',  FOLD_PW 'N');

--DROP USER MAPPING FOR db2admin SERVER ifxguaderio
CREATE USER MAPPING FOR db2admin
   SERVER ifxguaderio
   OPTIONS(
      ADD remote_authid 'carpooling',
      ADD remote_password 'metddallica23'
   );

create nickname usuario for IFXGUADERIO."informix"."usuario";
-1829

CREATE USER MAPPING FOR "CARPOOLING" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "GOYO" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "ADMINISTRADOR" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "INFORMIX" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "INVITADO" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "JUEGOS" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "MAMA" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "MANUEL" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "ROOT" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "TITO" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;
CREATE USER MAPPING FOR "USUARIOS" SERVER "IFXGUADERIO" OPTIONS ( ADD REMOTE_AUTHID 'carpooling', ADD  REMOTE_PASSWORD '*****') ;

CREATE FUNCTION calculoT (decimal,smallint)
        RETURNS decimal(10,2) DETERMINISTIC AS TEMPLATE

CREATE FUNCTION calculoT2 (int,int)
        RETURNS decimal(10,2) DETERMINISTIC AS TEMPLATE

CREATE FUNCTION MAPPING f_mapp22 FOR calculoT2
        SERVER ifxguaderio
        OPTIONS (REMOTE_NAME 'calculo')
;

select "calculo"(5,10) from usuario

Error: SQL0440N  No se ha encontrado ninguna rutina autorizada de nombre "calculo" y tipo "FUNCTION" que tenga argumentos compatibles.    SQLSTATE=42884
 (State:42884, Native Code: FFFFFE48)


select * from SYSCAT.DUMMY1

select timestamp_iso(current timestamp) from usuario
