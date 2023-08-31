<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Modifica password - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "docente";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-desktop">

    <?php

      if (isset($_POST["submit"])) {
        $qry = "CALL unimia.edit_password($1, $2, $3);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_SESSION["userid"], $_POST["old_password"], $_POST["password"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la modifica:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Password aggiornata con successo.";
          Redirect("home.php");
        endif;
      }

    ?>

    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-lock fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Modifica password</h1>
      </span>

      <label class="label mt-5">Vecchia password</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="password" name="old_password" placeholder="Password" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-lock"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Nuova password</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="password" name="password" placeholder="Password" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-lock"></i>
          </span>
        </p>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Aggiorna password" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>

  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
