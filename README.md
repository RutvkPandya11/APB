# APB
Verilog Implementation of APB Simplified 

For direct implementation skip to "Step - 9".

## APB Protocol Verilog Implementation
This project provides a Verilog implementation of the Advanced Peripheral Bus (APB) protocol, including an APB master, APB slave, and a testbench. 
The APB master handles state transitions for read and write operations, while the APB slave simulates memory access and response signals. 
The testbench generates clock and reset signals, applies test sequences, and verifies the correct functionality of the APB master and slave modules. Waveform dumping is included for detailed analysis using GTKWave.

## Prerequisites
To run this project, you need to have the following tools installed:
1. **Icarus Verilog**: 
2. **GTKWave**: A waveform viewer for visualizing simulation results.

## Note
To create more instances of the slave module, you can either copy-paste to create the new slave module in the design or you can simply do more instantiation in the testbench if you just want to see simulation and not create more instantiations of the actual slave unit.

## APB Protocol Project Overview

### 1. Introduction to APB Protocol
- **Overview**: The Advanced Peripheral Bus (APB) is part of the AMBA (Advanced Microcontroller Bus Architecture) family, designed for low-power and low-complexity communication with peripheral devices.
- **Key Features**: Simple, non-pipelined protocol, low bandwidth, and minimal power consumption.

### 2. APB Protocol Basics
- **Signals**:
  - `PCLK`: Clock signal.
  - `PSEL`: Select signal.
  - `PADDR`: Address bus.
  - `PWRITE`: Write enable.
  - `PWDATA`: Write data bus.
  - `PRDATA`: Read data bus.
  - `PREADY`: Ready signal.
  - `PSLVERR`: Slave error signal.
  - `PSTRB`: Write strobe signal, indicates which byte lanes to update during a write transfer.

### 3. Working of APB Protocol
- **Read Operation**: The master initiates a read by setting `PSEL` and `PADDR`, then waits for `PREADY` from the slave to read `PRDATA`.
- **Write Operation**: The master sets `PSEL`, `PADDR`, `PWRITE`, `PWDATA`, and `PSTRB`, then waits for `PREADY` from the slave to complete the write.

### 4. Implementation
- **APB Master**: Controls the communication, initiates read/write operations.
- **APB Slaves**: Respond to the master’s requests, typically peripheral devices.

### 5. State Machine Flow for APB Master

![image](https://github.com/user-attachments/assets/0f3d5263-e93f-4586-a082-d0e4066be2f4)

- **IDLE**: Default state where the master is not performing any operation.
- **SETUP**: The master sets up the address, data, and control signals.
- **ACCESS**: The master enables the transfer and waits for the slave to signal readiness.

### 6. Add RTL Code
- Add RTL Code for APB Master (`apb_master.v`) in your directory.
- Add RTL Code for APB Slave (`apb_slave.v`) in your directory.
- Add Testbench in your directory (`tb_apb.v`).

### 7. Expected Correct Responses
- **Write Operation to Slave 1**:
  - `PREADY1` should be asserted by the slave when it is ready to accept the data.
  - `PRDATA1` should reflect the data written to the corresponding address.
- **Read Operation from Slave 1**:
  - `PREADY1` should be asserted by the slave when it is ready to provide the data.
  - `PRDATA1` should match the data written to the corresponding address.
- **Write Operation to Slave 2**:
  - `PREADY2` should be asserted by the slave when it is ready to accept the data.
  - `PRDATA2` should reflect the data written to the corresponding address.
- **Read Operation from Slave 2**:
  - `PREADY2` should be asserted by the slave when it is ready to provide the data.
  - `PRDATA2` should match the data written to the corresponding address.

### 8. Using GTKWave for Waveform Analysis
- **Generate VCD File**: Ensure your simulation tool generates a Value Change Dump (VCD) file during simulation.
- **Open GTKWave**: Load the VCD file into GTKWave.
- **Analyze Signals**: Use GTKWave to view and analyze the waveforms of your APB signals. This helps in verifying the correct operation of your design by visually inspecting the signal transitions and states.

### 9. Example Steps to Verify the Code
- **Save the Verilog Code**: Save the APB Master, APB Slave, and the testbench code into separate `.v` files.
- **Install Icarus Verilog**.
- **Compile the Code**: Use the following command to compile the Verilog files:
  ```  iverilog -o apb_testbench tb_apb.v apb_master.v apb_slave.v
- **Run the Simulation**: Use the following command to compile the Verilog files:
  ```  vvp apb_testbench
- **View the Waveforms**: Use the following command to compile the Verilog files:
  ```  gtkwave tb_apb.vcd

  
