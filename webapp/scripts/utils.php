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
  $endPos = strpos($error, "DETAIL:");
  
  return substr($error, $startPos + 7, $endPos - $startPos - 8);
}

?>
