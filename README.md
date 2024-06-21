# configureplus

Minimal autoconfig-like configure tool. Can be used to locally create a (.configureplus) folder, which holds variables about the platform. Custom variables can be added. 
Moreover, a global fallback for variables is available (~/.config/configureplus/.configureplus)

# Synopsis

 $ make install
 $ pushd build/platforms/darwin19
 $ make install-systemwide
 $ configureplus help
 $ cd somewhere
 $ configureplus                               # create a local .configureplus/ folder with default platform variables (use $OSTYPE)
 $ CONFIGUREPLUS_SESSION=local1 configureplus set ALPHA 123 # .. create a scratch session for later use
 $ CONFIGUREPLUS_SESSION=local1 configureplus get ALPHA # .. create a scratch session for later use
 123
 
# Description

This is a configuration management utility designed to simplify and standardize the process of setting up project-specific configurations across different platforms and environments. Here are some key points about its usefulness:

  1. Cross-platform configuration: It helps manage configuration settings across different operating systems (like macOS and Linux) by detecting the platform and creating platform-specific configurations.

  2. Session-based configuration: It allows creating and managing different configuration sessions, which can be useful for handling multiple environments (e.g., development, testing, production) or different versions of a project.

  3. Variable management: It provides a structured way to define, store, and retrieve configuration variables, both globally and for specific sessions.

  4. Multiple output formats: The tool can generate configuration files in various formats, including Makefiles (.mk), Bash scripts (.bash and .bash_local), and JSON, making it versatile for different build systems and environments.

  5. Documentation support: It allows adding documentation to configuration variables, which can be helpful for team collaboration and maintaining complex configurations.

  6. Minimal dependencies: The tool is designed to work with minimal dependencies, primarily relying on Bash, which makes it portable across Unix-like systems.

  7. Automation: It can automate the process of creating and updating configuration files, reducing manual errors and saving time in project setup.

  8. Consistency: By providing a standardized way to manage configurations, it helps maintain consistency across different parts of a project or across multiple projects.

  9. Flexibility: Users can easily add custom variables and extend the tool's functionality to suit specific project needs.

In summary, it is particularly useful for developers and system administrators who need to manage complex configurations across different environments, automate setup processes, and maintain consistency in project configurations. 

It is especially beneficial for open-source projects, cross-platform development, or any scenario where managing multiple configuration variants is necessary.

Notably, no compatibility to the **autoconf** chain is planned.

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

    $ make
      .. building target platform
    $ cd build
    $ make
    $ cd platform/darwin19
    $ make install
      .. installing userprofile

### INSTALL systemwide (darwin19)

    $ make
      .. building target platform
    $ cd build
    $ make
    $ cd platform/darwin19
    $ make install-systemwide
      .. installing systemwide

## linux-gnu
There are two alternative installation options. Per default, the program is unpacked into this directory, and the userprofile is modified to include the corresponding bin/ into the PATH system variable.

### INSTALL userprofile (linux-gnu)

    $ make
      .. building target platform
    $ cd build
    $ make
    $ cd platform/linux-gnu
    $ make install
      .. installing userprofile

### INSTALL systemwide (linux-gnu)

    $ make
      .. building target platform
    $ cd build
    $ make
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

## .configureplus/**doc**/varname
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
- .configureplus/**global**/CONFIGUREPLUS_SESSION                         # variable
- .configureplus/**global**/CONFIGURE_DIR_OUTPUT                          # variable
- .configureplus/**global**/CONFIGURE_PKGNAME                             # variable
- .configureplus/**global**/CONFIGURE_DIR_TEMPLATE                        # variable
- .configureplus/**global**/CONFIGURE_VERSION                             # variable
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
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_OUT               # variable
- .configureplus/**session**/darwin19/CONFIGUREPLUS_SESSION               # variable
- .configureplus/**session**/darwin19/CONFIGUREPLUS_PWD                   # variable
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_CONFIG            # variable
- .configureplus/**session**/darwin19/CONFIGUREPLUS_VERSION               # variable
- .configureplus/**session**/darwin19/CONFIGUREPLUS_DIR_OUT_SESSIONS      # variable
- .configureplus/**session**/darwin19/CONFIGURE_MKTEMP                    # variable
- .configureplus/**session**/darwin19/CONFIGURE_TIMESTAMP                 # variable
- .configureplus/**session**/darwin19/CONFIGURE_DIR_OUTPUT                # variable
- .configureplus/**session**/darwin19/CONFIGURE_FLAG_TOOL_BTEST           # variable
- .configureplus/**session**/darwin19/CONFIGURE_OSTYPE                    # variable
- .configureplus/**session**/darwin19/CONFIGURE_PKGNAME                   # variable
- .configureplus/**session**/darwin19/CONFIGURE_DIR_TEMPLATE              # variable
- .configureplus/**session**/darwin19/CONFIGURE_BASH_PROFILE_FILE         # variable
- .configureplus/**session**/darwin19/CONFIGURE_VERSION                   # variable
- .configureplus/**session**/darwin19.bash_local
- .configureplus/**session**/darwin19.bash
- .configureplus/**session**/darwin19.mk
- .configureplus/**currentsession.bash**
- .configureplus/**currentsession.mk**


# Author

Murat Uenalan <murat.uenalan@gmail.com>
