import processing.serial.*;
Serial myPort;
String data;     
int k = 0 ;

    float val ;
    float angle ;
    float radius ;

void setup() 
{
  size(1500, 550);
  
  clearAll(); // to draw the default monitor of radar
      
  // String portName = Serial.list()[5]; 
  // myPort = new Serial ( this, portName, 9600);
  myPort = new Serial(this,"COM3", 9600); // starts the serial communication
 
}

void draw() 
{
if ( myPort.available() > 0) 
 {  
  data = myPort.readStringUntil('\n') ;
  if (data != null )
 {
         val = float(data);
         angle = (5.625 * floor(val/100));
         radius = (val-floor(val/100)*100)*10;
         k=k+15;
         fill(0,0,0);
         text(radius, 1200, k);
         text(angle, 1300,  k);
          
          
            pushMatrix();
            translate(550, 550);
            rotate(radians(-90));  // no we have: direction of x axe to the right and y axes is up
                                   
         fill(30,200,30);
         ellipse(radius * sin(radians(angle)), radius * cos(radians(angle)) , 20,25);
         

        
        if((angle == 180)||(angle == 0))
        {
        delay(2000);
        clearAll();
        //this is not needed line
        ellipse(radius * sin(radians(angle)), radius * cos(radians(angle)) , 20,25);
        
        }
        
        popMatrix();
        
   }
    
 }
  
}



void clearAll ()  // to reset the canavas
{
    fill(57, 68, 212);
  arc(550, 550, 1100, 1100, 180, 360);
  noFill();
  
   for (int i = 0; i < 11; i++)
  {
    ellipse(550,550,1000-(i*100),1000-(i*100));
  }
  line(550,550,550,0);
      
      textSize(20);
      textAlign(CENTER);
      fill(250,250,250);
      for (int i = 0; i < 12; i++) 
      { 
       text(i*5, 550, 550-(50*i))   ;
      } 
      
fill(143,191,230);
rect(1150,0,300,550,15);
k=0;
}