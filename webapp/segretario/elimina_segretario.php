<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.delete_segretario($1);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["id"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Segretario eliminato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-gear";
$title = "Elimina segretario";
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
  )
);

require("../components/form.php");

?>
