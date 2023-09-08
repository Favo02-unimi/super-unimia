<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.valuta_iscrizione($1, $2, $3);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["studente"], $_POST["appello"], $_POST["voto"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Valutazione inserita con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "docente";
$fa_icon = "fa-marker";
$title = "Valuta iscrizione";
$subtitle = "";

$class = "is-link";
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
    "label"=>"Insegnamento",
    "name"=>"nome_insegnamento",
    "value"=>$_POST["insegnamento"]." - ".$_POST["nome_insegnamento"],
    "placeholder"=>"Insegnamento",
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
    "label"=>"Matricola",
    "name"=>"matricola",
    "value"=>$_POST["matricola"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-barcode",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-align-center",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Email",
    "name"=>"email",
    "value"=>$_POST["email"],
    "placeholder"=>"",
    "required"=>"required",
    "readonly"=>"readonly",
    "icon"=>"fa-envelope",
    "help"=>""
  ),
  array(
    "type"=>"number",
    "label"=>"Voto",
    "name"=>"voto",
    "value"=>$_POST["voto"],
    "placeholder"=>"18",
    "required"=>"required",
    "icon"=>"fa-marker",
    "help"=>"Un voto inferiore a 18 comporta la bocciatura, tra 18 e 30 la promozione e 31 la lode."
  ),
);

require("../components/form.php");

?>
