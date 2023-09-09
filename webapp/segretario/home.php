<?php

$title = "Home segretario";
require("../components/head.php");

require_once("../scripts/utils.php");

$CUR_PAGE = "segretario";
require("../scripts/redirector.php");

require("../components/navbar.php");

?>

  <div class="container is-max-desktop box">

    <?php if (isset($_SESSION["feedback"])): ?>
      <div class="notification is-success is-light mt-6">
        <strong><?php echo $_SESSION["feedback"]; unset($_SESSION["feedback"]) ?></strong>
      </div>
    <?php endif; ?>
    
    <div class="block">
      <p class="title is-2 is-link">Buongiorno, <?php echo $_SESSION["username"]; ?>.</p>
      <p class="subtitle is-4">Servizi accessibili come <?php echo $_SESSION["usertype"]; ?>:</p>
    </div>

    <a href="profilo.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-address-card fa-xl"></i></span>
      <strong>Profilo</strong>
    </a>

    <a href="modifica_password.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-lock fa-xl"></i></span>
      <strong>Modifica password ad un utente</strong>
    </a>

    <a href="gestione_studenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-graduate fa-xl"></i></span>
      <strong>Gestione studenti</strong>
    </a>

    <a href="gestione_docenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-tie fa-xl"></i></span>
      <strong>Gestione docenti</strong>
    </a>

    <a href="gestione_segretari.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-user-gear fa-xl"></i></span>
      <strong>Gestione segretari</strong>
    </a>

    <a href="gestione_corsi_di_laurea.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-graduation-cap fa-xl"></i></span>
      <strong>Gestione corsi di laurea</strong>
    </a>

    <a href="gestione_insegnamenti.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-book fa-xl"></i></span>
      <strong>Gestione insegnamenti</strong>
    </a>

    <a href="gestione_appelli.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-calendar-day fa-xl"></i></span>
      <strong>Gestione appelli</strong>
    </a>

    <a href="gestione_iscrizioni.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-users fa-xl"></i></span>
      <strong>Gestione iscrizioni</strong>
    </a>

    <a href="gestione_valutazioni.php" class="block button is-link is-outlined is-fullwidth">
      <span class="icon is-small"><i class="fa-solid fa-marker fa-xl"></i></span>
      <strong>Gestione valutazioni e Carriere</strong>
    </a>

  </div>

<?php require("../components/footer.php"); ?>
