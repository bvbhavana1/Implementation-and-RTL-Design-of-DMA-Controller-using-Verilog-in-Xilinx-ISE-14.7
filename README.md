# Implementation-and-RTL-Design-of-DMA-Controller-using-Verilog-in-Xilinx-ISE-14.7  & Spartan-6 FPGA Implementation

<p align="center">

  <img src="https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/FPGA-Spartan--6-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Simulation-Xilinx%20ISim-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Synthesis-Xilinx%20XST-red?style=for-the-badge">
  <img src="https://img.shields.io/badge/Status-Verified-success?style=for-the-badge">

</p>

## Overview

This project implements a **single-channel Direct Memory Access (DMA) controller** in synthesizable Verilog HDL.

The DMA controller autonomously transfers a programmable block of **8-bit data between source and destination memory locations**, reducing the need for CPU intervention during the actual transfer.

The controller is built around a **5-state finite state machine (FSM)**:

```text
IDLE → READ → READ_WAIT → WRITE → READ → ... → DONE → IDLE
