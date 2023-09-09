<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.edit_insegnamento($1, $2, $3, $4, $5, $6, $7, $8);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"], $_POST["new_codice"], $_POST["corso_di_laurea"], $_POST["nome"], $_POST["descrizione"], $_POST["anno"], $_POST["responsabile"], ToPostgresArray($_POST["propedeuticita"])));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Insegnamento modificato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-book";
$title = "Modifica insegnamento";
$subtitle = "";

$class = "is-link";
$help = "";

// options corso di laurea query
$qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$optionsCdl = array();
while ($row = pg_fetch_assoc($res)) {
  if ($row["__codice"] != $_POST["corso_di_laurea"]) {
    $optionsCdl[$row["__codice"]] = $row["__codice"]." - ".$row["__nome"];
  }
}
$selectedCdl = array();
$selectedCdl[$_POST["corso_di_laurea"]] = $_POST["corso_di_laurea"]." - ".$_POST["nome_corso_di_laurea"];


// options responsabile query
$qry = "SELECT __id, __nome, __cognome, __email FROM unimia.get_docenti()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$optionsRes = array();
while ($row = pg_fetch_assoc($res)) {
  if ($row["__id"] != $_POST["responsabile"]) {
    $optionsRes[$row["__id"]] = $row["__nome"]." ".$row["__cognome"]." - ".$row["__email"];
  }
}
$selectedRes = array();
$selectedRes[$_POST["responsabile"]] = $_POST["nome_responsabile"]." ".$_POST["email_responsabile"];

// options propedeuticita
$selectedProp = array();
if ($_POST["propedeuticita"] != "" && !is_array($_POST["propedeuticita"])) {  
  foreach (explode(", ", $_POST["propedeuticita"]) as $prop) {
    $selectedProp[$prop] = $prop;
  }
}

$inputs = array(
  array(
    "type"=>"hidden",
    "name"=>"codice",
    "value"=>$_POST["codice"]
  ),
  array(
    "type"=>"text",
    "label"=>"Codice",
    "name"=>"new_codice",
    "value"=>$_POST["codice"],
    "placeholder"=>"Codice",
    "icon"=>"fa-barcode",
    "help"=>"Lunghezza massima codice 6 caratteri."
  ),
  array(
    "type"=>"select",
    "name"=>"corso_di_laurea",
    "label"=>"Corso di laurea",
    "icon"=>"fa-graduation-cap",
    "options"=>$optionsCdl,
    "selected"=>$selectedCdl,
    "onchange"=>"generaInsegnamenti(this.value, false)",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "placeholder"=>"Nome",
    "icon"=>"fa-align-center",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Descrizione",
    "name"=>"descrizione",
    "value"=>$_POST["descrizione"],
    "placeholder"=>"Descrizione",
    "icon"=>"fa-align-justify",
    "help"=>""
  ),
  array(
    "type"=>"select",
    "name"=>"anno",
    "label"=>"Anno",
    "icon"=>"fa-calendar-days",
    "options"=>array(
      $_POST["anno"]=>$_POST["anno"],
      "1"=>"1",
      "2"=>"2",
      "3"=>"3",
      "4"=>"4",
      "5"=>"5"
    ),
    "help"=>""
  ),
  array(
    "type"=>"select",
    "name"=>"responsabile",
    "label"=>"Responsabile",
    "icon"=>"fa-user-tie",
    "options"=>$optionsRes,
    "selected"=>$selectedRes,
    "help"=>""
  ),
  array(
    "type"=>"select",
    "multiple"=>"multiple",
    "ismultiple"=>"is-multiple",
    "name"=>"propedeuticita[]",
    "label"=>"Propedeuticità",
    "icon"=>"fa-user-tie",
    "options"=>array(),
    "selected"=>$selectedProp,
    "help"=>"È possibile selezionare più di un insegnamento utilizzando CTRL."
  )
);

require("../components/form.php");

?>

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
    xmlhttp.open("GET", `ajax_insegnamenti.php?cdl=${cdl}&sel=<?= $_POST["propedeuticita"] ?>`, true);
    xmlhttp.send();
  }

  generaInsegnamenti(document.querySelector("select[name='corso_di_laurea']").value, true)
</script>
