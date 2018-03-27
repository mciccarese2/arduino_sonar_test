/*Processing sketch to control two servos
  and an HC-SR04 ultrasonic sensor for 3D surface scanning.

Authors:Prithvijit Chakrabarty (prithvichakra@gmail.com)
        Kartik S. Lovekar (kslovekar@gmail.com)
*/

import processing.serial.*;       
import toxi.geom.*;
import toxi.processing.*;
import peasy.*;

Serial port;
ToxiclibsSupport gfx;
PeasyCam cam;
int servo_num = 1, val = 0, alpha = 0, beta = 0, dist = 0;
int INC = 3;
float SERVO_RADIUS = 3.5;
float distances[][];
ArrayList<Vec3D> cloud;
boolean scanOver;

void setup(){
  size(700, 500, P3D);
  frameRate(100);
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  
  //Setup 3D plotting tool
  gfx = new ToxiclibsSupport(this); 
  cam = new PeasyCam(this, 0, 0, 0, 100);
  cloud = new ArrayList<Vec3D>();
  scanOver = false;
  
  distances = new float[181][71];  //Holds the minimum distance to a point on a surface
  for(int i = 0; i < 181; i++)
    for(int j = 0; j < 71; j++)
      distances[i][j] = -1;
}

void draw(){
  background(255);
  if(!scanOver){
    //Control loops to control the servos on the Arduino
    for(int i = 1; i < 70; i+=INC){  //Loop for beta
      for(int j = 0; j < 180; j+=INC){  //Loop for alpha
        port.write(j+"x");  //Rotate servo 1
        delay(50);
      }
      for(int j = 180; j >= 0; j-=INC){  //Return loop for alpha
        port.write(j+"x");  //Rotate back servo 1
        delay(50);
      }
      port.write(i+"y");  //Rotate servo 2
      delay(50);
    }
  }
  scanOver = true;
  plot();
  drawAxes();
}

//Parse echo scan values returned from the Arduino
void serialEvent(Serial port){
  int next = port.read();
  //Format for return: <servo_num>-<angle>:<distance>c
  if(next == (int)('-')){
      servo_num = val;
      val = 0;
  }
  else if(next == (int)(':')){
      if(servo_num == 1)
        alpha = val;
      else if(servo_num == 2)
        beta = val;
      val = 0;
  }
  else if(next == (int)('c')){
      //Print current scan status
      println("Servo:"+servo_num+" alpha="+alpha+" beta="+beta+" Dist = "+val);
      dist = val;
      val = 0;
      
      //Find coordinates here - apply transforms to calculate (x,y,z)
      float x = SERVO_RADIUS*sin(radians(beta)) + dist*cos(radians(alpha))*cos(radians(beta));
      float y = dist*sin(radians(alpha));
      float z = SERVO_RADIUS*cos(radians(beta)) + dist*cos(radians(alpha))*sin(radians(beta));
      //Now, rotate out the faulty initial setting
      int INIT_XY = 20, INIT_XZ = 60;
      x = x*cos(radians(20))-y*sin(radians(20));
      y = x*sin(radians(20))+y*cos(radians(20));
      //rotation(INIT_XZ, x, z);
      x = x*cos(radians(60))-z*sin(-radians(60));
      z = x*sin(-radians(60))+z*cos(radians(60));
      if(distances[alpha][beta] != -1){
        distances[alpha][beta] = distances[alpha][beta]<dist?distances[alpha][beta]:dist;
        cloud.add(new Vec3D(x,y,z));
      }
      else
        distances[alpha][beta] = dist;
  }
  else if(next >= '0' && next <= '9'){
      val = val * 10 + next - (int)('0');
  }
}

//Add points from the cloud to the 3D space
void plot(){
     for(int i = 0; i < cloud.size(); i++)
        gfx.point(cloud.get(i)); 
}

void drawAxes() {
  //X axis - Red
  stroke(255, 0, 0);
  line(-500, 0, 0, 500, 0, 0);
  
  //Y axis - Green
  stroke(0, 255, 0);
  line(0, -500, 0, 0, 500, 0);
  
  //Z axis - Blue
  stroke(0, 0, 255);
  line(0, 0, -500, 0, 0, 500);
}