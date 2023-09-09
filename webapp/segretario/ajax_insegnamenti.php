<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
require("../scripts/redirector.php");

$selected = explode(", ", $_GET["sel"]);

$qry = "SELECT __codice, __nome FROM unimia.get_insegnamenti_per_corso_di_laurea($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_GET["cdl"]));

while ($row = pg_fetch_assoc($res)): 
  if (!in_array($row["__codice"], $selected)): ?>
  <option value="<?= $row["__codice"] ?>"><?= $row["__codice"] ?> - <?= $row["__nome"] ?></option>
  <?php endif ?>
<?php endwhile ?>
