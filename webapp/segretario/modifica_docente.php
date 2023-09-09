<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_docente($1, $2, $3, $4);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["id"], $_POST["nome"], $_POST["cognome"], $_POST["email"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Docente modificato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-tie";
$title = "Modifica docente";
$subtitle = "";

$class = "is-link";
$help = "Modificando manualmente nome, cognome o email, potrebbero generarsi inconsistenze tra email ed effetivo nome e cognome del docente.";

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
    "placeholder"=>"Nome",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Cognome",
    "name"=>"cognome",
    "value"=>$_POST["cognome"],
    "placeholder"=>"Cognome",
    "icon"=>"fa-user-tag",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Email",
    "name"=>"email",
    "value"=>$_POST["email"],
    "placeholder"=>"Email",
    "icon"=>"fa-envelope",
    "help"=>""
  )
);

require("../components/form.php");

?>
