<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Nuovo studente - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("navbar.php");

  ?>

  <div class="container is-max-desktop">

    <?php

      if (isset($_POST["submit"])) {
        $qry = "CALL unimia.new_studente($1, $2, $3);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["nome"], $_POST["cognome"], $_POST["password"]));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la creazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: ?>
          <div class="notification is-success is-light mt-6">
            <strong>Studente creato con successo.</strong>
            <a href="home.php">Torna alla home.</a>
          </div>
        <?php endif;
      }
    ?>
    
    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-user-graduate fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Nuovo studente</h1>
      </span>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="nome" placeholder="Nome" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-user-tag"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Cognome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="cognome" placeholder="Cognome" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-user-tag"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Password</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="password" name="password" placeholder="Password" required>
          <span class="icon is-small is-left">
            <i class="fa-solid fa-lock"></i>
          </span>
        </p>
        <p class="help">Lunghezza minima 8 caratteri.</p>
      </div>

      <div class="icon-text mt-5">
        <span class="icon">
          <i class="fa-solid fa-circle-info"></i>
        </span>
        <span>Email e matricola verranno generati automaticamente.</span>
      </div>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Crea utente" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>
  
  </div>
    
</body>
</html>