<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.delete_corso_di_laurea($1);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Corso di laurea eliminato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-graduation-cap";
$title = "Elimina corso di laurea";
$subtitle = "";

$class = "is-danger";
$help = "È possibile eliminare un corso di laurea solo se non sono presenti insegnamenti o iscritti al corso di laurea.";

$inputs = array(
  array(
    "type"=>"text",
    "label"=>"Codice",
    "name"=>"codice",
    "value"=>$_POST["codice"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-barcode",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Tipo",
    "name"=>"tipo",
    "value"=>$_POST["tipo"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-calendar-days",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-align-center",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Descrizione",
    "name"=>"descrizione",
    "value"=>$_POST["descrizione"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-align-justify",
    "help"=>""
  )
);

require("../components/form.php");

?>
