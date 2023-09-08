<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Visualizza carriere - SuperUnimia</title>
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
        <i class="fa-solid fa-marker fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Carriere degli studenti</h1>
    </span>
    <h2 class="subtitle">Vengono visualizzate tutte le valutazioni, anche quelle non valide perchè insufficienti o sovrascritte da una valutazione più recente.</h2>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Docente</th>
          <th class="has-text-centered">Studente</th>
          <th class="has-text-centered">Matricola</th>
          <th class="has-text-centered">Voto</th>
          <th class="has-text-centered">Valida</th>
          <th colspan="1" class="has-text-centered">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __appello, __insegnamento, __nome_insegnamento, __data, __nome_docente, __studente, __nome_studente, __matricola_studente, __voto, __valida FROM unimia.get_valutazioni()";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array());

        while ($row = pg_fetch_assoc($res)):
        ?>
        <?php
          if ($curCdl != $row["__studente"]):
          $curCdl = $row["__studente"];
        ?>
          <tr>
            <td colspan="8" class="has-text-centered has-text-weight-bold"><?php echo $row["__matricola_studente"] ?> - <?php echo $row["__nome_studente"] ?></td>
          </tr>
        <?php endif ?>
          <tr class="<?php if ($row["__valida"] == "f") echo "invalid" ?>">
            <td><?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?></td>
            <td><?php echo $row["__data"] ?></td>
            <td><?php echo $row["__nome_docente"] ?></td>
            <td><?php echo $row["__nome_studente"] ?></td>
            <td><?php echo $row["__matricola_studente"] ?></td>
            <td><?php echo $row["__voto"] ?></td>
            <td><?php echo $row["__valida"] == "f" ? "<i>Non valida</i>" : "<b>Valida</b>" ?></td>
            <td>
              <form method="post" action="modifica_valutazione.php">
                <input type="hidden" name="appello" value="<?php echo $row["__appello"] ?>">
                <input type="hidden" name="studente" value="<?php echo $row["__studente"] ?>">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__insegnamento"] ?>">
                <input type="hidden" name="nome_insegnamento" value="<?php echo $row["__nome_insegnamento"] ?>">
                <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                <input type="hidden" name="matricola" value="<?php echo $row["__matricola_studente"] ?>">
                <input type="hidden" name="nome" value="<?php echo $row["__nome_studente"] ?>">
                <input type="hidden" name="voto" value="<?php echo $row["__voto"] ?>">
                <button class="button is-link is-small">Modifica</button>
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
