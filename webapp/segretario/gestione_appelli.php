<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione appelli - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../components/navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <span class="icon-text mb-4">
      <span class="icon is-large">
        <i class="fa-solid fa-calendar-day fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Gestione appelli</h1>
    </span>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Corso di laurea</th>
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Ora</th>
          <th class="has-text-centered">Luogo</th>
          <th class="has-text-centered">Docente</th>
          <th class="has-text-centered">Iscritti</th>
          <th class="has-text-centered" colspan="2">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __insegnamento, __nome_insegnamento, __data, __ora, __luogo, __docente, __nome_docente, __iscritti FROM unimia.get_appelli()";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array());

        while ($row = pg_fetch_assoc($res)):
        ?>
        <?php
          if ($curIns != $row["__insegnamento"]):
          $curIns = $row["__insegnamento"];
        ?>
          <tr>
            <td colspan="9" class="has-text-centered has-text-weight-bold">
              <?php echo $row["__corso_di_laurea"] ?> - <?php echo $row["__nome_corso_di_laurea"] ?>:
              <?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?>
            </td>
          </tr>
        <?php endif ?>
          <tr>
            <td><?php echo $row["__corso_di_laurea"] ?> - <?php echo $row["__nome_corso_di_laurea"] ?></td>
            <td><?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?></td>
            <td><?php echo $row["__data"] ?></td>
            <td><?php echo $row["__ora"] ?></td>
            <td><?php echo $row["__luogo"] ?></td>
            <td><?php echo $row["__nome_docente"] ?></td>
            <td><?php echo $row["__iscritti"] ?></td>
            <td>
              <form method="post" action="modifica_appello.php">
                <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                <input type="hidden" name="ora" value="<?php echo $row["__ora"] ?>">
                <input type="hidden" name="luogo" value="<?php echo $row["__luogo"] ?>">
                <button class="button is-link is-small">Modifica</button>
              </form>
            </td>
            <td>
              <form method="post" action="elimina_appello.php">
                <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                <button class="button is-danger is-small">Elimina</button>
              </form>
            </td>
          </tr>
        <?php endwhile ?>
      </tbody>
    </table>

  </div>
    
  <?php require("../components/footer.php"); ?>

</body>
</html>
