<?php
include 'validar.php';
validar_sesion();
include 'header.php';
carpooling_header("Nuevo Viaje");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Nuevo Viaje</h1>
<?php
        $camposOk = 0;									                    
        
        $paisOrigen = valor_campo('paisOrigen');
        $regionOrigen = valor_campo('regionOrigen');
        $ciudadOrigen = valor_campo('ciudadOrigen');
        $paisDestino = valor_campo('paisDestino');
        $regionDestino = valor_campo('regionDestino');
        $ciudadDestino = valor_campo('ciudadDestino');
        $fechaDesde = valor_campo('fechaDesde');        
        $fechaHasta = valor_campo('fechaHasta');        
        $importe = valor_campo('importe');        
        $tipoImporte = valor_campo('tipoImporte');        
        $cantidadLugares = valor_campo('cantidadLugares');        
        $recorridoSeleccionado = valor_campo('recorridoSeleccionado');
        $vehiculo = valor_campo('vehiculo');
        
        /* Si se enviaron parametros.*/
		if (hay_campos_enviados()) {										        										        
		    if ($paisOrigen == '' || $paisOrigen <= 0) {												    
			   error("Por favor, complete el pais de origen");																			
            } elseif ($regionOrigen == '' || $regionOrigen <= 0) {			
                        error("Por favor, complete la region de origen");																			
            } elseif ($ciudadOrigen == '' || $ciudadOrigen <= 0) {			
                        error("Por favor, complete la ciudad de origen");																			
            } elseif ($paisDestino == '' || $paisDestino <= 0) {			
                error("Por favor, complete el pais de destino");																			
            } elseif ($regionDestino == '' || $regionDestino <= 0) {			
                        error("Por favor, complete la region de destino");																			
            } elseif ($ciudadDestino == '' || $ciudadDestino <= 0) {			
                        error("Por favor, complete la ciudad de destino");																			
            } elseif (!verificar_campo('fechaDesde') ) {
                        error("Por favor, complete la minima fecha en la cual desea viajar");																			
            } elseif (!es_string_fecha_valida(valor_campo('fechaDesde')) ) {
                        error("La fecha inicial ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                                                
            } elseif (!verificar_campo('fechaHasta') ) {
                        error("Por favor, complete la maxima fecha en la cual desea viajar");																			
            } elseif (!es_string_fecha_valida(valor_campo('fechaHasta')) ) {
                        error("La fecha final ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                        
            } elseif (verificar_campo('importe') && !es_numero_decimal($_REQUEST['importe']) ) {
                        error("El importe debe ser un número. Recuerde utilizar el punto como separador de decimales.");																			                        
            } elseif (verificar_campo('importe') && (valor_campo('importe') < 0) ) {
                        error("El importe no puede ser negativo. Recuerde utilizar el punto como separador de decimales.");																			                        
            } elseif (!verificar_campo('tipoImporte') ) {
                        error("Por favor, seleccione un tipo de importe.");																			
            } elseif (!verificar_campo('cantidadLugares') ) {
                        error("Por favor, ingrese la cantidad de lugares.");																			
            } elseif (verificar_campo('cantidadLugares') && !es_numero_entero($_REQUEST['cantidadesLugares']) ) {
                        error("La cantidad de lugares debe ser un número.");																			                        
            } elseif (verificar_campo('cantidadLugares') && (valor_campo('cantidadLugares') < 0) ) {
                        error("La cantidad de lugares no puede ser negativa.");																	            
            } elseif ($vehiculo == '' || $vehiculo <= 0) {			
                        error("Por favor, seleccione un vehiculo.");																					                        
            } elseif (!verificar_campo('recorridoSeleccionado') ) {
                   error("Por favor, seleccione un recorrido.");																			
            } else {                        
                        $camposOk = 1;	                        
            };
        };
        
        $conexion = nuevaConexion();
                                               
        /* Si tenemos todos los datos, guardamos el nuevo pedido de viaje.*/
        if ($camposOk != 0) {
            try {
                $conexion->beginTransaction();
                $resultadoViajeMax = $conexion->query('SELECT max(vje_id) maxid from viaje');
                $filaViajeMax = $resultadoViajeMax->fetch(PDO::FETCH_ASSOC);
                if ($filaViajeMax != '') {
                        $viajeID = $filaViajeMax['MAXID'];
                };
                if ($viajeID > 0) {
                    $viajeID++;
                } else {                 
                    $viajeID = 1;
                };                        
                if ($tipoImporte == 'P') {
                	$importePasajero = $importe;
                	$importeTotal = 0;
                } else {
                	$importePasajero = 0;
                	$importeTotal = $importe;
        	};
                $conexion->exec("
                    insert into viaje (
                        vje_id,
                        vje_rdo_id,
                        vje_fechamenor,
                        vje_fechamayor,
                        vje_tipoviaje
                    ) values (
                        ".$viajeID.",
                        ".$recorridoSeleccionado.",
                        '".obtener_string_fecha_bd($fechaDesde)."',
                        '".obtener_string_fecha_bd($fechaHasta)."',
                        'C')
                        ");
                                                        
                $conexion->exec("
                    insert into viajeconductor (
                        vcr_vje_id,
                        vcr_cantlugares,
                        vcr_importe,
                        vcr_importeviaje,                        
                        vcr_lugareslibres,
                        vcr_uio_id
                    ) values (
                        ".$viajeID.",
                        ".$cantidadLugares.",
                        ".$importePasajero.",
                        ".$importeTotal.",
                        ".$cantidadLugares.",
                        ".$_SESSION['idusuario'].")
                        ");
                        /* Inserta el viaje como el usuario tester. */  
                $conexion->commit();
                echo '<H3>El viaje se guardo correctamente.</H3>';        
            } catch (PDOException $e) {  
                echo '<H3>Ocurrio un error al guardar el viaje.</H3>';        
                echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';     
                $conexion->rollback();                   
            };
            
        } else {                
            if ($fechaDesde == '') {
                $fechaDesde = date('d/m/Y');
            };        
            if ($fechaHasta == '') {
                $fechaHasta = date('d/m/Y');
            };        
            if ($importe == '') {
                $importe = 0;
            };        
            if ($tipoImporte == '') {
                $tipoImporte = 'P';
            };
            $cantidadLugares = valor_campo('cantidadLugares');                
            $usuario = $_SESSION['idusuario'];
            
            /* Comienzo del formulario.*/
            echo '
        <form name="formingresarviaje" method="get" action="">  
                ';             
        campoHidden('idUsuarioActual', $usuario);		        
            echo '
            <table cellpadding="1" cellspacing="1" width="500" bordercolor="#999999" align="center" valign="top">
            <tr>
			    <td width="25%"> 
                    <div align="right"><span class="intro">Origen: </span></div>
                 </td>
			     <td width="75%">					  			     
			        <select name="paisOrigen" class="searchbox" id="paisOrigen" onchange="mostrarRegiones(\'paisOrigen\',\'regionOrigen\', \'ciudadOrigen\', \'ciudadOrigenDescripcion\')" >
                    <select name="regionOrigen" class="searchbox" id="regionOrigen" onchange="cambioRegion(\'ciudadOrigen\', \'ciudadOrigenDescripcion\', \'divCiudadOrigen\')">
                    <input type="text" id="ciudadOrigenDescripcion" name="ciudadOrigenDescripcion" value="" '.
		                'onkeyup="mostrarCiudades(\'regionOrigen\', \'ciudadOrigenDescripcion\', \'divCiudadOrigen\',\'setCiudadOrigen\');" autocomplete="off" />
                    <div id="divCiudadOrigen">
	                </div>	            
	                <input type="hidden" id="ciudadOrigen" name="ciudadOrigen" value="'.$ciudadOrigen.'"/>	            
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Destino: </span></div>
                 </td>
			     <td>					  			     
			        <select name="paisDestino" class="searchbox" id="paisDestino" onchange="mostrarRegiones(\'paisDestino\',\'regionDestino\', \'ciudadDestino\', \'ciudadDestinoDescripcion\')" >
                    <select name="regionDestino" class="searchbox" id="regionDestino" onchange="cambioRegion(\'ciudadDestino\', \'ciudadDestinoDescripcion\', \'divCiudadDestino\')">
                    <input type="text" id="ciudadDestinoDescripcion" name="ciudadDestinoDescripcion" value="" '.
		                'onkeyup="mostrarCiudades(\'regionDestino\', \'ciudadDestinoDescripcion\', \'divCiudadDestino\',\'setCiudadDestino\');" autocomplete="off" />
                    <div id="divCiudadDestino">
	                </div>	                        
	                <input type="hidden" id="ciudadDestino" name="ciudadDestino" value="'.$ciudadDestino.'"/>
	            ';
	            	            	                                                      
           if ($tipoImporte == 'P') {
                $pasajeroSelected = ' selected="selected"';
                $totalSelected = '';
           } else {
                $totalSelected = ' selected="selected"';
                $pasajeroSelected = '';
            };
           echo '
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Fecha: </span></div>
                 </td>
			     <td>					  			     			        
			        <input class="searchbox" name="fechaDesde" type="text" id="fechaDesde" value="'.$fechaDesde.'" maxlength="10" />
			        hasta
			        <input class="searchbox" name="fechaHasta" type="text" id="fechaHasta" value="'.$fechaHasta.'" maxlength="10" />
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Importe:</span></div>
                 </td>
		        <td>					  			     
			        <input class="searchbox" name="importe" type="text" id="importe" value="'.$importe.'" maxlength="10" />			        
		    		<select name="tipoImporte" class="searchbox" id="tipoImporte">
			    		<option value="T"'.$totalSelected.'>Total</option>
				    	<option value="P"'.$pasajeroSelected.'>Por pasajero</option>
				    </select>        			        
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Cantidad de Lugares:</span></div>
                 </td>
		        <td>					  			     
			        <input class="searchbox" name="cantidadLugares" type="text" id="cantidadLugares" value="'.$cantidadLugares.'" maxlength="10" />			        		    		
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Vehiculo:</span></div>
                 </td>
		        <td>					  			     
		            <select name="vehiculo" class="searchbox" id="vehiculo" onchange="mostrarRecorridos();">		        
                </td>
            </tr>                
            <tr>
			    <td> 
                    <div align="left"><span class="intro">Recorridos:</span></div>
                </td>			                        
            </tr>
            <tr>              
                <td colspan ="2"> 
			        <div id="divRecorridos"> </div>            
                </td>
            </tr>
            <tr>
                <td colspan="2"> 
                &nbsp;
                </td>
            </tr>
            <tr>    
			    <td colspan="2" align="center">
			        <input class="searchbutton" type="submit" name="botonContinuar" value="Continuar">
                </td>
            </tr>
            </table>
            </form>';                 
        }; /*if ($camposOk != 0) {*/
      
        cerrarConexion($conexion);

?>
    <div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>
