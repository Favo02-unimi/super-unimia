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

?>