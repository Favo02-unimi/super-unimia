<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.new_segretario($1, $2, $3);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["nome"], $_POST["cognome"], $_POST["password"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Segretario creato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-gear";
$title = "Nuovo segretario";
$subtitle = "";

$class = "is-link";
$help = "L'email verrà generata automaticamente.";

$inputs = array(
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "placeholder"=>"Nome",
    "required"=>"required",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Cognome",
    "name"=>"cognome",
    "value"=>$_POST["cognome"],
    "placeholder"=>"Cognome",
    "required"=>"required",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"password",
    "label"=>"Password",
    "name"=>"password",
    "value"=>$_POST["password"],
    "placeholder"=>"Password",
    "required"=>"required",
    "icon"=>"fa-lock",
    "help"=>""
  )
);

require("../components/form.php");

?>
