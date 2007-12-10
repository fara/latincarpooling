<?php
/*include 'validar.php';*/
include 'header.php';
carpooling_header("Mensajes");
include 'func_lib.php';
include 'menu.php';

menu();
?>
<style type="text/css" media="screen">	
	.suggest_link {
		background-color: #FFFFFF;
		padding: 2px 6px 2px 6px;
	}
	.suggest_link_over {
		background-color: #3366CC;
		padding: 2px 6px 2px 6px;
	}
	#search_suggest {
		position: absolute; 
		background-color: #FFFFFF; 
		text-align: left; 
		border: 1px solid #000000;			
	}		
</style>
<div id="content">
<h1>Mensajes</h1>
<form id="frmSearch" action="http://www.DynamicAJAX.com/search.php">
	<input type="text" id="txtSearch" name="txtSearch" alt="Search Criteria" value="ar"
		onload="searchSuggest();" onkeyup="searchSuggest();" autocomplete="off" />
	<input type="submit" id="cmdSearch" name="cmdSearch" value="Search" alt="Run Search" />
    <div id="search_suggest">
	</div>
</form>


	<div class="clearingdiv">&nbsp;</div>
</div>
<?php
include 'footer.php';
footer();
?>