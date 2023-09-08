<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Profilo utente - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  // missing login: redirect to login page
  if (!isset($_SESSION["userid"])) {
    Redirect("index.php");
  }

  require("../navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <h1 class="title"><i class="fa-solid fa-address-card"></i> Il tuo profilo:</h1>
  
    <?php

    $qry = "SELECT * FROM unimia.get_" . $_SESSION["usertype"] . "($1)";
    $res = pg_prepare($con, "", $qry);
    $res = pg_execute($con, "", array($_SESSION["userid"]));

    $row = pg_fetch_assoc($res);

    foreach ($row as $key => $value): ?>

      <label class="label mt-5"><?php echo ucfirst(str_replace("_", " ", substr($key, 2))); ?>:</label>
      <input class="input" type="text" value="<?php echo $value ?>" readonly>

    <?php endforeach; ?>

  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
