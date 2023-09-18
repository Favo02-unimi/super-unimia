<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-calendar-day";
$title = "Gestione appelli";
$subtitle = "";

$table_headers = array("Corso di laurea", "Insegnamento", "Data", "Ora", "Luogo", "Docente", "Da valutare", array("colspan"=>"4", "text"=>"Controlli"));

$qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __insegnamento, __nome_insegnamento, __data, __ora, __luogo, __docente, __nome_docente, __da_valutare FROM unimia.get_appelli()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__insegnamento"],
      "separator_text"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"].": ".$row["__insegnamento"]." - ".$row["__nome_insegnamento"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__ora"]),
        array("type"=>"text", "val"=>$row["__luogo"]),
        array("type"=>"text", "val"=>$row["__nome_docente"]),
        array("type"=>"text", "val"=>$row["__da_valutare"]),
        array(
          "type"=>"button",
          "target"=>"gestione_iscrizioni.php?filter=".$row["__data"]."&highlight=false&hide=true",
          "submit"=>"Iscritti",
          "class"=>"is-link",
          "params"=>array()
        ),
        array(
          "type"=>"button",
          "target"=>"gestione_valutazioni.php?filter=".$row["__data"]."&highlight=false&hide=true",
          "submit"=>"Valutazioni",
          "class"=>"is-link",
          "params"=>array()
        ),
        array(
          "type"=>"button",
          "target"=>"modifica_appello.php",
          "submit"=>"Modifica",
          "class"=>"is-link",
          "params"=>array(
            "nome_corso_di_laurea"=>$row["__nome_corso_di_laurea"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "codice"=>$row["__codice"],
            "data"=>$row["__data"],
            "ora"=>$row["__ora"],
            "luogo"=>$row["__luogo"]
          )
        ),
        array(
          "type"=>"button",
          "target"=>"elimina_appello.php",
          "submit"=>"Elimina",
          "class"=>"is-danger",
          "params"=>array(
            "nome_corso_di_laurea"=>$row["__nome_corso_di_laurea"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "codice"=>$row["__codice"],
            "data"=>$row["__data"],
            "ora"=>$row["__ora"],
            "luogo"=>$row["__luogo"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
