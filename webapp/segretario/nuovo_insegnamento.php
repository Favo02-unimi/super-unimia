<?php

require_once("../scripts/utils.php");

if (isset($_POST["submit"])) {
  $qry = "CALL unimia.new_insegnamento($1, $2, $3, $4, $5, $6, $7);";
  $res = pg_prepare($con, "", $qry);
  $res = pg_execute($con, "", array($_POST["codice"], $_POST["corso_di_laurea"], $_POST["nome"], $_POST["descrizione"], $_POST["anno"], $_POST["responsabile"], ToPostgresArray($_POST["propedeuticita"])));

  if (!$res) {
    $error = ParseError(pg_last_error());
  }
  else {
    unset($error);
    $_SESSION["feedback"] = "Insegnamento creato con successo.";
    Redirect("home.php");
  }
}

$CUR_PAGE = "segretario";
$fa_icon = "fa-book";
$title = "Nuovo insegnamento";
$subtitle = "";

$class = "is-link";
$help = "";

// options corso di laurea query
$qry = "SELECT __codice, __nome FROM unimia.get_corsi_di_laurea()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$optionsCdl = array();
while ($row = pg_fetch_assoc($res)) {
  $optionsCdl[$row["__codice"]] = $row["__codice"]." - ".$row["__nome"];
}
$selectedCdl = array();

// options responsabile query
$qry = "SELECT __id, __nome, __cognome, __email FROM unimia.get_docenti()";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array());

$optionsRes = array();
while ($row = pg_fetch_assoc($res)) {
  $optionsRes[$row["__id"]] = $row["__nome"]." ".$row["__cognome"]." - ".$row["__email"];
}
$selectedRes = array();

$inputs = array(
  array(
    "type"=>"text",
    "label"=>"Codice",
    "name"=>"codice",
    "value"=>$_POST["codice"],
    "placeholder"=>"Codice",
    "required"=>"required",
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
    "onchange"=>"generaInsegnamenti(this.value)",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Nome",
    "name"=>"nome",
    "value"=>$_POST["nome"],
    "placeholder"=>"Nome",
    "required"=>"required",
    "icon"=>"fa-align-center",
    "help"=>""
  ),
  array(
    "type"=>"text",
    "label"=>"Descrizione",
    "name"=>"descrizione",
    "value"=>$_POST["descrizione"],
    "placeholder"=>"Descrizione",
    "required"=>"required",
    "icon"=>"fa-align-justify",
    "help"=>""
  ),
  array(
    "type"=>"select",
    "name"=>"anno",
    "label"=>"Anno",
    "icon"=>"fa-calendar-days",
    "options"=>array(
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
    "options"=>array("<option>Loading...</option>"),
    "selected"=>array(),
    "help"=>"È possibile selezionare più di un insegnamento utilizzando CTRL."
  )
);

require("../components/form.php");

?>

<script>
  function generaInsegnamenti(cdl) {
    document.querySelector("select[name='propedeuticita[]']").innerHTML = "<option>Loading...</option>";

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        document.querySelector("select[name='propedeuticita[]']").innerHTML = this.responseText;
      }
    };
    xmlhttp.open("GET", `ajax_insegnamenti.php?cdl=${cdl}`, true);
    xmlhttp.send();
  }

  generaInsegnamenti(document.querySelector("select[name='corso_di_laurea']").value)
</script>
