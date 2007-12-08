<?php
include 'func_lib.php';

$ciudadOrigen = valor_campo('ciudadOrigen');
$ciudadDestino = valor_campo('ciudadDestino');
$idUsuario = valor_campo('idUsuario');
$idVehiculo = valor_campo('idVehiculo');
$paisOrigen = valor_campo('paisOrigen');
$fechaHoy = date('d/m/Y'); //Formato de Fecha para informix.
$idSesion = rand(1,5000);

//ciudadOrigen=3435548&ciudadDestino=3841490&idUsuario=13&idVehiculo=1&paisOrigen=1
        
if (($ciudadOrigen > 0) && ($ciudadDestino > 0) && ($idUsuario > 0) &&
    ($idVehiculo >= 0) && ($paisOrigen > 0)) {
    try {
        $conexionInformix = nuevaConexionInformix();		                   
        	            	
    	$llamadaSp = "EXECUTE PROCEDURE sps_xml_mostrar_recorridos ("
    	    . $ciudadOrigen . ", " . $ciudadDestino . ", " . $idUsuario . ", " . $idVehiculo .  ", "
    	    . $paisOrigen . ", " . $idSesion .  ", '" . $fechaHoy . "')";
    	    	    	     	 
        $sph= $conexionInformix->prepare($llamadaSp);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
             throw new Exception("Fallo la llamada al SP sps_xml_mostrar_recorridos (prepare): ".$error["1"]);                        
        };        
           
        $sph->execute();
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
               throw new Exception("Fallo la llamada al SP sps_xml_mostrar_recorridos (execute): ".$error["1"]);                        
        };        
    
        $filaSp = $sph->fetch(PDO::FETCH_NUM);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP sps_xml_mostrar_recorridos (fetch): ".$error["1"]);                        
        };        
           
        //Mostramos el documento XML.
        echo $filaSp[0];
          
        cerrarConexion($conexionInformix);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
           throw new Exception("Error al cerrar la conexion (close): ".$error["1"]);                        
        };        
            
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                       
    }; 
} else {
    echo 'Faltan datos areco';
    echo $ciudadOrigen;
    echo $ciudadDestino;
    echo $idUsuario;
    echo $idVehiculo;
    echo $paisOrigen;
    echo $fechaHoy;
    echo $idSesion;
};
?>
	
