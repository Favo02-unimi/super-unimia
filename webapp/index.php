<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
  <link rel="stylesheet" href="styles/index.css">
  <script src="https://kit.fontawesome.com/eb793f993c.js" crossorigin="anonymous"></script>
  <title>Login - SuperUnimia</title>
</head>
<body class="has-background-dark has-text-light">

  <?php

  require_once("scripts/utils.php");

  require("scripts/index_redirector.php");

  ?>

  <div class="container is-max-desktop mt-6">

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

</body>
</html>
