/*
luckylarry.co.uk
 Radar Screen Visualisation for SRF-05
 Maps out an area of what the SRF-05 sees from a top down view.
 Takes and displays 2 readings, one left to right and one right to left.
 Displays an average of the 2 readings
 Displays motion alert if there is a large difference between the 2 values.
 */
import processing.serial.*;     // import serial library
Serial myPort;                  // declare a serial port
float x, y;                       // variable to store x and y co-ordinates for vertices
int radius = 350;               // set the radius of objects
int w = 300;                    // set an arbitary width value
int degree = 0;                 // servo position in degrees
int value = 0;                  // value from sensor
int motion = 0;                 // value to store which way the servo is panning
int[] newValue = new int[181];  // create an array to store each new sensor value for each servo position
int[] oldValue = new int[181];  // create an array to store the previous values.
PFont myFont;                   // setup fonts in Processing
int radarDist = 0;              // set value to configure Radar distance labels
int firstRun = 0;               // value to ignore triggering motion on the first 2 servo sweeps

/* create background and serial buffer */
void setup() {
  // setup the background size, colour and font.
  size(750, 450);
  background (0); // 0 = black
  myFont = createFont("verdana", 12);
  textFont(myFont);
  // setup the serial port and buffer
 
  myPort = new Serial(this,"COM3", 9600); // starts the serial communication
  myPort.bufferUntil('n');
}

/* draw the screen */
void draw() {
  fill(0);                              // set the following shapes to be black
  noStroke();                           // set the following shapes to have no outline
  ellipse(radius, radius, 750, 750);    // draw a circle with a width/ height = 750 with its center position (x and y) set by the radius
  rectMode(CENTER);                     // set the following rectangle to be drawn around its center
  rect(350, 402, 800, 100);                // draw rectangle (x, y, width, height)
  if (degree >= 179) {                  // if at the far right then set motion = 1/ true we're about to go right to left
    motion = 1;                         // this changes the animation to run right to left
  }
  if (degree <= 1) {                    // if servo at 0 degrees then we're about to go left to right
    motion = 0;                         // this sets the animation to run left to right
  }
  /* setup the radar sweep */
  /*
  We use trigonmetry to create points around a circle.
   So the radius plus the cosine of the servo position converted to radians
   Since radians 0 start at 90 degrees we add 180 to make it start from the left
   Adding +1 (i) each time through the loops to move 1 degree matching the one degree of servo movement
   cos is for the x left to right value and sin calculates the y value
   since its a circle we plot our lines and vertices around the start point for everything will always be the center.
   */
  strokeWeight(7);                      // set the thickness of the lines
  if (motion == 0) {                    // if going left to right
    for (int i = 0; i <= 20; i++) {     // draw 20 lines with fading colour each 1 degree further round than the last
      stroke(0, (10*i), 0);             // set the stroke colour (Red, Green, Blue) base it on the the value of i
      line(radius, radius, radius + cos(radians(degree+(180+i)))*w, radius + sin(radians(degree+(180+i)))*w); // line(start x, start y, end x, end y)
    }
  } else {                              // if going right to left
    for (int i = 20; i >= 0; i--) {     // draw 20 lines with fading colour
      stroke(0, 200-(10*i), 0);          // using standard RGB values, each between 0 and 255
      line(radius, radius, radius + cos(radians(degree+(180+i)))*w, radius + sin(radians(degree+(180+i)))*w);
    }
  }
}