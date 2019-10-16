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
	mv archive/* ./ &> /dev/null ;
	rm -rf src archive llvm-$(LLVM_VERSION).src

uninstall:
	rm -rf release enable

.PHONY: clean clean_build debug unpack print release
