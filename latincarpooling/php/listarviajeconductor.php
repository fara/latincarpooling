<?php
include 'validar.php';
include 'header.php';
carpooling_header("Viajes de Conductor");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Viajes de Conductor</h1>
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
	<tr Class="tituloColumna">
		<td width="15%">Fecha Inicial</td>
		<td width="15%">Fecha Final</td>
		<td width="48%">Importe</td>
		<td width="11%">Lugares Libres</td>
		<td width="11%">Lugares Totales</td>
	</tr>
<?php
	try {
		$sql = "select
                		v.vje_id,
				v.vje_fechamenor,
				v.vje_fechamayor,
				vc.vcr_uio_id,
				vc.vcr_importe,
				vc.vcr_importeviaje,
				vc.vcr_cantlugares,
				vc.vcr_lugareslibres,
				u.uio_id
                	from viaje v, viajeconductor vc, usuario u
			where
				v.vje_id = vc.vcr_vje_id AND
				u.uio_id = vc.vcr_uio_id AND
				vc.vcr_uio_id = ". $idUsuario .";";
		foreach ($conexion->query($sql)	as $row) {
			$cantidadResultados++;        
			if ($row['vcr_importe'] > 0) {
				$descripcionImporte = '$ '.$row['vcr_importe'].' / pasajero';
			} else {
				$descripcionImporte = '$ '.$row['vcr_importeviaje'];
			};
			
			echo '<tr class="filaResultado">							        
					<td>'. $row['vje_fechamenor'].'</td>
					<td>'.$row['vje_fechamayor'].'</td>
					<td>'.$descripcionImporte.'</td>
					<td>'.$row['vcr_lugareslibres'].'</td>
					<td>'.$row['vcr_cantlugares'].'</td>
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
		echo '<center>Se encontraron '. $cantidadResultados .' viajes conductor.</center>';
	};
	cerrarConexion($conexion);
?>
    <div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>