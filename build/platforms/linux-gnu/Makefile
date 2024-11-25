# call before: ./configureplus/usr/local/bin/configureplus

include .configureplus/currentsession.mk

PRE=/usr/local

DIR_TEMPLATE=$(CONFIGURE_PKGNAME)/$(PRE)

.PHONY: status install-systemwide install-systemwide-lib install-systemwide-share install-systemwide-doc uninstall zip archive-master archive package deb test install-deb uninstall-deb clean

install-systemwide:
	mkdir -p $(PRE)/bin && cp -r $(DIR_TEMPLATE)/bin/* $(PRE)/bin/
	chmod +x $(DIR_TEMPLATE)/bin/*
	make -B install-systemwide-lib
	make -B install-systemwide-share
	make -B install-systemwide-doc
	-mkdir -p ~/.config/$(CONFIGURE_PKGNAME)/
	-cp -r .configureplus ~/.config/$(CONFIGURE_PKGNAME)/

status:
	CONFIGURE_BASH_PROFILE_FILE="$(shell cat .configureplus/session/linux-gnu/CONFIGURE/BASH_PROFILE_FILE)"
	CONFIGURE_FLAG_TOOL_BTEST="$(shell cat .configureplus/session/linux-gnu/CONFIGURE/FLAG_TOOL_BTEST)"
	CONFIGURE_MKTEMP="$(shell cat .configureplus/session/linux-gnu/CONFIGURE/MKTEMP)"
	CONFIGURE_OSTYPE="$(shell cat .configureplus/session/linux-gnu/CONFIGURE/OSTYPE)"
	CONFIGURE_TIMESTAMP="$(shell cat .configureplus/session/linux-gnu/CONFIGURE/TIMESTAMP)"
	CONFIGUREPLUS_DIR_CONFIG="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/DIR_CONFIG)"
	CONFIGUREPLUS_DIR_OUT="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/DIR_OUT)"
	CONFIGUREPLUS_DIR_OUT_SESSIONS="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/DIR_OUT_SESSIONS)"
	CONFIGUREPLUS_PWD="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/PWD)"
	CONFIGUREPLUS_SESSION="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/SESSION)"
	CONFIGUREPLUS_VERSION="$(shell cat .configureplus/session/linux-gnu/CONFIGUREPLUS/VERSION)"
	echo CONFIGURE_PKGNAME=$(CONFIGURE_PKGNAME)

FILES=$(wildcard $(PWD)/$(DIR_TEMPLATE)/lib/$(CONFIGURE_PKGNAME)/*) 

install-systemwide-lib:
	install -d $(PRE)/lib/$(CONFIGURE_PKGNAME) || mkdir -p $(PRE)/lib/$(CONFIGURE_PKGNAME)
	if [ -n "$(wildcard $(DIR_TEMPLATE)/lib/$(CONFIGURE_PKGNAME)/*) " ]; then \
		install -m 755 $(wildcard $(DIR_TEMPLATE)/lib/$(CONFIGURE_PKGNAME)/*) $(PRE)/lib/$(CONFIGURE_PKGNAME)/;  \
	fi

FILES=$(wildcard $(DIR_TEMPLATE)/share/*)

install-systemwide-share:
	install -d $(PRE)/share/$(CONFIGURE_PKGNAME) || mkdir -p $(PRE)/share/$(CONFIGURE_PKGNAME)
	@if [ -n "$(FILES)" ]; then \
		echo install -m 755 -t $(PRE)/share/$(CONFIGURE_PKGNAME) $(FILES); \
		install -m 755 -t $(PRE)/share/$(CONFIGURE_PKGNAME) $(FILES); \
	fi

FILES=$(wildcard $(DIR_TEMPLATE)/doc/*)

install-systemwide-doc:
	install -d $(PRE)/doc/$(CONFIGURE_PKGNAME) || mkdir -p $(PRE)/doc/$(CONFIGURE_PKGNAME)
	@if [ -n "$(FILES)" ]; then \
	echo install -m 755 -t $(PRE)/doc/$(CONFIGURE_PKGNAME) $(FILES); \
	install -m 755 -t $(PRE)/doc/$(CONFIGURE_PKGNAME) $(FILES); \
	fi


install-userprofile:
	./bin/install-userprofile.sh

uninstall-userprofile:
	./bin/uninstall-userprofile.sh

uninstall:
	$(info ****** uninstall-systemwide: Not implemented yet *******)

zip:
	mkdir ../packages
	zip -r9 ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

archive-master:
	wget https://github.com/muenalan/configureplus/archive/master.tar.gz -o ../$(CONFIGURE_PKGNAME)-master.tar.gz

archive:
	git init
	git add .
	git commit -m "release"
	git tag v0.0.1
	git archive --format=tar.gz -o ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz --prefix=v0.0.1/ master
	md5sum ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz >../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz.sha256

package:
	mkdir ../packages
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE) && cp -r . ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)/
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew &&	cp -r $(CONFIGURE_PKGNAME)/.brew ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew/

deb:
	mkdir -p ../packages
	dpkg-deb --build $(CONFIGURE_PKGNAME)
	mv $(CONFIGURE_PKGNAME).deb ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

test:
	btest /usr/local/lib/ob/t

install-deb: deb
	dpkg -i ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).deb

uninstall-deb:
	dpkg --remove $(CONFIGURE_PKGNAME)

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-zip -rm .configureplus/session-bak.zip .configureplus/session/$(CONFIGUREPLUS_SESSION)*



