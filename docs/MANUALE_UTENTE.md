## Manuale utente

Istruzioni tecniche per lanciare "SuperUnimia".

Il software è anche disponibile all'**indirizzo web** [superunimia.favo02.dev](https://superunimia.favo02.dev).\
Ogni **modifica** _pushata_ al [repository GitHub](https://github.com/Favo02/super-unimia) scatena un **aggiornamento automatico** della versione disponibile online, attraverso una **GitHub action**.

### Requisiti:

- PHP _(preferibile versione `8+`)_
- WebServer _(è possibile utilizzare anche il webserver integrato di PHP)_, per il deploy disponibile online è utilizzato `nginx`
- Postgres server _(preferibile versione `15+`)_

_Il software è stato sviluppato e testato su ambiente **Linux**. I comandi indicati sono per ambiente Linux._

### Installazione

- **Creazione e popolazione database:** il dump del database è fornito come due script SQL, uno che crea solo lo schema (`dump-schema-only.sql`), uno che inserisce solo i dati (`dump-data-only.sql`). \
Il database può essere creato e popolato utilizzando lo script `restore.sh`, _(oppure utilizzando i comandi in esso riportati)_.
  - `cd database/dump/`
  - inserire i parametri corretti del proprio server postgres nel file `restore.sh`
  - `sh restore.sh` _(importerà sia lo schema che i dati)_
- **Creazione connessione al database:** è necessario stabile una connessione tra l'applicativo PHP e il database Postgres, attraverso la creazione del file `webapp/scripts/connection.php` _(omesso dal repository per ovvie ragioni di sicurezza)_
  - creare il file `webapp/scripts/connection.php`
  - scrivere nel file, sostituendo le parti tra parentesi graffe con le informazioni del proprio server postgres _(senza parentesi)_:
    ```php
    <?php
    $con = pg_connect("host={localhost} port={5432} dbname={unimia}
                       user={postgres} password={password}");
    ?>
    ```
- **Avviare l'applicativo PHP:** spostare tutto il contenuto della cartella `webapp` all'interno della cartella servita dal server web scelto.\
In alternativa è possibile avviare il webserver integrato di PHP eseguendo i comandi:
  - `cd webapp/`
  - `php -S localhost:8000`
  - recarsi all'indirizzo `localhost:8000`
  - _Come ricordato dalla [documentazione ufficiale](https://www.php.net/manual/en/features.commandline.webserver.php) di PHP, questo webserver è inteso come webserver di test e di sviluppo, non è consigliato da utilizzare in ambienti di production_
- **Accedere all'applicativo web:** non esiste un meccanismo di registrazione, quindi il primo utente segretario deve essere creato dal database
  - creazione utente attraverso la procedura `new_segretario`
    - CALL `unimia.new_segretario('Nome', 'Cognome', 'Password');`
  - in caso di import del dump `data-only` sarà presente l'utente con le seguenti credenziali _(presente anche nella versione online)_:
    - email: `seg.retario@segretario.superuni.it`
    - password: `8Caratteri!` _(uguale a tutti gli utenti)_
