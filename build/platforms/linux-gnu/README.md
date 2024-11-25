# configureplus
Minimal autoconfig-like configure tool

# Description
Architecture dependency is traditionally detected with an universal **configure** tool. This packages provide similar means, and is not intended to be compatible to the **autoconf** chain. However, it solves a similar generic problem, but beeing more granular and more friendly.

# INSTALL
You can install it only locally for the user (userprofile), or system-wide.

## INSTALL userprofile (darwin19)

    $ echo $OSTYPE >.configure/global/CONFIGUREPLUS/SESSION
    $ ./bin/configureplus
    $ make install
      .. installing userprofile

    $ make uninstall
      .. uninstalling userprofile

## INSTALL systemwide (darwin19)

    $ echo $OSTYPE >.configure/global/CONFIGUREPLUS/SESSION
    $ ./bin/configureplus
    $ sudo make install-systemwide
      .. installing systemwide

# SYNOPSIS
