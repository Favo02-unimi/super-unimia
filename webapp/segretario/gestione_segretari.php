<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-gear";
$title = "Gestione segretari";
$subtitle = "";

$create = array(
  "target"=>"nuovo_segretario.php",
  "text"=>"Crea nuovo segretario"
);

$table_headers = array("Nome", "Cognome", "Email", array("colspan"=>"3", "text"=>"Controlli"));

$qry = "SELECT __id, __nome, __cognome, __email FROM unimia.get_segretari()";
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
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__cognome"]),
        array("type"=>"text", "val"=>$row["__email"]),
        array(
          "type"=>"button",
          "target"=>"modifica_segretario.php",
          "submit"=>"Modifica",
          "class"=>"is-link",
          "params"=>array(
            "id"=>$row["__id"],
            "nome"=>$row["__nome"],
            "cognome"=>$row["__cognome"],
            "email"=>$row["__email"]
          )
        ),
        array(
          "type"=>"button",
          "target"=>"modifica_password.php",
          "submit"=>"Modifica password",
          "class"=>"is-link",
          "params"=>array(
            "email"=>$row["__email"]
          )
        ),
        array(
          "type"=>"button",
          "target"=>"elimina_segretario.php",
          "submit"=>"Elimina",
          "class"=>"is-danger",
          "params"=>array(
            "id"=>$row["__id"],
            "nome"=>$row["__nome"],
            "cognome"=>$row["__cognome"],
            "email"=>$row["__email"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
