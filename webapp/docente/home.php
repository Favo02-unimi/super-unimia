<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Home docente - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "docente";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-desktop box">

    <?php if (isset($_SESSION["feedback"])): ?>
      <div class="notification is-success is-light mt-6">
        <strong><?php echo $_SESSION["feedback"]; unset($_SESSION["feedback"]) ?></strong>
      </div>
    <?php endif; ?>

    <div class="block">
      <p class="title is-2 is-link">Buongiorno, <?php echo $_SESSION["username"]; ?>.</p>
      <p class="subtitle is-4">Servizi accessibili come <?php echo $_SESSION["usertype"]; ?>:</p>
    </div>

    <a href="profilo.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-address-card fa-xl"></i></span>
      <strong>Profilo</strong>
    </a>

    <a href="modifica_password.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-lock fa-xl"></i></span>
      <strong>Modifica password</strong>
    </a>

    <a href="gestione_insegnamenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-book fa-xl"></i></span>
      <strong>Gestione insegnamenti</strong>
    </a>

    <a href="gestione_appelli.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-calendar-day fa-xl"></i></span>
      <strong>Gestione appelli</strong>
    </a>

  </div>

  <?php require("../footer.php"); ?>

</body>
</html>
