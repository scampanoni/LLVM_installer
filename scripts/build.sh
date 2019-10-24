#!/bin/bash -e

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

  return ;
}

if test $# -lt 3 ; then
  echo "USAGE: `basename $0` LLVM_VERSION [debug|release] BACKENDS" ;
  exit 1;
fi
llvmVersion=$1 ;

# Set file names and special options
if test "$2" == "debug" ; then
  releaseDir="releaseDebug" ;
  enableFileName="enableDebug" ;
  CMAKE_EXTRA_OPTIONS="-DLLVM_ENABLE_ASSERTIONS=On -DCMAKE_BUILD_TYPE=RelWithDebInfo";
else
  releaseDir="release" ;
  enableFileName="enable" ;
  CMAKE_EXTRA_OPTIONS="-DCMAKE_BUILD_TYPE=Release";
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

# Target to build
if test "$3" != "all" ; then
  CMAKE_OPTIONS="-DLLVM_TARGETS_TO_BUILD=\"${LLVM_BACKENDS}\" ${CMAKE_OPTIONS}" ;
fi

# Create the directory where we are going to install LLVM
mkdir -p $installDir ;

# Compile and install
pushd ./ 
cd src ;
compile_install ;
popd ;

# Dump the enable file
echo "#!/bin/bash" > ${enableFileName} ;
echo " " >> ${enableFileName} ;
echo "LLVM_HOME=`pwd`/${releaseDir}" >> ${enableFileName} ;
echo "export PATH=\$LLVM_HOME/bin:\$PATH" >> ${enableFileName} ;
echo "export LD_LIBRARY_PATH=\$LLVM_HOME/lib:\$LD_LIBRARY_PATH" >> ${enableFileName} ;
