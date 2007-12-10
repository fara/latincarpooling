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
        $paisOrigen = valor_campo('paisOrigen');
        $regionOrigen = valor_campo('regionOrigen');
        $ciudadOrigen = valor_campo('ciudadOrigen');
        $paisDestino = valor_campo('paisDestino');
        $regionDestino = valor_campo('regionDestino');
        $ciudadDestino = valor_campo('ciudadDestino');
        $fechaDesde = valor_campo('fechaDesde');
        $fechaHasta = valor_campo('fechaHasta');
        $cantidadLugares = valor_campo('cantidadLugares');
        
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
                        error("Por favor, complete la fecha inicial en la cual desea viajar");																			
                    } elseif (!es_string_fecha_valida(valor_campo('fechaDesde')) ) {
                        error("La fecha inicial ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                                                
                    } elseif (!verificar_campo('fechaHasta') ) {
                        error("Por favor, complete la maxima fecha en la cual desea viajar");																			
                    } elseif (!es_string_fecha_valida(valor_campo('fechaHasta')) ) {
                        error("La fecha final ingresada es incorrecta. Por favor, utilice el formato dd/mm/aaaa.");																			                                    																		                    
                    } elseif (verificar_campo('cantidadLugares') && !es_numero_entero($_REQUEST['cantidadLugares']) ) {
                        error("La cantidad de lugares tiene que ser un numero entero.");																			                        
                    } else {                        
                        $camposOk = 1;	                        
                    };
        };
        
        $usuario = $_SESSION['idusuario'];
        $conexion = nuevaConexion();
                
        if ($fechaDesde == '') {
            $fechaDesde = date('d/m/Y');
        };        
        if ($fechaHasta == '') {
            $fechaHasta = date('d/m/Y');
        };        
        if ($cantidadLugares == '') {
            $cantidadLugares = 1;
        };
                        
        /* Comienzo del formulario.*/
        echo '<form name="formbuscarviaje" method="post" action="">';
        campoHidden('idUsuarioActual', $usuario);		        
        echo '
        <table cellpadding="1" cellspacing="1" width="500" bordercolor="#999999" align="center" valign="top">
            <tr>
			    <td width="15%"> 
                    <div align="right"><span class="intro">Origen: </span></div>
                 </td>
			     <td width="85%">					  			     	     
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
                </td>
            </tr>
            <tr>
                <td colspan="2"> 
                &nbsp;
                </td>
            </tr>
            <tr>    
			    <td colspan="2" align="center">
	                <input class="searchbutton" type="submit" name="botonContinuar" value="Buscar">	  		  	  
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
              if ($row['VCR_IMPORTE'] > 0) {
                $descripcionImporte = '$ '.$row['VCR_IMPORTE'].'/pasajero';
              } else {
                $descripcionImporte = '$ '.$row['VCR_IMPORTEVIAJE'];
              };
              if ($row['UIO_SEXO'] == 'M') {
                $descripcionSexo = 'Hombre';
              } else {
                $descripcionSexo = 'Mujer';
              };
              if ($row['UIO_ESFUMADOR'] == '1') {
                $descripcionEsFumador = 'Sí';
              } else {
                $descripcionEsFumador = 'No';
              };
              
              echo '
                <tr class="filaResultado">							        
					<td>
	                    '.$row['VJE_FECHAMENOR'].'
					</td>
					<td>
			            '.$row['VJE_FECHAMAYOR'].'
				    </td>
					<td>
						'.$descripcionImporte.'
					</td>					
					<td>
						'.$row['VCR_LUGARESLIBRES'].'
					</td>					
					<td>
						'.$row['UIO_NOMBREUSUARIO'].'
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
