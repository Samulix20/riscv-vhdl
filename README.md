# RiscZeto - A RISC-V processor implemented in VHDL

This project is an VHDL implementation of a 5 stage RISC-V CPU with support for the RV32I Base Integer Instruction Set, M Standard Extension for Integer Multiplication and Division, Zicsr Control and Status Register (CSR) Instructions, Machine mode and User mode.

This project contains an automated set of tests for the instructions and extensions implemented. It was created using unit tests from [riscv-software-src/riscv-tests](https://github.com/riscv-software-src/riscv-tests). 

This project also contains a simple example program written in C with a set of utils for its compilation and simulation.

## Context

This project was developed as part of an academic final degree project and is intended for educational and experimental purposes.

## Software requirements

- [GHDL 2.0](https://github.com/ghdl/ghdl), an open-source analyzer, compiler and simulator for VHDL.
- The [RISC-V GNU Compiler Toolchain 12.2](https://github.com/riscv-collab/riscv-gnu-toolchain) for cross-compiling.
- Python 3.10
  - [Pyelftools](https://github.com/eliben/pyelftools) for ELF file parsing.

## CPU design

The following diagram shows the set of actions that are performed in each stage of the pipeline.

![](diagrams/cpu.png)

## System Design

The following diagram shows the design of the system.

![](diagrams/cpu_system.png)

The ``MTIMER`` device is the standard RISC-V timer.

The ``PRINT`` MMIO device every time a store is issued to its address executes an VHDL report that prints to the standard output of the simulation the value of the store.

The VHDL source files of the whole system can be found at ``vhdl_src/src``.

## Compilation and linking

The compilation flags for ``riscv32-unknown-elf-gcc`` required for this platform are:

    -march=rv32im -mabi=ilp32

The linking must be done using a linking script that respects the memory size and map of the platform. Valid scripts can be found at ``c_src/linker.lds`` and ``tests/linker.lds``.

## VHDL Ram files

The simulation runs the program that is loaded in the VHDL ram files ``vhdl_src/src/B_RAM_[0-3].vhd``. A new program can be loaded using the ``common/elf.py`` script, it extracts the instructions and data from an ELF executable file and creates the new ram files.

## Simulation

The ``vhdl_src/scripts`` directory contains scripts for GHDL compilation and simulation and a ``term.py`` script that parses the reports of the ``PRINT`` MMIO device as ASCII characters.

To start a simulation of the program loaded in the ram files run in the ``vhdl_src`` directory:

    $ make sim

This simulation stops when it reaches 8000 us of simulated time. 

## Testing

The ``tests`` directory contains the source files of the test programs and the ``exec_test.sh`` script. To execute all tests run in the ``tests`` directory:

    $ ./exec_test.sh

To execute only the tests which name match a certain regular expression run:

    $ ./exec_test.sh REGEX

## C Example

The ``c_src/src`` and ``c_src/include`` contain the source files and headers of a simple "Hello World!" program written in C. 

The ``c_src/sim.sh`` script compiles the C program using the ``c_src/Makefile``, generates its VHDL ram files and simulates its execution until it reaches a limit of simulated time. It can be executed by running in the ``c_src`` directory:

    $ ./sim.sh TIME_LIMIT

If the script is called without the ``TIME_LIMIT`` parameter the simulation never ends.

## RISC-V FreeRTOS

The ``riscv-freertos`` directory includes a version of [FreeRTOS](https://www.freertos.org/) compatible with this processor.
