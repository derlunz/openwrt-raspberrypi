#!/usr/bin/python

#
# adapted from imagetool-uncompressed.py
#

import os
import re
import sys

if len(sys.argv) != 2:
    print("usage: " + sys.argv[0] + " <output-filename>")
    print("\tGenerates binary boot info for the raspberry pi bootloader")
    print("\tPrepend the generated file to a uncompressed Linux Image")
    sys.exit(1)

outfile = sys.argv[1]

re_line = re.compile(r"0x(?P<value>[0-9a-f]{8})")

mem = [0 for i in range(32768)]

def load_to_mem(name, addr):
   f = open(name)

   for l in f.readlines():
      m = re_line.match(l)

      if m:
         value = int(m.group("value"), 16)

         for i in range(4):
            mem[addr] = int(value >> i * 8 & 0xff)
            addr += 1

   f.close()

load_to_mem("boot-uncompressed.txt", 0x00000000)
load_to_mem("args-uncompressed.txt", 0x00000100)

f = open(outfile, "wb")

for m in mem:
    f.write(chr(m))

f.close()
