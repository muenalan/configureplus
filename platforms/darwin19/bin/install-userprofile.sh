#!/bin/bash

source .configureplus/currentsession.bash

CONFIGUREPLUS_SESSION_HOME=$CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/session/$CONFIGUREPLUS_SESSION

echo modify userprofile file....: $CONFIGURE_BASH_PROFILE_FILE

source ../../bin/install-userprofile.sh $CONFIGUREPLUS_SESSION

echo creating file....: $CONFIGUREPLUS_SESSION_HOME/userprofile.bash

echo '# Generated with configureplus/bin/install-userprofile.sh' >$CONFIGUREPLUS_SESSION_HOME/userprofile.bash
echo "source $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/session/$CONFIGUREPLUS_SESSION.bash_local" >>$CONFIGUREPLUS_SESSION_HOME/userprofile.bash   
echo "export PATH=\$PATH:$PWD/configureplus/usr/local/bin/" >>$CONFIGUREPLUS_SESSION_HOME/userprofile.bash   

