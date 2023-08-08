<?php
// redirectot for root level files (only index.php)

require_once("utils.php");

if (isset($_SESSION["userid"])) {
  switch ($_SESSION["usertype"]) {
    case "studente":
      Redirect("studente/home.php");
    case "docente":
      Redirect("docente/home.php");
    case "segretario":
      Redirect("segretario/home.php");
  }
}

?>
