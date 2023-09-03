<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Valuta iscrizione - SuperUnimia</title>
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
        $qry = "CALL unimia.valuta_iscrizione($1, $2, $3);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["studente"], $_POST["appello"], $_POST["voto"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la creazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Valutazione inserita con successo.";
          Redirect("home.php");
        endif;
      }
    ?>
    
    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-users fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Valuta iscrizione</h1>
      </span>

      <input type="hidden" name="appello" value="<?php echo $_POST["appello"] ?>">
      <input type="hidden" name="studente" value="<?php echo $_POST["studente"] ?>">

      <label class="label mt-5">Insegnamento</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" value="<?php echo $_POST["insegnamento"] ?> - <?php echo $_POST["nome_insegnamento"] ?>" required disabled>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-book"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Data</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" value="<?php echo $_POST["data"] ?>" required disabled>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-calendar-days"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Matricola</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" value="<?php echo $_POST["matricola"] ?>" required disabled>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-barcode"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" value="<?php echo $_POST["nome"] ?>" required disabled>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-center"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Email</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" value="<?php echo $_POST["email"] ?>" required disabled>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-envelope"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Voto</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="number" name="voto" placeholder="Voto" value="<?php echo $_POST["voto"] ?>" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-marker"></i>
          </span>
        </p>
        <p class="help">Un voto inferiore a 18 comporta la bocciatura, tra 18 e 30 la promozione e 31 la lode.</p>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Valuta studente" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>
  
  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
