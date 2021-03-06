
import processing.serial.*;
Serial myPort;  
int time, i, currentServoAngle, k, m, ANGLE, DISTANCE;
float ANGLE_RAD;
float x, y;
float[] x_mem=new float[200];
float[] y_mem=new float[200];
float[] x_width =new float[200];
float[] y_width =new float[200];
int CHECK_ANG_INT;
int CHECK_SON_int;
int OBJECT_WIDTH = 4;


PFont Font1;

void setup() {
  size(800, 400);
  Font1 = createFont("Times New Roman Bold", 16);
  println(Serial.list());
  smooth();
  myPort = new Serial(this, Serial.list()[0], 115200);
  translate(400, 400);
}

void draw_background()
{
  background(0, 30, 30);  

  fill(0, 102, 51);
  textFont(Font1);
  text("Arduino Radar v1.0", 10, 30);
  fill(0, 51, 0);
  arc(400, 400, 800, 800, PI, 2*PI, CHORD);
  noFill(); 
  stroke(0, 251, 32) ;
  arc(400, 400, 700, 700, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 600, 600, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 500, 500, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 400, 400, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 300, 300, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 200, 200, PI, 2*PI, CHORD);
  noFill();
  arc(400, 400, 100, 100, PI, 2*PI, CHORD);
  line(400, 400, 400, 0);

  line(400, 400, 25, 250);
  line(400, 400, 775, 250);

  line(400, 400, 115, 115);
  line(400, 400, 685, 115);

  line(400, 400, 235, 35);
  line(400, 400, 565, 35);
}

void draw() {

  draw_background();
  String INPUT_ANGLE = myPort.readStringUntil('*');
  String INPUT_DIST = myPort.readStringUntil('^');

  if (INPUT_ANGLE != null) { 
    INPUT_ANGLE = INPUT_ANGLE.replaceFirst("\\*", "");   
    ANGLE=int(INPUT_ANGLE);
    ANGLE_RAD=radians(ANGLE);
    currentServoAngle=ANGLE;
  }
  if (INPUT_DIST != null) {
    INPUT_DIST = INPUT_DIST.replaceFirst("\\^", "");    
    DISTANCE=int(INPUT_DIST);
    DISTANCE=DISTANCE*5;
  } 
  
  if (1 == 1)
  {

    if (DISTANCE>=300) {
      // Large distance object need not be plotted
      DISTANCE= 0;
    }
    
    
    println(DISTANCE);
    println(currentServoAngle);
    i=i+10;
    x=DISTANCE*cos(ANGLE_RAD); 
    text(400+x, 10, 60);
    y=DISTANCE*sin(ANGLE_RAD); 
    text(400-y, 10, 80);
    x_mem[currentServoAngle]=400+x;
    y_mem[currentServoAngle]=400-y;

    if (DISTANCE < 300 )
    {
      x_width[currentServoAngle] = 400 + ((DISTANCE + OBJECT_WIDTH)*cos(ANGLE_RAD));
      y_width[currentServoAngle] = 400 - ((DISTANCE + OBJECT_WIDTH)*sin(ANGLE_RAD));
    } else {
      x_width[currentServoAngle] = x_mem[currentServoAngle];
      y_width[currentServoAngle] = y_mem[currentServoAngle];
    }
    // if (DISTANCE<400)
    for (k=0; k<180; k++)
    {
      stroke(127, 255, 0); 
      fill(127, 255, 0); 
      ellipse(400, 400, 4, 4); 
      ellipse(x_mem[k], y_mem[k], 4, 4); 
      ellipse(x_width[k], y_width[k], 4, 4); 
      //line(x_width[k], y_width[k], x_mem[k], y_mem[k]);
    }

    if (i>800) {
      i=0;
    }
    noFill();
    stroke(255, 0, 51) ;


    arc(400, 400, i, i, PI, 2*PI, CHORD);
    arc(400, 400, i-1, i-1, PI, 2*PI, CHORD);
    arc(400, 400, i-2, i-2, PI, 2*PI, CHORD);
    arc(400, 400, i-3, i-3, PI, 2*PI, CHORD);
    arc(400, 400, i-4, i-4, PI, 2*PI, CHORD);
  }
}