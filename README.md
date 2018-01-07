# me176c-acpi
This repository contains a number of patches for the ACPI tables of the ASUS MeMO Pad 7 (ME176C/CX).

## Why?
Unfortunately, ASUS decided to add workarounds to the kernel instead of fixing the ACPI tables using a BIOS update.
Most of these workarounds are for the ACPI DSDT table, which contains information about the hardware of the tablet,
e.g. where to find certain I/O ports. Obviously, this doesn't work well when using an upstream kernel.

Originally, I started adding similar workarounds in the kernel, but as they grew they became rather annoying to maintain.
Eventually, when attempting to get Bluetooth working, I run into a problem that wasn't easy to workaround directly in kernel
code without a lot of ugly hacks.

Consequently, I decided to fork the ACPI DSDT table where these mistakes have been made, and update it with the necessary
fixes. The kernel loads the fixed table at runtime and overrides the original one from the BIOS. This is potentially
dangerous, and can easily break things (or even hardware), but it has shown to work quite well.

## Usage
The ACPI DSDT table appears to be equal on all ASUS MeMO Pad 7 (ME176C/CX) devices, except for a tiny address to a
memory region (`GNVS`). It appears to contain certain variables that are used throughout the DSDT table (maybe BIOS options?).

Since I would like to avoid rebuilding the fixed table for all devices, the table in this repository contains a dummy
address, and is replaced at runtime by the kernel using a single kernel patch. Slightly hacky too, but it works!

## License
`dsdt.dsl` is a disassembled version of the original ACPI DSDT table using [iASL](https://www.acpica.org/downloads).
The original table and the BIOS implementation of the tablet are not open-source, so it should not be considered to be under
an open-source license.

**Only my changes** (see commit history) can be reproduced under the terms and conditions of the [MIT License](
https://opensource.org/licenses/MIT):

```
MIT License

Copyright (c) 2017 lambdadroid

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
