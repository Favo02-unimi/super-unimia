<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_corso_di_laurea($1, $2, $3, $4, $5);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"], $_POST["new_codice"], $_POST["tipo"], $_POST["nome"], $_POST["descrizione"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Corso di laurea modificato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-graduation-cap";
$title = "Modifica Corso di laurea";
$subtitle = "";

$class = "is-link";
$help = "I campi lasciati vuoti non saranno modificati.";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"codice",
    "value"=>$_POST["codice"]
  ),
  array(
    "type"=>"text",
    "label"=>"Codice",
    "name"=>"new_codice",
    "value"=>$_POST["codice"],
    "placeholder"=>"Codice",
    "icon"=>"fa-barcode",
    "help"=>"Lunghezza massima codice 6 caratteri."
  ),
  array(
    "type"=>"select",
    "name"=>"tipo",
    "label"=>"Tipo",
    "icon"=>"fa-calendar-days",
    "selected"=>array(
      $_POST["tipo"]=>$_POST["tipo"]
    ),
    "options"=>array(
      "Triennale"=>"Triennale",
      "Magistrale"=>"Magistrale",
      "Magistrale a ciclo unico"=>"Magistrale a ciclo unico"
    ),
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "placeholder"=>"Nome",
    "icon"=>"fa-align-center",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Descrizione",
    "name"=>"descrizione",
    "value"=>$_POST["descrizione"],
    "placeholder"=>"Descrizione",
    "icon"=>"fa-align-justify",
    "help"=>""
  )
);

require("../components/form.php");

?>
