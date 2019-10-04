#!/bin/bash

LLVM_BACKENDS="X86;ARM" ;
CMAKE="cmake3"

function compile_install {
  rm -rf build ;
  mkdir build ;

  cd build ;
  eval ${CMAKE} ${CMAKE_OPTIONS} ../

  ${CMAKE} --build . ;

  ${CMAKE} --build . --target install ;
}

if test $# -lt 1 ; then
  echo "USAGE: `basename $0` LLVM_VERSION" ;
  exit 1;
fi
llvmVersion=$1 ;

installDir="`pwd`/release" ;
cmakeOutput="Unix Makefiles" ;

CMAKE_OPTIONS="-G \"${cmakeOutput}\" -DCMAKE_INSTALL_PREFIX=${installDir}"

# Set the sources
rm -f src ;
if ! test -e llvm-${llvmVersion}.src ; then
  tar xf llvm-${llvmVersion}.src.tar.xz ;
fi
ln -s llvm-${llvmVersion}.src src 

# Decide the type of build
if test "$2" == "debug" ; then
  CMAKE_OPTIONS="-DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_ASSERTIONS=On ${CMAKE_OPTIONS} "
else
  CMAKE_OPTIONS="-DCMAKE_BUILD_TYPE=Release ${CMAKE_OPTIONS}"
fi

# Target to build
CMAKE_OPTIONS="-DLLVM_TARGETS_TO_BUILD=\"${LLVM_BACKENDS}\" ${CMAKE_OPTIONS}"

# Create the directory where we are going to install LLVM
mkdir -p $installDir ;

pushd ./ 
cd src ;
compile_install ;
popd ;

echo "#!/bin/bash" > enable ;
echo " " >> enable ;
echo "LLVM_HOME=`pwd`/release" >> enable ;
echo "export PATH=\$LLVM_HOME/bin:\$PATH" >> enable ;
echo "export LD_LIBRARY_PATH=\$LLVM_HOME/lib:\$LD_LIBRARY_PATH" >> enable ;
