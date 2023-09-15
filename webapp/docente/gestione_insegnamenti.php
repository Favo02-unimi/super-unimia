<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "docente";
$fa_icon = "fa-book";
$title = "Gestione insegnamenti";
$subtitle = "Insegnamenti di cui sei responsabile";

$table_headers = array("Codice", "Corso di laurea", "Nome", "Descrizione", "Anno", array("colspan"=>"3", "text"=>"Controlli"));

$qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __nome, __descrizione, __anno FROM unimia.get_insegnamenti_per_docente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>$row["__corso_di_laurea"],
      "separator_text"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"],
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__codice"]),
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__descrizione"]),
        array("type"=>"text", "val"=>$row["__anno"]),
        array(
          "type"=>"button",
          "target"=>"gestione_appelli.php?filter=".$row["__codice"]."&highlight=false&hide=true",
          "submit"=>"Appelli",
          "class"=>"is-link",
          "params"=>array()
        ),
        array(
          "type"=>"button",
          "target"=>"gestione_valutazioni.php?filter=".$row["__codice"]."&highlight=false&hide=true",
          "submit"=>"Valutazioni",
          "class"=>"is-link",
          "params"=>array()
        )
      )
    )
  );
}

require("../components/table.php");

?>
