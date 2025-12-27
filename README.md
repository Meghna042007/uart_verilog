# UART Transmitter and Receiver – Verilog RTL

## Overview

This repository contains an RTL implementation of a UART (Universal Asynchronous Receiver–Transmitter) using Verilog HDL.
The project focuses on understanding asynchronous serial communication, baud-rate timing, and FSM-based digital design.

Both UART TX and UART RX are implemented as independent modules and integrated through a top-level design for functional verification.

## Features

FSM-based UART Transmitter (TX)

FSM-based UART Receiver (RX)

Parameterized system clock frequency and baud rate

## Standard UART frame format:

1 Start bit

8 Data bits (LSB first)

1 Stop bit

Baud-rate timing using clock counters

RX mid-bit sampling for data recovery

Modular and readable RTL structure

Functional testbench for end-to-end verification

## UART Frame Format

Communication is asynchronous (no shared clock)

Timing is derived from the system clock and baud rate

Data is transmitted and received LSB first

## Design Description
UART Transmitter (TX)

Generates start, data, and stop bits sequentially

Uses a baud counter to control bit timing

Transmits one bit per baud interval

Indicates transmission status using a busy flag

UART Receiver (RX)

Detects falling edge of the start bit

Validates start bit at mid-bit position

Samples incoming data at the center of each bit period

Reconstructs the received byte using a shift register

Asserts a completion flag after a valid frame is received

Top-Level Integration

Connects TX output directly to RX input (loopback)

Enables functional verification without external hardware

Demonstrates full TX → RX data flow

## Verification

A loopback testbench is used to verify functionality

TX output is connected directly to RX input

Testbench validates:

FSM transitions

Baud-rate timing

Correct data reception

##Tools Used

Verilog HDL

Vivado Simulator (or equivalent RTL simulator)

## Notes

This project is intended for learning and experimentation

The design is parameterized and can be extended

Possible future enhancements include:

Parity support

Multiple stop bits

Improved RX robustness

Integration with external peripherals

## Author

Developed as part of hands-on learning in digital design, FSMs, and communication protocols.
