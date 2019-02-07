/* CONWAY'S GAME OF LIFE*/
// Start with a blank canvas that has no life cells, allowing the user to add life cells by mouse click on the grid, and then you can press SPACE to unpause,
// which by default it would start with scenario 1, in which you may press the following keys to change the scenarios:
// Press 1: Underpopulation 
// Press 2: Overcrowding
// Press 3: Survival/Creation of Life
// Press C: To clear the grid and start anew
// Press SPACE: To pause and unpause the sketch

// Size of cells
int cellSize = 15;

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

  // Iterate if timer ticks
  if (millis() - lastRecordedTime > interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(dead); // Fill with dead cell colour
    } else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive colour
    }
  } else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x = 0; x < width/cellSize; x++) {
      for (int y = 0; y < height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
  
  PFont font= createFont("Georgia", 64);
  String states = "Scenario: " + state;
  fill(0, 155, 255);
  textFont (font);
  textSize(64);
  text (states, 10, 50);
}

void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x = 0; x < width/cellSize; x++) {
    for (int y = 0; y < height/cellSize; y++) {
      // Will visit all the neighbours of each cell
      int neighbours = 0; // Will count the neighbours
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

      // Checks the neigbours then it will apply the rules
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
    state = 1;
  }

  if (key == '2') {
    state = 2;
  }
  
  if (key == '3') {
    state = 3;
  }
  
  // Pauses and unpause the sketch and would set on state 1
  if (key == ' ') {
    pause = !pause;
  }

 // Clears the sketch (scenario 5) and pauses it
 if (key == 'c' || key == 'C') { // Clear all
    state = 0;
    pause = true;
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}