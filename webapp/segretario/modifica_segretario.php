<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Modifica segretario - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../components/navbar.php");

  ?>

  <div class="container is-max-desktop">

    <?php

      if (isset($_POST["submit"])) {
        $qry = "CALL unimia.edit_segretario($1, $2, $3, $4);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["id"], $_POST["nome"], $_POST["cognome"], $_POST["email"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la modifica:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Segretario modificato con successo.";
          Redirect("home.php");
        endif;
      }

    ?>

      <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-user-gear fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Modifica Segretario</h1>
      </span>

      <input class="input" type="hidden" name="id" value="<?php echo $_POST["id"] ?>" required>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="nome" placeholder="Nome" value="<?php echo $_POST["nome"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-user-tag"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Cognome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="cognome" placeholder="Cognome" value="<?php echo $_POST["cognome"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-user-tag"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Email</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="email" placeholder="Email" value="<?php echo $_POST["email"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-envelope"></i>
          </span>
        </p>
      </div>

      <div class="icon-text mt-5">
        <span class="icon">
          <i class="fa-solid fa-circle-info"></i>
        </span>
        <span>Modificando manualmente nome, cognome o email, potrebbero generarsi inconsistenze tra email ed effetivo nome e cognome del segretario.</span>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Modifica segretario" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>

  </div>
    
  <?php require("../components/footer.php"); ?>

</body>
</html>
