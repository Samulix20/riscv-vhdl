#!/bin/bash

cd build

if [[ $1 ]]
then
    ghdl -r "riscv" --stop-time="$1" --unbuffered | python -u ../scripts/term.py 2> /dev/null
else
    ghdl -r "riscv" --unbuffered | python -u ../scripts/term.py 2> /dev/null
fi

