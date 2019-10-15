Steps:
1- Name the working directory to be the version of LLVM you are installing. For example, if you want to install LLVM 9.0.0, name your working directory "9.0.0".
  $ mkdir 9.0.0 ; cd 9.0.0

2- Download the compressed archieved files to your working directory (e.g., 9.0.0)

3- Unpack all files by running make unpack
  $ make unpack

4- Compile LLVM by running make or make debug
  $ make
