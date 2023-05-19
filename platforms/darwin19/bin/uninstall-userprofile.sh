#!/bin/bash

source .configureplus/currentsession.bash

CONFIGUREPLUS_SESSION_HOME=$CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/session/$CONFIGUREPLUS_SESSION

echo modify userprofile file....: $CONFIGURE_BASH_PROFILE_FILE

source ../../bin/uninstall-userprofile.sh $CONFIGUREPLUS_SESSION

echo remove file....: $CONFIGUREPLUS_SESSION_HOME/userprofile.bash

cp $CONFIGUREPLUS_SESSION_HOME/userprofile.bash $CONFIGUREPLUS_SESSION_HOME/userprofile.bash.bak
