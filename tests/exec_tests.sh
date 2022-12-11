#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

# Compiler definitions
CROSS="riscv32-unknown-elf-"
CC="${CROSS}gcc"
LD="${CROSS}ld"
DUMP="${CROSS}objdump"

# Compiler flags
CFLAGS="-Wall -I macros -march=rv32im -mabi=ilp32"
# Linker flags
LDFLAGS="-nostartfiles -T linker.lds"

# Create temp build dir
rm -rf build
mkdir build

# Test src
rv_tests=$(ls rv32ui/*.S rv32mi/*.S rv32um/*.S)

# If there is an argument, use as regex for test selection
if [[ $1 ]]
then
    rv_tests=$(echo "$rv_tests" | grep -E "$1")
fi

num_tests=$(echo "$rv_tests" | wc -l)
num_pass="1"

for test in $rv_tests
do
    echo "COMPILING TEST $test [$num_pass/$num_tests]"
    $CC $CFLAGS $LDFLAGS $test -o build/main 2> /dev/null
    if [[ $? != 0 ]]
    then
        echo -e "${RED}ERROR COMPILING $file${NC}"
        echo "$CC $CFLAGS $LDFLAGS $test -o build/main"
        $CC $CFLAGS $LDFLAGS $test -o build/main
        exit 1
    fi
    # Create RAM vhdl files
    python ../common/elf.py > build/ram.dump

    # Compile vhdl and simulate
    cd ../vhdl_src
    rm -rf build
    bash ./scripts/vhdl_comp.sh
    cd build
    echo "SIMULATING..."
    test_result=$(ghdl -r "riscv" --stop-time=8000us | grep -E "(report note)" | grep -Eo "[0-9]+$")

    if [[ test_result -eq "0" ]]
    then
        echo -e "${GREEN}TEST $test PASSED${NC}"
        echo "--------"
        cd ../../tests
        ((num_pass++))
    else
        echo -e "${RED}TEST $test FAILED AT $test_result${NC}"
        exit 1
    fi
done

# Delete temp build dir
rm -rf build
