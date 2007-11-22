<?Php

function menu(){
echo '<div id="mainmenu">
<ul>
<li><a class="current" href="index.html">Inicio</a></li>
<li><a href="green.html">Viajes</a></li>
<li><a href="orange.html">Pedidos</a></li>
<li><a href="purple.html">Mensajes</a></li>
<li><a href="red.html">Opciones</a></li>
<li><a href="red.html">Salir</a></li>
<li><a href="red.html">Novedades</a></li>
</ul>
</div>
 
<div id="wrap">

<div id="leftside">
<a class="nav" href="buscarviaje.php">Viajes</a><span class="hide"> | </span>
<a class="nav sub" href="buscarviaje.php">Buscar</a><span class="hide"> | </span>
<a class="nav sub" href="ingresarviaje.php">Nuevo</a><span class="hide"> | </span>
<a class="nav sub" href="listarviajeconductor.php">Mis Viajes</a><span class="hide"> | </span>
<a class="nav" href="#">Pedidos</a><span class="hide"> | </span>
<a class="nav sub" href="ingresarPedido.php">Nuevo</a><span class="hide"> | </span>
<a class="nav sub" href="listarviajepasajero.php">Mis Pedidos</a><span class="hide"> | </span>
<a class="nav" href="#">Mis Mensajes</a><span class="hide"> | </span>
<a class="nav sub" href="listarmensajes.php?tipo=recibidos">Recibidos</a><span class="hide"> | </span>
<a class="nav sub" href="listarmensajes.php?tipo=enviados">Enviados</a><span class="hide"> | </span>
<a class="nav sub" href="#">Nuevo</a><span class="hide"> | </span>
<a class="nav" href="#">Opciones</a><span class="hide"> | </span>
<a class="nav" href="login.php?accion=salir">Salir</a><span class="hide"> | </span>
<a class="nav" href="#">Novedades</a><span class="hide"> | </span>

</div>

<div id="rightside">
<h1>Latest news</h1>
<p><strong>Dec 11: </strong>
andreas09 is built with valid XHTML 1.1 and CSS2. It is simple and easy to work with, and it comes in several different flavors. This is version 1.0 (Dec 11th 2005).</p>
<p><strong>Dec 10: </strong>
Place for news or important messages, maybe?</p>

</div>
';
};

?>
