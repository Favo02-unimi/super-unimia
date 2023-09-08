<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.disiscriviti_appello($1, $2);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_SESSION["userid"], $_POST["codice"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Discrizione avvenuta con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "studente";
$fa_icon = "fa-calendar-day";
$title = "Disiscriviti appello";
$subtitle = "Disiscriviti dall'appello selezionato.";

$class = "is-danger";
$help = "Solo se non è un appello passato";

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
  ),
  array(
    "type"=>"text",
    "label"=>"Ultimo voto",
    "name"=>"ultimo_voto",
    "value"=>$_POST["ultimo_voto"] == "" ? "Mai sostenuto" : $_POST["ultimo_voto"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-marker",
    "help"=>""
  )
);

require("../components/form.php");

?>
