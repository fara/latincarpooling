<?php
include 'validar.php';
/*validar_sesion(); Areco */
include 'header.php';
carpooling_header("Busqueda de Viajes");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Búsqueda de Viajes</h1>
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
                    } elseif (verificar_campo('validarCampos') && verificar_campo('fechaHasta') && !es_numero_entero($_REQUEST['cantidadLugares']) ) {
                        error("La cantidad de lugares tiene que ser un numero entero.");																			                        
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
        $cantidadLugares = valor_campo('cantidadLugares');
        if ($cantidadLugares == '') {
            $cantidadLugares = 1;
        };
        
        /* Si seleccionaron el boton atras, reseteamos algunos campos...*/
        if (verificar_campo('botonAtras')) {
          if (verificar_campo('validarCampos') || verificar_campo('validarCiudades')) {
            $regionOrigen = 0;
            $regionDestino = 0;            
          } elseif (verificar_campo('validarRegiones')) {                        
            $paisOrigen = 0;
            $paisDestino = 0;
            $regionOrigen = 0;
            $regionDestino = 0;          
          };
        };
        
        /* Comienzo del formulario.*/
        echo '<form name="formbuscarviaje" method="post" action="">
        <table cellpadding="1" cellspacing="1" width="500" bordercolor="#999999" align="center" valign="top">
            <tr>
			    <td width="15%"> 
                    <div align="right"><span class="intro">Origen: </span></div>
                 </td>
			     <td width="85%">					  			     
			    ';               
        if ($paisOrigen >= 1) {
            echo descripcionPais($conexion, $paisOrigen).' - ';
            campoHidden('paisOrigen', $paisOrigen);
            
            if ($regionOrigen >= 1) {
                echo descripcionRegion($conexion, $regionOrigen).' - ';
                campoHidden('regionOrigen', $regionOrigen);
                                                                              
                echo listaCiudades($conexion,'ciudadOrigen',$regionOrigen,$ciudadOrigen);
                campoHidden('validarRegiones', 'validarRegiones');
                campoHidden('validarCiudades', 'validarCiudades');                
            } else {
                echo listaRegiones($conexion,'regionOrigen',$paisOrigen,'');
                campoHidden('validarRegiones', 'validarRegiones');
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
                                                         
                echo listaCiudades($conexion,'ciudadDestino',$regionDestino,$ciudadDestino);                                                        
            } else {
                echo listaRegiones($conexion,'regionDestino',$paisDestino,'');                
            };            
        } else {
            echo listaPaises($conexion,'paisDestino','');
        };
        
        /* Si ya se elegio el pais y la region, mostramos el resto de los campos. */
        if (($regionOrigen >= 1) && ($regionDestino >= 1)) {
            campoHidden('validarCampos', 'validarCampos');
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
                    <div align="right"><span class="intro">Cantidad de Lugares: </span></div>
                 </td>
			     <td>					  			     
			        <input class="searchbox" name="cantidadLugares" type="text" id="cantidadLugares" value="'.$cantidadLugares.'" maxlength="3" />			        
			    ';               
       };
       
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
	  
	  echo          '<input class="searchbutton" type="submit" name="botonContinuar" value="Continuar">';
	  		  
	  echo  '
                </td>
            </tr>
            </table>
            </form>';
            
      /*Si tenemos todos los datos que necesitamos, realizamos la busqueda de viajes.*/
      if ($camposOk != 0) {
        echo '<h1>Viajes encontrados</h1>
            <table cellpadding="1" cellspacing="1" width="100%">
                <tr Class="tituloColumna">							        
					<td width="15%">
	                    Fecha Inicial
					</td>
					<td width="15%">
			            Fecha Final
				    </td>
					<td width="10%">
						Importe
					</td>					
					<td width="11%">
						Lugares Libres
					</td>					
					<td width="31%">
						Conductor
					</td>							
					<td width="12%">
						Sexo
					</td>		
					<td width="12%">
						¿Es Fumador?
					</td>	
		        </tr>
		    ';        
		if (!($cantidadLibres >= 1)) {
		    $cantidadLibres = 1;
	    };
	    $cantidadResultados = 0;
	    	                
        try {                        
            foreach ($conexion->query("
                select v.vje_id,
                    v.vje_fechamenor,
                    v.vje_fechamayor,
                    vc.vcr_uio_id,
                    vc.vcr_importe,
                    vc.vcr_importeviaje,
                    vc.vcr_lugareslibres,
                    u.uio_id,
                    u.uio_nombreusuario,
                    u.uio_sexo,
                    u.uio_esfumador
                from viaje v
                inner join recorrido r
                    on v.vje_rdo_id = r.rdo_id
                    and ((r.rdo_cad_id_origen = ".$ciudadOrigen." and r.rdo_cad_id_destino = ".$ciudadDestino.")
                        or (r.rdo_cad_id_origen = ".$ciudadDestino." and r.rdo_cad_id_destino = ".$ciudadOrigen."))
                inner join viajeconductor vc
                    on v.vje_id = vc.vcr_vje_id
                    and vc.vcr_lugareslibres >= ".$cantidadLibres."
                inner join usuario u
                    on vc.vcr_uio_id = u.uio_id
                where v.vje_tipoviaje = 'C'
                and not (v.vje_fechamenor > '".obtener_string_fecha_bd($fechaHasta)."')
                and not (v.vje_fechamayor < '".obtener_string_fecha_bd($fechaDesde)."')      
                    ")
               as $row) {
        
              $cantidadResultados++;        
              if ($row['vcr_importe'] > 0) {
                $descripcionImporte = '$ '.$row['vcr_importe'].'/pasajero';
              } else {
                $descripcionImporte = '$ '.$row['vcr_importeviaje'];
              };
              if ($row['uio_sexo'] == 'M') {
                $descripcionSexo = 'Hombre';
              } else {
                $descripcionSexo = 'Mujer';
              };
              if ($row['uio_esfumador'] == '1') {
                $descripcionEsFumador = 'Sí';
              } else {
                $descripcionEsFumador = 'No';
              };
              
              echo '
                <tr class="filaResultado">							        
					<td>
	                    '.$row['vje_fechamenor'].'
					</td>
					<td>
			            '.$row['vje_fechamayor'].'
				    </td>
					<td>
						'.$descripcionImporte.'
					</td>					
					<td>
						'.$row['vcr_lugareslibres'].'
					</td>					
					<td>
						'.$row['uio_nombreusuario'].'
					</td>							
					<td>
						'.$descripcionSexo.'
					</td>		
					<td>
						'.$descripcionEsFumador.'
					</td>	
		        </tr>
		            ';
                  
           };                            
        } catch (PDOException $e) {  
            echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
        };
        echo '</table>             
             ';
        if ($cantidadResultados == 0) {
            echo '
              <h3><center>No se encontraron viajes con esas características.<BR>Por favor, cargue un pedido de viaje.</center></h3>              
              ';
        };
      };                               
      cerrarConexion($conexion);

?>
    <div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>
