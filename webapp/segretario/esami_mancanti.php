<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-list-check";
$title = "Esami mancanti";
$subtitle = "Vengono visualizzati tutti gli esami mancanti per completare il percorso di studi di ogni studente.";

$table_headers = array("Studente", "Matricola", "Corso di Laurea", "Insegnamento", "Anno", "Responsabile", "Propedeuticità");

$qry = "SELECT __nome_studente, __matricola, __corso_di_laurea, __nome_corso_di_laurea, __codice, __nome, __anno, __nome_responsabile, __propedeuticita FROM unimia.get_esami_mancanti()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__nome_studente"],
      "separator_text"=>$row["__nome_studente"]." - ".$row["__matricola"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__nome_studente"]),
        array("type"=>"text", "val"=>$row["__matricola"]),
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__codice"]." - ".$row["__nome"]),
        array("type"=>"text", "val"=>$row["__anno"]),
        array("type"=>"text", "val"=>$row["__nome_responsabile"]),
        array("type"=>"text", "val"=>$row["__propedeuticita"] == "" ? "-" : $row["__propedeuticita"])
      )
    )
  );
}

require("../components/table.php");

?>
