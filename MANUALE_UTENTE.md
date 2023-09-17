## Manuale utente

Istruzioni tecniche per lanciare "SuperUnimia".

Il software è anche disponibile all'**indirizzo web** [superunimia.favo02.dev](https://superunimia.favo02.dev).\
Ogni **modifica** _pushata_ al [repository GitHub](https://github.com/Favo02/super-unimia) scatena un **aggiornamento automatico** della versione disponibile online, attraverso una **GitHub action**.

### Requisiti:

- PHP _(preferibile versione `8+`)_
- WebServer _(è possibile utilizzare anche il webserver integrato di PHP)_
- Postgres server _(preferibile versione `15+`)_

### Installazione

- **Creazione e popolazione database:** connettersi al server Postgres ed eseguire i seguenti script SQL, nel seguente ordine:
  - `database/1_setup.sql`: creazione dello schema e dei tipi di dato personalizzati
  - `database/2_tables.sql`: creazione tabelle
  - `database/3_procedures.sql`: creazione procedure
  - `database/4_functions.sql`: creazione funzioni
  - `database/5_triggers.sql`: creazione trigger
  - `database/6_population.sql`: popolazione del database _(da non eseguire in caso si voglia un database vuoto)_
  - il database sarà creato con nome dello schema `unimia`
- **Creazione connessione al database:** è necessario stabile una connessione tra l'applicativo PHP e il database Postgres, attraverso la creazione del file `webapp/scripts/connection.php` _(omesso dal repository per ovvie ragioni di sicurezza)_
  - creare il file `webapp/scripts/connection.php`
  - scrivere nel file, sostituendo le parti tra parentesi graffe con le informazioni del proprio server postgres _(senza parentesi)_:
    ```php
    <?php
    $con = pg_connect("host={postgres.favo02.dev} port={5432} dbname={unimia} user={user} password={password}");
    ?>
    ```
- **Avviare l'applicativo PHP:** spostare tutto il contenuto della cartella `webapp` all'interno della cartella servita dal server web scelto.\
In alternativa è possibile avviare il webserver integrato di PHP eseguendo i comandi:
  - `cd webapp/`
  - `php -S localhost:8000`
  - recarsi all'indirizzo `localhost:8000`
  - _Come ricordato dalla [documentazione ufficiale](https://www.php.net/manual/en/features.commandline.webserver.php) di PHP, questo webserver è inteso come webserver di test e di sviluppo, non è consigliato da utilizzare in ambienti di production_


