<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Elimina corso di laurea - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-desktop">

    <?php

      if (isset($_POST["submit"])) {
        $qry = "CALL unimia.delete_corso_di_laurea($1);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["codice"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la cancellazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Corso di laurea eliminato con successo.";
          Redirect("home.php");
        endif;
      }

    ?>

      <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-graduation-cap fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Elimina corso di laurea</h1>
      </span>

      <input class="input" type="hidden" name="codice" value="<?php echo $_POST["codice"] ?>" required>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Conferma cancellazione" class="button is-danger is-fullwidth is-medium">
        </p>
        <p class="help is-danger">È possibile cancellare un corso di laurea solo in caso non sia mai utilizzato (non abbia docenti o insegnamenti associati). Utilizzare l'archivio per dismettere.</p>
      </div>

    </form>

  </div>

  <?php require("../footer.php"); ?>

</body>
</html>
