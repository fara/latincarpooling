<?Php

/* set_time_limit(6000); AR Para que no genere un timeout al conextarse en el laboratorio. */

/* AR 2007-11-24 Abre una conexion con el servidor DB2 */
Function nuevaConexion(){	
        
    try {	             
        //Conexion DB2 arobirosa.no-ip.org
        $dbh = new PDO("ibm:DRIVER={IBM DB2 ODBC DRIVER};DATABASE=produ;HOSTNAME=127.0.0.1;PORT=50000;PROTOCOL=TCPIP;", "db2admin", "robinson24");
            
        //Conexion DB2 Laboratorio.
        //$dbh = new PDO("ibm:DRIVER={IBM DB2 ODBC DRIVER};DATABASE=SABD;HOSTNAME=127.0.0.1;PORT=50001;PROTOCOL=TCPIP;", "db2admin", "sabd03");
    
        /* Cambiamos el manejo de errores. */
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
   
    } catch (PDOException $e) {  
        print "Error!: " . $e->getMessage() . "<br/>";
        die();
    }
    
	return $dbh;
}

/* AR 2007-11-24 Abre una conexion con el servidor DB2 */
Function nuevaConexionInformix(){	
    
    try {	             
        //Conexion Informix arobirosa.no-ip.org        
        $dbh = new PDO("informix:host=guaderio; service=1526; database=produccion; server=ol_guaderio; protocol=onsoctcp ", "carpooling", "metallica23");        
       
        //Conexion Informix Laboratorio.
        //$dbh =  new PDO("informix:host=192.168.2.2;service=1525;database=grupo03;server=on_centauro;protocol=onsoctcp;", "sa505103", "sabd03");
   
        /* Cambiamos el manejo de errores. */
        $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
   
    } catch (PDOException $e) {  
        print "Error!: " . $e->getMessage() . "<br/>";
        die();
    }
    
	return $dbh;
}


function cerrarConexion($dbh) {
    $dbh = null;
    return 0;
};

function verificar_campo($campo){
	if (isset($_REQUEST[$campo])){
		if (strlen(trim($_REQUEST[$campo])) > 0){
			return 1;
		}
	}
	return 0;
}

function hay_campos_enviados() {
	if (count($_POST) > 0 || count($_GET) > 0 ) {		
		return 1;		
	}
	return 0;
}


function error($msg){
	echo '
	    <table align="center">
		<tr>
			<td><div align="right">			
				<img src="/img/Warning.png" width="50" height="50" border="0">
			</div></td>
			<td>			
				<span class="style5">ERROR: '.$msg.' <br></span>
			</td>
		</tr>
		</table>
	';
}

function no_error($msg){
	echo '
	    <table align="center">
		<tr>
			<td><div align="right">			
				<img src="/img/Good.png" width="50" height="50" border="0">
			</div></td>
			<td>			
				<span class="style1">'.$msg.' <br></span>
			</td>
		</tr>
		</table>
	';
}

function valor_campo($campo){
	if(count($_REQUEST) == 0) {
		return "";
	}else {
		return $_REQUEST[$campo];
	};
};

/* Verifica numeros sin espacios */
function verificar_numero($string){
	$var = $_REQUEST[$string];
	return !ereg('[^0-9]', trim($var));
}

/* Verifica caracteres */
function verificar_caracter($string){
	$var = $_REQUEST[$string];
	return !ereg('[^a-zA-Z ]', trim($var));
}

/* Verifica caracteres y numeros */
function verificar_caracter_numeros($string){
	$var = $_REQUEST[$string];
	return !ereg('[^a-zA-Z0-9 ]', trim($var));
}

/* Verifica caracteres y numeros sin espacio */
function verificar_caracter_numeros_se($string){
	$var = $_REQUEST[$string];
	return !ereg('[^a-zA-Z0-9]', trim($var));
}

/* Verifica formato de mail */
function verificar_email($string){
	$var = $_REQUEST[$string];
	if (ereg('[^a-zA-Z0-9@.\-_]', $var) == true){
		return false;
	}else{
		list($usuario, $dominio) = explode("@", $var, 2);
		if (ereg('@', trim($usuario))){
			return false;
		}
		if (ereg('@', trim($dominio))){
			return false;
		}
		/*list($part1, $part2) = explode(".", $dominio, 2);
		if(strlen($part1) == 0 || strlen($part2) ==0 ){
			echo ".".$part1.".".$part2.".";
			return false;
		}*/
		return true;
	}
}

/* Verifica numeros de ip o limites que tengan punto */
function verificar_ip($string){
	$var = $_REQUEST[$string];
	return !ereg('[^0-9.]', trim($var));
}

function es_bisiesto($año){ 
  if ($año%4!=0) 
    $bisiesto=false; 
  else 
    if ($año%400==0) 
      $bisiesto=true; 
    else 
      if ($año%100==0) 
        $bisiesto=false; 
      else 
        $bisiesto=true; 
  return $bisiesto; 
}

function es_fecha_valida($dia, $mes, $año){ 
  if ($dia<0 || $dia>31 || $mes<0 || $mes >12) 
    $valida=false; 
  else 
    if (($mes==4 || $mes==6 || $mes==9 || $mes==11) && $dia > 30) 
      $valida=false; 
    else 
      if ($mes==2 && $dia>28+es_bisiesto($año)) 
        $valida=false; 
       else 
        $valida=true; 
  return $valida; 
} 

/*AR 2007-10-27 Devuelve un booleano indicando si el string recibido como parametro es una
  fecha valida con formato dd/mm/aaaa. */
function es_string_fecha_valida($fecha){	
    $bol = false;
	if (strlen($fecha) == 10){
		list($dia, $mes, $año) = explode("/", $fecha, 3);
		if (strlen($dia) == 2 && strlen($mes) == 2 && strlen($año) == 4){
			$bol = es_fecha_valida($dia, $mes, $año);
		};
	};
	return $bol;
}


/*AR 2007-10-27 Devuelve una fecha con el formato que necesita la base.
    Toma como entrada una fecha valida con formato dd/mm/aaaa.
  En caso de error, devuelve un string vacio.*/  
function obtener_string_fecha_bd($fecha){
	if (!es_string_fecha_valida($fecha)) {
	        return '';
	};
	list($dia, $mes, $año) = explode("/", $fecha, 3);
	//return $mes.'-'.$dia.'-'.$año; //Informix
	return $año.'-'.$mes.'-'.$dia;
}


/* Verifica numeros sin espacios */
function es_numero_entero($string){	
	return !ereg('[^0-9]', trim($string));
}

function es_numero_decimal($string){	
	return !ereg('[^0-9.]', trim($string));
}


function es_string_hora_valida($horaString){	    
	if (strlen($horaString) == 5) {
		list($horas, $minutos) = explode(':', $horaString, 2);	
		if (es_numero_entero($horas) && es_numero_entero($minutos)) {
		    if (strlen($horas) == 2 && strlen($minutos) == 2) {
			    if ($horas >= 0 && $horas <= 23 && $minutos >= 0 && $minutos <= 59) {			
    			    return true;
	    		};
		    };
		};
	};
	return false;
};



function print_select_mes ($name, $mesSeleccionado, $estilo) {
    if ($estilo != '') {
        echo '<span class="'.$estilo.'">';
    };
    echo '<select name="'.$name.'" id="'.$name.'">';
					
	echo                            '<option value="01"';
	if ($mesSeleccionado == '01') { echo ' selected="selected"'; } ;
	echo                                    '>Enero</option>';					
			
	echo                            '<option value="02"';										
	if ($mesSeleccionado == '02') { echo ' selected="selected"'; } ;
	echo                                    '>Febrero</option>';
			
	echo                            '<option value="03"';					
	if ($mesSeleccionado == '03') { echo ' selected="selected"'; } ;
	echo                                    '>Marzo</option>';
							
	echo                            '<option value="04"';
	if ($mesSeleccionado == '04') { echo ' selected="selected"'; } ;
	echo                                    '>Abril</option>';
			
	echo                            '<option value="05"';
	if ($mesSeleccionado == '05') { echo ' selected="selected"'; } ;
	echo                                    '>Mayo</option>';
			
	echo                            '<option value="06"';
	if ($mesSeleccionado == '06') { echo ' selected="selected"'; } ;
	echo                                    '>Junio</option>';
			
	echo                            '<option value="07"';
	if ($mesSeleccionado == '07') { echo ' selected="selected"'; } ;
	echo                                    '>Julio</option>';
			
	echo                            '<option value="08"';
	if ($mesSeleccionado == '08') { echo ' selected="selected"'; } ;
	echo                                    '>Agosto</option>';
			
	echo                            '<option value="09"';
	if ($mesSeleccionado == '09') { echo ' selected="selected"'; } ;
	echo                                    '>Septiembre</option>';
			
	echo                            '<option value="10"';
	if ($mesSeleccionado == '10') { echo ' selected="selected"'; } ;
	echo                                    '>Octubre</option>';
			
	echo                            '<option value="11"';
	if ($mesSeleccionado == '11') { echo ' selected="selected"'; } ;
	echo                                    '>Noviembre</option>';
			
    echo                            '<option value="12"';				    
    if ($mesSeleccionado == '12') { echo ' selected="selected"'; } ;
    echo                                    '>Diciembre</option>';
    echo '</select>';
    if ($estilo != '') {
        echo '</span>';
    };
};

function descripcionPais($conexion, $pais) {
    try {
                   $resultado = $conexion->query('SELECT pis_nombre from pais where pis_id = '.$pais);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {
                        return $fila['PIS_NOMBRE'];
                   };                   
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };
    return '(Sin Pais)';               
};

function listaPaises($conexion, $nombreCampo, $paisSeleccionado) {
    try {
        echo '<select name="'.$nombreCampo.'" class="searchbox" id="'.$nombreCampo.'">';
        foreach ($conexion->query('SELECT pis_id, pis_nombre from pais order by pis_nombre') as $row) {
            if ($paisSeleccionado == $row['PIS_ID']) {
                echo '<option value="'.$row['PIS_ID'].'" selected="selected">'.$row['PIS_NOMBRE'].'</option>';
            } else {
                echo '<option value="'.$row['PIS_ID'].'">'.$row['PIS_NOMBRE'].'</option>';
            };
        };
        echo '</select>';
   } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                        
    };
};

function descripcionRegion($conexion, $region) {
    try {
                   $resultado = $conexion->query('SELECT ron_nombre from region where ron_id = '.$region);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {
                        return $fila['RON_NOMBRE'];
                   };                   
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };
    return '(Sin Region)';                                  
};

function listaRegiones($conexion, $nombreCampo, $pais, $regionSeleccionada) {
    try {
        echo '<select name="'.$nombreCampo.'" class="searchbox" id="'.$nombreCampo.'">';
        foreach ($conexion->query('SELECT ron_id, ron_nombre from region where ron_pis_id = '.$pais.' order by ron_nombre') as $row) {
            if ($regionSeleccionada == $row['RON_ID']) {
                echo '<option value="'.$row['RON_ID'].'" selected="selected">'.$row['RON_NOMBRE'].'</option>';
            } else {
                echo '<option value="'.$row['RON_ID'].'">'.$row['RON_NOMBRE'].'</option>';
            };
        };
        echo '</select>';
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
    };
};

function descripcionCiudad($conexion, $ciudad) {
    try {
                   $resultado = $conexion->query('SELECT cad_nombre from ciudad where cad_id = '.$ciudad);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {
                        return $fila['CAD_NOMBRE'];
                   };
                   return '(Sin Ciudad)';
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };
    return '(Sin Ciudad)';                                  
};

function listaCiudades($conexion, $nombreCampo, $region, $ciudadSeleccionada) {
    try {
        echo '<select name="'.$nombreCampo.'" class="searchbox" id="'.$nombreCampo.'">';
        foreach ($conexion->query('SELECT cad_id, cad_nombre from ciudad where cad_ron_id = '.$region.' order by cad_nombre') as $row) {
            if ($ciudadSeleccionada == $row['CAD_ID']) {
                echo '<option value="'.$row['CAD_ID'].'" selected="selected">'.$row['CAD_NOMBRE'].'</option>';
            } else {
                echo '<option value="'.$row['CAD_ID'].'">'.$row['CAD_NOMBRE'].'</option>';
            };
        };
        echo '</select>';
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
    };
};

function campoHidden($nombreCampo, $valorCampo) {
    echo '<input type="hidden" id="'.$nombreCampo.'" name="'.$nombreCampo.'" value="'.$valorCampo.'" />';   
};

function fetchOne($conexion, $query) {
	try {
    	$resultado = $conexion->query($query);
		$fila = $resultado->fetch(PDO::FETCH_ASSOC);
  		return $fila;
	} catch (PDOException $e) {  
        echo '<H3>Error al obtener una fila: '.$e->getMessage().'</h3>';                
    };
    return '';
};


function listaVehiculos($conexion, $nombreCampo, $usuario, $vehiculoSeleccionado) {
    try {
        echo '<select name="'.$nombreCampo.'" class="searchbox" id="'.$nombreCampo.'">';
        foreach ($conexion->query('SELECT vlo_modelo, vlo_patente, vlo_id from vehiculo where vlo_uio_id = '.$usuario.' order by vlo_modelo') as $row) {
            if ($vehiculoSeleccionado == $row['VLO_ID']) {
                echo '<option value="'.$row['VLO_ID'].'" selected="selected">'.$row['VLO_MODELO'].' ('.$row['VLO_PATENTE'].') </option>';
            } else {
                echo '<option value="'.$row['VLO_ID'].'">'.$row['VLO_MODELO'].' ('.$row['VLO_PATENTE'].') </option>';
            };
        };
        echo '</select>';
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
    };
};

function descripcionVehiculo($conexion, $usuario, $vehiculo) {        
    try {
                   $resultado = $conexion->query('SELECT vlo_modelo, vlo_patente from vehiculo
                            where vlo_uio_id = '.$usuario.'
                            and vlo_id = '.$vehiculo);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {                                        
                        return ($fila['VLO_MODELO'].' ('.$fila['VLO_PATENTE'].')');
                   };
                   return '(Sin Vehiculo)';                   
    } catch (PDOException $e) {          
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };    
};

function costoKmCombustible($conexion, $usuario, $vehiculo, $fecha, $pais) {        
    try {
                   $resultado = $conexion->query("
                            SELECT vlo_consumo, pce_preciolitro
                            from vehiculo
                            inner join preciocombustible
                                on vlo_cle_id = pce_cle_id
                                and pce_pis_id = ".$pais." 
                                and pce_vigentedesde <= '".obtener_string_fecha_bd($fecha)."'
                                and (pce_vigentehasta >= '".obtener_string_fecha_bd($fecha)."' or pce_vigentehasta is null)
                            where vlo_uio_id = ".$usuario."
                            and vlo_id = ".$vehiculo);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {                       
                        return ($fila['VLO_CONSUMO'] * $fila['PCE_PRECIOLITRO'] / 100);
                   };
                   return 0;
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };    
};

function costoKmCombustible($conexion, $fecha, $pais) {        
    /*
    try {
                   $resultado = $conexion->query("
                            SELECT vlo_consumo, pce_preciolitro
                            from vehiculo
                            inner join preciocombustible
                                on vlo_cle_id = pce_cle_id
                                and pce_pis_id = ".$pais." 
                                and pce_vigentedesde <= '".obtener_string_fecha_bd($fecha)."'
                                and (pce_vigentehasta >= '".obtener_string_fecha_bd($fecha)."' or pce_vigentehasta is null)
                            where vlo_uio_id = ".$usuario."
                            and vlo_id = ".$vehiculo);
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {                       
                        return ($fila['VLO_CONSUMO'] * $fila['PCE_PRECIOLITRO'] / 100);
                   };
                   return 0;
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };*/
    return 0.5;    
};

function recorridoMasBarato($conexion, $ciudadOrigen, $ciudadDestino, $fecha, $costoKmCombustible) {        
    try {
                   $resultado = $conexion->query("
                            select r.rdo_id
                            from recorrido r
                            inner join ordenrecorrido oro
                                     on oro.oro_rdo_id = r.rdo_id
                            inner join tramo t
                                     on t.tra_id = oro.oro_tra_id
                            left join costofijotramo c
                                     on t.tra_id = c.cft_tra_id
                                     and c.cft_vigentedesde <= '".obtener_string_fecha_bd($fecha)."'
                                     and (c.cft_vigentehasta is null or c.cft_vigentehasta >= '".obtener_string_fecha_bd($fecha)."')
                            inner join ciudad c_origen
                                     on c_origen.cad_id = t.tra_cad_id1
                            inner join ciudad c_destino
                                     on c_destino.cad_id = t.tra_cad_id2
                            where r.rdo_cad_id_origen = ".$ciudadOrigen."
                            and r.rdo_cad_id_destino = ".$ciudadDestino."
                                group by rdo_id
                            order by (sum(t.tra_distancia) * ".$costoKmCombustible." + sum(c.cft_costofijo)) ASC
                            Fetch first 1 rows only
                            ");
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {
                        return $fila['RDO_ID'];
                   };
                   return 0;
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };    
};

function recorridoMasCorto($conexion, $ciudadOrigen, $ciudadDestino) {        
    try {
                   $resultado = $conexion->query("
                            select r.rdo_id
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
                                group by rdo_id
                            order by sum(t.tra_distancia) ASC
                            Fetch first 1 rows only
                            ");
                   $fila = $resultado->fetch(PDO::FETCH_ASSOC);
                   if ($fila != '') {
                        return $fila['RDO_ID'];
                   };
                   return 0;
    } catch (PDOException $e) {  
        echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';        
    };    
};


//AR 2007-11-23 Si el vehiculo es cero, se considera que fue llamada por un pasajero.
function mostrarRecorridos($conexion, $ciudadOrigen, $ciudadDestino, $usuario, $vehiculo, $paisOrigen) {
    /* Mostramos los recorridos que de las ciudades origen y destino.*/	        		    
   try {                        
       
       //AR 2007-11-24 Llamaos al SP que genera los recorridos.
       $conexionInformix = nuevaConexionInformix();		            
       $llamadaSp = " execute procedure sp_calcular_recorrido ( ".$ciudadOrigen.", ".$ciudadDestino.", ".rand(1,5000)." );";		            
       		            
       $sph= $conexionInformix->prepare($llamadaSp);
       $errorInformix = $conexionInformix->errorInfo();
       if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP de calculo de recorridos (prepare): ".$error["1"]);                        
       };        
       
       $sph->execute();
       $errorInformix = $conexionInformix->errorInfo();
       if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP de calculo de recorridos (execute): ".$error["1"]);                        
       };        

       $filaSp = $sph->fetch(PDO::FETCH_NUM);
       $errorInformix = $conexionInformix->errorInfo();
       if ( $errorInformix["1"]) {
           throw new Exception("Fallo la llamada al SP de calculo de recorridos (fetch): ".$error["1"]);                        
       };        
       
       //Las siguientes lineas son para depurar el SP.
       /*if ($filaSp[0] > 0) {
           echo("Se generaron ".$filaSp[0]." recorridos nuevos.<BR>");
       } else {
           echo("No se generaron nuevos recorridos.<BR>");
       };
       */	
       		            		            
       /* AR 2007-11-24 Ahora buscamos los recorridos que hay en la base (nuevos y anteriores). */		       
       $ultimoRecorridoEncontrado = '';		    
       $totalDistancia = 0;
       $totalPeaje = 0;
       $totalCosto = 0;
       $fechaActualBD = obtener_string_fecha_bd(date('d/m/Y'));		          
       if ($vehiculo > 0) {
            $costoKmCombustible = costoKmCombustible($conexion, $usuario, $vehiculo, date('d/m/Y'), $paisOrigen);    		                		            
       } else {
            $costoKmCombustible = costoKmCombustiblePasajero($conexion, date('d/m/Y'), $paisOrigen);    		                		            
       };
       
       $recorridoMasBarato = recorridoMasBarato($conexion, $ciudadOrigen, $ciudadDestino, date('d/m/Y'), $costoKmCombustible);
       $recorridoMasCorto = recorridoMasCorto($conexion, $ciudadOrigen, $ciudadDestino);
       
       foreach ($conexion->query("		       		                                                                                   
            select r.rdo_id,
                oro.oro_ordentramo orden,
               c_origen.cad_nombre cad_origen,
               c_destino.cad_nombre cad_destino,
               t.tra_distancia,
               c.cft_costofijo
            from recorrido r
            inner join ordenrecorrido oro
                    on oro.oro_rdo_id = r.rdo_id
            inner join tramo t
                    on t.tra_id = oro.oro_tra_id
            left join costofijotramo c
                    on t.tra_id = c.cft_tra_id
                    and c.cft_vigentedesde <= '".$fechaActualBD."'
                    and (c.cft_vigentehasta is null or c.cft_vigentehasta >= '".$fechaActualBD."')
            inner join ciudad c_origen
                    on c_origen.cad_id = t.tra_cad_id1
            inner join ciudad c_destino
                    on c_destino.cad_id = t.tra_cad_id2
            where r.rdo_cad_id_origen = ".$ciudadOrigen."
            and r.rdo_cad_id_destino = ".$ciudadDestino."                                        
            order by r.rdo_id asc,
                    oro.oro_ordentramo asc                            
       
           ") as $row) {
      
           if ( $ultimoRecorridoEncontrado != $row['RDO_ID']) {
               /* Cerramos el radiobutton anterior.*/
               if ($ultimoRecorridoEncontrado > 0) {
                   if ($costoKmCombustible > 0) {
                       $costoTotal = ($costoKmCombustible * $totalDistancia) + $totalPeaje;
                   };
                   echo ' ('.$totalDistancia.' Km.';
                   if ($totalPeaje > 0) {
                       echo ' - Peajes: $ '.round($totalPeaje,2);
                   };
                   if ($recorridoMasBarato == $ultimoRecorridoEncontrado) {
                       echo ' - Más Barato';
                   };
                   if ($recorridoMasCorto == $ultimoRecorridoEncontrado) {
                       echo ' - Más Corto';
                   };    		                        
                   echo ')';
                   if ($costoKmCombustible > 0) {
                       echo ' <STRONG>$ '.round($costoTotal,2).'</STRONG>';
                   };
                   if ($recorridoMasBarato == $ultimoRecorridoEncontrado || $recorridoMasCorto == $ultimoRecorridoEncontrado ) {
                       echo '</U>';
                   };    
                   echo '<BR>';
                   $totalDistancia = 0;
                   $totalPeaje = 0;
                   $totalTotal = 0;
               };
      
            /* Creamos otro radiobutton.*/
               $ultimoRecorridoEncontrado = $row['RDO_ID'];
               if ($recorridoMasBarato == $ultimoRecorridoEncontrado || $recorridoMasCorto == $ultimoRecorridoEncontrado ) {
                   echo '<U>';
               };
               echo '<input type="radio" name="recorridoSeleccionado" value="'.$row['RDO_ID'].'"';
               if ($recorridoMasBarato == $ultimoRecorridoEncontrado) {
                   echo " checked";
               };
               echo '>';
               echo $row['CAD_ORIGEN'];		            
           };
           echo ' - '.$row['CAD_DESTINO'];		            
           $totalDistancia = $totalDistancia + $row['TRA_DISTANCIA'];
           $totalPeaje = $totalPeaje + $row['CFT_COSTOFIJO'];
       };
       if ($ultimoRecorridoEncontrado > 0) {
           if ($costoKmCombustible > 0) {
               $costoTotal = ($costoKmCombustible * $totalDistancia) + $totalPeaje;
           };
           echo ' ('.$totalDistancia.' Km.';
           if ($totalPeaje > 0) {
               echo ' - Peajes: $ '.round($totalPeaje,2);
           };
           if ($recorridoMasBarato == $ultimoRecorridoEncontrado) {
               echo ' - Más Barato';
           };
           if ($recorridoMasCorto == $ultimoRecorridoEncontrado) {
               echo ' - Más Corto';
           };    		                        
           echo ')';
           if ($costoKmCombustible > 0) {
               echo ' <STRONG>$ '.round($costoTotal,2).'</STRONG>';
           };
           if ($recorridoMasBarato == $ultimoRecorridoEncontrado || $recorridoMasCorto == $ultimoRecorridoEncontrado) {
               echo '</U>';
           };    
           echo '<BR>';
           $totalDistancia = 0;
           $totalPeaje = 0;
           $totalTotal = 0;
       } else {
         echo   '<h4>No se encontraron recorridos.</h4>';
       };
   } catch (PDOException $e) {  
       echo '<H3>Error de Base de Datos: '.$e->getMessage().'</h3>';                
   }; 
};

?>
