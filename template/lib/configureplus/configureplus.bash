#!/bin/bash

# Script version
CONFIGUREPLUS_VERSION=0.16.3

# COMMONS ENV
: ${CONFIGUREPLUS_DEBUG:=0}

CONFIGUREPLUS_PWD=$PWD

CONFIGUREPLUS_DIR_OUT=.$SCRIPT_NAME

CONFIGUREPLUS_DIR_OUT_SESSIONS=$CONFIGUREPLUS_DIR_OUT/session

CONFIGUREPLUS_ZERO_ARG_BASENAME=$(basename $0)

CONFIGUREPLUS_DIR_CONFIG=~/.config/$SCRIPT_NAME

CONFIGUREPLUS_DIR_CONFIG_FULL=${CONFIGUREPLUS_DIR_CONFIG}/$CONFIGUREPLUS_DIR_OUT

CONFIGUREPLUS_OPTION_FLAG_HOME=false

CONFIGUREPLUS_OPTION_FLAG_GLOBAL=false

CONFIGUREPLUS_OPTION_FLAG_DETECT_OS=false

# functions

function echo_local
{
    if [[ "$@" == "" ]]; then

       >&1 echo "[INFO echo_local, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : EMPTY_LINE"

       exit 100
       
    fi
       
       >&1 echo "[INFO echo_local, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}"
}

function echo_local_level
{
    local LEVEL=$1

    shift
    
    if [ "$CONFIGUREPLUS_DEBUG" -ge "$LEVEL" ]; then

       >&1 echo "[INFO echo_local_level $LEVEL, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}"

    fi
}

function warn_local
{
   if [ "$CONFIGUREPLUS_DEBUG" -ge "1" ]; then

    >&2 echo "[WARN warn_local, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}"

   fi
}

function error_local
{
    >&2 echo "[ERROR error_local, $CONFIGUREPLUS_ZERO_ARG_BASENAME] : {" $@ "}"
}

function configureplus_env
{
    warn_local Sourcing ${CONFIGUREPLUS_DIR_CONFIG_FULL}/global.bash_local
    
    source ${CONFIGUREPLUS_DIR_CONFIG_FULL}/global.bash_local

    set|perl -ne 'print if /^CONFIGURE(PLUS)?_/;'

    warn_local "Note: Your local shell variables are not shown. Rerun: '$ set|grep CONFIGURE' if needed." 
}


function configureplus_status
{
    echo configureplus_status: CONFIGUREPLUS_DEBUG=$CONFIGUREPLUS_DEBUG 

    warn_local Showing ${CONFIGUREPLUS_DIR_CONFIG_FULL}/
    
    tree ${CONFIGUREPLUS_DIR_CONFIG_FULL}/

    if [ -d "$CONFIGUREPLUS_DIR_OUT/" ]; then

        tree $CONFIGUREPLUS_DIR_OUT/

    else
	
	error_local "CONFIGUREPLUS_DIR_OUT=$CONFIGUREPLUS_DIR_OUT is empty. Need to change dir, or create first ?"

	exit 22
    fi

    if [[ ! "$CONFIGUREPLUS_DIR_OUT_SESSIONS" ]]; then

	error_local "CONFIGUREPLUS_DIR_OUT_SESSIONS=$CONFIGUREPLUS_DIR_OUT_SESSIONS is empty"

	exit 33
    fi

    configureplus_session_identify
    
    if [[ ! "$CONFIGUREPLUS_SESSION" ]]; then

	error_local "CONFIGUREPLUS_SESSION=$CONFIGUREPLUS_SESSION is empty"

	exit 44
    fi

    echo ""
    echo "// HOME-GLOBAL, HOME-LOCAL, LOCAL-GLOBAL, LOCAL-LOCAL"


    warn_local '$CONFIGUREPLUS_DIR_OUT_SESSION=' $CONFIGUREPLUS_DIR_OUT_SESSIONS
    
        FOLDERS=$(echo ${CONFIGUREPLUS_DIR_CONFIG_FULL}/global ${CONFIGUREPLUS_DIR_CONFIG_FULL}_SESSIONS/$CONFIGUREPLUS_SESSION $CONFIGUREPLUS_DIR_OUT/global $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION)

        for FOLDER in $FOLDERS; do

            warn_local FOLDER=$FOLDER
            
            if [[ -d $FOLDER ]]; then
	        find $FOLDER/* -type f                          | perl -MPath::Class -ne 'chomp; $f=file($_); chomp($fs=$f->slurp); printf qq[%s = "%s"\n], $f, $fs;'
            fi

        done

    echo ""
    echo "// VALUES"

    find $FOLDERS -mindepth 1 -type f | 
         CONFIGUREPLUS_SESSION=$CONFIGUREPLUS_SESSION /usr/bin/perl -MPath::Class -MData::Dump=pp -ne '

         chomp; 

         $f=file($_); 

         chomp( $val=$f->slurp ); 

         $e = quotemeta $ENV{HOME};

         $k = "";

         if( /$e/ )
         {
           $key = "HOME-SESSION" if /session/;

           $key = "HOME-GLOBAL" if /global/;
         }
         else
         {
           $key = "LOCAL-SESSION" if /session/;

           $key = "LOCAL-GLOBAL" if /global/;
         }

         $href->{ $f->basename }->{ $key } = $val; 

         $field_fmt="%-45s";

         sub middle_clip
         {
         my $str = shift;
         my $max_length = shift||50;

         if (length($str) > $max_length) 
         {
             my $half = int(($max_length - 2) / 2);  # Subtract 2 for the '..'
             my $clipped_str = substr($str, 0, $half) . ".." . substr($str, -$half);
            return $clipped_str;
         }

         return $str;
         }

         END 
         { 
            @k = qw(HOME-GLOBAL HOME-SESSION LOCAL-GLOBAL LOCAL-SESSION);

            printf "$field_fmt %s\n", "VARNAME", join( " ", map { $_="$_ ($ENV{CONFIGUREPLUS_SESSION})" if /SESSION/; sprintf "$field_fmt", $_||"<empty>" } @k ), "\n";
 
            for my $varname (sort keys %$href) 
            { 
               printf "$field_fmt %s\n", $varname, join( " ", map { $str=$href->{$varname}->{$_}; sprintf "$field_fmt", middle_clip($str||"<>", 45) } @k );
            } 

         }

         '
    

}

function configureplus_fname
{
    warn_local "configureplus_fname : \$1 = $1"

    local FNAME_PRE=$CONFIGUREPLUS_DIR_OUT

    local FNAME_POST=session/$CONFIGUREPLUS_SESSION/$1

    
    if [ "$CONFIGUREPLUS_OPTION_FLAG_HOME" = true ]; then

	warn_local "configureplus_fname : \$CONFIGUREPLUS_OPTION_FLAG_HOME is true; setting FNAME to home-global var.."

	FNAME_PRE=${CONFIGUREPLUS_DIR_CONFIG_FULL}

    fi

    if [ "$CONFIGUREPLUS_OPTION_FLAG_GLOBAL" = true ]; then

	warn_local "configureplus_fname : \$CONFIGUREPLUS_OPTION_FLAG_GLOBAL is true; setting FNAME to global var.."

	FNAME_POST=global/$1


    fi

    echo $FNAME_PRE/$FNAME_POST
}

function configureplus_filepath_dir_create()
{
    local DIRNAME=$(dirname $1)

    if [[ ! -d $DIRNAME ]]; then

        mkdir -p $DIRNAME

        if [[ ! -d $DIRNAME ]]; then

            echo "*FATAL*: configureplus_filepath_dir_create - Could not create $DIRNAME with: mkdir -p $DIRNAME" >&2

            exit 99
        fi

    fi
    
}

function configureplus_set
{
    if [ -z "$1" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 1: configureplus_set requires key argument."

    fi
    
    if [ -z "$2" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 2: configureplus_set requires value argument."

    fi

    local FNAME=$(configureplus_fname $1)

    warn_local "configureplus_set : decided on FNAME=$FNAME"

    shift
    
    echo_local_level 2 Setting $FNAME to value \"$1\" "(all values \"$*\")"

    configureplus_filepath_dir_create $FNAME
    
    >$FNAME echo "$*"
}

function configureplus_add
{
    if [ -z "$1" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 1: configureplus_add requires key argument."

    fi
    
    local FNAME=$(configureplus_fname $1)

    warn_local "configureplus_add : decided on FNAME=$FNAME"

    shift

    configureplus_filepath_dir_create $FNAME

    if [ -z "$2" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 2: configureplus_add requires value argument."

        echo_local "No VALUE given, setting from PIPE.."

        while IFS= read -r line; do

            local OLD_VALUE=""

            if [[ -f "$FNAME" ]]; then

                OLD_VALUE=`cat $FNAME`

            fi

            echo_local_level 2 Adding to $FNAME value \"$1\" "(line \"$line\")"

            >$FNAME echo "$OLD_VALUE:$line"

        done
    
    else
        

        local OLD_VALUE=""

        if [[ -f "$FNAME" ]]; then

            OLD_VALUE=`cat $FNAME`

        fi
        
        echo_local_level 2 Adding to $FNAME value \"$1\" "(all values \"$*\")"

        >$FNAME echo "$OLD_VALUE:$*"
    fi
    
}

function configureplus_remove
{
    if [ -z "$1" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 1: configureplus_remove requires key argument."

    fi
    
    if [ -z "$2" ]; then

        echo_local_level 2 "ARGUMENT_MISSING at pos 2: configureplus_remove requires value argument."

    fi

    local FNAME=$(configureplus_fname $1)

    warn_local "configureplus_remove : decided on FNAME=$FNAME"

    shift

    local OLD_VALUE=`cat $FNAME`

    local NEW_VALUE=$(OLD_VALUE="$OLD_VALUE" REMOVE_VALUE="$1" /usr/bin/perl -e '

      use Env qw(@OLD_VALUE $REMOVE_VALUE); 

      @new_value= grep( !/^$REMOVE_VALUE$/, @OLD_VALUE ); 

      print join( ":", @new_value); 
      '
    )

    warn_local NEW_VALUE="$NEW_VALUE"
    
    echo_local_level 2 Removing from $FNAME value \"$1\" "(all values \"$*\")"

    >$FNAME echo "$NEW_VALUE"
}

function configureplus_get
{
    echo_local_level 2 Getting $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$1

    local FNAME=$(configureplus_fname $1)

    echo_local_level 2 cat $FNAME

    cat $FNAME

    echo ""
}

function configureplus_sessions_list
{
    warn_local Getting global sessions $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/session

    find $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/session -maxdepth 1 -mindepth 1 -type d

    if [ -d "$CONFIGUREPLUS_DIR_OUT/" ]; then

        warn_local Getting local sessions $CONFIGUREPLUS_DIR_OUT/session

        find $CONFIGUREPLUS_DIR_OUT -maxdepth 1 -mindepth 1 -type d

    fi

    echo_local_level 2 Currently CONFIGUREPLUS_SESSION=$CONFIGUREPLUS_SESSION

}

# defaults

function configureplus_dir_config_setup
{
    if [ ! -d "$CONFIGUREPLUS_DIR_CONFIG" ]; then

        export CONFIGUREPLUS_DIR_CONFIG_EMPTY=1

        warn_local "configureplus_dir_config_setup - init $CONFIGUREPLUS_DIR_CONFIG"

        mkdir -p $CONFIGUREPLUS_DIR_CONFIG
        
    fi
}

function configureplus_session_var_update_ostype
{
    warn_local "--detect-os: \$OSTYPE >$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION"

    warn_local "echo $OSTYPE >$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION"

    echo $OSTYPE >$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION
}

function configureplus_session_identify
{
    echo_local_level 2 configureplus_session_identify - begin ..
    
    if [[ -z "$CONFIGUREPLUS_SESSION" ]]; then

        echo_local_level 2 configureplus_session_identify - CONFIGUREPLUS_SESSION not set at start.

        if [ -f "$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION" ]; then

	    CONFIGUREPLUS_SESSION=$(cat $CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION)
	    
	    echo_local_level 2 configureplus_session_identify - Setting to $CONFIGUREPLUS_SESSION "(from $CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION)"
	    
        else

            if [ "$CONFIGUREPLUS_DIR_OUT" == `basename $PWD` ]; then

                warn_local configureplus_session_identify - "init $CONFIGUREPLUS_DIR_OUT ... *SKIP* because we are currently inside one."

                exit
            fi

	    CONFIGUREPLUS_DEBUG=1 warn_local ERROR_NOT_SET_CONFIGUREPLUS_SESSION
	    
	    warn_local configureplus_session_identify - Will invoke: mkdir -p $CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS

            mkdir -p $CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS

	    warn_local configureplus_session_identify - Will invoke: echo $OSTYPE >$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION

	    echo $OSTYPE >$CONFIGUREPLUS_DIR_OUT/global/CONFIGUREPLUS/SESSION

	    warn_local configureplus_session_identify - Retry configureplus again.

	    exit
        fi
    fi

    echo_local_level 2 configureplus_session_identify - .. done

}




function configureplus_session_directory_setup
{
    echo_local_level 2 configureplus_session_directory_setup - begin ..

    # $CONFIGUREPLUS_SESSION

    mkdir -p $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION

    # dynamic

    if [ ! -f $CONFIGUREPLUS_DIR_OUT/dynamic.bash ]; then

        warn_local configureplus_session_directory_setup - Probing $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/dynamic.bash
        
        if [ -f $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/dynamic.bash ]; then

            warn_local configureplus_session_directory_setup - COMMAND: cp $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/dynamic.bash $CONFIGUREPLUS_DIR_OUT/

            cp $CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/dynamic.bash $CONFIGUREPLUS_DIR_OUT/

        else

            warn_local configureplus_session_directory_setup - COMMAND: touch $CONFIGUREPLUS_DIR_OUT/dynamic.bash

            touch $CONFIGUREPLUS_DIR_OUT/dynamic.bash

        fi
        

    fi


    if [ ! -d $CONFIGUREPLUS_DIR_OUT/global ]; then

        mkdir -p $CONFIGUREPLUS_DIR_OUT/global 

    fi

    echo_local_level 2 configureplus_session_directory_setup - .. end

}

function configureplus_dynamic_source
{
    echo_local_level 2 configureplus_dynamic_source - begin ..

    echo_local_level 2 source $CONFIGUREPLUS_DIR_OUT/dynamic.bash

    source $CONFIGUREPLUS_DIR_OUT/dynamic.bash

    echo_local_level 2 configureplus_dynamic_source - .. end
}

function configureplus_globalvars_setup
{
    echo_local_level 2 configureplus_globalvars_setup - begin .. 

    # global

    echo_local_level 2 "configureplus_globalvars_setup - init session vars from global (overwrite) (source=$CONFIGUREPLUS_DIR_OUT/global/)"

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT/global/

    for VARFILE in $(find ${FIND_DIR}* -type f); do

        warn_local VARFILE=$VARFILE
        
	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

	if [ ! -f "$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$VARFILE_BASE" ]; then
	    
	    warn_local configureplus_globalvars_setup - overwriting "$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$VARFILE_BASE"

            configureplus_filepath_dir_create $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$VARFILE_BASE

	    echo_local_level 3 cp "$VARFILE" "$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$VARFILE_BASE"

            cp "$VARFILE" "$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/$VARFILE_BASE"
	    
	fi

    done

    # std

    echo_local_level 2 configureplus_globalvars_setup - write current variable values to $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/

    VARS="PWD SESSION VERSION DIR_CONFIG DIR_OUT DIR_OUT_SESSIONS"

    echo_local_level 2 configureplus_globalvars_setup - reset VARS=$VARS

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/
    
    for VARNAME in $VARS; do

	VARNAME_=CONFIGUREPLUS_$VARNAME

	VARNAME_FULL=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/CONFIGUREPLUS/$VARNAME

	echo_local_level 2 configureplus_globalvars_setup - Test $VARNAME_FULL = ${!VARNAME_}

	if [ ! -f "$VARNAME_FULL" ]; then
	    
	    echo_local_level 2 configureplus_globalvars_setup - overwrite $VARNAME_FULL = ${!VARNAME_}

            configureplus_filepath_dir_create $VARNAME_FULL

	    >$VARNAME_FULL               echo ${!VARNAME_}

	fi
	
    done

    echo_local_level 2 configureplus_globalvars_setup - done
}


# functions

function configureplus_summary
{
    echo_local_level 2 PWD=$PWD
    
    echo_local_level 2 configureplus_summary - "(find $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/*|sort)":

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/

    for VARFILE in $(find ${FIND_DIR}* -type f|sort); do

	BASENAME=$(basename $VARFILE)
        
        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

	DOCFILE_GLOBAL=~/.config/configureplus/.configureplus/doc/$VARFILE_BASE

	DOCFILE=$DOCFILE_GLOBAL

	echo_local_level 2 DOCFILE=$DOCFILE


	
	if [ -f $DOCFILE ]; then

	    >&2 printf "     - %-90s [%s]\n" "$VARFILE = '$(cat $VARFILE)'" "$(cat $DOCFILE)" 

	else

    	    >&2 echo   "     - $VARFILE = "`cat $VARFILE`
	fi

    done
}


# mk

function configureplus_generate_configure_global_mk
{
    echo >$CONFIGUREPLUS_DIR_OUT/global.mk

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT/global.mk
    echo "# Note: space before a comment are part of a variable" >>$CONFIGUREPLUS_DIR_OUT/global.mk

    echo >>$CONFIGUREPLUS_DIR_OUT/global.mk

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT/global/
    
    for VARFILE in $(find ${FIND_DIR}* -type f); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "%s# %s\n" "$VARFILE_KEY=\$(shell cat $VARFILE)" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT/global.mk

	else

	    echo "$VARFILE_KEY=\$(shell cat $VARFILE)" >>$CONFIGUREPLUS_DIR_OUT/global.mk
	fi

    done

    echo "   " $CONFIGUREPLUS_DIR_OUT/global.mk generated
}

function configureplus_generate_configure_session_mk
{
    echo >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk
    echo "# Note: space before a comment are part of a variable" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk

    echo >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/
    
    for VARFILE in $(find ${FIND_DIR}* -type f|sort); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}


	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "%s# %s\n" "$VARFILE_KEY=\$(shell cat $VARFILE)" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk

	else

	    echo "$VARFILE_KEY=\$(shell cat $VARFILE)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk
	fi

    done

    echo "   " $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.mk generated
}

function configureplus_generate_configure_global_bash
{
    echo >$CONFIGUREPLUS_DIR_OUT/global.bash

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT/global.bash

    echo >>$CONFIGUREPLUS_DIR_OUT/global.bash

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT/global/
    
    for VARFILE in $(find ${FIND_DIR}* -type f); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}


	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        	echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "export %-85s # %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT/global.bash

	else

	    printf "export %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" >>$CONFIGUREPLUS_DIR_OUT/global.bash
	fi

    done

    echo "   " $CONFIGUREPLUS_DIR_OUT/global.bash generated
}



function configureplus_generate_configure_global_bash_local
{
    echo >$CONFIGUREPLUS_DIR_OUT/global.bash_local

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT/global.bash_local

    echo >>$CONFIGUREPLUS_DIR_OUT/global.bash_local

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT/global/
    
    for VARFILE in $(find ${FIND_DIR}* -type f); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}
        
	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        	echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "%-85s # %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT/global.bash_local

	else

	    printf "%s\n" "$VARFILE_KEY='$(cat $VARFILE)'" >>$CONFIGUREPLUS_DIR_OUT/global.bash_local
	fi

    done

    echo "   " $CONFIGUREPLUS_DIR_OUT/global.bash_local generated
}

function configureplus_generate_configure_global_json
{
    echo >$CONFIGUREPLUS_DIR_OUT/global.json

    # JSON does not support comments
    #    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo "[" >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo "  {" >>$CONFIGUREPLUS_DIR_OUT/global.json


    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT/global/
    
    local ARRAY=( $(find ${FIND_DIR}* -type f) )

    local ARRAY_LEN=${#ARRAY[@]}

    local CNT=1

    for VARFILE in ${ARRAY[@]}; do

	local BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}
        
        COMMA=

        if [[ $CNT < $ARRAY_LEN ]]; then

            COMMA=,
            
        fi

	printf -v VAR '   "%s" : "%s"%s'  $VARFILE_KEY "$(cat $VARFILE)" $COMMA

        echo "$VAR"  >>$CONFIGUREPLUS_DIR_OUT/global.json

	let CNT=$CNT+1
        
    done

    echo "  }" >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo "]" >>$CONFIGUREPLUS_DIR_OUT/global.json

    echo "   " $CONFIGUREPLUS_DIR_OUT/global.json generated
}





# session

function configureplus_generate_configure_session_bash
{
    echo >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash

    echo >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/
    
    for VARFILE in $(find ${FIND_DIR}* -type f|sort); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

        echo_local_level 2 configureplus_generate_configure_session_bash - VARFILE_KEY=$VARFILE_KEY
        
	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        	echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "export %-85s # %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash

	else

	    printf "export %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash
	fi
        
    done

    echo "   " $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash generated
}

function configureplus_generate_configure_session_bash_local
{
    echo >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local

    echo "# Generated with configureplus (CONFIGUREPLUS_VERSION=$CONFIGUREPLUS_VERSION, CONFIGUREPLUS_PWD=$CONFIGUREPLUS_PWD)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local

    echo >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/
    
    for VARFILE in $(find ${FIND_DIR}* -type f|sort); do

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

	DOCFILE=$CONFIGUREPLUS_DIR_OUT/doc/$VARFILE_BASE

        #echo_local_level 2 $VARFILE .... ENTRY
	echo_local_level 2 DOCFILE=$DOCFILE

	if [ -f $DOCFILE ]; then

	    printf "%-85s # %s\n" "$VARFILE_KEY='$(cat $VARFILE)'" "$(cat $DOCFILE)" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local

	else

	    printf "%s\n" "$VARFILE_KEY='$(cat $VARFILE)'" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local
	fi

    done

    echo "   " $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.bash_local generated
}

function configureplus_generate_configure_session_json
{
    echo >$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo "[" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo "  {" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    local FIND_DIR=$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/

    echo_local_level 2 configureplus_generate_configure_session_json - FIND_DIR=$FIND_DIR

    local ARRAY=($(find ${FIND_DIR}* -type f|sort))

    local ARRAY_LEN=${#ARRAY[@]}

    local CNT=1

    for VARFILE in ${ARRAY[@]}; do

        echo_local_level 2 configureplus_generate_configure_session_json - VARFILE=$VARFILE

	BASENAME=$(basename $VARFILE)

        VARFILE_BASE=${VARFILE#$FIND_DIR}

        VARFILE_KEY=${VARFILE_BASE//\//_}

        echo_local_level 2 configureplus_generate_configure_session_json - VARFILE_KEY=$VARFILE_KEY

        COMMA=

        #        echo CNT=$CNT ARRAY_LEN=$ARRAY_LEN
        
        if [[ $CNT -lt $ARRAY_LEN ]]; then

            COMMA=,
            
        fi

	printf -v VAR '   "%s" : "%s"%s'  $VARFILE_KEY "$(cat $VARFILE)" $COMMA

        echo "$VAR"  >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

	let CNT=$CNT+1

    done

    echo >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo "  }" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo "]" >>$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json

    echo "   " $CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION.json generated
}

# main

function configureplus_generate 
{
    echo_local_level 2 configureplus_generate ..

    local target_dir="$CONFIGUREPLUS_DIR_OUT"

    if [ "$CONFIGUREPLUS_OPTION_FLAG_GLOBAL" = true ]; then

        target_dir="$CONFIGUREPLUS_DIR_CONFIG/"

        cd $target_dir

        echo_local_level 2 Detected CONFIGUREPLUS_OPTION_FLAG_GLOBAL, switched to PWD=$PWD

    fi

    echo_local_level 2 configureplus_generate show summary..
    
    configureplus_summary
    
    echo "Generating configuration in $target_dir"

    # Call your existing generation functions here
    configureplus_generate_configure_global_mk
    configureplus_generate_configure_global_bash
    configureplus_generate_configure_global_bash_local
    configureplus_generate_configure_global_json
    configureplus_generate_configure_session_mk
    configureplus_generate_configure_session_bash
    configureplus_generate_configure_session_bash_local
    configureplus_generate_configure_session_json

    echo_local_level 2 configureplus_generate .. done

    echo "Configuration generated successfully"
}




function configureplus_setup
{
    echo_local_level 2 configureplus_setup ..
    
    configureplus_dir_config_setup

    configureplus_session_identify

    configureplus_session_directory_setup

    configureplus_dynamic_source

    configureplus_globalvars_setup

    echo_local_level 2 configureplus_setup .. done
}


function configureplus_setup_bootstrap
{
    echo_local_level 2 configureplus_setup_bootstrap - CONFIGUREPLUS_DEBUG=$CONFIGUREPLUS_DEBUG 

    echo_local_level 2 configureplus_setup_bootstrap - Checking ${CONFIGUREPLUS_DIR_CONFIG_FULL}/


    if [ ! -d "$CONFIGUREPLUS_DIR_CONFIG_FULL" ]; then

        export CONFIGUREPLUS_DIR_CONFIG_FULL_EMPTY=1

        error_local "configureplus_dir_config_setup - could not find $CONFIGUREPLUS_DIR_CONFIG_FULL"

        exit 10
    fi




    echo_local_level 2 configureplus_setup_bootstrap - Checking standard files 'dynamic.bash' is present, and currentsession.{mk,bash} is uptodate

    local REQUIRED_DIRS=( global global/CONFIGURE global/CONFIGUREPLUS ) # dont put 'session' here, it is handled somewhere else

    echo_local REQUIRED_DIRS="${REQUIRED_DIRS[@]}"

    for DIR in "${REQUIRED_DIRS[@]}"; do

        echo_local DIR="$DIR"

        if [ ! -d "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$DIR" ]; then

            error_local "configureplus_dir_config_setup - could not find *required* DIR=$DIR in ${CONFIGUREPLUS_DIR_CONFIG_FULL}"

            exit 5
        fi

        if [ ! -d "${CONFIGUREPLUS_DIR_OUT}/$DIR" ]; then

            error_local "configureplus_dir_config_setup - create/fill *required* DIR=$DIR in ${CONFIGUREPLUS_DIR_OUT}"

            echo_local_level 2 COMMAND: rsync -ru "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$DIR" $(dirname "${CONFIGUREPLUS_DIR_OUT}/$DIR")

            rsync -ru "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$DIR" $(dirname "${CONFIGUREPLUS_DIR_OUT}/$DIR")

            if [ ! -d "${CONFIGUREPLUS_DIR_OUT}/$DIR" ]; then

                error_local "configureplus_dir_config_setup - could not setup *required* DIR=$DIR in ${CONFIGUREPLUS_DIR_OUT}"

                exit 6
            fi
        fi

    done
        
    local REQUIRED_FILES=( "dynamic.bash" "currentsession.mk" "currentsession.bash" )

    echo_local REQUIRED_FILES="${REQUIRED_FILES[@]}"

    local FILES_DIR=.configurelplus

    for FILE in "${REQUIRED_FILES[@]}"; do

        echo_local FILE="$FILE"

        if [ ! -f "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$FILE" ]; then

            error_local "configureplus_dir_config_setup - could not find *required* FILE=$FILE in ${CONFIGUREPLUS_DIR_CONFIG_FULL}"

            exit 10
        fi

        if [ ! -f "${CONFIGUREPLUS_DIR_OUT}/$FILE" ]; then

            warn_local "configureplus_dir_config_setup - could not find *required* FILE=${CONFIGUREPLUS_DIR_OUT}/$FILE"

            echo COMMAND: cp "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$FILE" "${CONFIGUREPLUS_DIR_OUT}/$FILE"

            cp "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$FILE" "${CONFIGUREPLUS_DIR_OUT}/$FILE"

            if [ ! -f "${CONFIGUREPLUS_DIR_CONFIG_FULL}/$FILE" ]; then

                error_local "configureplus_dir_config_setup - could not setup *required* FILE=$FILE in ${CONFIGUREPLUS_DIR_OUT} (from ${CONFIGUREPLUS_DIR_CONFIG_FULL})"

                exit 20
            fi

        fi

    done


    echo_local_level 2 configureplus_setup_bootstrap - configureplus_dir_config_setup
    
    configureplus_dir_config_setup

    echo_local_level 2 configureplus_setup_bootstrap - configureplus_session_identify ..

    configureplus_session_identify

    echo_local_level 2 configureplus_setup_bootstrap - configureplus_session_directory_setup ..

    configureplus_session_directory_setup

    echo_local_level 2 configureplus_setup_bootstrap - configureplus_globalvars_setup ..

    configureplus_globalvars_setup

}



function join_array_comma
{
    local SEP=$1

    shift
    
    local ARRAY=$@
    
    ARRAY_LEN=${#ARRAY[@]}

#    echo ARRAY="${ARRAY[@]} .."
    
#    echo ARRAY_LEN=$ARRAY_LEN

    CNT=1

    RESULT=()

    for ENTRY in ${ARRAY[@]}; do

        COMMA=

        if [[ $CNT -lt $ARRAY_LEN ]]; then

            COMMA=,
            
        fi

	printf -v VAR '%s%s' $ENTRY $COMMA

        echo "VAR=$VAR"
        
        RESULT=("${RESULT[@]}" $VAR)
                
	let CNT=$CNT+1

    done

    echo ${RESULT[@]}
}

#test
#join_array_comma ",\n" "ALPHA : 1" "BETA : 2" "GAMMA : 3"
