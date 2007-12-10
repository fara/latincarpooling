<?php
try {
    $dbh = new PDO("informix:; database=sysmaster; server=ol_guaderio;port=1526",
    "informix", "aymara17");
    printf("<pre>");
    printf(" %s \n",$dbh->getAttribute(PDO::ATTR_DRIVER_NAME) ) ;
    $stmt=$dbh->query('SELECT * FROM systables');
    $row=$stmt->fetch(PDO::FETCH_ASSOC);
    $count=0;
    while ( $stmt && $count<5 && $row)
    {
        print_r($row);
        $row=$stmt->fetch(PDO::FETCH_ASSOC);
        $count++;
    }
    printf("</pre>");
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage();
    exit;
}
?>