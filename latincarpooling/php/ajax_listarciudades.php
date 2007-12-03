<?php
include 'func_lib.php';

$unaRegion = valor_campo('region');
$nombreInicial = valor_campo('nombreInicial');
if ($unaRegion > 0) {
    try {
        $conexionInformix = nuevaConexionInformix();		            
        $nombreInicial = addslashes($nombreInicial);
        	
    	//Get every page title for the site.
    	$llamadaSp = "EXECUTE PROCEDURE sps_xml_ciudades (" . $unaRegion . ", '" . $nombreInicial ."')";
    	
        $sph= $conexionInformix->prepare($llamadaSp);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
             throw new Exception("Fallo la llamada al SP sps_xml_ciudades (prepare): ".$error["1"]);                        
        };        
           
        $sph->execute();
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
               throw new Exception("Fallo la llamada al SP sps_xml_ciudades (execute): ".$error["1"]);                        
        };        
    
        $filaSp = $sph->fetch(PDO::FETCH_NUM);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP sps_xml_ciudades (fetch): ".$error["1"]);                        
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
	
