<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
$fa_icon = "fa-book";
$title = "Gestione insegnamenti";
$subtitle = "";

$create = array(
  "target"=>"nuovo_insegnamento.php",
  "text"=>"Crea nuovo insegnamento"
);

$table_headers = array("Codice", "Corso di laurea", "Nome", "Descrizione", "Anno", "Responsabile", "Propedeuticità", array("colspan"=>"2", "text"=>"Controlli"));

$qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __nome, __descrizione, __anno, __responsabile, __nome_responsabile, __email_responsabile, __propedeuticita FROM unimia.get_insegnamenti()";
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
        array("type"=>"text", "val"=>$row["__codice"]),
        array("type"=>"text", "val"=>$row["__corso_di_laurea"]." - ".$row["__nome_corso_di_laurea"]),
        array("type"=>"text", "val"=>$row["__nome"]),
        array("type"=>"text", "val"=>$row["__descrizione"]),
        array("type"=>"text", "val"=>$row["__anno"]),
        array("type"=>"text", "val"=>$row["__nome_responsabile"]."<br>".$row["__email_responsabile"]),
        array("type"=>"text", "val"=>$row["__propedeuticita"] == "" ? "-" : $row["__propedeuticita"]),
        array(
          "type"=>"button",
          "target"=>"modifica_insegnamento.php",
          "submit"=>"Modifica",
          "class"=>"is-link",
          "params"=>array(
            "codice"=>$row["__codice"],
            "corso_di_laurea"=>$row["__corso_di_laurea"],
            "nome_corso_di_laurea"=>$row["__nome_corso_di_laurea"],
            "nome"=>$row["__nome"],
            "descrizione"=>$row["__descrizione"],
            "anno"=>$row["__anno"],
            "responsabile"=>$row["__responsabile"],
            "nome_responsabile"=>$row["__nome_responsabile"],
            "email_responsabile"=>$row["__email_responsabile"],
            "propedeuticita"=>$row["__propedeuticita"]
          )
        ),
        array(
          "type"=>"button",
          "target"=>"elimina_insegnamento.php",
          "submit"=>"Elimina",
          "class"=>"is-danger",
          "params"=>array(
            "codice"=>$row["__codice"],
            "corso_di_laurea"=>$row["__corso_di_laurea"],
            "nome_corso_di_laurea"=>$row["__nome_corso_di_laurea"],
            "nome"=>$row["__nome"],
            "descrizione"=>$row["__descrizione"],
            "anno"=>$row["__anno"],
            "responsabile"=>$row["__responsabile"],
            "nome_responsabile"=>$row["__nome_responsabile"],
            "email_responsabile"=>$row["__email_responsabile"],
            "propedeuticita"=>$row["__propedeuticita"]
          )
        )
      )
    )
  );
}

require("../components/table.php");

?>
