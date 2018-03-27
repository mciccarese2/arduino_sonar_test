#include<Servo.h>

#include<Ultrasonic.h>

Servo serv;

int trig = 13;

int echo = 11;

Ultrasonic utr(trig, echo);
float pingTime;
float targetDistance;
float speedOfSound = 776.5;
int th;

float dist;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  //pinMode(trig, OUTPUT);
  //pinMode(echo, INPUT);
  serv.attach(9);
  th = 0;
  serv.write(th);
  establishContact();
}

void loop() {
  // put your  main code here, to run repeatedly:
  if (Serial.available() > 0) {
    th = Serial.read();
    serv.write(th);
    dist = utr.distanceRead();
    dist = readDist();
    Serial.println(dist);
    delay(100);
  }
}

float readDist() {
  digitalWrite(trig, LOW);
  delayMicroseconds(2000);
  digitalWrite(trig, HIGH);
  delayMicroseconds(15);
  digitalWrite(trig, LOW);
  delayMicroseconds(10);
  pingTime = pulseIn(echo, HIGH);
  pingTime = pingTime / 1000000;
  pingTime = pingTime / 3600;
  targetDistance = speedOfSound * pingTime;
  targetDistance = targetDistance / 2;
  targetDistance = targetDistance * 63360;
  return targetDistance;
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");
    delay(300);
  }
}
