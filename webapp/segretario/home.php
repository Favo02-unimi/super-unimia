<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Home segretario - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
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

    <a href="modifica_password.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-lock fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-pen-to-square"></i></span>
      <strong>Modifica password ad un utente</strong>
    </a>

    <a href="gestione_studenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-graduate fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-list"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-pen-to-square"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-trash"></i></span>
      <strong>Gestione studenti</strong>
    </a>

    <a href="gestione_docenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-tie fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-list"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-pen-to-square"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-trash"></i></span>
      <strong>Gestione docenti</strong>
    </a>

    <a href="gestione_segretari.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-gear fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-list"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-pen-to-square"></i></span>
      <span class="icon is-small"><i class="fa-solid fa-trash"></i></span>
      <strong>Gestione segretari</strong>
    </a>
    
  </div>
    
</body>
</html>
