#!/bin/bash

# Create temp build dir
mkdir build 2> /dev/null

# Compile and link C sources using makefile
# Create ram vhdl files
echo "COMPILING C..."
make clean > /dev/null
err=$(make rams 2>&1)
if [[ $? != 0 ]] 
then
    echo "$err"
    exit 1
fi
# Create main.dump with RISCV asm
make dump > /dev/null

# Compile and simulate vhdl
cd ../vhdl_src
echo "COMPILING VHDL..."
err=$(bash scripts/vhdl_comp.sh 2>&1)
if [[ $? != 0 ]] 
then
    echo "$err"
    exit 1
fi
echo "SIMULATION $1"
bash scripts/vhdl_sim.sh $1
