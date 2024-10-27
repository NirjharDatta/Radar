#include <Servo.h>
Servo ultrasonicServo;  
Servo laserServo;  
const int trigPin = 11;      
const int echoPin = 10;      
const int buzzerPin = 5;  
long duration;
int distance;
int detectedAngle = -1;
void setup() {
    Serial.begin(9600);  
    ultrasonicServo.attach(9); 
    laserServo.attach(6);       
    pinMode(trigPin, OUTPUT);
    pinMode(echoPin, INPUT);    
    pinMode(buzzerPin, OUTPUT);
    digitalWrite(buzzerPin, LOW); 
}
void loop() {
    bool objectDetected = false;     
    for (int angle = 0; angle <= 180; angle += 1) {        
        ultrasonicServo.write(angle);
        delay(10);          
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);        
        duration = pulseIn(echoPin, HIGH);
        distance = duration * 0.034 / 2;          
        Serial.print(angle);
          Serial.print(",");
          Serial.print(distance);
          Serial.print(".");
          if (distance > 0 && distance < 40) {  
            laserServo.write(angle);  
            objectDetected = true;    
        }        
        if (distance > 0 && distance < 40) {
            digitalWrite(buzzerPin, HIGH);  
        } 
        else {
            digitalWrite(buzzerPin, LOW);   
        }
        delay(10);  
    }    
    for (int angle = 180; angle >= 0; angle--) {        
        ultrasonicServo.write(angle);
        delay(10);         
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);        
        duration = pulseIn(echoPin, HIGH);
        distance = duration * 0.034 / 2;  
        Serial.print(angle);
        Serial.print(",");
        Serial.print(distance);
        Serial.print(".");        
        if (distance > 0 && distance < 40) {  
            laserServo.write(angle);  
            objectDetected = true;    
        }
        if (distance > 0 && distance < 40) {
            digitalWrite(buzzerPin, HIGH);  
        } else {
            digitalWrite(buzzerPin, LOW);   
        }
        delay(10);  
    }
    delay(10);  
}