# Bataille navale — MIPS 32 Assembleur

Ce projet de première année de **BUT Informatique** consiste à programmer une
simulation de bataille navale en assembleur MIPS. La partie se déroule
automatiquement : le programme place une flotte sur une grille, tire sur des
cases choisies aléatoirement et affiche la grille après chaque tir effectif,
jusqu'à ce que tous les navires soient touchés.

### Fonctionnalités

- Grille de jeu de 10 × 10 cases, repérée de A à J et de 1 à 10.
- Placement aléatoire de cinq navires, horizontalement ou verticalement :
  - porte-avions (5 cases) ;
  - cuirassé (4 cases) ;
  - croiseur (3 cases) ;
  - sous-marin (3 cases) ;
  - torpilleur (2 cases).
- Vérification des cases disponibles lors du placement.
- Simulation de tirs aléatoires et suivi des cases déjà visées.
- Affichage de la grille et du nombre de tirs nécessaires pour toucher les
  17 cases de la flotte.

### Prérequis

- [MARS](https://computerscience.missouristate.edu/mars-mips-simulator.htm), un
  simulateur d'assembleur MIPS. Le programme utilise notamment le service
  système aléatoire 42 de MARS ; il n'est donc pas garanti compatible avec
  d'autres simulateurs.

### Lancer le programme

1. Ouvrir `start.s` dans MARS.
2. Assembler le programme (**Run > Assemble**, ou `F3`).
3. Lancer l'exécution (**Run > Go**, ou `F5`).
4. Consulter la grille et le résultat dans la fenêtre **Run I/O**.

Les navires apparaissent sous forme de lettres dans la grille (`A`, `B`, `C`,
`S` et `D`). Un tir réussi est marqué `X` et un tir manqué `~`. Le programme
ne demande aucune entrée : chaque exécution lance une nouvelle partie avec des
placements et des tirs aléatoires.

### Fichier

- `start.s` : initialisation de la grille et des navires, affichage, génération
  aléatoire et simulation de la partie.

---



This first-year **Bachelor of Technology in Computer Science (BUT
Informatique)** project implements a Battleship simulation in MIPS assembly.
The game runs automatically: the program places a fleet on a grid, fires at
randomly selected cells, and displays the grid after each effective shot until
all ship cells have been hit.

### Features

- A 10 × 10 grid labelled A to J and 1 to 10.
- Random placement of five ships, horizontally or vertically:
  - aircraft carrier (5 cells);
  - battleship (4 cells);
  - cruiser (3 cells);
  - submarine (3 cells);
  - destroyer (2 cells).
- Checks that cells are available before placing a ship.
- Random-shot simulation and tracking of previously targeted cells.
- Displays the grid and the number of shots needed to hit all 17 fleet cells.

### Requirements

- [MARS](https://computerscience.missouristate.edu/mars-mips-simulator.htm), a
  MIPS assembler and simulator. The program uses MARS system call 42 for
  random numbers, so compatibility with other simulators is not guaranteed.

### Run the program

1. Open `start.s` in MARS.
2. Assemble the program (**Run > Assemble**, or `F3`).
3. Start execution (**Run > Go**, or `F5`).
4. View the grid and result in the **Run I/O** window.

Ships are shown as letters (`A`, `B`, `C`, `S`, and `D`). A hit is marked `X`
and a miss is marked `~`. No input is required: each run starts a new game
with random ship placements and shots.

### File

- `start.s`: grid and ship initialization, display, random number generation,
  and game simulation.
