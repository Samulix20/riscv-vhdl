#!/bin/bash

rm -rf build
mkdir build
mkdir build/work

cd src
err=$(ghdl -a --workdir=../build/work *.vhd 2>&1)
if [[ $? != 0 ]]
then
    echo "$err"
    exit 1
fi

err=$(ghdl -e --workdir=../build/work --ieee=synopsys -fexplicit "test" 2>&1)
if [[ $? != 0 ]]
then
    echo "$err"
    exit 1
fi

mv "test" "../build/riscv"
rm e~*.o
cd ..
rm -rf build/work