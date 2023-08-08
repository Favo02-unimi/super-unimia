<?php

require_once("utils.php");

if (isset($_SESSION["userid"])) {
  require("redirector.php");
}

$email = $_POST["email"] . $_POST["type"];
// $password = password_hash($_POST["password"], PASSWORD_DEFAULT);
$password = $_POST["password"];

$qry = "SELECT __id, __type FROM unimia.login($1, $2)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($email, $password));

$row = pg_fetch_assoc($res);

if (is_null($row["__id"])) {
  Redirect("../index.php");
}

$_SESSION["userid"] = $row["__id"];
$_SESSION["usertype"] = $row["__type"];

require("redirector.php");

?>
