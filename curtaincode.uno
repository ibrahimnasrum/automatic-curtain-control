#include <util/atomic.h>
#include <math.h>


// PINS (WIRING)

const int TRIG = 9;
const int ECHO = 10;

const int ENCA = 2;   // Encoder A (must be interrupt pin on UNO: 2 or 3)
const int ENCB = 4;   // Encoder B

const int PWM  = 5;   // PWM pin (motor speed)
const int IN1  = 6;   // Motor driver direction pin 1
const int IN2  = 7;   // Motor driver direction pin 2


// Encoder position variable

volatile long posi = 0;   // position (encoder counts)


// PID variables
float kp = 0.5;
float kd = 0.017;
float ki = 0.0;

float eintegral = 0.0;
float ePrev = 0.0;

// Timing
long prevT = 0;

// Target range
const int TARGET_MIN = 0;
const int TARGET_MAX = 1200;

// 5) Encoder ISR (position tracking)

void readEncoder() {
  int b = digitalRead(ENCB);
  if (b > 0) posi++;
  else       posi--;
}

// Motor control helper
// dir: +1 forward, -1 reverse
// pwr: 0..255
void setMotor(int dir, int pwr, int pwmPin, int in1Pin, int in2Pin) {
  pwr = constrain(pwr, 0, 255);

  analogWrite(pwmPin, pwr);

  if (dir >= 0) {
    digitalWrite(in1Pin, HIGH);
    digitalWrite(in2Pin, LOW);
  } else {
    digitalWrite(in1Pin, LOW);
    digitalWrite(in2Pin, HIGH);
  }
}


// 1) Ultrasonic distance (cm)

float getDistance() {
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  // pulseIn timeout to avoid blocking forever (e.g., 30ms)
  long duration = pulseIn(ECHO, HIGH, 30000);

  // Convert microseconds to cm: speed of sound ~0.0343 cm/us
  float distance = (duration * 0.0343) / 2.0;
  return distance;
}

void setup() {
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  pinMode(ENCA, INPUT_PULLUP);
  pinMode(ENCB, INPUT_PULLUP);

  pinMode(PWM, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);

  // Encoder interrupt on ENCA
  attachInterrupt(digitalPinToInterrupt(ENCA), readEncoder, RISING);

  Serial.begin(115200);

  prevT = micros();
}

void loop() {
  
  // 6) Real-time processing

  long currT = micros();
  float deltaT = ((float)(currT - prevT)) / (1.0e6);
  prevT = currT;

  
  // Read position safely (atomic)
  
  long pos = 0;
  ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
    pos = posi;
  }


  // 2) Distance -> Target mapping

  float distance = getDistance();                 // cm
  distance = constrain(distance, 0, 10);          // only 0–10 cm range

  int target = map((int)distance, 0, 10, TARGET_MIN, TARGET_MAX);
  target = constrain(target, TARGET_MIN, TARGET_MAX);


  // 3) PID control

  float e = (float)(pos - target);
  float dedt = (e - ePrev) / deltaT;
  eintegral += e * deltaT;

  float u = kp * e + kd * dedt + ki * eintegral;
  ePrev = e;

  
  // 4) Motor control
  
  float pwr_f = fabs(u);
  if (pwr_f > 255) pwr_f = 255;

  int dir = 1;
  if (u < 0) dir = -1;

  setMotor(dir, (int)pwr_f, PWM, IN1, IN2);

 
  // 7) Serial Plotter output
 
  Serial.print("Target:");
  Serial.print(target);
  Serial.print("\t");

  Serial.print("Position:");
  Serial.print(pos);
  Serial.print("\t");

  Serial.print("Distance:");
  Serial.println(distance);

  delay(10); // small delay for stability (optional)
}
