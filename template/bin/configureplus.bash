#!/bin/bash

# Script: configureplus - a minimal autoconf(1)-like configure tool, which depends only on bash
# 
# Version: 0.1
#
# Author: Murat Uenalan <murat.uenalan@gmail.com

CONFIGUREPLUS_PWD=$PWD
CONFIGUREPLUS_VERSION=0.1
CONFIGUREPLUS_DIR_OUT=.configureplus
CONFIGUREPLUS_DIR_OUT_SESSIONS=$CONFIGUREPLUS_DIR_OUT/session
CONFIGUREPLUS_ZERO_ARG_BASENAME=$(basename $0)

if [[ ! "$CONFIGUREPLUS_DEBUG" ]]; then

    CONFIGUREPLUS_DEBUG=

fi

# if [[ ! "$CONFIGUREPLUS_SESSION" ]]; then
#
#    CONFIGUREPLUS_SESSION=local1
#
# fi


# functions

function warn_local
{
    if [ "$CONFIGUREPLUS_DEBUG" ]; then

        >&2 echo "[WARN stdout, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}" 

    fi
}

if [ ! -d "$CONFIGUREPLUS_DIR_CONFIG" ]; then

    export CONFIGUREPLUS_DIR_CONFIG_EMPTY=1

    warn_local "init $CONFIGUREPLUS_DIR_CONFIG"

    mkdir -p $CONFIGUREPLUS_DIR_CONFIG
    
fi

function configureplus_envshow
{
    env|grep CONFIGUREPLUS_|sort
}



