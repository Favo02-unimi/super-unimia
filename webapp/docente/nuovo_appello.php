<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Nuovo appello - SuperUnimia</title>
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
        $qry = "CALL unimia.new_appello($1, $2, $3, $4);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["insegnamento"], $_POST["data"], $_POST["ora"], $_POST["luogo"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la creazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Appello creato con successo.";
          Redirect("home.php");
        endif;
      }
    ?>
    
    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-calendar-day fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Nuovo appello</h1>
      </span>

      <label class="label mt-5">Insegnamento</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="insegnamento">
              <?php
                $qry = "SELECT __codice, __nome, __nome_corso_di_laurea FROM unimia.get_insegnamenti_per_docente($1)";
                $res = pg_prepare($con, "", $qry);
                $res = pg_execute($con, "", array($_SESSION["userid"]));
        
                while ($row = pg_fetch_assoc($res)):
              ?>
                <option value="<?php echo $row["__codice"] ?>"><?php echo $row["__nome_corso_di_laurea"] ?> - <?php echo $row["__codice"] ?> - <?php echo $row["__nome"] ?></option>
              <?php endwhile ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-book"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Data</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="date" name="data" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-calendar-days"></i>
          </span>
        </p>
        <p class="help">È possibile create appelli con date furute.</p>
      </div>

      <label class="label mt-5">Ora</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="time" name="ora" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-clock"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Luogo</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="luogo" placeholder="Luogo" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-location-dot"></i>
          </span>
        </p>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Crea appello" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>
  
  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
