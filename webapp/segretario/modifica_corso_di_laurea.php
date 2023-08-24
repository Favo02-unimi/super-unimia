<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Modifica corso di laurea - SuperUnimia</title>
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
        $qry = "CALL unimia.edit_corso_di_laurea($1, $2, $3, $4, $5);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["codice"], $_POST["new_codice"], $_POST["tipo"], $_POST["nome"], $_POST["descrizione"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la modifica:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Corso di laurea modificato con successo.";
          Redirect("home.php");
        endif;
      }

    ?>

      <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-graduation-cap fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Modifica Corso di laurea</h1>
      </span>

      <input class="input" type="hidden" name="codice" value="<?php echo $_POST["codice"] ?>" required>

      <label class="label mt-5">Codice</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="new_codice" placeholder="L-00" value="<?php echo $_POST["codice"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-barcode"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Tipo</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="tipo">
              <option selected><?php echo $_POST["tipo"] ?></option>
              <option>Triennale</option>
              <option>Magistrale</option>
              <option>Magistrale a ciclo unico</option>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-calendar-days"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="nome" placeholder="Nome" value="<?php echo $_POST["nome"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-center"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Descrizione</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="descrizione" placeholder="Descrizione" value="<?php echo $_POST["descrizione"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-justify"></i>
          </span>
        </p>
      </div>

      <div class="icon-text mt-5">
        <span class="icon">
          <i class="fa-solid fa-circle-info"></i>
        </span>
        <span>I campi lasciati vuoti non saranno modificati.</span>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Modifica corso di laurea" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>

  </div>
    
</body>
</html>
