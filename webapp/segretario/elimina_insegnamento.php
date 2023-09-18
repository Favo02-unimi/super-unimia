<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.delete_insegnamento($1);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Insegnamento eliminato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-book";
$title = "Elimina insegnamento";
$subtitle = "";

$class = "is-danger";
$help = "È possibile eliminare un insegnamento solo se non esistono appelli (futuri i passati) dell'insegnamento.";

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
    "label"=>"Corso di laurea",
    "name"=>"corso_di_laurea",
    "value"=>$_POST["corso_di_laurea"]." - ".$_POST["nome_corso_di_laurea"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-graduation-cap",
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
  ),
  array(
    "type"=>"text",
    "label"=>"Anno",
    "name"=>"anno",
    "value"=>$_POST["anno"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-calendar-days",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Responsabile",
    "name"=>"nome_responsabile",
    "value"=>$_POST["nome_responsabile"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-user-tie",
    "help"=>""
  )
);

require("../components/form.php");

?>
