<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-marker";
$title = "Carriere degli studenti";
$subtitle = "Vengono visualizzate tutte le valutazioni, anche quelle non valide perchè insufficienti o sovrascritte da una valutazione più recente.";

$table_headers = array("Insegnamento", "Data", "Docente", "Studente", "Matricola", "Voto", "Valida", "Controlli");

$qry = "SELECT __appello, __insegnamento, __nome_insegnamento, __data, __nome_docente, __studente, __nome_studente, __matricola_studente, __voto, __valida FROM unimia.get_valutazioni()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__studente"],
      "separator_text"=>$row["__matricola_studente"]." - ".$row["__nome_studente"],
      "class"=>$row["__valida"] == "f" ? "invalid" : "",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__insegnamento"]." - ".$row["__nome_insegnamento"]),
        array("type"=>"text", "val"=>$row["__data"]),
        array("type"=>"text", "val"=>$row["__nome_docente"]),
        array("type"=>"text", "val"=>$row["__nome_studente"]),
        array("type"=>"text", "val"=>$row["__matricola_studente"]),
        array("type"=>"text", "val"=>$row["__voto"] == "" ? "<i>In attesa</i>" : $row["__voto"]),
        array("type"=>"text", "val"=>$row["__valida"] == "f" ? "<i>Non valida</i>" : "<b>Valida</b>"),
        array(
          "type"=>"button",
          "target"=>"modifica_valutazione.php",
          "submit"=>"Modifica",
          "class"=>"is-link",
          "params"=>array(
            "appello"=>$row["__appello"],
            "studente"=>$row["__studente"],
            "insegnamento"=>$row["__insegnamento"],
            "nome_insegnamento"=>$row["__nome_insegnamento"],
            "data"=>$row["__data"],
            "matricola"=>$row["__matricola_studente"],
            "nome"=>$row["__nome_studente"],
            "voto"=>$row["__voto"] == "" ? "In attesa" : $row["__voto"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
