<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-graduation-cap";
$title = "Gestione corsi di laurea";
$subtitle = "";

$create = array(
  "target"=>"nuovo_corso_di_laurea.php",
  "text"=>"Crea nuovo corso di laurea"
);

$table_headers = array("Codice", "Tipo", "Nome", "Descrizione", array("colspan"=>"2", "text"=>"Controlli"));

$qry = "SELECT __codice, __tipo, __nome, __descrizione FROM unimia.get_corsi_di_laurea()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$rows = array();

while($row = pg_fetch_assoc($res)) {
  array_push($rows,
    array(
      "separator"=>"",
      "separator_text"=>"",
      "class"=>"",
      "cols"=> array(
        array("type"=>"text", "val"=>$row["__codice"]),
        array("type"=>"text", "val"=>$row["__tipo"]),
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__descrizione"]),
        array(
          "type"=>"button",
          "target"=>"modifica_corso_di_laurea.php",
          "submit"=>"Modifica",
          "class"=>"is-link",
          "params"=>array(
            "codice"=>$row["__codice"],
            "tipo"=>$row["__tipo"],
            "nome"=>$row["__nome"],
            "descrizione"=>$row["__descrizione"]
          )
        ),
        array(
          "type"=>"button",
          "target"=>"elimina_corso_di_laurea.php",
          "submit"=>"Elimina",
          "class"=>"is-danger",
          "params"=>array(
            "codice"=>$row["__codice"],
            "tipo"=>$row["__tipo"],
            "nome"=>$row["__nome"],
            "descrizione"=>$row["__descrizione"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
