from elftools.elf.elffile import ELFFile

# Tool for creating vhdl RAM files from an elf file

def write_vhdl_memory(ram, data):
    '''Writes VHDL RAM memory'''
    with open(f'../vhdl_src/src/B_RAM_{ram}.vhd', "w", encoding="utf8") as ram_file:
        with open("../common/vhdl_rams/tail.txt", "r", encoding="utf8") as tail:
            tail_lines = tail.readlines()
        with open(f'../common/vhdl_rams/head_{ram}.txt', "r", encoding="utf8") as ram_head:
            ram_file.writelines(ram_head.readlines())
        addr = 0
        for j in data:
            ram_file.write(f'\t\t{addr} => x\"{j:02x}\",\n')
            addr += 1
        ram_file.writelines(tail_lines)

def bank_divide(efile):
    '''Divide data in 4 banks'''
    with open(efile, 'rb') as fil:
        elf_file = ELFFile(fil)
        seg_data = elf_file.get_segment(1).data()
        _rams = [[], [], [], []]
        j = 0
        print_out_ram = ""
        for byt in seg_data:
            _rams[j].append(byt)
            print_out_ram = f'{byt:02x}' + print_out_ram
            j += 1
            if j == 4:
                j = 0
                print(f'0x{print_out_ram},')
                print_out_ram = ""
        return _rams

# Main func
rams = bank_divide("build/main")
for i in range(4):
    write_vhdl_memory(i, rams[i])
