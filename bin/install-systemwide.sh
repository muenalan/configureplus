#!/bin/bash

cat .configureplus/session/local1.bash

exit

source .configureplus/session/local1.bash

source $CONFIGUREPLUS_PWD/platforms/$CONFIGURE_OSTYPE/ob/usr/local/var/ob/system/contexts/platform/$CONFIGURE_OSTYPE/local1/.bash_context

OB_DEBUG=1 ob call system/objects/ob/systemwide/install system/contexts/platform/$(CONFIGURE_OSTYPE)/local1 
