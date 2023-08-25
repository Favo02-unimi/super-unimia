<?php

// start session
session_start();

// connect to database
require_once("connection.php");

// redirect function util
function Redirect($url, $permanent = false) {
  header("Location: $url", true, $permanent ? 301 : 302);
  exit();
}

function ParseError($error) {
  $startPos = strpos($error, "ERROR:");

  $endPos1 = strpos($error, "DETAIL"); // end position for "default" errors
  $endPos2 = strpos($error, "CONTEX"); // end position for custom trigger exceptions
  
  $endPos1 = $endPos1 ? $endPos1 : PHP_INT_MAX;
  $endPos2 = $endPos2 ? $endPos2 : PHP_INT_MAX;

  return substr($error, $startPos + 7, min($endPos1, $endPos2) - $startPos - 8);
}

?>
