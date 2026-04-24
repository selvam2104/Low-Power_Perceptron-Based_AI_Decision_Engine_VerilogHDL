# Low-Power Perceptron-Based AI Decision Engine (VerilogHDL)

## Overview
This project implements a **low-power AI inference engine** on FPGA using a **single-layer perceptron model**.
The system performs **real-time binary classification** by processing input features received via UART and generating a hardware-based decision output.
The design is fully written in **Verilog HDL**, verified through simulation, and synthesized using **Xilinx Vivado** with successful timing closure.

---

## Key Features
* Parameterized RTL design (`DATA_WIDTH`, `NUM_FEATURES`, `FRAC_WIDTH`)
* Hardware implementation of **Perceptron (MAC + Bias)**
* Activation layer for **binary decision (threshold-based)**
* UART-based **real-time feature input**
* Modular design (communication, compute, control separation)
* Fully verified using **testbench + waveform analysis**
* FPGA-ready with constraints and synthesis reports

---

## System Architecture
The system is divided into the following modules:
* **UART RX** → Receives serial input data
* **Packet Parser** → Extracts feature values
* **Perceptron Core** → Computes weighted sum (MAC operation)
* **Activation Layer** → Applies threshold to generate prediction
* **UART TX (optional)** → Sends output back to host

---

## Perceptron Model
The decision engine follows:
        **y = sign( Σ (wi × xi) + b )**
Where:
* `xi` → Input features
* `wi` → Weights
* `b` → Bias
* `y` → Binary output (0 / 1)

---

## Application Demo
**Use Case:** Character Classification (Is it ‘A’ or Not?)
* Features representing structural properties are sent via UART
* The perceptron evaluates the input
* Output:
  * `1` → It is 'A'
  * `0` → Not 'A'

---

## Results

### esource Utilization
* ~1% FPGA usage (LUTs & Registers)
* Efficient hardware footprint

### Timing Performance
* Positive Worst Negative Slack (WNS): ~11 ns
* Total Negative Slack (TNS): 0
* No timing violations → **Timing Closure Achieved**

---

## Tools & Technologies
* **Verilog HDL**
* **Xilinx Vivado**
* **ModelSim / Icarus Verilog**
* **FPGA: Artix-7**

---

## Repository Structure
rtl/           → RTL design files  
tb/            → Testbench  
sim/           → Waveforms & logs  
reports/       → Vivado synthesis & timing reports  
constraints/   → XDC file  
docs/          → Presentation / documentation  

---

## Simulation & Reports
* Waveform showing feature input and prediction
<img width="1919" height="1079" alt="Screenshot 2026-04-16 094716" src="https://github.com/user-attachments/assets/d1a8e99a-ff8c-476e-9066-d26cc5f4c449" />

* Vivado utilization report
<img width="1615" height="394" alt="Screenshot 2026-04-16 095945" src="https://github.com/user-attachments/assets/4129ac29-6741-43cb-a830-9e6d536e5770" />

* Timing summary report
<img width="1616" height="393" alt="Screenshot 2026-04-16 095906" src="https://github.com/user-attachments/assets/b6b638b2-9690-47a8-b0b2-271b4e41c625" />

---

## Future Work
* Multi-layer neural network implementation
* Runtime programmable weights (via UART/BRAM)
* Multi-class classification
* Pipeline optimization for higher throughput
* Integration with real sensor/image input

---

## Conclusion
This project demonstrates how **AI inference can be efficiently implemented in hardware** using a perceptron model.
The design achieves **low resource utilization, timing closure, and modular scalability**, making it suitable for **real-time embedded AI applications**.

---

## Author
**Pradeep Palaniselvam**
Aspiring VLSI/FPGA Design Engineer
