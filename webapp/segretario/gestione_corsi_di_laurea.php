<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Gestione corsi di laurea - SuperUnimia</title>
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
        <i class="fa-solid fa-graduation-cap fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Gestione corsi di laurea</h1>
    </span>

    <a href="nuovo_corso_di_laurea.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-graduation-cap fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <strong>Crea nuovo corso di laurea</strong>
    </a>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Codice</th>
          <th class="has-text-centered">Tipo</th>
          <th class="has-text-centered">Nome</th>
          <th class="has-text-centered">Descrizione</th>
          <th class="has-text-centered" colspan="2">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __codice, __tipo, __nome, __descrizione FROM unimia.get_corsi_di_laurea()";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array());

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__codice"] ?></td>
            <td><?php echo $row["__tipo"] ?></td>
            <td><?php echo $row["__nome"] ?></td>
            <td><?php echo $row["__descrizione"] ?></td>
            <td>
              <form method="post" action="modifica_corso_di_laurea.php">
                <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                <input type="hidden" name="tipo" value="<?php echo $row["__tipo"] ?>">
                <input type="hidden" name="nome" value="<?php echo $row["__nome"] ?>">
                <input type="hidden" name="descrizione" value="<?php echo $row["__descrizione"] ?>">
                <button class="button is-link is-small">Modifica</button>
              </form>
            </td>
            <td>
              <form method="post" action="elimina_corso_di_laurea.php">
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
