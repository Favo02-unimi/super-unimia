## Documentazione Tecnica

Relazione del progetto _"Piattaforma per la gestione degli esami universitari"_ (in breve _"Unimia"_ o _"SuperUnimia"_) per il corso _"Basi di dati"_ (a.a. 2022-2023, appello di Settembre).

Realizzata da Luca Favini (matricola 987617).

- [Testing e Deploy](#testing-e-deploy)
- [Struttura del progetto](#struttura-del-progetto)
  - [Stack tecnologico](#stack-tecnologico)
  - [Organizzazione del codice](#organizzazione-del-codice)
- Database
  - Schema Logico
  - Schema concettuale
- Webapp PHP
- Descrizione funzioni realizzate
- Scelte implementative significative

## Testing e Deploy

Per informazioni riguardo l'installazione e l'avvio del software si rimanda al ([MANUALE_UTENTE.md](MANUALE_UTENTE.md)).

Il software è anche disponibile all'**indirizzo web** [superunimia.favo02.dev](https://superunimia.favo02.dev).\
Ogni **modifica** _pushata_ al [repository GitHub](https://github.com/Favo02/super-unimia) scatena un **aggiornamento automatico** della versione disponibile online, attraverso una **GitHub action**.

## Struttura del progetto

### Stack tecnologico

- Postgres (database)
- PHP _+ HTML, CSS, JavaScript_ (webapp)
- _Docker + Github Actions (deploy)_

### Organizzazione del codice

Ogni cartella alla root del progetto include una parte indipendente del progetto:

- `database`: script sql per la creazione e popolazione del **database**
- `webapp`: cartella contentente tutti i file PHP per la realizzazione della **webapp**
  - `components`: **componenti** _(molto grezzi)_ riutilizzabili tra varie pagine PHP. Utilizzabili semplicemente dichiarando delle variabili ed includendo il componente
  - `docente`: pagine accessibili dagli utenti di tipo **docente**
  - `scripts`: vari script di utilità _(login, controllo autorizzazioni, connessione al database, ...)_
  - `segretario`: pagine accessibili dagli utenti di tipo **segretario**
  - `studente`: pagine accessibili dagli utenti di tipo **studente**
  - `styles`: stili CSS
- _`.github`: GitHub actions per il deploy_
- _`deploy`: file Docker per il deploy_
