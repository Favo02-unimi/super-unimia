<?php

$title = "Profilo segretario";
require("../components/head.php");

require_once("../scripts/utils.php");

// missing login: redirect to login page
if (!isset($_SESSION["userid"])) {
  Redirect("index.php");
}

require("../components/navbar.php");

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
    
<?php require("../components/footer.php"); ?>
