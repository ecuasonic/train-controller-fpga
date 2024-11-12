# Train Controller

This project is a VHDL-based train controller that manages train direction and track alignment using motion sensors placed along segmented sections of the track. By detecting the train's position, the controller adjusts the track orientation (stright or diverted) enabling precise and responsive routing across the rail system. <br>

Implemented in:
- FPGA (vhdl)

## Worksheet State Diagrams

![Worksheet State Diagrams](images/worksheet-state-diagram.png)

Worksheet diagrams of train controller current states and corresponding signals, along with next state based on current state and inputs. <br>

## Signal Output Table

![signal-output-table](images/signal-output-table.png)

Describes which signals are active during each state for the train controller. <br>

## Train Controller State Diagram

![UML-state-diagram](images/uml-state-diagram.png)

Created from corresponding worksheet diagrams and output table.
