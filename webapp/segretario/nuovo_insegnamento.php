<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Nuovo insegnamento - SuperUnimia</title>
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
        $qry = "CALL unimia.new_insegnamento($1, $2, $3, $4, $5, $6);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["codice"], $_POST["corso_di_laurea"], $_POST["nome"], $_POST["descrizione"], $_POST["anno"], $_POST["responsabile"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la creazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Insegnamento creato con successo.";
          Redirect("home.php");
        endif;
      }
    ?>
    
    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-book fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Nuovo insegnamento</h1>
      </span>

      <label class="label mt-5">Codice</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="codice" placeholder="INF/00" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-barcode"></i>
          </span>
        </p>
        <p class="help">Lunghezza massima codice 6 caratteri.</p>
      </div>

      <label class="label mt-5">Corso di laurea</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="corso_di_laurea">
              <?php
                $qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
                $res = pg_prepare($con, "", $qry);
                $res = pg_execute($con, "", array());
        
                while ($row = pg_fetch_assoc($res)):
              ?>
                <option value="<?php echo $row["__codice"] ?>"><?php echo $row["__codice"] ?> - <?php echo $row["__nome"] ?></option>
              <?php endwhile ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-graduation-cap"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="nome" placeholder="Nome" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-center"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Descrizione</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="descrizione" placeholder="Descrizione" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-justify"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Anno</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="anno">
              <option>1</option>
              <option>2</option>
              <option>3</option>
              <option>4</option>
              <option>5</option>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-calendar-days"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Responsabile</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="responsabile">
              <?php
                $qry = "SELECT __id, __nome, __cognome, __email FROM unimia.get_docenti()";
                $res = pg_prepare($con, "", $qry);
                $res = pg_execute($con, "", array());
        
                while ($row = pg_fetch_assoc($res)):
              ?>
                <option value="<?php echo $row["__id"] ?>"><?php echo $row["__nome"] . " " . $row["__cognome"] ?> - <?php echo $row["__email"] ?></option>
              <?php endwhile ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-user-tie"></i>
          </div>
        </div>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Crea insegnamento" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>
  
  </div>
    
</body>
</html>
