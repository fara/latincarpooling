<?php

function my_handler ($number, $message, $file, $line) {
	// Match the formatting, CSS, etc., for your site's style!
	echo '

The following error occurred, allegedly on line ' . $line . ' of file ' . $file . ': ' . $message . '
';
};

set_error_handler('my_handler');


$dsn = "carpooling";
$usuario = "carpooling";
$clave="metallica23";

//realizamos la conexion mediante odbc
$cid=odbc_connect($dsn, $usuario, $clave);
odbc_autocommit($cid, FALSE);

if (!$cid){
	exit("<strong>Ya ocurrido un error tratando de conectarse con el origen de datos.</strong>");
}	

echo 'Contenido de la tabla valorcambio';
// consulta SQL a nuestra tabla "usuarios" que se encuentra en la base de datos "db.mdb"
$sql="Select * from valorcambio";

// generamos la tabla mediante odbc_result_all(); utilizando borde 1
$result=odbc_exec($cid,$sql);
print odbc_result_all($result,"border=1");

echo '<P>Llamada a un procedimiento</P>';

/*$sql="RAISE EXCEPTION -746, 0, 'No se indico el id de vehiculo. [3]'; ";*/

 $sql = "EXECUTE PROCEDURE dbo.spu_valor_cambio (1, '01-01-2009', 444.00)";

try
{

$result=odbc_do($cid,$sql);

} catch (Exception $e) {
	echo 'Excepcion Capturada: ' . $e->getMessage();
};

if (!$result) {
	echo 'Ocurrio un error al ejecutar el procedimiento.';
};

echo '<P>Ultimo Error ocurrido:'.odbc_error();
echo '<P>Mensaje del ultimo error:'.odbc_errormsg ();


echo '<P>Cerramos la conexion.';
odbc_close($cid);
	
?>