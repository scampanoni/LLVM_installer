LLVM_VERSION=$(notdir $(shell pwd))
MINIMUM_LLVM_PACKAGES=llvm-$(LLVM_VERSION).src.tar.xz cfe-$(LLVM_VERSION).src.tar.xz openmp-$(LLVM_VERSION).src.tar.xz
EXTRA_PACKAGES=polly-$(LLVM_VERSION).src.tar.xz clang-tools-extra-$(LLVM_VERSION).src.tar.xz compiler-rt-$(LLVM_VERSION).src.tar.xz
PACKAGES=$(MINIMUM_LLVM_PACKAGES) $(EXTRA_PACKAGES)
BACKENDS="all"  #"X86;ARM;RISCV"

all: archive $(PACKAGES) llvm-$(LLVM_VERSION).src
	./scripts/build.sh $(LLVM_VERSION) release "$(BACKENDS)"

archive:
	if test -e $@/llvm-$(LLVM_VERSION).src.tar.xz ; then mv archive/* ./ ; fi

llvm-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

cfe-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

polly-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

clang-tools-extra-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

compiler-rt-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

openmp-$(LLVM_VERSION).src.tar.xz:
	wget http://releases.llvm.org/$(LLVM_VERSION)/$@

llvm-$(LLVM_VERSION).src: unpack

print:
	echo $(LLVM_VERSION)

unpack:
	./scripts/unpack.sh $(LLVM_VERSION)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@ $(BACKENDS)

clean_build:
	rm -rf `find ./ -name build`

clean: clean_build
	./scripts/clean.sh $(LLVM_VERSION)

uninstall:
	rm -rf release enable *.xz

.PHONY: archive clean clean_build debug unpack print release
