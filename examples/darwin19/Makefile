# call ./configureplus before make

include .configureplus/session/local1.mk

install: $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin/
	mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin   && cp -r $(CONFIGURE_DIR_TEMPLATE)/bin/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin/
	mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib   && cp -r $(CONFIGURE_DIR_TEMPLATE)/lib/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib/
	mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var   && cp -r $(CONFIGURE_DIR_TEMPLATE)/var/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var/
	mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share && cp -r $(CONFIGURE_DIR_TEMPLATE)/share/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share/
	$(info Please follow README.md / INSTALL)
	cp -r .configureplus ~/.config/ob/
	./bin/install.sh local1

test:
	btest t/

zip:
	zip -r9 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.zip .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && zip -r9 $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

tar.gz:
	tar cfz ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.tar.gz .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && tar cfz $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz .

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-rm -r .configureplus/session/local1*



