<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "studente";
$fa_icon = "fa-list-check";
$title = "Esami mancanti";
$subtitle = "Vengono visualizzati tutti gli esami mancanti per completare il percorso di studi.";

$table_headers = array("Codice", "Nome", "Descrizione", "Anno", "Responsabile", "Propedeuticità");

$qry = "SELECT __codice, __nome, __descrizione, __anno, __responsabile, __nome_responsabile, __email_responsabile, __propedeuticita FROM unimia.get_esami_mancanti_per_studente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>"",
      "separator_text"=>"",
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__codice"]),
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__descrizione"]),
        array("type"=>"text", "val"=>$row["__anno"]),
        array("type"=>"text", "val"=>$row["__nome_responsabile"]),
        array("type"=>"text", "val"=>$row["__propedeuticita"] == "" ? "-" : $row["__propedeuticita"])
      )
    )
  );
}

require("../components/table.php");

?>
