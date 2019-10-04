LLVM_VERSION=$(notdir $(shell pwd))

all:
	./scripts/build.sh $(LLVM_VERSION)

print:
	echo $(LLVM_VERSION)

unpack:
	./scripts/unpack.sh $(LLVM_VERSION)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@

clean_build:
	rm -rf `find ./ -name build`

clean: clean_build
	rm -rf src archive

.PHONY: clean clean_build debug unpack print
