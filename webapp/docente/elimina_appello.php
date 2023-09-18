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

$CUR_PAGE = "docente";
$fa_icon = "fa-calendar-day";
$title = "Elimina appello";
$subtitle = "È possibile eliminare un appello solo se non sono presenti iscrizioni o valutazioni per questo appello.";

$class = "is-danger";
$help = "È possibile cancellare un appello solo in caso non sia mai utilizzato (non risultino studenti iscritti e/o voti registrati).";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"codice",
    "value"=>$_POST["codice"]
  ),
  array(
    "type"=>"text",
    "label"=>"Insegnamento",
    "name"=>"nome_insegnamento",
    "value"=>$_POST["insegnamento"]." - ".$_POST["nome_insegnamento"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-book",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Data",
    "name"=>"data",
    "value"=>$_POST["data"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-calendar-days",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Ora",
    "name"=>"ora",
    "value"=>$_POST["ora"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-clock",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Luogo",
    "name"=>"luogo",
    "value"=>$_POST["luogo"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-location-dot",
    "help"=>""
  )
);

require("../components/form.php");

?>
