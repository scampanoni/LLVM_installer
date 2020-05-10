#!/bin/bash -e

CMAKE="cmake3"

function compile_install {
  echo "LLVM_Installer:   Compiling LLVM" ;
  rm -rf build ;
  mkdir build ;

  cd build ;
  eval ${CMAKE} ${CMAKE_OPTIONS} ../

  # Compile
  make -j 24 clang ;
  echo "" ;

  # Install
  echo "LLVM_Installer:   Installing LLVM" ;
  make install ;
  echo "" ;

  # Check
  if test $1 == "test" ; then
    echo "LLVM_Installer:   Testing LLVM" ;
    make check-clang ;
  fi

  return ;
}

if test $# -lt 4 ; then
  echo "USAGE: `basename $0` LLVM_VERSION [debug|release] BACKENDS [test|notest]" ;
  exit 1;
fi
llvmVersion=$1 ;
performTests=$4 ;
extraCmakeOptions="" ;
if test $# -ge 5 ; then
  extraCmakeOptions="$5" ;
fi

# Set variables
origDir="`pwd`" ;

# Set file names and special options
if test "$2" == "debug" ; then
  releaseDir="releaseDebug" ;
  enableFileName="${origDir}/enableDebug" ;
  CMAKE_EXTRA_OPTIONS="-DLLVM_ENABLE_ASSERTIONS=On -DCMAKE_BUILD_TYPE=RelWithDebInfo";
else
  releaseDir="release" ;
  enableFileName="${origDir}/enable" ;
  CMAKE_EXTRA_OPTIONS="-DCMAKE_BUILD_TYPE=Release";
fi
CMAKE_EXTRA_OPTIONS="$extraCmakeOptions $CMAKE_EXTRA_OPTIONS" ;

# Define the install directory
installDir="`pwd`/${releaseDir}" ;
cmakeOutput="Unix Makefiles" ;

# Set cmake options
CMAKE_OPTIONS="-G \"${cmakeOutput}\" -DCMAKE_INSTALL_PREFIX=${installDir} ${CMAKE_EXTRA_OPTIONS}"

# Target to build
if test "$3" != "all" ; then
  CMAKE_OPTIONS="-DLLVM_TARGETS_TO_BUILD=\"$3\" ${CMAKE_OPTIONS}" ;
fi

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

# Create the directory where we are going to install LLVM
mkdir -p $installDir ;

# Compile, install, and test LLVM
pushd ./ ;
cd src ;
compile_install $performTests;
popd ;

# Dump the enable file
echo "#!/bin/bash" > ${enableFileName} ;
echo " " >> ${enableFileName} ;
echo "LLVM_HOME=`pwd`/${releaseDir}" >> ${enableFileName} ;
echo "export PATH=\$LLVM_HOME/bin:\$PATH" >> ${enableFileName} ;
echo "export LD_LIBRARY_PATH=\$LLVM_HOME/lib:\$LD_LIBRARY_PATH" >> ${enableFileName} ;
