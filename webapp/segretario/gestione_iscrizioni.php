<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione iscrizioni - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <span class="icon-text mb-4">
      <span class="icon is-large">
        <i class="fa-solid fa-users fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Gestione iscrizioni</h1>
    </span>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Corso di laurea</th>
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Docente</th>
          <th class="has-text-centered">Studente</th>
          <th class="has-text-centered">Matricola</th>
          <th class="has-text-centered" colspan="1">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __appello, __corso_di_laurea, __nome_corso_di_laurea, __insegnamento, __nome_insegnamento, __data, __docente, __nome_docente, __studente, __nome_studente, __matricola FROM unimia.get_iscrizioni()";
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
            <td><?php echo $row["__nome_docente"] ?></td>
            <td><?php echo $row["__nome_studente"] ?></td>
            <td><?php echo $row["__matricola"] ?></td>
            <td>
              <form method="post" action="elimina_iscrizione.php">
                <input type="hidden" name="appello" value="<?php echo $row["__appello"] ?>">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__insegnamento"] ?>">
                <input type="hidden" name="nome_insegnamento" value="<?php echo $row["__nome_insegnamento"] ?>">
                <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                <input type="hidden" name="studente" value="<?php echo $row["__studente"] ?>">
                <input type="hidden" name="nome_studente" value="<?php echo $row["__nome_studente"] ?>">
                <button class="button is-danger is-small">Cancella iscrizione</button>
              </form>
            </td>
          </tr>
        <?php endwhile ?>
      </tbody>
    </table>

  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
