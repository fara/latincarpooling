--Informix
CREATE FUNCTION calculo (price money, quantity smallint)
                RETURNING decimal WITH (not variant);
        RETURN price * quantity;
END FUNCTION;

select calculo(3.5,10) from combustible


--drop function verificar_usuario
--;

create function DBO.VERIFICAR_USUARIO
(
    nombre_usuario char(20),
    contrasena_hash char(200)

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

select calculo(5,10) from usuario

Error: SQL0440N  No se ha encontrado ninguna rutina autorizada de nombre "calculo" y tipo "FUNCTION" que tenga argumentos compatibles.    SQLSTATE=42884
 (State:42884, Native Code: FFFFFE48)


select * from SYSCAT.DUMMY1

select timestamp_iso(current timestamp) from usuario



CREATE FUNCTION dbo.BONUS (price money, quantity smallint)
                RETURNING decimal(8,2);
        RETURN price * quantity * 3;
END FUNCTION;

--drop FUNCTION DBO.SINPARAMETROS
CREATE FUNCTION DBO.CONPARAMETROS ( numero integer )
                RETURNING integer;
        RETURN numero;
END FUNCTION;





select carpooling.BONUS(1,1), sinparametros() from usuario



create FUNCTION DB2ADMIN.SINPARAMETROS ()
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION


CREATE FUNCTION MAPPING MAPSINPARAEMTROS FOR SINPARAMETROS()
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'SINPARAMETROS()')


--En informix
CREATE FUNCTION DBO.SUMAR ( numero1 integer, numero2 integer )
                RETURNING integer;
        RETURN numero1 + numero2;
END FUNCTION;

--En DB"
create FUNCTION BONUS ()
    RETURNS DECIMAL(8,2)
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION


CREATE FUNCTION MAPPING IFXGUADERIO FOR BONUS()
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'BONUS()')


--Funciona
create FUNCTION DB2ADMIN.SINPARAMETROS ()
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION

CREATE FUNCTION MAPPING MAPCONPARAMETROS FOR CONPARAMETROS(INTEGER)
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'CONPARAMETROS')
select SINPARAMETROS() from USUARIO

create FUNCTION DB2ADMIN.SINPARAMETROS ()
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION


--Con un parametro

CREATE FUNCTION MAPPING MAPCONPARAMETROS FOR CONPARAMETROS(INTEGER)
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'CONPARAMETROS')
select DB2ADMIN.CONPARAMETROS(1) from USUARIO

create FUNCTION DB2ADMIN.CONPARAMETROS (integer)
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION

-- Verificar usuario.

create FUNCTION DB2ADMIN.VERIFICAR_USUARIO (char(20), char(200))
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION

DROP MAPPING MAPFUNCVERIFICAR_USUARIO
CREATE FUNCTION MAPPING MAPFUNCVERIFICAR_USUARIO FOR VERIFICAR_USUARIO
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'VERIFICAR_USUARIO')

select VERIFICAR_USUARIO('dfaf','afsdfsf') from USUARIO

drop function db2admin.sumart
--En DB2
create FUNCTION DB2ADMIN.SUMAR (integer, integer)
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION

CREATE FUNCTION MAPPING MAPSUMART FOR SUMAR
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'SUMAR')


select sumar(1,2) from USUARIO


CREATE FUNCTION calculoT (decimal,smallint)
        RETURNS decimal(10,2) DETERMINISTIC AS TEMPLATE

CREATE FUNCTION calculoT2 (int,int)
        RETURNS decimal(10,2) DETERMINISTIC AS TEMPLATE

CREATE FUNCTION MAPPING f_mapp22 FOR calculoT2
        SERVER ifxguaderio
        OPTIONS (REMOTE_NAME 'calculo')


create function DBO.VERIFICAR_USUAURIO
(
    nombre_usuario char(20),
    contrasena_hash char(255)


create FUNCTION DB2ADMIN.VERIFICAR_USUAURIO ( char(20), char(254))
    RETURNS integer
    AS TEMPLATE
    DETERMINISTIC
    NO EXTERNAL ACTION


CREATE FUNCTION MAPPING MAPVERIFICAR_USUARIO FOR VERIFICAR_USUAURIO
   SERVER TYPE INFORMIX OPTIONS (REMOTE_NAME 'VERIFICAR_USUAURIO')


select DB2ADMIN.VERIFICAR_USUAURIO('dfdsf','asfasfd') from USUARIO




