<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_appello($1, $2, $3, $4);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"], $_POST["data"], $_POST["ora"], $_POST["luogo"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Appello modificato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-calendar-day";
$title = "Modifica appello";
$subtitle = "";

$class = "is-link";
$help = "È possibile modificare solo appelli non passati. I campi lasciati vuoti non saranno modificati.";

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
    "type"=>"date",
    "label"=>"Data",
    "name"=>"data",
    "value"=>$_POST["data"],
    "placeholder"=>"",
    "icon"=>"fa-calendar-days",
    "help"=>"È possibile spostare solo la data nel futuro."
  ),
  array(
    "type"=>"time",
    "label"=>"Ora",
    "name"=>"ora",
    "value"=>$_POST["ora"],
    "placeholder"=>"",
    "icon"=>"fa-clock",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Luogo",
    "name"=>"luogo",
    "value"=>$_POST["luogo"],
    "placeholder"=>"Luogo",
    "icon"=>"fa-location-dot",
    "help"=>""
  )
);

require("../components/form.php");

?>
