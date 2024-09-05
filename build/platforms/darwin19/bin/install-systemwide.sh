#!/bin/bash

echo "*WARN* Discontinued $0. Now using dpkg pipeline."

exit

if [[ ! "$CONFIGUREPLUS_DEBUG" ]]; then

    CONFIGUREPLUS_DEBUG=

fi

# functions

function warn_local
{
    if [ "$CONFIGUREPLUS_DEBUG" ]; then

        >&2 echo "[WARN stdout, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}" 

    fi
}

source .configureplus/currentsession.bash

echo INSTALL SYSTEMWIDE DIR_TEMPLATE=$DIR_TEMPLATE

chmod +x $DIR_TEMPLATE/bin/*

cp -r $DIR_TEMPLATE/bin/* $PRE/bin/

echo Step 1

if [ ! -d $PRE/lib/$CONFIGURE_PKGNAME ]; then

    warn_local mkdir -p $PRE/lib/$CONFIGURE_PKGNAME

    mkdir -p $PRE/lib/$CONFIGURE_PKGNAME

else

    warn_local cp -r $DIR_TEMPLATE/lib/* $PRE/lib/$CONFIGURE_PKGNAME

    cp -r $DIR_TEMPLATE/lib/* $PRE/lib/$CONFIGURE_PKGNAME
fi


echo Step 2

if [ ! -d $PRE/var/$CONFIGURE_PKGNAME ]; then

    warn_local mkdir -p $PRE/var/$CONFIGURE_PKGNAME

    mkdir -p $PRE/var/$CONFIGURE_PKGNAME

else

    warn_local cp -r $DIR_TEMPLATE/var/* $PRE/var/$CONFIGURE_PKGNAME

    cp -r $DIR_TEMPLATE/var/* $PRE/var/$CONFIGURE_PKGNAME
fi

echo Step 3

if [ ! -d $PRE/share/$CONFIGURE_PKGNAME ]; then

    warn_local mkdir -p $PRE/share/$CONFIGURE_PKGNAME 

    mkdir -p $PRE/share/$CONFIGURE_PKGNAME 

else
    
    warn_local cp -r $DIR_TEMPLATE/share/* $PRE/share/$CONFIGURE_PKGNAME

    cp -r $DIR_TEMPLATE/share/* $PRE/share/$CONFIGURE_PKGNAME

fi


echo Step 4

if [ ! -d ~/.config/$CONFIGURE_PKGNAME/ ]; then

    warn_local mkdir ~/.config/$CONFIGURE_PKGNAME/

    mkdir ~/.config/$CONFIGURE_PKGNAME/

else
    
    warn_local cp -r .configureplus ~/.config/$CONFIGURE_PKGNAME/

    cp -r .configureplus ~/.config/$CONFIGURE_PKGNAME/

fi

