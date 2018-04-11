// —————————————————————————
// Example NewPing library sketch that does a ping about 20 times per second.
// —————————————————————————
#include <NewPing.h>
#define TRIGGER_PIN A9 // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN A8 // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 600 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400 - 500cm.
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.
void setup() {
  Serial.begin(115200); // Open serial monitor at 115200 baud to see ping results.
  while (Serial.available()) {
    int temp = Serial.read();
  }
}
void loop() {
  if (Serial.available()) {
    int temp = Serial.read();
    // *** Replace these lines with your sensor reading code
    // I used a ping sensor to measure distance
    unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
    int value = uS / US_ROUNDTRIP_CM; // convert from time to distance
    // try looking at a floating analog input
    //int value = analogRead(A1); // touch the A1 pin and you will see the value change
    // *** end of sensor reading code (make sure you store as an integer called value)
    Serial.write(value / 256);
    Serial.write(value % 256);
  }
}
