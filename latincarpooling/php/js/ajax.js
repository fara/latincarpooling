//Gets the browser specific XmlHttpRequest Object
function getXmlHttpRequestObject() {
	if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		return new ActiveXObject("Microsoft.XMLHTTP");
	} else {
		alert("Your Browser Sucks!\nIt's about time to upgrade don't you think?");
	}
}

//Our XmlHttpRequest object to get the auto suggest
var searchReq = getXmlHttpRequestObject();

function roundNumber(num, dec) {
	var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	return result;
}

//Called from keyup on the search textbox.
//Starts the AJAX request.
function searchSuggest() {    
	if (searchReq.readyState == 4 || searchReq.readyState == 0) {
		var str = escape(document.getElementById('txtSearch').value);
		searchReq.open("GET", 'searchSuggest.php?search=' + str, true);
		searchReq.onreadystatechange = handleSearchSuggest; 
		searchReq.send(null);
	}		
}

function parameterValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}

//Called when the AJAX response is returned.
function handleSearchSuggest() {
	if (searchReq.readyState == 4) {
		var ss = document.getElementById('search_suggest')
		ss.innerHTML = '';
		var str = searchReq.responseText.split("\n");
		for(i=0; i < str.length - 1; i++) {
			//Build our element string.  This is cleaner using the DOM, but
			//IE doesn't support dynamically added attributes.
			var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
			suggest += 'onmouseout="javascript:suggestOut(this);" ';
			suggest += 'onclick="javascript:setSearch(this.innerHTML);" ';
			suggest += 'class="suggest_link">' + str[i] + '</div>';
			ss.innerHTML += suggest;
		}
	}
}

//Mouse over function
function suggestOver(div_value) {
	div_value.className = 'suggest_link_over';
}
//Mouse out function
function suggestOut(div_value) {
	div_value.className = 'suggest_link';
}

//Click function
function setSearch(value) {
	document.getElementById('txtSearch').value = value;
	document.getElementById('search_suggest').innerHTML = '';
}

function parsearXML(texto) {
    var parser = new DOMParser();
	return parser.parseFromString(texto, "text/xml");
};

//Carga los datos iniciales de la pagina si existen los campos.
function inicializarPagina() {    
    if (document.getElementById('paisOrigen') != null) {
        mostrarPais('paisOrigen','regionOrigen','ciudadOrigen', 'ciudadOrigenDescripcion');                
    };            
    
    if (document.getElementById('paisDestino') != null) {
        mostrarPais('paisDestino','regionDestino','ciudadDestino', 'ciudadDestinoDescripcion');                
    }; 
    
    if (document.getElementById('vehiculo') != null) {
        mostrarVehiculos();                
    }; 

};

function mostrarPais(nombreCampoPais, nombreCampoRegion, nombreCampoCiudad, nombreCampoCiudadDescripcion) {    
    var xmlrequest = getXmlHttpRequestObject();
	if ((xmlrequest.readyState == 4 || xmlrequest.readyState == 0)
	&& (document.forms[0].elements[nombreCampoPais].options.length == 0)) {		
		xmlrequest.open("GET", 'ajax_listarpaises.php', true);
		xmlrequest.onreadystatechange = function () {
		       handleMostrarPais(xmlrequest, nombreCampoPais, nombreCampoRegion,
		                        nombreCampoCiudad, nombreCampoCiudadDescripcion) };
		xmlrequest.send(null);
	};		
}

function handleMostrarPais(xmlrequest, nombreCampoPais, nombreCampoRegion,
    nombreCampoCiudad, nombreCampoCiudadDescripcion) {
	if (xmlrequest.readyState == 4) {
	    				
		var campo = document.getElementById(nombreCampoPais);				
		var doc =  parsearXML(xmlrequest.responseText);		
		
		var paises = doc.getElementsByTagName('pais');
		
		if (paises.length > 0) {
		  var paisId;
		  var paisNombre;
		  var opciones = '<option value="0">(Elija un pais)</option>';
		  for(var i=0;i < paises.length;i++) {  
		    paisId = paises[i].getElementsByTagName('pis_id')[0].textContent;
		    paisNombre = paises[i].getElementsByTagName('pis_nombre')[0].textContent;
		    opciones += '<option value="'+ paisId + '"';		    
		    opciones += '>' + paisNombre +'</option>';
		  };
		  campo.innerHTML = opciones;		  
		  document.getElementById(nombreCampoRegion).value = 0;
		  document.getElementById(nombreCampoCiudadDescripcion).value = '';
		  document.getElementById(nombreCampoCiudad).value = 0;		  
		  mostrarRecorridos();
	    };
	}
}

function mostrarRegiones(nombreCampoPais, nombreCampoRegion,
    nombreCampoCiudad, nombreCampoCiudadDescripcion) {           
    var idPaisOrigen = document.forms[0].elements[nombreCampoPais].value;
    var xmlrequest = getXmlHttpRequestObject();
    
	if (xmlrequest.readyState == 4 || xmlrequest.readyState == 0) {		
		xmlrequest.open("GET", 'ajax_listarregiones.php?pais=' + idPaisOrigen, true);
		xmlrequest.onreadystatechange = function () {
		       handleMostrarRegiones(xmlrequest, nombreCampoRegion,
		                        nombreCampoCiudad, nombreCampoCiudadDescripcion) };
		xmlrequest.send(null);
	};    
}

function handleMostrarRegiones(xmlrequest, nombreCampoRegion,
		                        nombreCampoCiudad, nombreCampoCiudadDescripcion) {
		                            
	if (xmlrequest.readyState == 4) {
	    				
		var campo = document.getElementById(nombreCampoRegion)				
		var doc =  parsearXML(xmlrequest.responseText);
		
		var regiones = doc.getElementsByTagName('region');
		
		var opciones = '';
		
		if (regiones.length > 0) {
		  var regionId;
		  var regionNombre;
		  opciones += '<option value="0">(Elija una provincia)</option>';
		  		 
		  for(var i=0;i < regiones.length;i++) {  
		    regionId = regiones[i].getElementsByTagName('ron_id')[0].textContent;
		    regionNombre = regiones[i].getElementsByTagName('ron_nombre')[0].textContent;
		    opciones += '<option value="'+ regionId + '"';		    
		    opciones += '>' + regionNombre +'</option>';
		  };		
		};	
		campo.innerHTML = opciones;
		document.getElementById(nombreCampoCiudad).value = 0;
		document.getElementById(nombreCampoCiudadDescripcion).value = '';		
		mostrarRecorridos();
	}
}

function mostrarCiudades(nombreCampoRegion, nombreCampoCiudadDescripcion, nombreDivCiudad, nombreFuncionCiudad ) {    
    var xmlrequest = getXmlHttpRequestObject();
    
    var idRegion = document.forms[0].elements[nombreCampoRegion].value;
    var nombreInicial = document.forms[0].elements[nombreCampoCiudadDescripcion].value;
	if ((xmlrequest.readyState == 4 || xmlrequest.readyState == 0)
	&& ( idRegion > 0) && (nombreInicial.length >= 3)) {		
		xmlrequest.open("GET", 'ajax_listarciudades.php?region=' + idRegion + '&nombreInicial=' + escape(nombreInicial), true);
		xmlrequest.onreadystatechange = function () {
		       handleMostrarCiudades(xmlrequest, nombreDivCiudad, nombreFuncionCiudad) };
		xmlrequest.send(null);
	} else {
	    document.getElementById(nombreDivCiudad).innerHTML = '';
	};		
}

function handleMostrarCiudades(xmlrequest, nombreDivCiudad, nombreFuncionCiudad) {
	if (xmlrequest.readyState == 4) {
	    var opciones = '';				
		var separador = document.getElementById(nombreDivCiudad);
		var doc =  parsearXML(xmlrequest.responseText);
		
		if (doc != null) {
		    var ciudades = doc.getElementsByTagName('row');
		
		    if (ciudades.length > 0) {
		        var ciudadId;
		        var ciudadNombre;		        
			
		        for(var i=0;i < ciudades.length;i++) {  
		            ciudadId = ciudades[i].getElementsByTagName('cad_id')[0].textContent;
		            ciudadNombre = ciudades[i].getElementsByTagName('cad_nombre')[0].textContent;
		            opciones += '<div onmouseover="javascript:suggestOver(this);" ';		            
			        opciones += 'onmouseout="javascript:suggestOut(this);" ';
			        opciones += 'onclick="javascript:';
			        opciones += nombreFuncionCiudad;
			        opciones += '(this.innerHTML);" ';
			        opciones += 'class="suggest_link">';
		            opciones += ciudadNombre + ' [' + ciudadId + ']';
		            opciones += '</div>';
		        };		        
		    };
		};	
		separador.innerHTML = opciones;
	}
}


function setCiudadOrigen(value) {
    var ciudadId = value.substring(value.indexOf('[') + 1, value.indexOf(']'));
    var ciudadDescripcion = value.substring(0, value.indexOf('[') - 1);
	document.getElementById('ciudadOrigen').value = ciudadId;
	document.getElementById('ciudadOrigenDescripcion').value = ciudadDescripcion;
	document.getElementById('divCiudadOrigen').innerHTML = '';	
	mostrarRecorridos();
}

function setCiudadDestino(value) {
    var ciudadId = value.substring(value.indexOf('[') + 1, value.indexOf(']'));
    var ciudadDescripcion = value.substring(0, value.indexOf('[') - 1);
	document.getElementById('ciudadDestino').value = ciudadId;
	document.getElementById('ciudadDestinoDescripcion').value = ciudadDescripcion;
	document.getElementById('divCiudadDestino').innerHTML = '';	
	mostrarRecorridos();
}


function cambioRegion(nombreCampoCiudad, nombreCampoCiudadDescripcion, nombreDivCiudad) {
    document.getElementById(nombreCampoCiudad).value = 0;
    document.getElementById(nombreCampoCiudadDescripcion).value = '';
    document.getElementById(nombreDivCiudad).innerHTML = '';        
};


function mostrarVehiculos() {    
    var xmlrequest = getXmlHttpRequestObject();    
    var idUsuario = document.getElementById('idUsuarioActual').value;
    
	if ((xmlrequest.readyState == 4 || xmlrequest.readyState == 0)
	&& (idUsuario > 0)) {			    
		xmlrequest.open("GET", 'ajax_listarvehiculos.php?usuario=' + idUsuario, true);
		xmlrequest.onreadystatechange = function () {
		       handleMostrarVehiculos(xmlrequest) };
		xmlrequest.send(null);
	};		
}

function handleMostrarVehiculos(xmlrequest) {
	if (xmlrequest.readyState == 4) {
	    				
		var campo = document.getElementById('vehiculo');				
		var doc =  parsearXML(xmlrequest.responseText);
		
		var vehiculos = doc.getElementsByTagName('vehiculo');
		
		if (vehiculos.length > 0) {
		  var vehiculoId;
		  var vehiculoModelo;
		  var vehiculoPatente;
		  var opciones = '<option value="0">(Elija un vehiculo)</option>';
		  for(var i=0;i < vehiculos.length;i++) {  
		    vehiculoId = vehiculos[i].getElementsByTagName('vlo_id')[0].textContent;
		    vehiculoModelo = vehiculos[i].getElementsByTagName('vlo_modelo')[0].textContent;
		    vehiculoPatente = vehiculos[i].getElementsByTagName('vlo_patente')[0].textContent;
		    opciones += '<option value="'+ vehiculoId + '"';
		    if (campo.value == vehiculoId) {
		        opciones += ' selected="selected"';
		    };
		    opciones += '>' + vehiculoModelo + ' (' + vehiculoPatente +') </option>';
		  };
		  campo.innerHTML = opciones;		  		  
	    };
	}
}


function mostrarRecorridos() {    
    var idPaisOrigen = document.getElementById('paisOrigen').value;
    var idCiudadOrigen = document.getElementById('ciudadOrigen').value;
    var idCiudadDestino = document.getElementById('ciudadDestino').value;
    var idUsuario = document.getElementById('idUsuarioActual').value;
    var campoVehiculo = document.getElementById('vehiculo');
    var idVehiculo;
    var divRecorridos = document.getElementById('divRecorridos');
    var xmlrequest = getXmlHttpRequestObject();    
        
    if (campoVehiculo != null) {
        idVehiculo = campoVehiculo.value;    
    } else {
        idVehiculo = 0;
    };
               
	if ((xmlrequest.readyState == 4 || xmlrequest.readyState == 0)
	&& (idUsuario > 0) && (divRecorridos != null)) {
	    //Validamos que tengamos los datos que necesitamos.
	    if (idPaisOrigen <= 0 || idPaisOrigen == '') {
	        divRecorridos.innerHTML = '<h4>Por favor, elija el pais de origen.</h4>';
	    } else if (idCiudadOrigen <= 0 || idCiudadOrigen == '') {
	        divRecorridos.innerHTML = '<h4>Por favor, elija la ciudad de origen.</h4>';
	    } else if (idCiudadDestino <= 0 || idCiudadDestino == '') {
	        divRecorridos.innerHTML = '<h4>Por favor, elija la ciudad de destino.</h4>';
        } else if (campoVehiculo != null && (idVehiculo <= 0 || idVehiculo == '')) {
	        divRecorridos.innerHTML = '<h4>Por favor, elija un vehiculo.</h4>';	        
	    } else {
	        divRecorridos.innerHTML = '<h4>Buscando recorridos...</h4>';
	        //Tenemos todo lo que necesitamos.     	
		    xmlrequest.open("GET", 'ajax_listarrecorridos.php?'
		        + 'ciudadOrigen=' + idCiudadOrigen
		        + '&ciudadDestino=' + idCiudadDestino
		        + '&idUsuario=' + idUsuario
		        + '&idVehiculo=' + idVehiculo
		        + '&paisOrigen=' + idPaisOrigen, true);
		    xmlrequest.onreadystatechange = function () {
		       handleMostrarRecorridos(xmlrequest) };
		    xmlrequest.send(null);
	    };
	};		
}

function handleMostrarRecorridos(xmlrequest) {
	if (xmlrequest.readyState == 4) {
	    				
		var divRecorridos = document.getElementById('divRecorridos');				
		var doc =  parsearXML(xmlrequest.responseText);
		
		var recorridos = doc.getElementsByTagName('row');
		
		if (recorridos.length > 0) {
		  var recorridoId;
		  var descripcion;
		  var distancia;
		  var costofijo;
		  var costototal;
		  var mascorto;
		  var masarato;		  
		  var opciones = '';
		  
		  for(var i=0;i < recorridos.length;i++) {  
		    recorridoId = recorridos[i].getElementsByTagName('idrecorrido')[0].textContent;
		    descripcion = recorridos[i].getElementsByTagName('descripcion')[0].textContent;
		    distancia = recorridos[i].getElementsByTagName('distancia')[0].textContent;
		    costofijo = recorridos[i].getElementsByTagName('costofijo')[0].textContent;
		    costototal = recorridos[i].getElementsByTagName('costototal')[0].textContent;
		    mascorto = recorridos[i].getElementsByTagName('mascorto')[0].textContent;
		    masbarato = recorridos[i].getElementsByTagName('masbarato')[0].textContent;
		    
		    if (mascorto == 'S' || masbarato == 'S') {
		        opciones += '<U>';
		    };
		    
		    opciones = opciones + '<input type="radio" name="recorridoSeleccionado" value="' + recorridoId + '"';
		    
            if (masbarato == 'S') {
                opciones += " checked";
            };
            opciones = opciones + '>' + descripcion + ' (' + distancia + ' Km.';               
            
            if (costofijo > 0) {
               opciones = opciones + ' - Peajes: $ ' + roundNumber(costofijo,2);
            };
            if (masbarato == 'S') {
               opciones += ' - Más Barato';
            };
            if (mascorto == 'S') {
               opciones += ' - Más Corto';
            };    		                        
            opciones += ')';                      
            opciones = opciones + ' <STRONG>$ ' + roundNumber(costototal,2) + '</STRONG>';
           
            if (mascorto == 'S' || masbarato == 'S') {
		        opciones += '</U>';
		    };
            opciones += '<BR>';		    		    
		  };
		  divRecorridos.innerHTML = opciones;		  		  
	    } else {
	      divRecorridos.innerHTML = '<h4>No se encontraron recorridos.</h4>';	        
	    };	    	    	
	};
}

