<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "studente";
$fa_icon = "fa-book";
$title = "Visualizza corsi di laurea";
$subtitle = "Manifesto di tutti i corsi di laurea offerti da Super Università.";

$table_headers = array("Corso di laurea", "Codice", "Nome", "Descrizione", "Anno", "Responsabile", "Propedeuticità");

$qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __nome, __descrizione, __anno, __responsabile, __nome_responsabile, __propedeuticita FROM unimia.get_insegnamenti()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__corso_di_laurea"],
      "separator_text"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
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
