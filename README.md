# me176c-acpi [![Build Status](https://travis-ci.com/me176c-dev/me176c-acpi.svg?branch=master)](https://travis-ci.com/me176c-dev/me176c-acpi)
This repository contains a number of patches for the ACPI DSDT table of the ASUS MeMO Pad 7 (ME176C/CX).

## Introduction
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
**Requirements:** [me176c-boot] or at least the [me176c-boot bootstrap] (can be used with other bootloaders)

The modified ACPI DSDT table (`dsdt.asl`) is compiled using [iASL] (part of ACPICA).
`iasl` should be available as package (`iasl` or `acpica`) in most Linux distributions.

See [Upgrading ACPI tables via initrd](https://www.kernel.org/doc/Documentation/acpi/initrd_table_override.txt)
of the Linux kernel documentation for an introduction how to compile and load in in your Linux kernel.

## Implementation
### Global NVS Area
The ACPI DSDT table appears to be equal on all ASUS MeMO Pad 7 (ME176C/CX) devices. The only difference is a memory address
to the global NVS (GNVS) area, which is dynamically allocated and therefore differs from device to device. Normally, this
address would need to be updated for each device before compilation. This makes sharing the compiled version impossible.

Example:
```asl
OperationRegion (GNVS, SystemMemory, 0x395FEA98, 0x0340) // Device 1
OperationRegion (GNVS, SystemMemory, 0x395F1A98, 0x0340) // Device 2
```

I used to handle this using an out-of-tree kernel patch that remapped this address at runtime.
However, I have been looking for alternative options so the ACPI DSDT override can also be used on mainline kernels.

After a lot of consideration I came up with a solution that handles this within the bootloader,
specifically within the "bootstrap" loader in [me176c-boot]. The DSDT table no longer contains the GNVS address.
Instead, it loads an extra `OEM6`/`GNVS` ACPI table that contains only the dynamic GNVS address.
This makes it possible to have one static compiled DSDT table, but still load the GNVS address dynamically.

Also see: https://github.com/me176c-dev/me176c-boot/commit/b50b460e92d46efab743fc1e1df47935f7755f39

## License
`dsdt.dsl` is a disassembled version of the original ACPI DSDT table using [iASL].
The original table and the BIOS implementation of the tablet are not open-source, so it should not be considered to be under
an open-source license.

**Only my changes** (see commit history) can be reproduced under the terms and conditions of the [MIT License]:

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

[me176c-boot]: https://github.com/me176c-dev/me176c-boot
[me176c-boot bootstrap]: https://github.com/me176c-dev/me176c-boot/tree/master/bootstrap
[iASL]: https://www.acpica.org/downloads
[MIT License]: https://opensource.org/licenses/MIT
