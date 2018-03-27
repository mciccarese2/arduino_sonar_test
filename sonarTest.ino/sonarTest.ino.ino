int distance;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("Start ");
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(1000);
  
  for (int i = 15; i <= 165; i++)
  {
    delay(100);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  for (int i = 165; i > 15; i--)
  {
    delay(100);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

int calculateDistance()
{
  int randNumber = random(1, 6000);
  return randNumber;
}
