<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.delete_studente($1);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["id"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Studente eliminato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-graduate";
$title = "Elimina studente";
$subtitle = "";

$class = "is-danger";
$help = "";

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"id",
    "value"=>$_POST["id"]
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "readonly"=>"readonly",
    "placeholder"=>"Nome",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Cognome",
    "name"=>"cognome",
    "value"=>$_POST["cognome"],
    "readonly"=>"readonly",
    "placeholder"=>"Cognome",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Email",
    "name"=>"email",
    "value"=>$_POST["email"],
    "readonly"=>"readonly",
    "placeholder"=>"Email",
    "icon"=>"fa-envelope",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Matricola",
    "name"=>"matricola",
    "value"=>$_POST["matricola"],
    "readonly"=>"readonly",
    "placeholder"=>"Matricola",
    "icon"=>"fa-hashtag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Corso di laurea",
    "name"=>"corso_di_laurea",
    "value"=>$_POST["corso_di_laurea"]." - ".$_POST["nome_corso_di_laurea"],
    "readonly"=>"readonly",
    "placeholder"=>"Corso di laurea",
    "icon"=>"fa-graduation-cap",
    "help"=>""
  )
);

require("../components/form.php");

?>
