#include <NewPing.h>
#include <Servo.h>

Servo myservo;  
int PIEZO_RED_WIRE = 10;
#define TRIGGER_PIN  11  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     10  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 200 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
int SERVO_ANGLE = 0;
int j=0;
int check_ang;
int check_son;
int temp;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

void setup() {
  Serial.begin (115200);
  myservo.attach(9);
  pinMode(PIEZO_RED_WIRE, OUTPUT);
  //  pinMode(trigPin, OUTPUT);
  //  pinMode(echoPin, INPUT);

}

void loop() {




  for(SERVO_ANGLE = 0; SERVO_ANGLE < 180; SERVO_ANGLE += 1)  // goes from 0 degrees to 180 degrees
  {                                  // in steps of 1 degree
    myservo.write(SERVO_ANGLE);  
    Serial.print(SERVO_ANGLE); 
    Serial.print("*");             // tell servo to go to SERVO_ANGLE
    delay(40);
    unsigned int uS = sonar.ping();
    temp=uS / US_ROUNDTRIP_CM; // Send ping, get ping time in microseconds (uS).
    Serial.print(uS / US_ROUNDTRIP_CM); 
    Serial.print("^");// Convert ping time to distance in cm and print result (0 = outside set distance range)
    if (j==10) {
      for(int i=0;i<100;i++)
      {
        digitalWrite(PIEZO_RED_WIRE, HIGH);
        delayMicroseconds(100);
        digitalWrite(PIEZO_RED_WIRE, LOW);
        delayMicroseconds(100); 
        j=0;
      } 
    }

    j++;
    delay(50);
  }

  for(SERVO_ANGLE = 180; SERVO_ANGLE>=1; SERVO_ANGLE-=1)     // goes from 180 degrees to 0 degrees
  {                                
    myservo.write(SERVO_ANGLE);   
    Serial.print(SERVO_ANGLE);  
    Serial.print("*");                // tell servo to go to SERVO_ANGLE
    delay(40);
    unsigned int uS = sonar.ping(); 
    temp=uS / US_ROUNDTRIP_CM; // Send ping, get ping time in microseconds (uS).
    Serial.print(uS / US_ROUNDTRIP_CM);
    Serial.print("^"); // Convert ping time to distance in cm and print result (0 = outside set distance range)

    if (j==10) {  
      for(int i=0;i<100;i++)
      {
        digitalWrite(PIEZO_RED_WIRE, HIGH);
        delayMicroseconds(100);
        digitalWrite(PIEZO_RED_WIRE, LOW);
        delayMicroseconds(100); 
        j=0;
      } 
    }
    j++;
    delay(50);
  }

  check_ang= SERVO_ANGLE | 0x0000; 
  Serial.print(check_ang); 
  Serial.print("$");
  check_son= temp | 0x0000; 
  Serial.print(check_son); 
  Serial.print("#");

}
