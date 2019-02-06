/* CONWAY'S GAME OF LIFE (INCOMPLETE) */

// Size of cells
int cellSize = 25;

// Variables for timer
int interval = 100; // For every 100 milliseconds, it would iterate to its next state
int lastRecordedTime = 0;

// Colours for dead and alive cells
color alive = color(0);
color dead = color(255);

// Array of cells
int[][] cells; 

// Buffer to record the state of the cells 
int[][] cellsBuffer; 

// Pause function to start true, in order to draw cells
boolean pause = true;

void setup() {
  size (1200, 600);
  background(255); // Fill in black in case cells don't cover all the windows
  
  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(alive); // If alive
      }
      else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
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
      fill(dead); // Fill with kill colour
    }
    else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive colour
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}



void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      for (int col=x-1; col<=x+1;col++) {
        for (int row=y-1;row<=y+1;row++) {  
          if (((col>=0)&&(col<width/cellSize))&&((row>=0)&&(row<height/cellSize))) { // Make sure you are not out of bounds
            if (!((col==x)&&(row==y))) { // Make sure to to check against self
              if (cellsBuffer[col][row]==1){
                neighbours ++; // Check alive neighbours and count them
              }
            } 
          } 
        } 
      }
      
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
         if (neighbours < 2) { // Underpopulation
          cells[x][y] = 0; // Dies if less than 2
        }
        else if (neighbours > 3) { // Overcrowding
          cells[x][y] = 0; // Dies if more than 
        }
        else if (neighbours < 2 || neighbours > 3) { // Survival/Creation of Life
          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
        }
      } 
      else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbours
        }
      } 
    } 
  } 
} 

void keyPressed() {
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  
  if (key=='c' || key == 'C') { // Clear all
  pause = true;
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}