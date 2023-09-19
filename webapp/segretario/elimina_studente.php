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


$qry = "SELECT count(*) as rimanenti FROM unimia.get_esami_mancanti_per_studente($1);";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_POST["id"]));

$row = pg_fetch_assoc($res);

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-graduate";
$title = "Elimina studente";
$subtitle = $row["rimanenti"] == 0
  ? "Lo studente verrà spostato nell'archivio con motivazione <b>\"Laurea\"</b> dato che ha superato tutti gli esami previsti dal corso di laurea."
  : "Lo studente verrà spostato nell'archivio con motivazione <b>\"Rinuncia agli studi\"</b> dato che NON ha superato tutti gli esami previsti dal corso di laurea.";

$class = "is-danger";
$help = $subtitle;

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
