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

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../navbar.php");

  ?>

  <div class="container is-max-widescreen box">

    <a href="nuovo_insegnamento.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-book fa-xl"></i></span>
      <span class="icon is-small"><i class="fa-regular fa-square-plus"></i></span>
      <strong>Crea nuovo insegnamento</strong>
    </a>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Codice</th>
          <th class="has-text-centered">Corso di laurea</th>
          <th class="has-text-centered">Nome</th>
          <th class="has-text-centered">Descrizione</th>
          <th class="has-text-centered">Anno</th>
          <th class="has-text-centered">Responsabile</th>
          <th class="has-text-centered" colspan="2">Controlli</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __codice, __corso_di_laurea, __nome_corso_di_laurea, __nome, __descrizione, __anno, __responsabile, __nome_responsabile, __email_responsabile FROM unimia.get_insegnamenti()";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array());

        while ($row = pg_fetch_assoc($res)):

        ?>
          <tr>
            <td><?php echo $row["__codice"] ?></td>
            <td><?php echo $row["__corso_di_laurea"] ?> - <?php echo $row["__nome_corso_di_laurea"] ?></td>
            <td><?php echo $row["__nome"] ?></td>
            <td><?php echo $row["__descrizione"] ?></td>
            <td><?php echo $row["__anno"] ?></td>
            <td><?php echo $row["__nome_responsabile"] ?> <br> <?php echo $row["__email_responsabile"] ?></td>
            <td>
              <form method="post" action="modifica_insegnamento.php">
                <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                <input type="hidden" name="corso_di_laurea" value="<?php echo $row["__corso_di_laurea"] ?>">
                <input type="hidden" name="nome_corso_di_laurea" value="<?php echo $row["__nome_corso_di_laurea"] ?>">
                <input type="hidden" name="nome" value="<?php echo $row["__nome"] ?>">
                <input type="hidden" name="descrizione" value="<?php echo $row["__descrizione"] ?>">
                <input type="hidden" name="anno" value="<?php echo $row["__anno"] ?>">
                <input type="hidden" name="responsabile" value="<?php echo $row["__responsabile"] ?>">
                <input type="hidden" name="nome_responsabile" value="<?php echo $row["__nome_responsabile"] ?>">
                <input type="hidden" name="email_responsabile" value="<?php echo $row["__email_responsabile"] ?>">
                <button class="button is-link is-small">Modifica</button>
              </form>
            </td>
            <td>
              <form method="post" action="elimina_insegnamento.php">
                <input type="hidden" name="codice" value="<?php echo $row["__codice"] ?>">
                <button class="button is-danger is-small">Elimina</button>
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
