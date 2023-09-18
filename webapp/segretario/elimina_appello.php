<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.delete_appello($1);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Appello eliminato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-calendar-day";
$title = "Elimina appello";
$subtitle = "";

$class = "is-danger";
$help = "È possibile eliminare un appello solo se non sono presenti iscrizioni o valutazioni per questo appello.";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"codice",
    "value"=>$_POST["codice"]
  ),
  array(
    "type"=>"text",
    "label"=>"Corso di laurea",
    "name"=>"nome_corso_di_laurea",
    "value"=>$_POST["nome_corso_di_laurea"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-graduation-cap",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Insengamento",
    "name"=>"nome_insegnamento",
    "value"=>$_POST["nome_insegnamento"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-book",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Data",
    "name"=>"data",
    "value"=>$_POST["data"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-calendar-days",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Ora",
    "name"=>"ora",
    "value"=>$_POST["ora"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-clock",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Luogo",
    "name"=>"luogo",
    "value"=>$_POST["luogo"],
    "readonly"=>"readonly",
    "placeholder"=>"Luogo",
    "icon"=>"fa-location-dot",
    "help"=>""
  )
);

require("../components/form.php");

?>
