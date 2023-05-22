# configureplus
Minimal autoconfig-like configure tool

# Description
Architecture dependency is traditionally detected with an universal **configure** tool. This packages provide similar means, and is not intended to be compatible to the **autoconf** chain. However, it solves a similar generic problem, but beeing more granular and more friendly.

# Aims

- Be universal, with absolute minimal prerequisites: bash.
- Keep it simple. Files are variables, that are used at each step.
- A recorded configuration should be transportable (such as stored in ~/.config for reuse).
- Multiple configurations (sessions) should be able to co-exists. Allowing the switch to a particular **session-key**; testing different versions.

# Supported platforms
This is a multiarch package, where during the build process the platform is detected and a architecture dependant version is manufactured into the platforms directory.

## darwin19 (macos)
There are two alternative installation options. Per default, the program is unpacked into this directory, and the userprofile is modified to include the corresponding bin/ into the PATH system variable.

### INSTALL userprofile (darwin19)

    $ ./bin/configureplus
    $ make
      .. building target platform
    $ cd platform/darwin19
    $ make install
      .. installing userprofile

### INSTALL systemwide (darwin19)

    $ ./bin/configureplus
    $ make
      .. building target platform
    $ cd platform/darwin19
    $ make install-systemwide
      .. installing systemwide

## linux-gnu
There are two alternative installation options. Per default, the program is unpacked into this directory, and the userprofile is modified to include the corresponding bin/ into the PATH system variable.

### INSTALL userprofile (linux-gnu)

    $ ./bin/configureplus
    $ make
      .. building target platform
    $ cd platform/linux-gnu
    $ make install
      .. installing userprofile

### INSTALL systemwide (linux-gnu)

    $ ./bin/configureplus
    $ make
      .. building target platform
    $ cd platform/linux-gnu
    $ make install-systemwide
      .. installing systemwide

# SYNOPSIS (darwin19)

    # Warn, because .configureplus/session/darwin19/CONFIGUREPLUS_SESSION is not set
    
    $ configureplus
    [WARN stdout, configureplus] : { ERROR_NOT_SET_CONFIGUREPLUS_SESSION }
    [WARN stdout, configureplus] : { Will invoke: echo darwin19 }
    [WARN stdout, configureplus] : { Retry configureplus again. }    

    $ configureplus
    [WARN stdout, configureplus] : { Loading .configureplus/global/CONFIGUREPLUS_SESSION=darwin19 }
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_CONFIG = /Users/muenalan/.config/configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_OUT = .configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_OUT_SESSIONS = .configureplus/session
- .configureplus/session/darwin19/CONFIGUREPLUS_PWD = /Users/muenalan/git-workdirs/github.com/muenalan/bash/configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_SESSION = 'darwin19' [session-id (such as $OSTYPE)]
- .configureplus/session/darwin19/CONFIGUREPLUS_VERSION = 0.1
- .configureplus/session/darwin19/CONFIGURE_BASH_PROFILE_FILE = /Users/muenalan/.bash_profile
- .configureplus/session/darwin19/CONFIGURE_DIR_OUTPUT = 'platforms' [folder for general and os-specific files (merged with CONFIG_DIR_TEMPLATE)]
- .configureplus/session/darwin19/CONFIGURE_DIR_TEMPLATE = 'template' [folder for os-specific files and template files merged]
- .configureplus/session/darwin19/CONFIGURE_FLAG_TOOL_BTEST = '' [btest *testing* tool path]
- .configureplus/session/darwin19/CONFIGURE_GIT_TAG = v0.0.1
- .configureplus/session/darwin19/CONFIGURE_MKTEMP = '/var/folders/px/ctnmlq5n5gbf154mj25wzdxh0000gn/T/tmp.FU7FWYDy' [make session temp dir]
- .configureplus/session/darwin19/CONFIGURE_OSTYPE = 'darwin19' [current os identifier]
- .configureplus/session/darwin19/CONFIGURE_PKGNAME = 'configureplus' [distribution package name]
- .configureplus/session/darwin19/CONFIGURE_TIMESTAMP = Mon May 22 11:41:16 CEST 2023
- .configureplus/session/darwin19/CONFIGURE_VERSION = '0.0.1'  [distribution version]
    INFO: .configureplus/global.mk generated
    INFO: .configureplus/global.bash generated
    INFO: .configureplus/global.bash_local generated
    INFO: .configureplus/session/darwin19.mk generated
    INFO: .configureplus/session/darwin19.bash generated
    INFO: .configureplus/session/darwin19.bash_local generated

    $ configureplus
    Configuring (darwin19) ...
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_CONFIG = /Users/muenalan/.config/configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_OUT = .configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_DIR_OUT_SESSIONS = .configureplus/session
- .configureplus/session/darwin19/CONFIGUREPLUS_PWD = /Users/muenalan/git-workdirs/github.com/muenalan/bash/configureplus
- .configureplus/session/darwin19/CONFIGUREPLUS_SESSION = darwin19
- .configureplus/session/darwin19/CONFIGUREPLUS_VERSION = 0.1
- .configureplus/session/darwin19/CONFIGURE_BASH_PROFILE_FILE = /Users/muenalan/.bash_profile
- .configureplus/session/darwin19/CONFIGURE_DIR_OUTPUT = 'platforms' [folder for general and os-specific files (merged with CONFIG_DIR_TEMPLATE)]
- .configureplus/session/darwin19/CONFIGURE_DIR_TEMPLATE = 'template' [folder for os-specific files and template files merged]
- .configureplus/session/darwin19/CONFIGURE_FLAG_TOOL_BTEST = '' [btest *testing* tool path]
- .configureplus/session/darwin19/CONFIGURE_MKTEMP = '/var/folders/px/ctnmlq5n5gbf154mj25wzdxh0000gn/T/tmp.2i0aHmR6' [make session temp dir]
- .configureplus/session/darwin19/CONFIGURE_OSTYPE = 'darwin19' [current os identifier]
- .configureplus/session/darwin19/CONFIGURE_PKGNAME = 'configureplus' [distribution package name]
- .configureplus/session/darwin19/CONFIGURE_TIMESTAMP = Thu May 18 16:54:08 CEST 2023
- .configureplus/session/darwin19/CONFIGURE_VERSION = '0.1'    [distribution version]
- INFO: .configureplus/global.mk generated
- INFO: .configureplus/global.bash generated
- INFO: .configureplus/global.bash_local generated
- INFO: .configureplus/session/darwin19.mk generated
- INFO: .configureplus/session/darwin19.bash generated
- INFO: .configureplus/session/darwin19.bash_local generated
    $ echo value1 .configureplus/global/var1
    $ echo value2 .configureplus/global/var2
    $ echo value3 .configureplus/global/var3
    $ cat .configureplus/dynamic.bash
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGURE_BASH_PROFILE_FILE echo $HOME/.bash_profile
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGUREPLUS_DIR_CONFIG    echo $HOME/.config/$CONFIGURE_PKG
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGURE_OSTYPE            echo $OSTYPE 
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGURE_MKTEMP            echo `mktemp -d` 
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGURE_FLAG_TOOL_BTEST   which btest
      >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGURE_TIMESTAMP         date
  
# INPUT .configureplus
Files are used to configure the configuration variables.

# SPEC

- .configureplus/global/**VARNAME**                      : global variables, stored as single files
- .confgureplus/**global**.mk                            : global variables single-file (Makefile part)
- .confgureplus/**global**.bash                          : global variables single-file (bash source, export)
- .confgureplus/**global**.bash_local                    : global variables single-file (bash source)
- .configureplus/doc/**VARNAME**                         : variable description, single file
- .confgureplus/session/**session-id**/**VARSESSION-ID** : variable file of session **session-id**
- .confgureplus/session/**session-id**.mk                : session as include'able Makefile part
- .confgureplus/session/**session-id**.bash              : session as include'able bash source (exported variables)
- .confgureplus/session/**session-id**.bash_local        : session as include'able bash source
- .confgureplus/**dynamic**.bash                         : script invoked by configureplus
- .confgureplus/**currentsession**.mk                    : include'able session single-file (Makefile part)
- .confgureplus/**currentsession**.bash                  : include'able session single-file (bash, export)
- .confgureplus/**currentsession**.bash_local            : include'able session single-file (bash)

## .configureplus/doc/**varname**
Each file contains annotation for a single variable. These can be global, or dynamically declared.

- .configureplus/**doc**/CONFIGUREPLUS_SESSIONS
- .configureplus/**doc**/CONFIGURE_MKTEMP
- .configureplus/**doc**/CONFIGURE_DIR_OUTPUT_SESSIONS
- .configureplus/**doc**/CONFIGURE_DIR_OUTPUT
- .configureplus/**doc**/CONFIGURE_FLAG_TOOL_BTEST
- .configureplus/**doc**/CONFIGURE_OSTYPE
- .configureplus/**doc**/CONFIGURE_PKGNAME
- .configureplus/**doc**/CONFIGURE_DIR_TEMPLATE
- .configureplus/**doc**/CONFIGURE_VERSION


# EXAMPLE

- .configureplus
- .configureplus/Makefile
- .configureplus/**dynamic.bash**
- .configureplus/**global**
- .configureplus/**global**/CONFIGUREPLUS_SESSION
- .configureplus/**global**/CONFIGURE_DIR_OUTPUT
- .configureplus/**global**/CONFIGURE_PKGNAME
- .configureplus/**global**/CONFIGURE_DIR_TEMPLATE
- .configureplus/**global**/CONFIGURE_VERSION
- .configureplus/**global.bash_local**
- .configureplus/**global.bash**
- .configureplus/**global.mk**
- .configureplus/**doc**
- .configureplus/**doc**/CONFIGUREPLUS_SESSIONS
- .configureplus/**doc**/CONFIGURE_MKTEMP
- .configureplus/**doc**/CONFIGURE_DIR_OUTPUT_SESSIONS
- .configureplus/**doc**/CONFIGURE_DIR_OUTPUT
- .configureplus/**doc**/CONFIGURE_FLAG_TOOL_BTEST
- .configureplus/**doc**/CONFIGURE_OSTYPE
- .configureplus/**doc**/CONFIGURE_PKGNAME
- .configureplus/**doc**/CONFIGURE_DIR_TEMPLATE
- .configureplus/**doc**/CONFIGURE_VERSION
- .configureplus/**session**
- .configureplus/**session**/darwin19
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_OUT
- .configureplus/**session**/darwin19/CONFIGUREPLUS_SESSION
- .configureplus/**session**/darwin19/CONFIGUREPLUS_PWD
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_CONFIG
- .configureplus/**session**/darwin19/CONFIGURE_MKTEMP
- .configureplus/**session**/darwin19/CONFIGUREPLUS_VERSION
- .configureplus/**session**/darwin19/CONFIGURE_TIMESTAMP
- .configureplus/**session**/darwin19/CONFIGURE_DIR_OUTPUT
- .configureplus/**session**/darwin19/CONFIGURE_FLAG_TOOL_BTEST
- .configureplus/**session**/darwin19/CONFIGURE_OSTYPE
- .configureplus/**session**/darwin19/CONFIGURE_PKGNAME
- .configureplus/**session**/darwin19/CONFIGURE_DIR_TEMPLATE
- .configureplus/**session**/darwin19/CONFIGURE_BASH_PROFILE_FILE
- .configureplus/**session**/darwin19/CONFIGURE_VERSION
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_OUT_SESSIONS
- .configureplus/**session**/darwin19.bash_local
- .configureplus/**session**/darwin19.bash
- .configureplus/**session**/darwin19.mk
- .configureplus/**currentsession.bash**
- .configureplus/**currentsession.mk**


# Author

Murat Uenalan <murat.uenalan@gmail.com>
