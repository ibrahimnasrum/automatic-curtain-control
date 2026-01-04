# Automatic Curtain System (Control & Automation Project)

An Arduino-based **automatic curtain control system** that uses an **ultrasonic sensor** as user input and a **DC motor with encoder** for precise position control. A **PID-style feedback controller** drives the motor smoothly to a target position derived from the measured distance.

> 📌 This repository includes the project report and control simulation files for reference and learning.

---

## Project Overview

This project demonstrates a practical control & automation workflow:
- **Measure distance** using an ultrasonic sensor (e.g., a hand gesture near the sensor).
- **Map distance (0–10 cm)** to a **target encoder position (0–1200)** to represent curtain opening level.
- Use **PID feedback** to reduce error between current motor position and target position for smoother motion.
- Track motor position via **encoder interrupts** for real-time updates.
- Output key signals (target, current position, distance) to **Serial Plotter** for visualization and tuning.

---

## Key Features
- Distance-based curtain positioning (gesture/proximity input)
- Encoder-based position tracking (interrupt-driven)
- PID/P(D) control for smooth movement & reduced oscillation
- Real-time monitoring using Serial Plotter

---

## Hardware / Components
- **Arduino Uno** (main controller)
- **Ultrasonic Sensor** (distance input)
- **DC Motor + Encoder** (curtain actuation & position feedback)
- **Motor Driver** (direction + PWM speed control)
- Mechanical coupling (e.g., pulley system)

---

## Control Method (How It Works)

### 1) Distance Measurement
The ultrasonic sensor measures pulse time and converts it into distance (cm).

### 2) Distance → Target Position Mapping
Distance (0–10 cm) is mapped to an encoder target range (0–1200).

### 3) PID Feedback Control
The controller computes error:
- **error = current_position - target_position**

and generates a control signal using PID terms (commonly P + D used to reduce jerk/overshoot).

### 4) Motor Control (PWM + Direction)
The control signal is converted to:
- PWM power (0–255)
- motor direction (forward/reverse)

### 5) Encoder Position Tracking
Encoder interrupts increment/decrement the position variable in real-time.

---

## PID Tuning Notes (From Testing)

Initial tuning:
- **KP = 0.8, KD = 0.15** → caused **very large jerk motion** when an object is within sensor range.

Improved tuning:
- **KP = 0.5, KD = 0.17** → **smaller jerk motion** and **slower/steadier rotation**.

---

## Repository Contents
- `Full_Report_Robotics_Project.pdf` (project report / slides)
- `pid_ultrasonic_motor_sim.m` (MATLAB simulation)
- `pid_ultrasonic_motor_sim.py` (Python simulation)
- `curtaincode.uno` (Arduino implementation)
- `README.md`

---

## How to Run (Arduino)

1. Open `curtaincode.uno` in **Arduino IDE**
2. Select:
   - Board: **Arduino Uno**
   - Correct COM port
3. Upload to Arduino
4. Open **Serial Plotter** to observe:
   - Target position
   - Current encoder position
   - Distance readings

> Tip: Start with the improved tuning values (KP=0.5, KD=0.17) and fine-tune based on your motor/load.

---

## How to Run (Simulation)

### MATLAB
- Open and run:
  - `pid_ultrasonic_motor_sim.m`

### Python
- Run:
  ```bash
  python pid_ultrasonic_motor_sim.py
