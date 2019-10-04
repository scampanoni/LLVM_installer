LLVM_VERSION=$(notdir $(shell pwd))

all:
	./scripts/build.sh $(LLVM_VERSION)

print:
	echo $(LLVM_VERSION)

unpack:
	./scripts/unpack.sh $(LLVM_VERSION)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@

clean:
	rm -rf `find ./ -name build` 
