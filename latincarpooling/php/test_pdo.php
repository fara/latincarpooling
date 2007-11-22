<?php

$dsn = "carpoolinginformix";
$usuario = "carpooling";
$pass="metallica23";

try {
	/*$dbh = new PDO('informix:host=localhost; service=1526; database=produccion; server=ol_guaderio; protocol=onsoctcp' , $user, $pass);*/
   $dbh = new PDO('informix:DSN='.$dsn, $user, $pass);
   $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

   echo '<P>Contenido de la tabla valorcambio</P>';      
      
   foreach ($dbh->query('SELECT * from valorcambio') as $row) {
      echo '<BR>';
      print_r($row);
   }
   
   echo '<P>';
   echo '<P>Llamada a un procedimiento</P>';      
   /*$dbh->beginTransaction();
   $dbh->exec("EXECUTE PROCEDURE spu_valor_cambio (1, '01-01-2009', 444.00)");
   $dbh->commit();*/
   
   $stmt = $dbh->prepare('EXECUTE PROCEDURE spu_valor_cambio (:moneda, :vigencia, :valor)');
   $moneda = 1;
   $fecha = '1998-01-01';
   $valor = 444.00;
   $stmt->bindParam(':moneda', $moneda);    
   
   $stmt->bindParam(':vigencia', $fecha, PDO::PARAM_STR); 
   $stmt->bindParam(':valor', $valor); 
   
   $stmt->execute();
   
   $dbh = null;
} catch (PDOException $e) {
   /*$dbh->rollBack();*/
   print "Error!: " . $e->getMessage() . "<br/>";
   die();
}
	
?>