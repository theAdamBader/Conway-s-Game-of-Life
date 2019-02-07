# Conway's Game of Life

## Introduction 
Conway's Game of Life is a zero player, cellular automaton, game in which it has a infinite, two dimensional orthogonal grid that has two possible states: dead or alive, or unpopulated or overcrowded. 

## Rules
Each cell interacts with its eight neighbours which are cell that occur horizontally, vertically or diagonally adjacent. These are the transitions that can occur:

1. If a cell has less than two live neighbours, it dies due to it being underpopulated

2. If a cell has more than three, it dies due to being overcrowded

3. If a cell has more than three or less than two then it lives on onto the next generation

4. Any cell that equally has three live neighbours then it would have its own life and stay in its position

## Interactivity
You start with a blank grid in which if mouse pressed then you may add "lives" to the grid and when you press one of the key pressed buttons (1, 2 or 3) then the following should happen:

1. Underpopulated

![alt text](https://giphy.com/gifs/fnuQoKPEbJ9UIBHkqw)

2. Overcrowded

3. Survival/Creation of Life

When you press 3, you can watch the cells being passed onto its next generation until you have a creation of life where the cells will equal to three.

You may press the SPACEBAR to pause the sketch and add or delete cells or press C to clear the grid and start with a new set of cells.
