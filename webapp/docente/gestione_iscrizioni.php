<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "docente";
$fa_icon = "fa-users";
$title = "Gestione iscrizioni";
$subtitle = "Studenti iscritti ad appelli dei tuoi insegnamenti";

$table_headers = array("Insegnamento", "Data", "Matricola", "Nome", "Email", "Controlli");

$qry = "SELECT __appello, __insegnamento, __nome_insegnamento, __data, __studente, __matricola, __nome, __email FROM unimia.get_iscrizioni_per_docente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__insegnamento"].$row["__data"],
      "separator_text"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]." - Appello ".$row["__data"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__matricola"]),
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__email"]),
        array(
          "type"=>"button",
          "target"=>"valuta_iscrizione.php",
          "submit"=>"Valuta",
          "class"=>"is-link",
          "params"=>array(
            "appello"=>$row["__appello"],
            "insegnamento"=>$row["__insegnamento"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "data"=>$row["__data"],
            "studente"=>$row["__studente"],
            "matricola"=>$row["__matricola"],
            "nome"=>$row["__nome"],
            "email"=>$row["__email"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
