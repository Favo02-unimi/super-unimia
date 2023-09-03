<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione insegnamenti - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "docente";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <span class="icon-text mb-4">
      <span class="icon is-large">
        <i class="fa-solid fa-book fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Gestione insegnamenti</h1>
    </span>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Codice</th>
          <th class="has-text-centered">Corso di laurea</th>
          <th class="has-text-centered">Nome</th>
          <th class="has-text-centered">Descrizione</th>
          <th class="has-text-centered">Anno</th>
          <th class="has-text-centered" colspan="3">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __nome, __descrizione, __anno FROM unimia.get_insegnamenti_per_docente($1)";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_SESSION["userid"]));

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__codice"] ?></td>
            <td><?php echo $row["__corso_di_laurea"] ?> - <?php echo $row["__nome_corso_di_laurea"] ?></td>
            <td><?php echo $row["__nome"] ?></td>
            <td><?php echo $row["__descrizione"] ?></td>
            <td><?php echo $row["__anno"] ?></td>
            <td>
              <form method="post" action="gestione_appelli.php">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__codice"] ?>">
                <button class="button is-link is-small">Appelli</button>
              </form>
            </td>
            <td>
              <form method="post" action="gestione_iscrizioni.php">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__codice"] ?>">
                <button class="button is-link is-small">Iscritti</button>
              </form>
            </td>
            <td>
              <form method="post" action="gestione_valutazioni.php">
                <input type="hidden" name="insegnamento" value="<?php echo $row["__codice"] ?>">
                <button class="button is-link is-small">Valutazioni</button>
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
