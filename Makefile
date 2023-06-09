install:
	cd build/ && ./bin/configureplus --detect-os
	cd build/ && make

init: 
	mkdir -p template/bin
	touch template/bin/$(CONFIGURE_PKGNAME)
	mkdir -p template/{lib,share/doc,var}/$(CONFIGURE_PKGNAME)

test:
	btest t/

clean:
	-find . -name '*~' |zip -rm bak.zip -@
	-find . -name '*.bak' |zip -rm bak.zip -@
	-cd build/ && ./bin/configureplus
	-cd build/ && make clean
