<?php
	include 'func_lib.php';
	/* AR 2007-09-04 Cerramos la sesion. */
	if ( isset($_GET['accion']) && ($_GET['accion'] == 'salir')) {
    	session_start();
    	session_destroy();
	};

	if ( isset($_POST['usuario']) && isset($_POST['password']) ){
		$conexion = nuevaConexion();
//		$query = "select uio_id, uio_nombreusuario from usuario where uio_nombreusuario = '". valor_campo('usuario') . 
//				"' AND uio_contrasena = '" . valor_campo('password') . "';";
//	    $query = "SELECT  VERIFICAR_UIO2('".valor_campo('usuario')."','".valor_campo('password')."'), count(*)  FROM USUARIO";				    
	    $query = "SELECT  VERIFICAR_UIO('".valor_campo('usuario')."','".valor_campo('password')."') FROM ifxsystables where tabid = 1";				            
                
		$row = fetchOne($conexion, $query);
			
		if ($row != '' && $row[1] > 0){		
	    	session_start();
			$_SESSION["autentificado"] = "SI";
			$_SESSION["idusuario"] = $row[1];
			/* AR 2007-09-04 Guardamos el nombre del usuario.*/
			$_SESSION["nombreusuario"] = $_POST['usuario'];
		    header ("Location: listarviajeconductor.php"); 
		}else{
			$Err = "No existe el usuario";
		}
	}

	include 'header.php';
	carpooling_header("Login");
	include 'menu.php';
	menu();
?>
<div id="content">
<h1>Login</h1>
<table cellpadding="0" cellspacing="0"  width="100%">
	<tr>
		<td align="center" valign="middle">
<?php 
	if ($Err == "No existe el usuario"){
		echo 'Usuario y/o Password incorrecto';
	}
?>
			<form id="form1" name="form1" method="post" action="">
				<table align="center">
					<tr>
	    				<td><label><span class="intro"><div align="right">Usuario:</div></span>
						</td>
				    	<td><input name="usuario" type="text" class="intro" id="usuario" maxlength="50" />
				    	</td>											
	    			</tr>
			    	<tr>
				    	<td><label><span class="intro"><div align="right">Password:</div></span></td>
				    	<td><input name="password" type="password" class="intro" id="password" maxlength="50" />
						</td>						     
					</tr>
				</table>	
				<input class="searchbox" name="Aceptar" type="submit" id="Aceptar" value="Aceptar" />	  
			</form>        
		</td>
	</tr>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
    <div class="clearingdiv">&nbsp;</div>
</div>
<?php
	cerrarConexion($conexion);
	include 'footer.php';
	footer();
?>