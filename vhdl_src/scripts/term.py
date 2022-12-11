'''Output terminal simulator'''

import sys
import re

print_re = re.compile("^PRINT_REG\.vhd.*: ([0-9]+)$")

print("-- Output TERM --")
for line in sys.stdin:
    re_result = print_re.match(line)
    if re_result:
        print(chr(int(re_result.group(1))), end='')
