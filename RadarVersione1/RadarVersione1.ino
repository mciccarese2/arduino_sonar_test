// —————————————————————————
// Example NewPing library sketch that does a ping about 20 times per second.
// —————————————————————————

#include <NewPing.h>
#include <Servo.h>

#define TRIGGER_PIN A8 // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN A7 // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 300 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
Servo myServo; // Creates a servo object for controlling the servo motor
void setup() {
  myServo.attach(9); // Defines on which pin is the servo motor attached
  Serial.begin(115200); // Open serial monitor at 115200 baud to see ping results.
  while (Serial.available()) {
    int temp = Serial.read();
  }

}

void loop() {
  unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
  int value = uS / US_ROUNDTRIP_CM; // convert from time to distance
Serial.write(">>" + value);
  
  if (Serial.available()) {
    int temp = Serial.read();
    // *** Replace these lines with your sensor reading code

    // I used a ping sensor to measure distance
    unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
    int value = uS / US_ROUNDTRIP_CM; // convert from time to distance

    // try looking at a floating analog input
    //int value = analogRead(A1); // touch the A1 pin and you will see the value change

    // *** end of sensor reading code (make sure you store as an integer called value)
    // Serial.write(value / 256);
    // Serial.write(value % 256);

    for (int i = 1; i <= 165; i++) {
      myServo.write(i);
      delay(30);
      uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
      value = uS / US_ROUNDTRIP_CM; // convert from time to distance

      /**Serial.print(i); // Sends the current degree into the Serial Port
        Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
        Serial.print(distance); // Sends the distance value into the Serial Port
        Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      **/
      Serial.write(value / 256);
      Serial.write(value % 256);
    }

    // Repeats the previous lines from 165 to 15 degrees
    for (int i = 165; i > 15; i--) {
      myServo.write(i);
      delay(30);
      uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
      value = uS / US_ROUNDTRIP_CM; // convert from time to distance
      Serial.write(value / 256);
      Serial.write(value % 256);

    }

  }

}
