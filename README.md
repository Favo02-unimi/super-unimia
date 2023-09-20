## Super-Unimia

"Basi di dati" final exam assignment.

Deployed (automatically) at [superunimia.favo02.dev](superunimia.favo02.dev).

## Documentazione

_In italian:_

- [Manuale utente](MANUALE_UTENTE.md) (installation manual)
- [Documentazione tecnica](DOCUMENTAZIONE_TECNICA.md) (technical documentation)

## Workflow

### Branching Strategy

<details>
<summary>Commit convention</summary>

No branches, all on main.

</details>

### Commit Convention

<details>
<summary>Commit convention</summary>

Each commit message consists of a **header**, a **body**, and a **footer**.

```
<header>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

#### Commit Message Header

```
<project part>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: segretario|docente|studente|*
  │
  └─⫸ Commit project part: repo|db|web
```

##### Project part

Must be one of the following:

* **repo**: changes to the repository (ci, readme, gitignore, ...)
* **db**: database
* **web**: webapp

##### Scope

The scope is the part of the codebase where the changes happened and it can be one of the following:

* **segretario**: segretario user
* **docente**: docente user
* **studente**: studente user

- If a commit changes multiple parts of the codebase then an `*` sign can be used as the scope specifier.

#### Commit Message Body

- Use imperative, present tense: “change” not “changed” nor “changes”.

- Include motivation for the change and contrasts with previous behavior.

#### Commit Message Footer

All breaking changes have to be mentioned in footer with the description of the change, justification and migration notes (e.g. `BREAKING CHANGE: desc...`).

- If a commit targets a specific issue, the issue_id must be specified in the footer e.g. `Closes #123`, in case of multiple issues `Closes #123, #124, #125`.
  
</details>

### Issues: bugs report, feature ideas
  
<details>
<summary>Issues: bugs report, feature ideas</summary>

> Issues can be opened for everything that has to do with the program, from asking questions to requesting new fetures or bug-fixes.

Issues should describe and include each of the following components:

- A `priority` label
    - `priority: 0` &larr; **Highest**
    - `priority: 1`
    - `priority: 2`
    - `priority: 3`
    - `priority: 4` &larr; **Lowest**
- A `type` label
    - `feature`: new feature to be implemented
    - `bug`: bug to be fixed
    - `idea`: an idea for a future update (not strictly required as a feature)

</details>

### Versioning and deploying
  
<details>
<summary>Versioning and deploying</summary>

#### Versioning

No versioning (fuck vanilla PHP).
  
#### Deploying

Every time a new version is bumped, the `serve` workflow will be triggered, generating a new Docker image for the application and serving it at [superunimia.favo02.dev](https://superunimia.favo02.dev).

</details>
  

