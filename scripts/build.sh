#!/bin/bash -e

LLVM_BACKENDS="X86;ARM;RISCV" ;
CMAKE="cmake3"

function compile_install {
  rm -rf build ;
  mkdir build ;

  cd build ;
  eval ${CMAKE} ${CMAKE_OPTIONS} ../

  # Compile
  make clang ;

  # Install
  make install ;

  # Check
  make check-clang ;
}

if test $# -lt 1 ; then
  echo "USAGE: `basename $0` LLVM_VERSION" ;
  exit 1;
fi
llvmVersion=$1 ;

# Set file names and special options
if test "$2" == "debug" ; then
  releaseDir="releaseDebug" ;
  enableFileName="enableDebug" ;
  CMAKE_EXTRA_OPTIONS="-DLLVM_ENABLE_ASSERTIONS=On";
else
  releaseDir="release" ;
  enableFileName="enable" ;
  CMAKE_EXTRA_OPTIONS="";
fi

# Define the install directory
installDir="`pwd`/${releaseDir}" ;
cmakeOutput="Unix Makefiles" ;

# Set cmake options
CMAKE_OPTIONS="-G \"${cmakeOutput}\" -DCMAKE_INSTALL_PREFIX=${installDir} ${CMAKE_EXTRA_OPTIONS}"

# Set the sources
rm -f src ;
if ! test -e llvm-${llvmVersion}.src ; then
  tar xf llvm-${llvmVersion}.src.tar.xz ;
fi
ln -s llvm-${llvmVersion}.src src 

# Decide the type of build
if test "$2" == "debug" ; then
  CMAKE_OPTIONS="-DCMAKE_BUILD_TYPE=RelWithDebInfo ${CMAKE_OPTIONS} "
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

echo "#!/bin/bash" > ${enableFileName} ;
echo " " >> ${enableFileName} ;
echo "LLVM_HOME=`pwd`/${releaseDir}" >> ${enableFileName} ;
echo "export PATH=\$LLVM_HOME/bin:\$PATH" >> ${enableFileName} ;
echo "export LD_LIBRARY_PATH=\$LLVM_HOME/lib:\$LD_LIBRARY_PATH" >> ${enableFileName} ;
