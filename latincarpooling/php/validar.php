<?Php
function validar_sesion() {
        session_start();
	if ($_SESSION["autentificado"] != "SI") {
	    header("Location: login.php");
	    exit();
	} 
}
validar_sesion();
?>
