<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-users";
$title = "Gestione iscrizioni";
$subtitle = "";

$table_headers = array("Corso di laurea", "Insegnamento", "Data", "Docente", "Studente", "Matricola", "Controlli");

$qry = "SELECT __appello, __corso_di_laurea, __nome_corso_di_laurea, __insegnamento, __nome_insegnamento, __data, __docente, __nome_docente, __studente, __nome_studente, __matricola FROM unimia.get_iscrizioni()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__insegnamento"].$row["__data"],
      "separator_text"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"].": ".$row["__insegnamento"]." - ".$row["__nome_insegnamento"]." - Appello ".$row["__data"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__nome_docente"]),
        array("type"=>"text", "val"=>$row["__nome_studente"]),
        array("type"=>"text", "val"=>$row["__matricola"]),
        array(
          "type"=>"button",
          "target"=>"elimina_iscrizione.php",
          "submit"=>"Cancella iscrizione",
          "class"=>"is-danger",
          "params"=>array(
            "appello"=>$row["__appello"],
            "corso_di_laurea"=>$row["__corso_di_laurea"],
            "nome_corso_di_laurea"=>$row["__nome_corso_di_laurea"],
            "insegnamento"=>$row["__insegnamento"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "data"=>$row["__data"],
            "studente"=>$row["__studente"],
            "nome_studente"=>$row["__nome_studente"],
            "matricola"=>$row["__matricola"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
