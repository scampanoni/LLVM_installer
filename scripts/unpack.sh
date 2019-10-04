#!/bin/bash -e

function check_file {
  if ! test -f $1 ; then
    echo "ERROR: Download \"$1\" and store it in \"$origDir\"" ;
    exit 1;
  fi
}

function add_llvm_block {
  pushd . ;
  mkdir -p "$1" ;
  cd "$1" ;
  check_file ${origDir}/${2}-${LLVM_VER}.src.tar.xz ;
  tar xf ${origDir}/${2}-${LLVM_VER}.src.tar.xz ;
  if test $# -gt 2 ; then
    mv ${2}-${LLVM_VER}.src "$3" ;
  fi
  mv ${origDir}/${2}-${LLVM_VER}.src.tar.xz ${origDir}/archive ;
  popd ;
}

# Fetch the inputs
if test $# -lt 1 ; then
  echo "USAGE: `basename $0` LLVM_VERSION" ;
  exit 1;
fi
LLVM_VER=$1 ;

# Set variables
origDir=`pwd` ;

# Create directories
mkdir -p archive ;

check_file llvm-${LLVM_VER}.src.tar.xz ; 
tar xf llvm-${LLVM_VER}.src.tar.xz ;
mv llvm-${LLVM_VER}.src.tar.xz ${origDir}/archive ;
cd llvm-${LLVM_VER}.src ;

add_llvm_block tools cfe ;
add_llvm_block "tools/clang/tools" clang-tools-extra extra ;
add_llvm_block projects compiler-rt ;
add_llvm_block projects openmp ;
add_llvm_block projects test-suite ;
