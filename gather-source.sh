#!/usr/bin/env bash
set -euo pipefail

for src in \
    ./bootstrap-seeds/POSIX/x86/hex0_x86.hex0 \
    ./bootstrap-seeds/POSIX/x86/kaem-minimal.hex0 \
    ./kaem.x86 \
    ./x86/mescc-tools-seed-kaem.kaem \
    ./x86/hex0_x86.hex0 \
    ./x86/kaem-minimal.hex0 \
    ./x86/mescc-tools-mini-kaem.kaem \
    ./x86/kaem.run \
    ./x86/hex1_x86.hex0 \
    ./x86/catm_x86.hex0 \
    ./x86/hex2_x86.hex1 \
    ./x86/ELF-i386.hex2 \
    ./x86/M0_x86.hex2 \
    ./x86/cc_x86.M1 \
    ./M2libc/x86/linux/bootstrap.c \
    ./M2-Planet/cc.h \
    ./M2libc/bootstrappable.c \
    ./M2-Planet/cc_globals.c \
    ./M2-Planet/cc_reader.c \
    ./M2-Planet/cc_strings.c \
    ./M2-Planet/cc_types.c \
    ./M2-Planet/cc_core.c \
    ./M2-Planet/cc_macro.c \
    ./M2-Planet/cc.c \
    ./x86/x86_defs.M1 \
    ./x86/libc-core.M1 \
    ./mescc-tools/stringify.c \
    ./mescc-tools/blood-elf.c \
    ./M2libc/x86/x86_defs.M1 \
    ./M2libc/x86/ELF-x86.hex2 \
    ./mescc-tools/M1-macro.c \
    ./M2libc/x86/libc-core.M1 \
    ./M2libc/x86/ELF-x86-debug.hex2 \
    ./M2libc/sys/types.h \
    ./M2libc/stddef.h \
    ./M2libc/x86/linux/unistd.c \
    ./M2libc/x86/linux/fcntl.c \
    ./M2libc/x86/linux/sys/stat.c \
    ./M2libc/stdlib.c \
    ./M2libc/stdio.c \
    ./mescc-tools/hex2.h \
    ./mescc-tools/hex2_linker.c \
    ./mescc-tools/hex2_word.c \
    ./mescc-tools/hex2.c \
    ./M2libc/x86/libc-full.M1 \
    ./M2libc/string.c \
    ./mescc-tools/Kaem/kaem.h \
    ./mescc-tools/Kaem/variable.c \
    ./mescc-tools/Kaem/kaem_globals.c \
    ./mescc-tools/Kaem/kaem.c \
    x86/mescc-tools-full-kaem.kaem \
    ./mescc-tools-extra/mescc-tools-extra.kaem \
    ./M2-Mesoplanet/cc.h \
    ./M2-Mesoplanet/cc_globals.c \
    ./M2-Mesoplanet/cc_env.c \
    ./M2-Mesoplanet/cc_reader.c \
    ./M2-Mesoplanet/cc_spawn.c \
    ./M2-Mesoplanet/cc_core.c \
    ./M2-Mesoplanet/cc_macro.c \
    ./M2-Mesoplanet/cc.c \
    mescc-tools/get_machine.c  \
    mescc-tools-extra/sha256sum.c \
    mescc-tools-extra/match.c \
    mescc-tools-extra/mkdir.c \
    mescc-tools-extra/untar.c \
    mescc-tools-extra/ungz.c \
    mescc-tools-extra/catm.c \
    mescc-tools-extra/cp.c \
    mescc-tools-extra/chmod.c \
    ./M2libc/string.h \
    ./M2libc/stdio.h \
    ./M2libc/sys/stat.h \
    M2libc/amd64/linux/sys/stat.c \
    M2libc/armv7l/linux/sys/stat.c \
    M2libc/aarch64/linux/sys/stat.c \
    M2libc/riscv32/linux/sys/stat.c \
    M2libc/riscv64/linux/sys/stat.c \
    M2libc/fcntl.h \
    M2libc/amd64/linux/fcntl.c \
    M2libc/armv7l/linux/fcntl.c \
    M2libc/aarch64/linux/fcntl.c \
    M2libc/riscv32/linux/fcntl.c \
    M2libc/riscv64/linux/fcntl.c \
    M2libc/unistd.h \
    M2libc/amd64/linux/unistd.c \
    M2libc/armv7l/linux/unistd.c \
    M2libc/aarch64/linux/unistd.c \
    M2libc/riscv32/linux/unistd.c \
    M2libc/riscv64/linux/unistd.c \
    M2libc/signal.h \
    M2libc/stdlib.h \
    M2libc/bootstrappable.h \
    x86.answers
do
    echo "src $(cd stage0-posix; wc -c $src)"
    cat stage0-posix/$src
done
echo "hex0 ./bootstrap-seeds/POSIX/x86/hex0_x86.hex0 ./bootstrap-seeds/POSIX/x86/hex0-seed"
echo "hex0 ./bootstrap-seeds/POSIX/x86/kaem-minimal.hex0 ./bootstrap-seeds/POSIX/x86/kaem-optional-seed"
echo "./bootstrap-seeds/POSIX/x86/kaem-optional-seed ./kaem.x86"
