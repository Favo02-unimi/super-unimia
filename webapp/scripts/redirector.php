<?php
// redirector for all non-root pages, so scripts/*, studente/*, docente/*, segretario/*

require_once("utils.php");

// missing login: redirect to login page
if (!isset($_SESSION["userid"])) {
  Redirect("../index.php");
}

// redirect to homepage for every user
// ignore redirection if current page ($CUR_PAGE) is already the same of usertype 
if ((!isset($CUR_PAGE)) || $_SESSION["usertype"] != $CUR_PAGE) {

  switch ($_SESSION["usertype"]) {
  case "studente":
    Redirect("../studente/home.php");
  case "docente":
    Redirect("../docente/home.php");
  case "segretario":
    Redirect("../segretario/home.php");
  }
}

?>
