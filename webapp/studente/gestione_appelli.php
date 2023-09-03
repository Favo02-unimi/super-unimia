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

  $CUR_PAGE = "studente";
  require("../scripts/redirector.php");

  require("../navbar.php");

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
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Ora</th>
          <th class="has-text-centered">Luogo</th>
          <th class="has-text-centered">Ultima valutazione</th>
          <th class="has-text-centered" colspan="1">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __codice, __insegnamento, __nome_insegnamento, __data, __ora, __luogo, __ultimo_voto, __iscritto FROM unimia.get_appelli_per_studente($1)";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_SESSION["userid"]));

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?></td>
            <td><?php echo $row["__data"] ?></td>
            <td><?php echo $row["__ora"] ?></td>
            <td><?php echo $row["__luogo"] ?></td>
            <td><?php echo $row["__ultimo_voto"] == "" ? "<i>Mai sostenuto</i>" : $row["__ultimo_voto"] ?></td>
            <?php if ($row["__iscritto"] == "f"): ?>
              <td>
                <form method="post" action="iscriviti_appello.php">
                  <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                  <input type="hidden" name="insegnamento" value="<?php echo $row["__insegnamento"] ?>">
                  <input type="hidden" name="nome_insegnamento" value="<?php echo $row["__nome_insegnamento"] ?>">
                  <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                  <input type="hidden" name="ora" value="<?php echo $row["__ora"] ?>">
                  <input type="hidden" name="luogo" value="<?php echo $row["__luogo"] ?>">
                  <input type="hidden" name="ultimo_voto" value="<?php echo $row["__ultimo_voto"] ?>">
                  <button class="button is-link is-small">Iscriviti</button>
                </form>
              </td>
            <?php else: ?>
              <td>
                <form method="post" action="disiscriviti_appello.php">
                  <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                  <input type="hidden" name="insegnamento" value="<?php echo $row["__insegnamento"] ?>">
                  <input type="hidden" name="nome_insegnamento" value="<?php echo $row["__nome_insegnamento"] ?>">
                  <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                  <input type="hidden" name="ora" value="<?php echo $row["__ora"] ?>">
                  <input type="hidden" name="luogo" value="<?php echo $row["__luogo"] ?>">
                  <input type="hidden" name="ultimo_voto" value="<?php echo $row["__ultimo_voto"] ?>">
                  <button class="button is-danger is-small">Cancella iscrizione</button>
                </form>
              </td>
            <?php endif ?>
          </tr>
        <?php endwhile ?>
      </tbody>
    </table>

  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
