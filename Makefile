PREFIX ?= /opt/amiga

init ?= echo no init
mfile ?= Makefile

.PHONY: all
all: objfw adoom milky ace


.PHONY: objfw adoom milky ace
objfw:
	$(MAKE) one url=https://github.com/Midar/objfw target=objfw init="./autogen.sh && ./configure --host=m68k-amigaos"

adoom:
	$(MAKE) one url=https://github.com/AmigaPorts/ADoom target=adoom subdir=/adoom_src env="TOOLCHAIN=/opt/amiga"

milky:
	$(MAKE) one url=https://github.com/AmigaPorts/MilkyTracker target=milky init="./build_gmake"

ace:
	$(MAKE) one url=https://github.com/AmigaPorts/ACE target=ace env="ACE_CC=m68k-amigaos-gcc" mtarget=all mfile=makefile

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
	for i in $$(cat .gitignore) ; do rm -rf $$i/*; pushd $$i; git checkout --force; popd; done
