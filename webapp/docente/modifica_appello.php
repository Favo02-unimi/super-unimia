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

$CUR_PAGE = "docente";
$fa_icon = "fa-calendar-day";
$title = "Modifica appello";
$subtitle = "";

$class = "is-link";
$help = "È possibile modificare solo appelli futuri. I campi lasciati vuoti non saranno modificati.";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"codice",
    "value"=>$_POST["codice"]
  ),
  array(
    "type"=>"text",
    "label"=>"Insegnamento",
    "name"=>"insegnamento",
    "value"=>$_POST["insegnamento"]." - ".$_POST["nome_insegnamento"],
    "placeholder"=>"Insegnamento",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-book",
    "help"=>""
  ),
  array(
    "type"=>"date",
    "label"=>"Data",
    "name"=>"data",
    "value"=>$_POST["data"],
    "placeholder"=>"",
    "required"=>"required",
    "icon"=>"fa-calendar-days",
    "help"=>"Non è possibile spostare un appello ad una data passata."
  ),
  array(
    "type"=>"time",
    "label"=>"Ora",
    "name"=>"ora",
    "value"=>$_POST["ora"],
    "placeholder"=>"",
    "required"=>"required",
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
