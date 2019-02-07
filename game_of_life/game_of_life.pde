/* CONWAY'S GAME OF LIFE*/
// Start with a blank canvas that has no life cells, allowing the user to add life cells by mouse click/drag on the grid, and then you can press the following to unpause:
// Press 1: Underpopulation 
// Press 2: Overcrowding
// Press 3: Survival/Creation of Life
// Press C: To clear the grid and start anew
// Press SPACE: To pause the sketch

// Size of cells
int cellSize = 15;
int gridSize = 25;

// Creating a state for each scenario
int state = 0;

// Variables for timer
int interval = 100; // For every 100 milliseconds, it would iterate to its next state
int lastRecordedTime = 0;

// Colours for dead and alive cells
color alive = color(0); // Alive cells are black
color dead = color(255); // Dead cells are white

// Array of cells
int[][] cells; 

// Buffer to record the state of the cells 
int[][] cellsBuffer; 

// Pause function to start true, in order to draw cells
boolean pause = true;

void setup() {
  
  size (1200, 600);
  background(255); // Fill in white in case cells don't cover all dead cells

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];
}


void draw() {
  
  // Draws a grid
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      if (cells[x][y] == 1) {
        fill(alive); // If alive, colour black
      } else {
        fill(dead); // If dead, colour white
      }
      rect (x * cellSize, y * cellSize, cellSize, cellSize);
    }
  }

  // Iterates the timer
  if (millis() - lastRecordedTime > interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    
    // Map and avoids out of bound errors when adding cells
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize - 1);
    
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize - 1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver] == 1) { // If cell is alive then a dead cell would cover the live cell
      cells[xCellOver][yCellOver] = 0; // Cell dies
      fill(dead); // Fills dead cell's colour
      
    } else { 
      cells[xCellOver][yCellOver] = 1; // Else the cell lives
      fill(alive); // Fill alive cell's colour
    }
  } 
  
  // Created a string within setup
  PFont font= createFont("Georgia", 64);
  String states = "Scenario: " + state; // Change the scenario depending on the keyPressed function
  String pausing = "Pause";
  
  fill(0, 255, 100);
  textFont (font);
  textSize(64);
  text (states, 10, 50);
  if(pause == true){ // If pause is true then add pause text to the sketch
  text (pausing, 1000, 50);}
}

void iteration() { // When the clock ticks
  // Save cells to buffer so it keeps the other intacted and interactable
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      // Will visit all the neighbours of each cell
      int neighbours = 0; // Counts the neighbours
      for (int col = x - 1; col <= x + 1; col++) {
        for (int row= y - 1; row <= y + 1; row++) {  
          if (((col >= 0) && (col < width/cellSize)) && ((row >= 0) && (row < height/cellSize))) { // Checks that it is not out of bounds
            if (!((col == x) && (row == y))) { // If col and row are not equal to x and y then it will make sure to check against self
              if (cellsBuffer[col][row] == 1) {
                neighbours ++; // it checks "alive" neighbours and count them
              }
            }
          }
        }
      }

      // Checks the neigbours then it will apply the rules when key pressed
      if (state == 1 && cellsBuffer[x][y] == 1) { // Underpopulation
        if (neighbours < 2) { 
          cells[x][y] = 0; // Dies if less than 2
        }
      }
      if (state == 2 && cellsBuffer[x][y] == 1) { // Overcrowding
        if (neighbours > 3) { 
          cells[x][y] = 0; // Dies if more than 3
        }
      }
      if (state == 3 && cellsBuffer[x][y] == 1) {// Survival/Creation of Life
        if (neighbours < 2 || neighbours > 3) { 
          cells[x][y] = 0; // Dies if it has 2 or 3 neighbours
        }
      } else {     
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbours then cell stays alive
        }
      }
    }
  }
} 

void keyPressed() {

  // Each key represents a state
  if (key == '1') {
    pause = false;
    state = 1;
  }

  if (key == '2') {
    pause = false;
    state = 2;
  }
  
  if (key == '3') {
    pause = false;
    state = 3;
  }
  
  // Pauses the sketch 
  if (key == ' ') {
    pause = true;
  }

 // Clears the sketch (scenario 5) and pauses it
 if (key == 'c' || key == 'C') { // Clear all
    state = 0;
    pause = true;
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Kills all live cells by reverting all back to zero
      }
    }
  }
}

/*
STATE ANY ASSUMPTION YOU MAKE ABOUT THE PROBLEM

1. The grid: I tried to possibly start a grid in which the cell would have a different size than the grid; however, as I had to add rect within the grid so that players could add cells, 
   I instantiate arrays and had to use a constrain function so that it could create a black rect within the white rect. Assuming I added a line object rather than rect, it would work and 
   allow to have an ellipse to draw but the problem is that the ellipse would probably not be centre within the line grid.

2. Iteration: Whilst creating the iteration was easy but as it was not interacting well with manually adding cells. I had to add a time function 'millis' so that it could time each iteration it goes 
   through the cells it would keep track however the intervals did not help with the speed it was generating so created a lastTimeRecord so it would go a pace that would be suitable. Also, would have 
   been interesting to create a slider or knob that would allow the user to control the speed of each iteration. Assuming another could be framerate function and add how many frames to add for each 
   second for an iteration.
   
3. Cells (Array): Big problem for me was trying to use an array list which complicated the process and used an array instead however, as mentioned in the grid I tried to make the grid separate from the 
   cell however, the issue would be mapping. Assuming, I could add noStroke object then added a grid to have a similar size as the rect then I could have a separate thing from the cells itself
   
4. States: Whilst using states in a keyPressed function works. There is a possibility of using switch statements and if used then that would be efficient as it would not need much runtime as keyPressed 
   and states
   
5. Scenarios: Assuming I have done the scenarios correctly, the issue was to maybe have enable a timer to recongn`ise when it hits scenario 4 and as for 5, it would be pressing C but it would it be 5/0 or 
   form of algorithm that would recognise when it starts if the neighbours are equal to three
   
*/