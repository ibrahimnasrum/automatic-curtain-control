\# Automatic Curtain System (Control \& Automation Project)



An Arduino-based \*\*automatic curtain control system\*\* that uses an \*\*ultrasonic sensor\*\* as user input and a \*\*DC motor with encoder\*\* for precise position control. A \*\*PID-style feedback controller\*\* drives the motor smoothly to a target position derived from the measured distance.



> 📌 This repository includes the project report and control simulation files for reference and learning.



---



\## Project Overview



This project demonstrates a practical control \& automation workflow:

\- \*\*Measure distance\*\* using an ultrasonic sensor (e.g., a hand gesture near the sensor).:contentReference\[oaicite:2]{index=2}

\- \*\*Map distance (0–10 cm)\*\* to a \*\*target encoder position (0–1200)\*\* to represent curtain opening level.:contentReference\[oaicite:3]{index=3}

\- Use \*\*PID feedback\*\* to reduce error between current motor position and target position for smoother motion.:contentReference\[oaicite:4]{index=4}

\- Track motor position via \*\*encoder interrupts\*\* for real-time updates.:contentReference\[oaicite:5]{index=5}

\- Output key signals (target, current position, distance) to \*\*Serial Plotter\*\* for visualization and tuning.:contentReference\[oaicite:6]{index=6}



---



\## Key Features



\- Distance-based curtain positioning (gesture/proximity input)

\- Encoder-based position tracking (interrupt-driven)

\- PID/P(D) control for smooth movement \& reduced oscillation:contentReference\[oaicite:7]{index=7}

\- Real-time monitoring using Serial Plotter:contentReference\[oaicite:8]{index=8}



---



\## Hardware / Components



\- \*\*Arduino Uno\*\* (main controller):contentReference\[oaicite:9]{index=9}

\- \*\*Ultrasonic Sensor\*\* (distance input):contentReference\[oaicite:10]{index=10}

\- \*\*DC Motor + Encoder\*\* (curtain actuation \& position feedback):contentReference\[oaicite:11]{index=11}

\- \*\*Motor Driver\*\* (direction + PWM speed control):contentReference\[oaicite:12]{index=12}

\- Mechanical coupling (e.g., pulley system):contentReference\[oaicite:13]{index=13}



---



\## Control Method (How It Works)



\### 1) Distance Measurement

The ultrasonic sensor measures pulse time and converts it into distance (cm).:contentReference\[oaicite:14]{index=14}



\### 2) Distance → Target Position Mapping

Distance (0–10 cm) is mapped to an encoder target range (0–1200).:contentReference\[oaicite:15]{index=15}



\### 3) PID Feedback Control

The controller computes error:

\- \*\*error = current\_position - target\_position\*\*

and generates a control signal using PID terms (commonly P + D used to reduce jerk/overshoot).:contentReference\[oaicite:16]{index=16}



\### 4) Motor Control (PWM + Direction)

The control signal is converted to:

\- PWM power (0–255)

\- motor direction (forward/reverse):contentReference\[oaicite:17]{index=17}



\### 5) Encoder Position Tracking

Encoder interrupts increment/decrement the position variable in real-time.:contentReference\[oaicite:18]{index=18}



---



\## PID Tuning Notes (From Testing)



Initial tuning:

\- \*\*KP = 0.8, KD = 0.15\*\* → caused \*\*very large jerk motion\*\* when an object is within sensor range.:contentReference\[oaicite:19]{index=19}



Improved tuning:

\- \*\*KP = 0.5, KD = 0.17\*\* → \*\*smaller jerk motion\*\* and \*\*slower/steadier rotation\*\*.:contentReference\[oaicite:20]{index=20}



---



\## Repository Contents



\- `Full\_Report\_Robotics\_Project.pdf` (project report / slides)

\- `pid\_ultrasonic\_motor\_sim.m` (MATLAB simulation)

\- `pid\_ultrasonic\_motor\_sim.py` (Python simulation)

\- `curtaincode.uno` (Arduino implementation)

\- `README.md`



---



\## How to Run (Arduino)



1\. Open `curtaincode.uno` in \*\*Arduino IDE\*\*

2\. Select:

&nbsp;  - Board: \*\*Arduino Uno\*\*

&nbsp;  - Correct COM port

3\. Upload to Arduino

4\. Open \*\*Serial Plotter\*\* to observe:

&nbsp;  - Target position

&nbsp;  - Current encoder position

&nbsp;  - Distance readings:contentReference\[oaicite:21]{index=21}



> Tip: Start with the improved tuning values (KP=0.5, KD=0.17) and fine-tune based on your motor/load.



---



\## How to Run (Simulation)



\### MATLAB

\- Open and run:

&nbsp; - `pid\_ultrasonic\_motor\_sim.m`



\### Python

\- Run:

&nbsp; ```bash

&nbsp; python pid\_ultrasonic\_motor\_sim.py



