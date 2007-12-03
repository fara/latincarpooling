<?php
include 'func_lib.php';

$idUsuario = valor_campo('usuario');
if ($idUsuario > 0) {
    try {
        $conexionInformix = nuevaConexionInformix();		                   
        	
    	//Get every page title for the site.
    	$llamadaSp = "EXECUTE PROCEDURE sps_xml_vehiculos (" . $idUsuario . ")";
    	
        $sph= $conexionInformix->prepare($llamadaSp);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
             throw new Exception("Fallo la llamada al SP sps_xml_vehiculos (prepare): ".$error["1"]);                        
        };        
           
        $sph->execute();
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
               throw new Exception("Fallo la llamada al SP sps_xml_vehiculos (execute): ".$error["1"]);                        
        };        
    
        $filaSp = $sph->fetch(PDO::FETCH_NUM);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP sps_xml_vehiculos (fetch): ".$error["1"]);                        
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
};
?>
	
