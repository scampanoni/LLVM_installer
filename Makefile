LLVM_VERSION=$(notdir $(shell pwd))

BACKENDS="all"  #"X86;ARM;RISCV"
TESTS="test" #"notest"
EXTRAS="extra" #"noextra"
EXTRA_CMAKE_OPTIONS="" 

LLVM_URL=https://github.com/llvm/llvm-project/archive/refs/tags
LLVM_NAME=llvmorg-$(LLVM_VERSION).tar.gz
PACKAGES=$(LLVM_NAME)

all: archive src
	./scripts/build.sh $(LLVM_VERSION) release "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

archive:
	if test -e $@/$(LLVM_NAME) ; then cp archive/* ./ ; fi

$(LLVM_NAME):
	wget -4 $(LLVM_URL)/$@

src: unpack
	if ! test -e src ; then ln -s llvm-project-llvmorg-$(LLVM_VERSION) $@ ; fi

print:
	echo $(LLVM_VERSION)

unpack: $(PACKAGES)
	./scripts/unpack.sh $(LLVM_VERSION) $(EXTRAS)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@ "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

clean_build:
	rm -rf `find ./ -name build`

clean: clean_build
	./scripts/clean.sh $(LLVM_VERSION)

uninstall:
	rm -rf release enable *.xz *.gz llvm-project-llvmorg-* src archive

.PHONY: archive clean clean_build debug unpack print release

