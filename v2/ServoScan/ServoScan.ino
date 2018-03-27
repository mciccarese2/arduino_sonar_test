/*
Arduino program to control a ultrasonic 3-D mapping sensor.
The programs controls an HC-SR04 ultrasonic sensor connected to the Arduino board.
A collaborating Processing sketch interacts with this program with serial communication to control the angle 

Authors:Prithvijit Chakrabarty (prithvichakra@gmail.com)
        Kartik S. Lovekar (kslovekar@gmail.com)
*/
#include <Servo.h>
#include <NewPing.h>

//Set pin numbers
#define PING_PIN  8
#define ECHO_PIN  9
//Maximum distance(cm) the HC-SR04 can detect accurately
#define MAX_DISTANCE 450
//Time delay to wait for the receiver to register the echo
#define DELAY_LOOP  3

Servo servo1;
Servo servo2;
NewPing sonar(PING_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pin and maximum distance.
int val;

void setup() {
  pinMode(1,OUTPUT);
  //Attach servos
  servo1.attach(14); //analog pin 0
  servo2.attach(15);  //analog pin 1
  Serial.begin(9600);
  //Serial.println("Ready");
  val = 0;
  //Set servos to 0 degreees initially
  servo1.write(val);
  servo2.write(val);
}

void loop() {
  //Protocol to communicate with the Processing sketch
  if(Serial.available()){
    int c = Serial.read();
    //delay(50);
    switch(c){
      case '0'...'9': val = val*10 + c - '0';
                      break;
      case 'x': servo1.write(val);
                scan(1);
                c = '\0';
                break;
      case 'y': servo2.write(val);
                scan(2);
                c = '\0';
                break;
    }
    //servo1.write(c);
    //delay(50);
  }
}

//Run one scan with a sonar ping
void scan(int servo_num){
  int avg = 0, i, NUM = 3;
  //for(i = 0; i < NUM; i++){
      unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
      /*int dist = sonar.ping();
      avg += dist;
      //delay(30);
  }
  unsigned int uS = avg/NUM;*/
  
  //Format to communicate with the Processing sketch <servo_num>-<angle>:<distance>c
  //servo_num represents the horizontal or vertical servo
  Serial.print(servo_num);
  Serial.print("-");
  Serial.print(val);
  Serial.print(":");
  //Convert to cm
  Serial.print(uS / US_ROUNDTRIP_CM);
  Serial.print("c");
  val = 0;
}
