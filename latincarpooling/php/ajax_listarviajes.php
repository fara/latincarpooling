<?php
include 'func_lib.php';

$ciudadOrigen = valor_campo('ciudadOrigen');
$ciudadDestino = valor_campo('ciudadDestino');
$cantidadLugaresLibres = valor_campo('cantidadLugaresLibres');
if (!($cantidadLugaresLibres >= 1)) {
    $cantidadLugaresLibres = 1;
};
$fechaDesde = valor_campo('fechaDesde'); //Para informix dd/mm/aaaa
$fechaHasta = valor_campo('fechaHasta'); //Para informix dd/mm/aaaa
        
//ciudadOrigen=3435548&ciudadDestino=3429248&cantidadLugaresLibres=1&fechaDesde=01/01/2007&fechaHasta=01/01/2008
        
if (($ciudadOrigen > 0) && ($ciudadDestino > 0) &&
    ($fechaDesde != '') && ($fechaHasta != '')) {
    try {
        $conexionInformix = nuevaConexionInformix();		                   
        	            	
    	$llamadaSp = "EXECUTE PROCEDURE sps_xml_buscar_viajes ("
    	    . $ciudadOrigen . ", " . $ciudadDestino . ", " . $cantidadLugaresLibres . ", '"
    	    . $fechaDesde . "', '" . $fechaHasta . "')";
    	        	    	    	    	     	 
        $sph= $conexionInformix->prepare($llamadaSp);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
             throw new Exception("Fallo la llamada al SP sps_xml_buscar_viajes (prepare): ".$error["1"]);                        
        };        
           
        $sph->execute();
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
               throw new Exception("Fallo la llamada al SP sps_xml_buscar_viajes (execute): ".$error["1"]);                        
        };        
    
        $filaSp = $sph->fetch(PDO::FETCH_NUM);
        $errorInformix = $conexionInformix->errorInfo();
        if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP sps_xml_buscar_viajes (fetch): ".$error["1"]);                        
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
	
