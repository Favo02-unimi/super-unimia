<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_user_password($1, $2);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["email"], $_POST["password"]));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Password aggiornata con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-lock";
$title = "Modifica password";
$subtitle = "Modifica password ad un utente data la sue email. È possibile anche modificare la propria password.";

$class = "is-link";
$help = "";

$inputs = array(
  array(
    "type"=>"text",
    "label"=>"Email",
    "name"=>"email",
    "value"=>$_POST["email"],
    "placeholder"=>"Email",
    "required"=>"required",
    "icon"=>"fa-envelope",
    "help"=>""
  ),
  array(
    "type"=>"password",
    "label"=>"Nuova password",
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
