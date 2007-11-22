<?php
include 'validar.php';
include 'header.php';
carpooling_header("Viajes de Pasajero Pendientes");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Viajes de Pasajero Pendientes</h1>
<?php
	$camposOk = 0;									                    
	/* Si se enviaron parametros.*/
	/*if (hay_campos_enviados()) {
		if (!verificar_campo('usuario') ) {
			error("Por favor, complete el id del usuario");
		} else {
			$camposOk = 1;	
		};
	};*/
	$conexion = nuevaConexion();
	$idUsuario = $_SESSION["idusuario"];
	$cantidadResultados = 0;
?>
<table cellpadding="1" cellspacing="1" width="100%">
	<tr class="tituloColumna">
		<td width="15%">Fecha Inicial</td>
		<td width="15%">Fecha Final</td>
		<td width="15%">Importe Máximo</td>
		<td width="31%">Pasajero</td>
		<td width="12%">Sexo</td>
		<td width="12%">¿Es Fumador?</td>
	</tr>
<?php
	try {
		$sql = "select
				v.vje_id,
				v.vje_fechamenor,
				v.vje_fechamayor,
				vp.vpp_uio_id,
				vp.vpp_importemaximo,
				u.uio_id,
				u.uio_nombreusuario,
				u.uio_sexo,
				u.uio_esfumador
                	from viaje v, viajepasajeropend vp, usuario u
			where 
				v.vje_id = vp.vpp_vje_id AND
				u.uio_id = vp.vpp_uio_id AND
				vp.vpp_uio_id = ". $idUsuario .";";
		foreach ($conexion->query($sql) as $row) {
			$cantidadResultados++;        
			$descripcionImporte = '$ '.$row['vpp_importemaximo'];
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
			
			echo '<tr class="filaResultado">							        
					<td>'. $row['vje_fechamenor'].'</td>
					<td>'.$row['vje_fechamayor'].'</td>
					<td>'.$descripcionImporte.'</td>					
					<td>'.$row['uio_nombreusuario'].'</td>							
					<td>'.$descripcionSexo.'</td>		
					<td>'.$descripcionEsFumador.'</td>	
		        </tr>';
		};
?>
</table>
<?php
	} catch (PDOException $e) {  
		echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
	};
	if ($cantidadResultados == 0) {
		echo '<h3><center>No se encontraron viajes de pasajero para el usuario.</center></h3>';
	} else {
		echo '<center>Se encontraron '. $cantidadResultados .' viajes de pasajero.</center>';
	};
	cerrarConexion($conexion);
?>
	<div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>