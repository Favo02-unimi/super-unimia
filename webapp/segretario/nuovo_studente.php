<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.new_studente($1, $2, $3, $4);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["nome"], $_POST["cognome"], $_POST["password"], $_POST["corso_di_laurea"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Studente creato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-user-graduate";
$title = "Nuovo studente";
$subtitle = "";

$class = "is-link";
$help = "Email e matricola verranno generati automaticamente.";

// options query
$qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$options = array();
while ($row = pg_fetch_assoc($res)) {
  $options[$row["__codice"]] = $row["__codice"]." - ".$row["__nome"];
}
$selected = array();

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
