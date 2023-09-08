<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="../styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Modifica insegnamento - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("../scripts/utils.php");

  $CUR_PAGE = "segretario";
  require("../scripts/redirector.php");

  require("../components/navbar.php");

  ?>

  <div class="container is-max-desktop">

    <?php

      if (isset($_POST["submit"])) {
        $qry = "CALL unimia.edit_insegnamento($1, $2, $3, $4, $5, $6, $7, $8);";
        $res = pg_prepare($con, "", $qry);
        $res = pg_execute($con, "", array($_POST["codice"], $_POST["new_codice"], $_POST["corso_di_laurea"], $_POST["nome"], $_POST["descrizione"], $_POST["anno"], $_POST["responsabile"], ToPostgresArray($_POST["propedeuticita"])));

        if (!$res): ?>
          <div class="notification is-danger is-light mt-6">
            <strong>Errore durante la creazione:</strong>
            <?php echo ParseError(pg_last_error()); ?>.
          </div>
        <?php else: 
          $_SESSION["feedback"] = "Insegnamento modificato con successo.";
          Redirect("home.php");
        endif;
      }
    ?>
    
    <form class="box p-6" action="" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-book fa-2xl"></i>
        </span>
        <h1 class="title mt-2">Modifica insegnamento</h1>
      </span>

      <input class="input" type="hidden" name="codice" value="<?php echo $_POST["codice"] ?>" required>

      <label class="label mt-5">Codice</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="new_codice" placeholder="INF/00" value="<?php echo $_POST["codice"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-barcode"></i>
          </span>
        </p>
        <p class="help">Lunghezza massima codice 6 caratteri.</p>
      </div>

      <label class="label mt-5">Corso di laurea</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="corso_di_laurea" onchange="generaInsegnamenti(this.value, false)">
              <option value="<?php echo $_POST["corso_di_laurea"] ?>"><?php echo $_POST["corso_di_laurea"] ?> - <?php echo $_POST["nome_corso_di_laurea"] ?></option>
              <?php
                $qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
                $res = pg_prepare($con, "", $qry);
                $res = pg_execute($con, "", array());
        
                while ($row = pg_fetch_assoc($res)):
              ?>
                <option value="<?php echo $row["__codice"] ?>"><?php echo $row["__codice"] ?> - <?php echo $row["__nome"] ?></option>
              <?php endwhile ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-graduation-cap"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Nome</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="nome" placeholder="Nome" value="<?php echo $_POST["nome"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-center"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Descrizione</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" name="descrizione" placeholder="Descrizione" value="<?php echo $_POST["descrizione"] ?>">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-align-justify"></i>
          </span>
        </p>
      </div>

      <label class="label mt-5">Anno</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="anno">
              <option selected><?php echo $_POST["anno"] ?></option>
              <option>1</option>
              <option>2</option>
              <option>3</option>
              <option>4</option>
              <option>5</option>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-calendar-days"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Responsabile</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth">
            <select name="responsabile">
              <option value="<?php echo $_POST["responsabile"] ?>"><?php echo $_POST["nome_responsabile"] ?> - <?php echo $_POST["email_responsabile"] ?></option>
              <?php
                $qry = "SELECT __id, __nome, __cognome, __email FROM unimia.get_docenti()";
                $res = pg_prepare($con, "", $qry);
                $res = pg_execute($con, "", array());
        
                while ($row = pg_fetch_assoc($res)):
              ?>
                <option value="<?php echo $row["__id"] ?>"><?php echo $row["__nome"] . " " . $row["__cognome"] ?> - <?php echo $row["__email"] ?></option>
              <?php endwhile ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-user-tie"></i>
          </div>
        </div>
      </div>

      <label class="label mt-5">Propedeuticità</label>
      <div class="field">
        <div class="control has-icons-left">
          <div class="select is-fullwidth is-multiple">
            <select name="propedeuticita[]" multiple>
              <!-- populated by ajax -->
              <?php
              if ($_POST["propedeuticita"] != ""):
                foreach (explode(", ", $_POST["propedeuticita"]) as $prop):
              ?>
                <option selected><?php echo $prop; ?></options>
              <?php endforeach; endif; ?>
            </select>
          </div>
          <div class="icon is-small is-left">
            <i class="fa-solid fa-book"></i>
          </div>
        </div>
        <p class="help">È possibile selezionare più di un insegnamento utilizzando CTRL.</p>
      </div>

      <script>
        function generaInsegnamenti(cdl, isAppend) {
          var xmlhttp = new XMLHttpRequest();
          xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
              if (isAppend) {
                document.querySelector("select[name='propedeuticita[]']").insertAdjacentHTML('beforeend', this.responseText);
              }
              else {
                document.querySelector("select[name='propedeuticita[]']").innerHTML = this.responseText;
              }
            }
          };
          xmlhttp.open("GET", `ajax_insegnamenti.php?cdl=${cdl}`, true);
          xmlhttp.send();
        }

        generaInsegnamenti(document.querySelector("select[name='corso_di_laurea']").value, true)
      </script>

      <div class="field mt-5">
        <p class="control">
          <input type="submit" name="submit" value="Modifica insegnamento" class="button is-link is-fullwidth is-medium">
        </p>
      </div>

    </form>
  
  </div>
    
  <?php require("../components/footer.php"); ?>

</body>
</html>
