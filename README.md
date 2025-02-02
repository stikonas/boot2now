# Boot2Now

This project combines the [builder-hex0](https://github.com/ironmeld/builder-hex0) bootstrap kernel with the bootstrap compilers from the [stage0-posix](https://github.com/oriansj/stage0-posix) project in order to bootstrap a C (subset) compiler *entirely* from hex files.

## Minimal Bootstrapping

Minimized bootstrapping of foundational software is a process for building software tools progressively, from a primitive compiler tool and source language up to a full linux development environment with gcc.

At each stage of development, the tool should build a more capable version of itself using only source code input. Then the new version should be able to handle more sophisticated source code for the next phase.

Bootstrapping serves to isolate all inputs and outputs in the construction of software. Moreover, a stricter form of authentication includes auditing all tools used in the construction as well, recursively. A strict bootstrap-audit can only be satisfied by bootstrapping your tools from "scratch".

## Building

Type `make`.

The Makefile:

* Bootstraps/Builds the boot kernel
* Creates a large shell script with stage0-posix x86 source included within
* Runs the kernel under qemu with the shell script in order to build M2-Mesoplanet
    * An after.kaem script builds and runs the final artifact (currently helloworld from helloworld.c)
    * The builder writes the artifact back to the hard drive
    * The builder outputs the length of the artifact to the screen
* Extracts the artifact from the beginning of the hard drive using the output length
* Runs the artifact locally


## Structure

The kernel in this project is from [builder-hex0](https://github.com/ironmeld/builder-hex0). A snapshot copy of that project is included in the builder-hex0 subdirectory. For detailed history, consult the source project.

The size of the initial boot sector seed is only 384 bytes of binary code. See builder-hex0/builder-hex0-mini.hex0 for the hex source code.

The "mini" builder is used to build a 3K minimal posix kernel (also in the form of a disk boot image), which is called the "full" builder. See builder-hex0/builder-hex0.hex0 for the hex source code.

The full builder is purpose-built to build the x86 source from the [stage0-posix](https://github.com/oriansj/stage0-posix) project, a partial snapshot of which is included in the stage0-posix subdirectory. This results in a C like compiler called M2-Mesoplanet which can then be used to compile C like programs.

To be clear, "purpose-built" means it contains several "hacks" which minimally supports building stage0-posix but it should not be considered posix compliant otherwise.

I imagine that a more capable kernel will be required to complete a full bootstrap to modern tools, but this will be a lot easier using the most capable compiler that builder-hex0 can build, which is currently M2-Mesoplanet. It might be possible to build a more capable compiler using builder-hex0; I just have not tried to build anything beyond M2-Mesoplanet.

## Why?

This project is intends to compliment [existing bootstrap projects](#existing-projects) by providing a missing piece: a bootstrap kernel. Two of the bootstrap projects (Guix and live-bootstrap) I looked required a prebuilt POSIX kernel.

A typical C compiler needs to read source files and system headers and it uses kernel system calls to perform file I/O. However, a POSIX kernel is typically built with a C compiler. So, we have a chicken-or-the-egg question. Indeed, when Linus Torvalds released Linux 0.02 he was using minix to compile it. Linux was not self-hostable until version .11.

I believe that building the operating system progressively in lock-step with the tool chain is the right approach.

My goal is to minimize the (Effort to Understand Source * Volume of Source) while maximizing progress towards a linux distro.

Another difference with other projects is the method of input. The amount of code to be compiled to reach a modern toolchain with gcc is enormous. It is not practical to type the code in with a keyboard. We must present it to the machine via hardware. Possible solutions include interfacting with network interfaces, serial ports, and hard drives. A hard drives make the most sense to me. Other projects are focused on network access, the console, or serial ports.


## Existing Projects

### Bootstrappable

* https://bootstrappable.org
* https://bootstrapping.miraheze.org/
* https://github.com/oriansj/talk-notes/blob/master/bootstrappable.org

This project does not include a kernel. This project targets Scheme as a foundational language.

### Live bootstrap

* https://github.com/fosslinux/live-bootstrap
* https://bootstrapping.miraheze.org/wiki/Live-bootstrap

This project does not include a kernel. This project is fairly strict about [what it considers source code](https://github.com/fosslinux/live-bootstrap#specific-things-to-be-bootstrapped).

### asmc

* https://gitlab.com/giomasce/asmc

Aligned with my thinking:
  * asmc targets Assembly and C and starts with minimal boot images, which is aligned with my thinking.
  * A tremendous amount of great embrionic boot loader and kernel code

Unaligned:
  * Presumes nasm and starts with thousands of lines of assembly code
  * Presumes python
  * 6 kb seed is large
  * asmc eventually targets loading code via iPXE and a network card, which:
    * Restricts the type of physical machine that are able to support that bootstrapping process.
    * Imposes a significant burden on the bootstrapper to setup a network and a PXE server external to the bootstrap machine.
    * Networking introduces a lot of complexity to bootstrap manually
  * Unclear roadmap / project goals

### tccboot

tccboot is a boot image that boots and builds a linux kernel from source.
https://bellard.org/tcc/tccboot.html

Building tccboot is still a bootstrapping challenge but once there, this project is very interesting.

### MinimalBinaryBoot

* https://codeberg.org/StefanK/MinimalBinaryBoot

Starts with a tiny monitor that allow entering octal.


## Requirements

* The first translation must be simple enough to be performed by hand.
    * Minimize the size of the initial binary that must be hand constructed
    * Do not require an existing kernel

* Minimize the work for the auditor
    * Minimize the number of manual hardware transitions
    * Each phase should support source code which is progressively more expressive to reduce the sheer volume of overall auditable code.

* A proper audit requires the ability to audit all source artifacts that will be used as inputs.
* To be useful, the bootstrap must evolve to a set of modern linux kernel and development tools 
* The bootstrap requires starting from a specific environment (i.e. hardware, which may be virtualized).
* The bootstrap process may require transitions to more sophisticated environments (i.e. 32-bit to 64-bit machine)
* Boostraps tied to simpler hardware are easier to build.
* Boostraps tied to older hardware helps keeps that hardware alive, which is a positive.
* Older hardware and virtualizations of older hardware are fragile and difficult to maintain, which is a negative.

## Proposed Solution

Minimalism is prioritized by focusing on the most enduring hardware environment and the most enduring languages. The expected environment is a minimal 386 cpu with a minimal BIOS and minimal ATA hard drive support.

* The build process is functional and produces deterministic outputs at every stage
* The output of a build is a bootable image
* Independent auditors should produce and vouch for every bootable environment.
* People can used cached artifacts to the extent that they trust the auditors that have signed off on them.

Start with the simplist possible translation to a binary with minimal machine requirements that can be used to bootstrap further operating systems and compilers.

* The build process is functional.

```
build-image = builder-image + source
result-image, length = build-image()
```

The notation build-image() means we invoke the build by booting the image. Initially, the image can access itself by reading and writing the disc using the BIOS. It can also write a new image back to the disc via the BIOS. The function is complete when the system terminates.

* The first working system is launched from a "hand built" bootable image.

* Every transition should preserve a bootable software environment which is checksumed and cryptographically signed. These are the Master Bootstrap Images.
  * launch
  * build
  * reboot
  * capture resulting image

## Build2Now Structure

A Build2Now compiler should (eventually) include:
   * a bootable image of the compiler
   * sha256 checksum of the compiler image
   * sha256 checksum of (parent) image that compiled the compiler
   * sha256 checksum of source provided to the parent compiler

Each builder in the Build2Now series defines:
   * A hardware interface
   * An operating system interface to access hardware and other operating system facilities
   * A system-specific language library interface to access the operating system
   * An application language which uses the system interface library
   * Comes with its own source by default and builds itself when invoked
   * Instructions on how to provide source
   * Instructions on how to extract output - what is the length?


## Levels of Trust

The strictness of your bootstrapping strategy stems from the amount of trust you are willing to accept. See TRUST.md for more information.


## Reference

linux .02 was the first runnable version and required gcc 1.40 and minix:
* https://www.cs.cmu.edu/~awb/linux.history.html
* http://oldlinux.org/
* https://virtuallyfun.com/wordpress/2010/08/13/linux-0-00-0-11-on-qemu/

Linux source:
* https://elixir.bootlin.com/linux/0.10/source
* http://www.oldlinux.org/Linux.old/

PC source:
* https://tldp.org/HOWTO/Large-Disk-HOWTO-4.html

Compiler:
* https://miyuki.github.io/2017/10/04/gcc-archaeology-1.html
* http://download.savannah.gnu.org/releases/tinycc/
* https://bootstrapping.miraheze.org/wiki/C_compilers
* https://github.com/oriansj/mes-m2

Like Linux from scratch
* https://buildroot.uclibc.org/

Libc from scratch
* https://github.com/jart/cosmopolitan

Small posix utilities:
https://c9x.me/yacc/
