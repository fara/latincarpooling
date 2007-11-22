<?php
include 'validar.php';
include 'header.php';
carpooling_header("Mensajes");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<div id="content">
<h1>Mensajes <?php echo valor_campo('tipo'); ?></h1>
<?php
	$camposOk = 0;									                    
	/* Si se enviaron parametros.*/
	if (!hay_campos_enviados() || !verificar_campo('tipo')) {
		error("Por favor, complete el tipo de mensaje");
	};
	$conexion = nuevaConexion();
	$enviados = false;
	if(valor_campo('tipo') == "enviados") {
		$enviados = true;
	}
	$idUsuario = $_SESSION["idusuario"];
	$cantidadResultados = 0;
?>
<table cellpadding="1" cellspacing="1" width="100%">
	<tr class="tituloColumna">
		<td width="15%">Fecha</td>
		<td width="15%">Asunto</td>
		<td width="70%">Texto</td>
	</tr>
<?php
	try {
		$sql = "select
					mje_fecha,
					mje_asunto,
					mje_texto
				from mensaje
				where ";
		if($enviados) {
			$sql .= "mje_uio_id_rem = " . $idUsuario;
		} else {
			$sql .= "mje_uio_id_dest = " . $idUsuario;
		}
		$sql .= " order by mje_fecha desc;";
		foreach ($conexion->query($sql) as $row) {
			$cantidadResultados++;        
			echo '<tr class="filaResultado">							        
					<td>'. $row['mje_fecha'].'</td>
					<td>'.$row['mje_asunto'].'</td>
					<td>'.$row['mje_texto'].'</td>
		        </tr>';
		};
?>
</table>
<?php
	} catch (PDOException $e) {  
		echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
	};
	if ($cantidadResultados == 0) {
		echo '<h3><center>No se encontraron mensajes para el usuario.</center></h3>';
	} else {
		echo '<center>Se encontraron '. $cantidadResultados .' mensajes.</center>';
	};
	cerrarConexion($conexion);
?>
	<div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>