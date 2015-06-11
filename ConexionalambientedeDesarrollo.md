# Instrucciones para conectarse al ambiente de desarrollo. #

## Pasos para conectarse al ambiente de desarrollo ##

  1. Instalar el SDK de Informix. Trae los drivers ODBC.
  1. Crear una nueva coneccion ODBC con los siguientes datos:
> En la solapa General:
    * Data Source Name: ol\_guaderio (O Cualquiera)
    * Description: (Cualquiera)
> En la solapa Connection:
    * Server Name: ol\_guaderio
    * Host Name: arobirosa.no-ip.org
    * Service: 1526
    * Protocol: olsoctcp
    * Database name: produccion
    * User ID: carpooling
    * Password: (la misma que para la base Postgresql - ver grupo yahoo)
> Con estos datos la coneccion deberia funcionar.
  1. Utilizando WinSQL o similar conectarse a la base.