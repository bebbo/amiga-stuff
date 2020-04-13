SHELL = /bin/bash
PREFIX ?= /opt/amiga

init ?= echo no init
mfile ?= Makefile

.PHONY: all
all: adoom sam a68k

disabled: milky objfw

.PHONY: objfw adoom milky ace a68k sam
objfw:
	$(MAKE) one url=https://github.com/Midar/objfw target=objfw init="./autogen.sh && ./configure --host=m68k-amigaos"

adoom:
	$(MAKE) one url=https://github.com/AmigaPorts/ADoom target=adoom subdir=/adoom_src env="TOOLCHAIN=/opt/amiga"

milky:
	$(MAKE) one url=https://github.com/AmigaPorts/MilkyTracker target=milky init="cmake -DCMAKE_SYSROOT=$(PREFIX) -DCMAKE_TOOLCHAIN_FILE=../CMakeMilky.txt -DCMAKE_BUILD_TYPE=Release"

ace:
	$(MAKE) one url=https://github.com/AmigaPorts/ACE target=ace env="ACE_CC=m68k-amigaos-gcc" mtarget=all mfile=makefile

a68k:
	$(MAKE) one url=https://github.com/alexalkis/a68k target=a68k

sam:
	$(MAKE) one url=https://github.com/githubaf/SAM target=sam mfile=../Makefile.sam

.PHONY: one
one:
	if [ ! -e $(target) ]; then \
	  git clone $(url) $(target); \
	fi
	cd $(target) && git pull && git checkout --force
	cd $(target) && $(init)
	$(env) $(MAKE) -C $(target)$(subdir) -f $(mfile) $(mtarget)

.PHONY: clean
clean:
	for i in $$(cat .gitignore) ;do  if [ -e $$i ]; then rm -rf $$i/*; pushd $$i; git checkout --force; popd; fi; done
