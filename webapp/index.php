<?php

$title = "Login";
require("../components/head.php");

require_once("scripts/utils.php");

require("scripts/index_redirector.php");

?>

  <div class="container is-max-desktop">

    <?php if (isset($_SESSION["feedback"])): ?>
      <div class="notification is-danger is-light mt-6">
        <strong><?php echo $_SESSION["feedback"]; unset($_SESSION["feedback"]) ?></strong>
      </div>
    <?php endif; ?>

    <form class="box p-6" action="scripts/login.php" method="post">

      <span class="icon-text">
        <span class="icon is-large">
          <i class="fa-solid fa-user-graduate fa-2xl"></i>
        </span>
        <h1 class="title mt-2">SuperUnimia Login</h1>
      </span>

      <label class="label mt-5">Email</label>
      <div class="field has-addons has-addons-right">
        <p class="control has-icons-left is-expanded">
          <input class="input" type="text" name="email" placeholder="nome.cognome">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-envelope"></i>
          </span>
        </p>
        <p class="control is-expanded">
          <span class="select is-fullwidth">
            <select name="type">
              <option>@studente.superuni.it</option>
              <option>@docente.superuni.it</option>
              <option>@segretario.superuni.it</option>
            </select>
          </span>
        </p>
      </div>

      <label class="label mt-5">Password</label>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="password" name="password" placeholder="Password">
          <span class="icon is-small is-left">
            <i class="fa-solid fa-lock"></i>
          </span>
        </p>
      </div>
      
      <div class="field mt-5">
        <p class="control">
          <button class="button is-link is-fullwidth is-medium">
            Login
          </button>
        </p>
      </div>

    </form>
    
  </div>

<?php require("components/footer.php"); ?>
