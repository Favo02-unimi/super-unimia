<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "studente";
$fa_icon = "fa-marker";
$title = "Valutazioni e carriera";
$subtitle = "Vengono visualizzate tutte le valutazioni, anche quelle non valide perchè insufficienti o sovrascritte da una valutazione più recente.";

$table_headers = array("Insegnamento", "Data", "Docente", "Voto", "Valida");

$qry = "SELECT __studente, __appello, __insegnamento, __nome_insegnamento, __data, __nome_docente, __voto, __valida, __media FROM unimia.get_valutazioni_per_studente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__studente"],
      "separator_text"=>"Media: ".number_format(floatval($row["__media"]), 2, '.', ''),
      "class"=>$row["__valida"] == "f" ? "invalid" : "",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__nome_docente"]),
        array("type"=>"text", "val"=>$row["__voto"] == "" ? "In attesa" : $row["__voto"]),
        array("type"=>"text", "val"=>$row["__valida"] == "f" ? "<i>Non valida</i>" : "<b>Valida</b>")
      )
    )
  );
}

require("../components/table.php");

?>
