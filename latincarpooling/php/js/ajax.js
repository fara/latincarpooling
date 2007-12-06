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
        mostrarPaisOrigen();                
    };    
};

function mostrarPaisOrigen() {    
	if ((searchReq.readyState == 4 || searchReq.readyState == 0)
	&& (document.forms[0].elements["paisOrigen"].options.length == 0)) {		
		searchReq.open("GET", 'ajax_listarpaises.php', true);
		searchReq.onreadystatechange = handleMostrarPaisOrigen; 
		searchReq.send(null);
	};		
}

function handleMostrarPaisOrigen() {
	if (searchReq.readyState == 4) {
	    				
		var campo = document.getElementById('paisOrigen');				
		var doc =  parsearXML(searchReq.responseText);
		
		var paises = doc.getElementsByTagName('pais');
		
		if (paises.length > 0) {
		  var paisId;
		  var paisNombre;
		  var opciones = '';
		  for(var i=0;i < paises.length;i++) {  
		    paisId = paises[i].getElementsByTagName('pis_id')[0].textContent;
		    paisNombre = paises[i].getElementsByTagName('pis_nombre')[0].textContent;
		    opciones += '<option value="'+ paisId + '"';
		    if (campo.value == paisId) {
		        opciones += ' selected="selected"';
		    };
		    opciones += '>' + paisNombre +'</option>';
		  };
		  campo.innerHTML = opciones;		  
		  //document.getElementById('regionOrigen').value = 0;
		  if (campo.options.length > 0 ) {
            campo.value = campo.options[0].value;
            mostrarRegionesOrigen();        
		  };	
	    };
	}
}

function mostrarRegionesOrigen() {    
    var idPaisOrigen = document.forms[0].elements["paisOrigen"].value;
	if ((searchReq.readyState == 4 || searchReq.readyState == 0)
	&& ( idPaisOrigen > 0)) {		
		searchReq.open("GET", 'ajax_listarregiones.php?pais=' + idPaisOrigen, true);
		searchReq.onreadystatechange = handleMostrarRegionesOrigen; 
		searchReq.send(null);
	};		
}

function handleMostrarRegionesOrigen() {
	if (searchReq.readyState == 4) {
	    				
		var campo = document.getElementById('regionOrigen')				
		var doc =  parsearXML(searchReq.responseText);
		
		var regiones = doc.getElementsByTagName('region');
		
		if (regiones.length > 0) {
		  var regionId;
		  var regionNombre;
		  var opciones = '';
		  		 
		  for(var i=0;i < regiones.length;i++) {  
		    regionId = regiones[i].getElementsByTagName('ron_id')[0].textContent;
		    regionNombre = regiones[i].getElementsByTagName('ron_nombre')[0].textContent;
		    opciones += '<option value="'+ regionId + '"';
		    if (campo.value == regionId) {
		        opciones += ' selected="selected"';
		    };
		    opciones += '>' + regionNombre +'</option>';
		  };
		  campo.innerHTML = opciones;
		};	
	}
}

function mostrarCiudadesOrigen() {    
    var idRegion = document.forms[0].elements["regionOrigen"].value;
    var nombreInicial = document.forms[0].elements["ciudadOrigenDescripcion"].value;
	if ((searchReq.readyState == 4 || searchReq.readyState == 0)
	&& ( idRegion > 0) && (nombreInicial.length >= 3)) {		
		searchReq.open("GET", 'ajax_listarciudades.php?region=' + idRegion + '&nombreInicial=' + escape(nombreInicial), true);
		searchReq.onreadystatechange = handleMostrarCiudadesOrigen; 
		searchReq.send(null);
	};		
}

function handleMostrarCiudadesOrigen() {
	if (searchReq.readyState == 4) {
	    				
		var separador = document.getElementById('divCiudadOrigen')				
		var doc =  parsearXML(searchReq.responseText);
		
		if (doc != null) {
		    var ciudades = doc.getElementsByTagName('row');
		
		    if (ciudades.length > 0) {
		        var ciudadId;
		        var ciudadNombre;
		        var opciones = '';
			
		        for(var i=0;i < ciudades.length;i++) {  
		            ciudadId = ciudades[i].getElementsByTagName('cad_id')[0].textContent;
		            ciudadNombre = ciudades[i].getElementsByTagName('cad_nombre')[0].textContent;
		            opciones += '<div onmouseover="javascript:suggestOver(this);" ';		            
			        opciones += 'onmouseout="javascript:suggestOut(this);" ';
			        opciones += 'onclick="javascript:setCiudadOrigen(this.innerHTML);" ';
			        opciones += 'class="suggest_link">';
		            opciones += ciudadNombre + ' [' + ciudadId + ']';
		            opciones += '</div>';
		        };
		        separador.innerHTML = opciones;
		    };
		};	
	}
}


function setCiudadOrigen(value) {
    var ciudadId = value.substring(value.indexOf('[') + 1, value.indexOf(']'));
    var ciudadDescripcion = value.substring(0, value.indexOf('[') - 1);
	document.getElementById('ciudadOrigen').value = ciudadId;
	document.getElementById('ciudadOrigenDescripcion').value = ciudadDescripcion;
	document.getElementById('divCiudadOrigen').innerHTML = '';
}

