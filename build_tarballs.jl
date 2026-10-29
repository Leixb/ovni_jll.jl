# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "ovni"
version = v"1.14.0"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/bsc-pm/ovni.git", "cf025e242f45fc43f62165cbf07f6f2077d53747")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/ovni
cmake -B build -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} -DCMAKE_BUILD_TYPE=Release -DUSE_MPI=OFF -DOVNI_GIT_COMMIT=unknown -DBUILD_TESTING=OFF
cmake --build build --parallel ${nproc}
cmake --install build
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("aarch64", "linux"; libc = "glibc"),
    Platform("powerpc64le", "linux"; libc = "glibc"),
    Platform("riscv64", "linux"; libc = "glibc")
]


# The products that we will ensure are always built
products = [
    LibraryProduct("libovni", :libovni),
    ExecutableProduct("ovnisort", :ovnisort),
    ExecutableProduct("ovniemu", :ovniemu),
    ExecutableProduct("ovnidump", :ovnidump),
    ExecutableProduct("ovnitop", :ovnitop),
    ExecutableProduct("ovniver", :ovniver)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"5.2.0")
