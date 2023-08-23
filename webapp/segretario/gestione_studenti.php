<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione studenti - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-desktop box">

    <a href="nuovo_studente.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-graduate fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <strong>Crea nuovo studente</strong>
    </a>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Nome</th>
          <th class="has-text-centered">Cognome</th>
          <th class="has-text-centered">Email</th>
          <th class="has-text-centered">Matricola</th>
          <th class="has-text-centered" colspan="3">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __id, __nome, __cognome, __email, __matricola FROM unimia.get_studenti()";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array());

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__nome"] ?></td>
            <td><?php echo $row["__cognome"] ?></td>
            <td><?php echo $row["__email"] ?></td>
            <td><?php echo $row["__matricola"] ?></td>
            <td>
              <form method="post" action="modifica_studente.php">
                <input type="hidden" name="id" value="<?php echo $row["__id"] ?>">
                <input type="hidden" name="nome" value="<?php echo $row["__nome"] ?>">
                <input type="hidden" name="cognome" value="<?php echo $row["__cognome"] ?>">
                <input type="hidden" name="email" value="<?php echo $row["__email"] ?>">
                <input type="hidden" name="matricola" value="<?php echo $row["__matricola"] ?>">
                <button class="button is-link is-small">Modifica</button>
              </form>
            </td>
            <td>
              <form method="post" action="modifica_password.php">
                <input type="hidden" name="email" value="<?php echo $row["__email"] ?>">
                <button class="button is-link is-small">Modifica password</button>
              </form>
            </td>
            <td>
              <form method="post" action="elimina_studente.php">
                <input type="hidden" name="id" value="<?php echo $row["__id"] ?>">
                <button class="button is-danger is-small">Elimina</button>
              </form>
            </td>
          </tr>
        <?php endwhile ?>
      </tbody>
    </table>

  </div>
    
</body>
</html>
