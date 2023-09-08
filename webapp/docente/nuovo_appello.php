<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.new_appello($1, $2, $3, $4);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["insegnamento"], $_POST["data"], $_POST["ora"], $_POST["luogo"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Appello creato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "docente";
$fa_icon = "fa-calendar-day";
$title = "Nuovo appello";
$subtitle = "";

$class = "is-link";
$help = "";

// options query
$qry = "SELECT __codice, __nome, __nome_corso_di_laurea FROM unimia.get_insegnamenti_per_docente($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_SESSION["userid"]));

$options = array();
while ($row = pg_fetch_assoc($res)) {
  $options[$row["__codice"]] = $row["__nome_corso_di_laurea"]." - ".$row["__codice"]." - ".$row["__nome"];
}

$inputs = array(
  array(
    "type"=>"select",
    "name"=>"insegnamento",
    "options"=>$options,
    "icon"=>"fa-book"
  ),
  array(
    "type"=>"date",
    "label"=>"Data",
    "name"=>"data",
    "value"=>"",
    "placeholder"=>"",
    "required"=>"required",
    "icon"=>"fa-calendar-days",
    "help"=>"È possibile creare solo appelli con data futura."
  ),
  array(
    "type"=>"time",
    "label"=>"Ora",
    "name"=>"ora",
    "value"=>"",
    "placeholder"=>"",
    "required"=>"required",
    "icon"=>"fa-clock",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Luogo",
    "name"=>"luogo",
    "value"=>$_POST["luogo"],
    "placeholder"=>"Luogo",
    "required"=>"required",
    "icon"=>"fa-location-dot",
    "help"=>""
  )
);

require("../components/form.php");

?>
