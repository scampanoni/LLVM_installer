LLVM_VERSION=3.7.1

all:
	./scripts/build.sh $(LLVM_VERSION)

unpack:
	./scripts/unpack.sh $(LLVM_VERSION)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@

clean:
	rm -rf `find ./ -name build` 
