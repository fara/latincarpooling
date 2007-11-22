<?php
include 'validar.php';
/*validar_sesion(); Areco */
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
        /* Si se enviaron parametros.*/
		if (hay_campos_enviados()) {										        										        
		    if (!verificar_campo('paisOrigen') ) {												    
			error("Por favor, complete el pais de origen");																			
                    } elseif (verificar_campo('validarRegiones') && !verificar_campo('regionOrigen') ) {
                        error("Por favor, complete la region de origen");																			
                    } elseif (verificar_campo('validarCiudades') && !verificar_campo('ciudadOrigen') ) {
                        error("Por favor, complete la ciudad de origen");																			
                    } elseif (!verificar_campo('paisDestino') ) {
                        error("Por favor, complete el pais de destino");																			
                    } elseif (verificar_campo('validarRegiones') && !verificar_campo('regionDestino') ) {
                        error("Por favor, complete la region de destino");																			
                    } elseif (verificar_campo('validarCiudades') && !verificar_campo('ciudadDestino') ) {
                        error("Por favor, complete la ciudad de destino");																			
                    } elseif (verificar_campo('validarCampos') && !verificar_campo('fechaDesde') ) {
                        error("Por favor, complete la minima fecha en la cual desea viajar");																			
                    } elseif (verificar_campo('validarCampos') && !es_string_fecha_valida(valor_campo('fechaDesde')) ) {
                        error("La fecha inicial ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                                                
                    } elseif (verificar_campo('validarCampos') && !verificar_campo('fechaHasta') ) {
                        error("Por favor, complete la maxima fecha en la cual desea viajar");																			
                    } elseif (verificar_campo('validarCampos') && !es_string_fecha_valida(valor_campo('fechaHasta')) ) {
                        error("La fecha final ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                        
                    } elseif (verificar_campo('validarCampos') && verificar_campo('importe') && !es_numero_decimal($_REQUEST['importe']) ) {
                        error("El importe debe ser un número. Recuerde utilizar el punto como separador de decimales.");																			                        
                    } elseif (verificar_campo('validarCampos') && verificar_campo('importe') && (valor_campo('importe') < 0) ) {
                        error("El importe no puede ser negativo. Recuerde utilizar el punto como separador de decimales.");																			                        
                    } elseif (verificar_campo('validarCampos') && !verificar_campo('tipoImporte') ) {
                        error("Por favor, seleccione un tipo de importe.");																			
                    } elseif (verificar_campo('validarCampos') && !verificar_campo('cantidadLugares') ) {
                        error("Por favor, ingrese la cantidad de lugares.");																			
                    } elseif (verificar_campo('validarCampos') && verificar_campo('cantidadLugares') && !es_numero_entero($_REQUEST['cantidadesLugares']) ) {
                        error("La cantidad de lugares debe ser un número.");																			                        
                    } elseif (verificar_campo('validarCampos') && verificar_campo('cantidadLugares') && (valor_campo('cantidadLugares') < 0) ) {
                        error("La cantidad de lugares no puede ser negativa.");																			                        
                    } elseif (verificar_campo('validarCampos') && !verificar_campo('recorridoSeleccionado') ) {
                        error("Por favor, seleccione un recorrido.");																			
                    } else {
                        if (verificar_campo('validarRegiones') && verificar_campo('validarCiudades') && verificar_campo('validarCampos')) {
                            $camposOk = 1;	
                        };
                    };
        };
        
        $conexion = nuevaConexion();
        
        $paisOrigen = valor_campo('paisOrigen');
        $regionOrigen = valor_campo('regionOrigen');
        $ciudadOrigen = valor_campo('ciudadOrigen');
        $paisDestino = valor_campo('paisDestino');
        $regionDestino = valor_campo('regionDestino');
        $ciudadDestino = valor_campo('ciudadDestino');
        $fechaDesde = valor_campo('fechaDesde');
        if ($fechaDesde == '') {
            $fechaDesde = date('d/m/Y');
        };
        $fechaHasta = valor_campo('fechaHasta');
        if ($fechaHasta == '') {
            $fechaHasta = date('d/m/Y');
        };
        $importe = valor_campo('importe');
        if ($importe == '') {
            $importe = 0;
        };
        $tipoImporte = valor_campo('tipoImporte');
        if ($tipoImporte == '') {
            $tipoImporte = 'P';
        };
        $cantidadLugares = valor_campo('cantidadLugares');
        if ($cantidadLugares == '') {
            $cantidadLugares = 1;
        };
        $recorridoSeleccionado = valor_campo('recorridoSeleccionado');
        
        /* Si seleccionaron el boton atras, reseteamos algunos campos...*/
        if (verificar_campo('botonAtras')) {
          if (verificar_campo('validarCampos')) {
            $ciudadOrigen = 0;
            $ciudadDestino = 0;            
          } elseif (verificar_campo('validarCiudades')) {            
            $regionOrigen = 0;
            $regionDestino = 0;            
          } elseif (verificar_campo('validarRegiones')) {                        
            $paisOrigen = 0;
            $paisDestino = 0;            
          };
        };
        
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
            /* Comienzo del formulario.*/
            echo '
        <form name="formingresarviaje" method="post" action="">            
        <table cellpadding="1" cellspacing="1" width="500" bordercolor="#999999" align="center" valign="top">
            <tr>
			    <td width="25%"> 
                    <div align="right"><span class="intro">Origen: </span></div>
                 </td>
			     <td width="75%">					  			     
			    ';               
            if ($paisOrigen >= 1) {
                echo descripcionPais($conexion, $paisOrigen).' - ';
                campoHidden('paisOrigen', $paisOrigen);
            
                campoHidden('validarRegiones', 'validarRegiones');            
                if ($regionOrigen >= 1) {
                    echo descripcionRegion($conexion, $regionOrigen).' - ';
                    campoHidden('regionOrigen', $regionOrigen);
                
                    campoHidden('validarCiudades', 'validarCiudades');                
                    if ($ciudadOrigen >= 1) {                                                              
                        echo descripcionCiudad($conexion, $ciudadOrigen);                                        
                        campoHidden('ciudadOrigen', $ciudadOrigen);
                    } else {
                        echo listaCiudades($conexion,'ciudadOrigen',$regionOrigen,$ciudadOrigen);                                        
                    };
                } else {
                    echo listaRegiones($conexion,'regionOrigen',$paisOrigen,'');                
                };            
            } else {
                echo listaPaises($conexion,'paisOrigen','');
            };
        
            echo '
                </td>
            </tr>
            <tr>
			    <td> 
                    <div align="right"><span class="intro">Destino: </span></div>
                 </td>
			     <td>					  			     
			    ';               
            if ($paisDestino >= 1) {
                echo descripcionPais($conexion, $paisDestino).' - ';
                campoHidden('paisDestino', $paisDestino);
            
                if ($regionDestino >= 1) {
                    echo descripcionRegion($conexion, $regionDestino).' - ';
                    campoHidden('regionDestino', $regionDestino);
                                                                         
                    if ($ciudadDestino >= 1) {                                                              
                        echo descripcionCiudad($conexion, $ciudadDestino);                                        
                        campoHidden('ciudadDestino', $ciudadDestino);
                    } else {
                        echo listaCiudades($conexion,'ciudadDestino',$regionDestino,$ciudadDestino);                    
                    };
                } else {
                    echo listaRegiones($conexion,'regionDestino',$paisDestino,'');                
                };            
            } else {
                echo listaPaises($conexion,'paisDestino','');
            };
        
            /* Si ya se elegio la ciudad origen y destino, mostramos el resto de los campos. */
            if (($paisOrigen >= 1) && ($paisDestino >= 1) &&
                ($regionOrigen >= 1) && ($regionDestino >= 1) &&
                ($ciudadOrigen >= 1) && ($ciudadDestino >= 1)) {
                campoHidden('validarCampos', 'validarCampos');
                
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
                    <div align="right"><span class="intro">Recorridos:</span></div>
                </td>			        
                <td>
			        ';               
			        
		    
		    
		    
		        /* Mostramos los recorridos que de las ciudades origen y destino.*/	    
    		    $ultimoRecorridoEncontrado = '';		    
		        try {                        
		        /*	
		       $conexionInformix = nuevaConexionInformix();
		       $consultaInformix = "EXECUTE PROCEDURE sp_calcular_recorrido (".$ciudadOrigen.",".$ciudadDestino.",".rand(1,1000).")";
		       echo 'Areco:<br>'.$consultaInformix;
		       $resultado = $conexionInformix->exec($consultaInformix);
		       	*/	       
		       
                    foreach ($conexion->query("		    
   		            select r.rdo_id,
                       oro.oro_ordentramo as orden,
                       c_origen.cad_nombre cad_origen,
                       c_destino.cad_nombre cad_destino
                    from recorrido r
                    inner join ordenrecorrido oro
                            on oro.oro_rdo_id = r.rdo_id
                    inner join tramo t
                            on t.tra_id = oro.oro_tra_id
                    inner join ciudad c_origen
                            on c_origen.cad_id = t.tra_cad_id1
                    inner join ciudad c_destino
                            on c_destino.cad_id = t.tra_cad_id2
                    where r.rdo_cad_id_origen = ".$ciudadOrigen."
                    and r.rdo_cad_id_destino = ".$ciudadDestino."
                    union
                    select r.rdo_id,
                           -oro.oro_ordentramo as orden,
                           c_origen.cad_nombre cad_origen,
                           c_destino.cad_nombre cad_destino
                    from recorrido r
                    inner join ordenrecorrido oro
                            on oro.oro_rdo_id = r.rdo_id
                    inner join tramo t
                            on t.tra_id = oro.oro_tra_id
                    inner join ciudad c_origen
                            on c_origen.cad_id = t.tra_cad_id1
                    inner join ciudad c_destino
                            on c_destino.cad_id = t.tra_cad_id2
                    where r.rdo_cad_id_origen = ".$ciudadDestino."
                    and r.rdo_cad_id_destino = ".$ciudadOrigen."
                    	order by rdo_id asc,
                           orden asc
                    
                        ") as $row) {
		        
		                if ( $ultimoRecorridoEncontrado != $row['RDO_ID']) {
		                    /* Cerramos el radiobutton anterior.*/
		                    if ($ultimoRecorridoEncontrado > 0) {
		                        echo '<BR>';
		                    };
		        
        		            /* Creamos otro radiobutton.*/
		                    $ultimoRecorridoEncontrado = $row['RDO_ID'];
		                    echo '<input type="radio" name="recorridoSeleccionado" value="'.$row['RDO_ID'].'">';
		                    echo $row['CAD_ORIGEN'];		            
		                };
		                echo ' - '.$row['CAD_DESTINO'];		            
		            };
		            if ($ultimoRecorridoEncontrado > 0) {
    		            echo '<BR>';
	    	        } else {
		              echo   '<h4>No se encontraron recorridos.</h4>';
		            };
		        } catch (PDOException $e) {  
                    echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
                };    			    
            }; /* if (($paisOrigen >= 1) && ($paisDestino >= 1) && ($regionOrigen >= 1) && ($regionDestino >= 1) && ($ciudadOrigen >= 1) && ($ciudadDestino >= 1)) { */
                   
            /* Botones Siguiente y Anterior */
            echo '
                </td>
            </tr>
            <tr>
                <td colspan="2"> 
                &nbsp;
                </td>
            </tr>
            <tr>    
			    <td colspan="2" align="center">
			    ';
	        if ($paisOrigen >= 1) {
		    	echo    '<input class="searchbutton" type="submit" name="botonAtras" value="Atrás">&nbsp;&nbsp;&nbsp;';
	        };		  
	  
	        if (($paisOrigen >= 1) && ($paisDestino >= 1) &&
                ($regionOrigen >= 1) && ($regionDestino >= 1) &&
                ($ciudadOrigen >= 1) && ($ciudadDestino >= 1)) {        
	            /* Solo podemos finalizar si encontramos al menos un recorrido valido. */
	            if ($ultimoRecorridoEncontrado > 0) {
	                echo          '<input class="searchbutton" type="submit" name="botonContinuar" value="Finalizar">';
	            };
	        } else {
	            echo          '<input class="searchbutton" type="submit" name="botonContinuar" value="Continuar">';
	        };	  		  
	        echo  '
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
