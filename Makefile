PREFIX ?= /opt/amiga

init ?= echo no init
mfile ?= Makefile

.PHONY: all
all: objfw adoom milky


.PHONY: objfw adoom milky
objfw:
	$(MAKE) one url=https://github.com/Midar/objfw target=objfw mfile=Makefile init="./autogen.sh && ./configure --host=m68k-amigaos"

adoom:
	$(MAKE) one url=https://github.com/AmigaPorts/ADoom target=adoom subdir=/adoom_src env="TOOLCHAIN=/opt/amiga"

milky:
	$(MAKE) one url=https://github.com/AmigaPorts/MilkyTracker target=milky init="./build_gmake"

.PHONY: one
one:
	if [ ! -e $(target) ]; then \
	  git clone $(url) $(target); \
	fi
	cd $(target) && git pull
	cd $(target) && $(init)
	$(env) $(MAKE) -C $(target)$(subdir) -f $(mfile)

.PHONY: clean
clean:
	for i in $$(cat .gitignore) ; do rm -rf $$i; done
