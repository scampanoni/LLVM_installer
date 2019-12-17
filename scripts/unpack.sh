#!/bin/bash -e

function check_file {
  if ! test -f $1 ; then
    echo "ERROR: Download \"$1\" and store it in \"$origDir\"" ;
    exit 1;
  fi
}

function add_llvm_block {
  pushd . ;

  # Create the destination directory
  mkdir -p "$1" ;
  cd "$1" ;
  check_file ${origDir}/${2}-${LLVM_VER}.src.tar.xz ;

  # Check if we have already added the current LLVM piece
  needToAdd="1";
  if test -e ${2}-${LLVM_VER}.src ; then
    needToAdd="0";
  fi
  if test $# -gt 2; then
    if test -e $3 ; then
      needToAdd="0";
    fi
  fi
  if test $needToAdd == "1" ; then
    echo "Adding $2" ;
    tar xf ${origDir}/${2}-${LLVM_VER}.src.tar.xz ;
    if test $# -gt 2 ; then
      mv ${2}-${LLVM_VER}.src "$3" ;
    fi
  fi
  mv ${origDir}/${2}-${LLVM_VER}.src.tar.xz ${origDir}/archive ;
  popd ;
  echo "" ;

  return ;
}

# Fetch the inputs
if test $# -lt 2 ; then
  echo "USAGE: `basename $0` LLVM_VERSION [extra|noextra]" ;
  exit 1;
fi
LLVM_VER=$1 ;
extras=$2 ;

# Set variables
origDir=`pwd` ;

# Create directories
mkdir -p archive ;

# Unpack the LLVM framework
if ! test -d llvm-${LLVM_VER}.src ; then
  check_file llvm-${LLVM_VER}.src.tar.xz ; 
  tar xf llvm-${LLVM_VER}.src.tar.xz ;
  mv llvm-${LLVM_VER}.src.tar.xz ${origDir}/archive ;
  cd llvm-${LLVM_VER}.src ;
fi

# Unpack the other packages
add_llvm_block tools cfe clang ;
if test $extras == "extra" ; then
  #add_llvm_block tools lldb ;
  add_llvm_block tools polly ;
  add_llvm_block "tools/clang/tools" clang-tools-extra extra ;
  add_llvm_block projects compiler-rt ;
  add_llvm_block projects openmp ;
  #add_llvm_block projects test-suite ;
fi
