# call before: ./configureplus/usr/local/bin/configureplus

include .configureplus/currentsession.mk

PRE=/usr/local
DIR_TEMPLATE=$(CONFIGURE_PKGNAME)/$(PRE)

install-systemwide:
	DIR_TEMPLATE=$(DIR_TEMPLATE) PRE=$(PRE) ./bin/install-systemwide.sh

uninstall-systemwide:
	$(info ****** uninstall-systemwide: Not implemented yet *******)

install:
	./bin/install-userprofile.sh

uninstall:
	./bin/uninstall-userprofile.sh

zip:
	zip -r9 packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

archive-master:
	wget https://github.com/muenalan/configureplus/archive/master.tar.gz -o ../$(CONFIGURE_PKGNAME)-master.tar.gz

archive:
	git init
	git add .
	git commit -m "release"
	git tag v0.0.1
	git archive --format=tar.gz -o ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz --prefix=v0.0.1/ master
	shasum -a 256 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz >../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz.sha256

package:
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE) && cp -r . ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)/
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew &&	cp -r $(CONFIGURE_PKGNAME)/.brew ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew/

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*


status:
	test -d .configureplus && echo .configureplus dir exists

	! test -f .configureplus && echo .configureplus is not a file

