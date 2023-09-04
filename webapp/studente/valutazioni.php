<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Valutazioni e carriera - SuperUnimia</title>
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
        <i class="fa-solid fa-marker fa-2xl"></i>
      </span>
      <h1 class="title mt-2">Valutazioni e Carriera</h1>
    </span>
    <h2 class="subtitle">Vengono visualizzate tutte le valutazioni, anche quelle non valide perchè insufficienti o sovrascritte da una valutazione più recente.</h2>

    <table class="table is-fullwidth is-hoverable has-text-centered">
      <thead>
        <tr>
          <th class="has-text-centered">Insegnamento</th>
          <th class="has-text-centered">Data</th>
          <th class="has-text-centered">Docente</th>
          <th class="has-text-centered">Voto</th>
          <th class="has-text-centered">Valida</th>
        </tr>
      </thead>
      
      <tbody>
        <?php

        $qry = "SELECT __appello, __insegnamento, __nome_insegnamento, __data, __nome_docente, __voto, __valida FROM unimia.get_valutazioni_per_studente($1)";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_SESSION["userid"]));

        while ($row = pg_fetch_assoc($res)):
        ?>
          <tr class="<?php if ($row["__valida"] == "f") echo "invalid" ?>">
            <td><?php echo $row["__insegnamento"] ?> - <?php echo $row["__nome_insegnamento"] ?></td>
            <td><?php echo $row["__data"] ?></td>
            <td><?php echo $row["__nome_docente"] ?></td>
            <td><?php echo $row["__voto"] ?></td>
            <td><?php echo $row["__valida"] == "f" ? "<i>Non valida</i>" : "<b>Valida</b>" ?></td>
          </tr>
        <?php endwhile ?>
      </tbody>
    </table>

  </div>
    
  <?php require("../footer.php"); ?>

</body>
</html>
