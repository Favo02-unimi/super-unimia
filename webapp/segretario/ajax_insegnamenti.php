<?php

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
require("../scripts/redirector.php");


$qry = "SELECT __codice, __nome FROM unimia.get_insegnamenti_per_corso_di_laurea($1)";
$res = pg_prepare($con, "", $qry);
$res = pg_execute($con, "", array($_GET["cdl"]));

while ($row = pg_fetch_assoc($res)): ?>
  <option value="<?php echo $row["__codice"] ?>"><?php echo $row["__codice"] ?> - <?php echo $row["__nome"] ?></option>
<?php endwhile ?>
