<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_studente($1, $2, $3, $4, $5, $6);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["id"], $_POST["nome"], $_POST["cognome"], $_POST["email"], $_POST["matricola"], $_POST["corso_di_laurea"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Studente modificato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-graduate";
$title = "Modifica studente";
$subtitle = "";

$class = "is-link";
$help = "Modificando manualmente nome, cognome o email, potrebbero generarsi inconsistenze tra email ed effetivo nome e cognome dello studente. I campi lasciati vuoti non saranno modificati.";

// options query
$qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$options = array();
while ($row = pg_fetch_assoc($res)) {
  if ($row["__codice"] != $_POST["corso_di_laurea"]) {
    $options[$row["__codice"]] = $row["__codice"]." - ".$row["__nome"];
  }
}
$selected = array();
$selected[$_POST["corso_di_laurea"]] = $_POST["corso_di_laurea"]." - ".$_POST["nome_corso_di_laurea"];

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
  ),
  array(
    "type"=>"text",
    "label"=>"Matricola",
    "name"=>"matricola",
    "value"=>$_POST["matricola"],
    "placeholder"=>"Matricola",
    "icon"=>"fa-hashtag",
    "help"=>""
  ),
  array(
    "type"=>"select",
    "label"=>"Corso di laurea",
    "name"=>"corso_di_laurea",
    "options"=>$options,
    "selected"=>$selected,
    "icon"=>"fa-graduation-cap"
  )
);

require("../components/form.php");

?>
