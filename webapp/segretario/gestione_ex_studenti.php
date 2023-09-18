<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-graduate";
$title = "Gestione ex studenti";
$subtitle = "";

$table_headers = array("Nome", "Cognome", "Email", "Matricola", "Corso di laurea", "Motivazione", array("colspan"=>"2", "text"=>"Controlli"));

$qry = "SELECT __id, __nome, __cognome, __email, __matricola, __corso_di_laurea, __nome_corso_di_laurea, __motivazione FROM unimia.get_ex_studenti()";
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
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__cognome"]),
        array("type"=>"text", "val"=>$row["__email"]),
        array("type"=>"text", "val"=>$row["__matricola"]),
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__motivazione"]),
        array(
          "type"=>"button",
          "target"=>"gestione_ex_valutazioni.php?filter=".$row["__matricola"]."&highlight=false&hide=true",
          "submit"=>"Carriera",
          "class"=>"is-link",
          "params"=>array()
        ),
        array(
          "type"=>"button",
          "target"=>"modifica_password.php",
          "submit"=>"Modifica password",
          "class"=>"is-link",
          "params"=>array(
            "email"=>$row["__email"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
