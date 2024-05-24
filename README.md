# Minimal 32-bit OS

This is a minimal 32-bit OS. I followed the [OSdev wiki](https://wiki.osdev.org/Main_Page) instructions to create this OS. The code is all in the wiki. I just put it together in a single repository.

![](Screenshot%202024-05-24%20031003.png)

![](Screenshot%202024-05-24%20025810.png)

## Tools, Environment, Cross-compiler

The entire OS development is done in Unix / POSIX environment (for reasons that I won't go into here). I myself used WSL on Windows.

On Windows WSL / Ubuntu we must install some tools and also compile our own cross-compiler (read OSdev wiki how to build cross-compiler [here](https://wiki.osdev.org/GCC_Cross-Compiler#Preparing_for_the_build)).

Here is a single script that will install all the necessary tools and build the cross-compiler:

```bash
# This will install basic tools for the host operation system
sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libisl-dev wget make grub-common xorriso

# For MAC you must install additional tools: gmp mpfr libmpc
# brew install gmp mpfr libmpc

# We need to build our own tools aswell (cross-compiler)
# These tools will be used by our host system to compile the OS (guest) system

# Download binutils release (it takes a while)
# Either clone it or download compressed version, here you can change binutils-2.42 to the latest version.
#git clone --depth 1 git://sourceware.org/git/binutils-gdb.git
wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz

# Download GCC release (it takes a while)
# Either clone it or donwload compressed version, here you can change gcc-14.1.0 to the latest version.
#git clone --depth 1 git://gcc.gnu.org/git/gcc.git
wget https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.gz

# We can also include GDB (GNU Debugger) if we want to debug our OS
wget https://sourceware.org/pub/gdb/releases/gdb-14.2.tar.gz

# Unzip them (this will take a long time, its a lot of source files)
tar -xf binutils-2.42.tar.xz
tar -xf gcc-14.1.0.tar.gz
tar -xf gdb-14.2.tar.gz

# Set up the environment before building the cross-compiler
export PREFIX="$HOME/my_tools"
export TARGET=i686-elf # For 32-bit OS
export PATH="$PREFIX/bin:$PATH"

# Here we will build binutils
mkdir build-gcc
mkdir build-binutils
mkdir build-gdb

# Build the binutils
cd build-binutils
../binutils-2.42/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j 8 
make -j 8 install

# Build GDB (You can skip this, it's not mandetory)
# cd ../build-gdb
# ../gdb-14.2/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
# make -j 8 all-gdb
# make -j 8 install-gdb

# Build GCC
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH
cd ../build-gcc
../gcc-14.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make -j 8 all-gcc
make -j 8 all-target-libgcc
make -j 8 install-gcc
make -j 8 install-target-libgcc
```

Finnaly, we can compile the OS:

```bash
make all
```

And run it in QEMU (for windows only: the QEMU should be running on the host system, not on the WSL):

```bash
make run
```

You should install QEMU and add the QEMU binaries to the Windows PATH.
