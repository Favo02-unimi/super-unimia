<?php

$title = "Home ex studente";
require("../components/head.php");

require_once("../scripts/utils.php");

$CUR_PAGE = "ex_studente";
require("../scripts/redirector.php");

require("../components/navbar.php");

?>

  <div class="container is-max-desktop box">

    <?php if (isset($_SESSION["feedback"])): ?>
      <div class="notification is-success is-light mt-6">
        <strong><?= $_SESSION["feedback"] ?><?php unset($_SESSION["feedback"]) ?></strong>
      </div>
    <?php endif; ?>

    <div class="block">
      <p class="title is-2 is-link">Buongiorno, <?= $_SESSION["username"]; ?>.</p>
      <p class="subtitle is-4">Servizi accessibili come <?= $_SESSION["usertype"]; ?>:</p>
    </div>

    <a href="profilo.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-address-card fa-xl"></i></span>
      <strong>Profilo</strong>
    </a>

    <a href="modifica_password.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-lock fa-xl"></i></span>
      <strong>Modifica password</strong>
    </a>

    <a href="visualizza_corsi_di_laurea.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-graduation-cap fa-xl"></i></span>
      <strong>Visualizza corsi di laurea</strong>
    </a>

    <a href="valutazioni.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-marker fa-xl"></i></span>
      <strong>Visualizza valutazioni e carriera</strong>
    </a>

  </div>

<?php require("../components/footer.php"); ?>
