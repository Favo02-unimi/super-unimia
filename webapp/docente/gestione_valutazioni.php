<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione valutazioni - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "docente";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Matricola</th>
          <th class="has-text-centered">Nome</th>
          <th class="has-text-centered">Email</th>
          <th class="has-text-centered">Voto</th>
          <th class="has-text-centered" colspan="1">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __appello, __insegnamento, __nome_insegnamento, __data, __studente, __matricola, __nome, __email, __voto FROM unimia.get_valutazioni_per_docente($1)";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_SESSION["userid"]));

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?></td>
            <td><?php echo $row["__data"] ?></td>
            <td><?php echo $row["__matricola"] ?></td>
            <td><?php echo $row["__nome"] ?></td>
            <td><?php echo $row["__email"] ?></td>
            <td><?php echo $row["__voto"] ?></td>
            <td>
              <form method="post" action="valuta_iscrizione.php">
                <input type="hidden" name="appello" value="<?php echo $row["__appello"] ?>">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__insegnamento"] ?>">
                <input type="hidden" name="nome_insegnamento" value="<?php echo $row["__nome_insegnamento"] ?>">
                <input type="hidden" name="data" value="<?php echo $row["__data"] ?>">
                <input type="hidden" name="studente" value="<?php echo $row["__studente"] ?>">
                <input type="hidden" name="matricola" value="<?php echo $row["__matricola"] ?>">
                <input type="hidden" name="nome" value="<?php echo $row["__nome"] ?>">
                <input type="hidden" name="email" value="<?php echo $row["__email"] ?>">
                <input type="hidden" name="voto" value="<?php echo $row["__voto"] ?>">
                <button class="button is-link is-small">Modifica</button>
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
