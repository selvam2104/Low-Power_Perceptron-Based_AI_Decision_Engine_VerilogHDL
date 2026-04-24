# RTL Modules Documentation

## Overview
This directory contains all the **Register Transfer Level (RTL) design modules** for the **Low-Power Perceptron-Based AI Decision Engine**.
The design is modular, parameterized, and written in **Verilog HDL**, following industry-style coding practices for clarity, scalability, and reusability.

---

## Design Philosophy
* Modular architecture (each block has a clear function)
* Parameterized design for flexibility
* Synthesizable and FPGA-ready RTL
* Separation of **control**, **datapath**, and **communication**

---

## Module List

### 1. `ai_system_top.v`
**Top-level integration module**
* Connects all submodules:
  * UART communication
  * Perceptron core
  * Activation layer
* Manages overall data flow
* Interface between external input (UART) and AI output

---

### 2. `comm_top.v`
**Communication subsystem**
* Integrates:
  * `uart_rx`
  * `packet_parser`
* Converts serial data into parallel feature inputs
* Generates `packet_valid` signal

---

### 3. `uart_rx.v`
**UART Receiver**
* Receives serial data from external source (PC)
* Converts serial bits into 8-bit parallel data
* Generates `rx_done` signal when byte is received

---

### 4. `packet_parser.v`
**Feature extraction module**
* Implements FSM-based packet decoding
* Detects:
  * Start byte (`0xAA`)
  * End byte (`0x55`)
* Extracts and assigns feature values (`feature0` to `feature7`)
* Generates `packet_valid` signal

---

### 5. `perceptron_core.v`
**AI computation engine**
* Implements:
  * Multiply-Accumulate (MAC) operation
  * Weighted sum calculation
* Uses:
  * Input features (`xi`)
  * Predefined weights (`wi`)
  * Bias (`b`)
* Produces:
  * `result` (computed score)
  * `done` signal

---

### 6. `perceptron_mac.v`
**MAC unit (datapath)**
* Performs:
  * Multiplication: `wi × xi`
  * Accumulation of results
* Designed for:
  * Sequential operation (low-power)
  * Fixed-point arithmetic support

---

### 7. `activation_layer.v`
**Decision layer**
* Applies threshold-based classification
* Converts computed score into binary output:
  * `prediction = 1` → Positive class
  * `prediction = 0` → Negative class
* Generates `decision_valid` signal

---

### 8. `uart_tx.v` *(Optional / Output module)*
**UART Transmitter**
* Sends classification result back to host
* Converts parallel data into serial output
* Controlled using `tx_start` signal

---

## Parameterization
Key parameters used across modules:
```verilog
parameter DATA_WIDTH   = 8;
parameter FRAC_WIDTH   = 4;
parameter NUM_FEATURES = 8;
parameter CLKS_PER_BIT = 434;
```

### Benefits:
* Easy scalability
* Supports different precision formats
* Reusable across applications

---

## Data Flow Summary
UART RX → Packet Parser → Perceptron Core → Activation Layer → Output

---

## Notes

* All modules are **synthesizable**
* Designed for **FPGA implementation (Artix-7)**
* Verified using **testbench and waveform simulation**

---

## Conclusion

The RTL modules are designed with a focus on **modularity, efficiency, and scalability**, enabling easy integration of AI functionality into hardware systems.

Each module is independently testable and collectively forms a complete **AI inference pipeline**.
