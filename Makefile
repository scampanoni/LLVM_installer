LLVM_VERSION=$(notdir $(shell pwd))
BACKENDS="all"  #"X86;ARM;RISCV"
TESTS="notest" #"notest"
EXTRA_CMAKE_OPTIONS="-DLLVM_ENABLE_PROJECTS=\"clang\;clang-tools-extra\;compiler-rt\;mlir\;openmp\;polly\;bolt\;lldb\;flang\;lld\""
LLVM_URL=https://github.com/llvm/llvm-project.git

all: src release #debug

src:
	git clone $(LLVM_URL) src 
	cd src ; git checkout tags/llvmorg-$(LLVM_VERSION)

print:
	echo $(LLVM_VERSION)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@ "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

release:
	./scripts/build.sh $(LLVM_VERSION) $@ "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

clean:
	rm -rf `find ./ -name build`

uninstall:
	rm -rf release debug enable src 

.PHONY: clean uninstall debug release print
