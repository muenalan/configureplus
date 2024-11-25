#!/bin/bash

function bt_run_documentation()
{
    
cat <<-'UNTIL_HERE'

configureplus basic tests

UNTIL_HERE

}

#bt_run_documentation

source $BT_OPT_DIR/btest.bash

env|grep BT_|sort


TMPDIR=/tmp/configureplus-temp-testfolder/dir-$RANDOM

if [[ -d "$TMPDIR" ]]; then

    zip -rm9 $(basename ${TMPDIR}.zip) "$TMPDIR"

fi


bt_begin 01_create_tempfolder 1 "1. Create temparary folder $TMPDIR"

  bt_declare "1. Makedir $TMPDIR"

  mkdir -p "$TMPDIR"
  
  bt_ok_if [ -d "$TMPDIR" ]

bt_end


  
bt_begin 02_call_configureplus_1st 1 "2. In temporary folder, call 1st time configureplus"

  bt_declare "Cd to $TMPDIR, then call configureplus"

  cd $TMPDIR

  configureplus
  
  bt_ok_if [ -d ".configureplus" ]
  
bt_end


bt_begin 03_call_configureplus_2nd 1 "3. In temporary folder, call 2nd time configureplus"

  bt_declare "Cd to $TMPDIR, then call configureplus"

  cd $TMPDIR

  configureplus

  bt_ok_if [ -d ".configureplus" ]

bt_end



bt_begin 04_set_simple_value 1 "4. In temporary folder, set simple variables"

  bt_declare "Set ALPHA 123"

  configureplus set ALPHA 123

  bt_ok_if [ "$(configureplus get ALPHA)" == "123" ]

bt_end
  


bt_begin 04_set_complex_value 1 "4. In temporary folder, set complex variable"

  bt_declare "Set META/ALPHA 888"

  configureplus set META/ALPHA 888

  bt_ok_if [ "$(configureplus get META/ALPHA)" == "888" ]

bt_end
  


bt_begin 05_add_variable_to_array 1 "5. Add variable to array"

  bt_declare "Add BETA aaa"

  configureplus add BETA aaa

  RESULT=$(configureplus get BETA)

  echo RESULT="$RESULT"
  
  bt_ok_if [[ "$(configureplus get BETA)" = *":aaa" ]]

bt_end


