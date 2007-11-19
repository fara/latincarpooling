<?php
include 'validar.php';
include 'header.php';
carpooling_header("Viajes de Conductor");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Listar Viajes de Conductor</h1>
<?php
	$camposOk = 0;									                    
	/* Si se enviaron parametros.*/
	if (hay_campos_enviados()) {
		if (!verificar_campo('usuario') ) {
			error("Por favor, complete el id del usuario");
		} else {
			$camposOk = 1;	
		};
	};
	$conexion = nuevaConexion();
    $idUsuario = valor_campo('usuario');
	$cantidadResultados = 0;
?>
<table cellpadding="1" cellspacing="1" width="100%">
	<tr Class="tituloColumna">
		<td width="15%">Fecha Inicial</td>
		<td width="15%">Fecha Final</td>
		<td width="10%">Importe</td>
		<td width="11%">Lugares Libres</td>
		<td width="25%">Conductor</td>
		<td width="12%">Sexo</td>
		<td width="12%">¿Es Fumador?</td>
	</tr>
<?php
	try {                        
		foreach (
			$conexion->query("
                select v.vje_id, v.vje_fechamenor,
                    v.vje_fechamayor, vc.vcr_uio_id, vc.vcr_importe, vc.vcr_importeviaje,
                    vc.vcr_lugareslibres, u.uio_id, u.uio_nombreusuario, u.uio_sexo,
                    u.uio_esfumador
                from viaje v, viajeconductor vc, usuario u
				where v.vje_id = vc.vcr_vje_id AND u.uio_id = vc.vcr_uio_id AND vc.vcr_uio_id = ". $usuario .";")
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
			
			echo '<tr class="filaResultado">							        
					<td>'. $row['vje_fechamenor'].'</td>
					<td>'.$row['vje_fechamayor'].'</td>
					<td>'.$descripcionImporte.'</td>					
					<td>'.$row['vcr_lugareslibres'].'</td>					
					<td>'.$row['uio_nombreusuario'].'</td>							
					<td>'.$descripcionSexo.'</td>		
					<td>'.$descripcionEsFumador.'</td>	
		        </tr>';
		};                            
	} catch (PDOException $e) {  
		echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
	};
?>
</table>
<?php
	if ($cantidadResultados == 0) {
		echo '<h3><center>No se encontraron viajes de conductor para el usuario.</center></h3>';
	} else {
		echo '<h3><center>Se encontraron '. $cantidadResultados .' viajes conductor.</center></h3>';
	};
	cerrarConexion($conexion);
?>
    <div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>