<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Elimina docente - SuperUnimia</title>
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
        $qry = "CALL unimia.delete_docente($1);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["id"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la cancellazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Docente eliminato con successo.";
          Redirect("home.php");
        endif;
      }

    ?>

      <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-user-tie fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Elimina docente</h1>
      </span>

      <input class="input" type="hidden" name="id" value="<?php echo $_POST["id"] ?>" required>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Conferma cancellazione" class="button is-danger is-fullwidth is-medium">
        </p>
        <p class="help is-danger">È possibile cancellare un docente solo in caso non sia mai utilizzato (non abbia appelli o insegnamenti). Utilizzare l'archivio per dismettere.</p>
      </div>

    </form>

  </div>

  <?php require("../components/footer.php"); ?>
    
</body>
</html>
