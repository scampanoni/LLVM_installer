#!/bin/bash

LLVM_VERSION=$1 ;

if test -e archive; then 
  mv archive/* ./ ; 
fi
	
rm -rf src archive llvm-${LLVM_VERSION}.src
