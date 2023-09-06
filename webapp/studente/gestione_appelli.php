<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "studente";
$fa_icon = "fa-calendar-day";
$title = "Gestione appelli";
$subtitle = "Appelli degli insegnamenti del tuo corso di laurea.";

$table_headers = array("Insegnamento", "Data", "Ora", "Luogo", "Ultima valutazione", "Controlli");

$qry = "SELECT __codice, __insegnamento, __nome_insegnamento, __data, __ora, __luogo, __ultimo_voto, __iscritto FROM unimia.get_appelli_per_studente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__insegnamento"],
      "separator_text"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__ora"]),
        array("type"=>"text", "val"=>$row["__luogo"]),
        array("type"=>"text", "val"=>$row["__ultimo_voto"] == "" ? "<i>Mai sostenuto</i>" : $row["__ultimo_voto"]),
        array(
          "type"=>"button",
          "target"=>$row["__iscritto"] == "f" ? "iscriviti_appello.php" : "disiscriviti_appello.php",
          "submit"=>$row["__iscritto"] == "f" ? "Iscriviti" : "Disiscriviti",
          "class"=>$row["__iscritto"] == "f" ? "is-link" : "is-danger",
          "params"=>array(
            "codice"=>$row["__codice"],
            "insegnamento"=>$row["__insegnamento"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "data"=>$row["__data"],
            "ora"=>$row["__ora"],
            "luogo"=>$row["__luogo"],
            "ultimo_voto"=>$row["__ultimo_voto"],
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
