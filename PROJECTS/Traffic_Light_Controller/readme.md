# Traffic Light Controller — Verilog FSM
A parameterized traffic light controller implemented in Verilog using a finite state machine (FSM). This project focuses on sequential logic, state transitions, timing control, and enhanced testbench verification.

## Features
- Three-state FSM: RED, GREEN, and YELLOW.
- Parameterized phase durations for configurable timing.
- Synchronous active-high reset.
- Binary state encoding.
- One-hot output safety checking: exactly one light must be active.
- Automated testbench with directed verification scenarios.
- Reset-during-operation testing.
- Simulation and waveform analysis using Icarus Verilog and GTKWave.

## Architecture
The controller cycles through the following sequence:
`RED → GREEN → YELLOW → RED`
The phase counter tracks the duration of the current state. When the configured number of clock cycles is reached, the controller transitions to the next state and clears the phase counter.

### Default timing parameters
| Parameter | Default value |
| `RED_CYCLES` | 5 |
| `GREEN_CYCLES` | 5 |
| `YELLOW_CYCLES` | 2 |
These values represent clock cycles, not real-world seconds.

## Repository Structure
Traffic_Light_Controller/
├── rtl/
│   └── traffic_light_controller.v
├── tb/
│   └── traffic_light_controller_tb.v
├── files/
│   ├── traffic_light_waveform.png
│   └── simulation_terminal.png
└── README.md

## Verification
The testbench checks:
- Reset selects the RED state.
- RED → GREEN transition and phase duration.
- GREEN → YELLOW transition and phase duration.
- YELLOW → RED transition and phase duration.
- Repetition of the traffic-light sequence.
- Reset during GREEN.
- Reset during YELLOW.
- One-hot light-output safety.
- Internal phase-counter clearing during reset.

The latest reported simulation completed with **30 successful light-output checks** and `ALL TESTS PASSED`. The testbench also includes internal counter-reset assertions; these should be confirmed present and passing before claiming that coverage as verified.

## Tools
- Verilog
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Git and GitHub

## Learning Outcomes
- Designing a sequential FSM in Verilog.
- Implementing parameterized timing logic.
- Using nonblocking assignments for sequential logic.
- Writing directed testbench checks and assertions.
- Verifying reset behavior during normal operation.
- Inspecting digital signal transitions using GTKWave.

## Limitations
This project was verified through simulation only. No ASIC design flow or No physical FPGA implementation or hardware testing was performed.

## Future Improvements
- Add pedestrian-request handling.
- Add a second road direction with interlocked signal phases.
- Add configurable timing through input controls.
- Extend verification with randomized tests and functional coverage.