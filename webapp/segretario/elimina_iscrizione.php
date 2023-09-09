<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.disiscriviti_appello($1, $2);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["studente"], $_POST["appello"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Iscrizione eliminata con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-calendar-day";
$title = "Cancella iscrizione appello";
$subtitle = "";

$class = "is-danger";
$help = "";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"appello",
    "value"=>$_POST["appello"]
  ),
  array(
    "type"=>"hidden",
    "name"=>"studente",
    "value"=>$_POST["studente"]
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
    "label"=>"Studente",
    "name"=>"nome_studente",
    "value"=>$_POST["nome_studente"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-user-graduate",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Matricola",
    "name"=>"matricola",
    "value"=>$_POST["matricola"],
    "readonly"=>"readonly",
    "placeholder"=>"",
    "icon"=>"fa-id-card",
    "help"=>""
  )
);

require("../components/form.php");

?>
