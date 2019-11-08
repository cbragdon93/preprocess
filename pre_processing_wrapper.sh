#!/bin/bash

usage="==============OVERVIEW==============
Primary Wrapper script for the pre-processing pipeline for microarrays
-h  show this help text
-d  The design ID of the microarray
-w  The wavelength at which you ran the microarray
-r  array name [e.g.'array_7']
-p  project name. e.g. CASCADE, CoRec. project name is child directory of
    whatever you set the rootdir variable to be in sourcefile.sh
-i  Image tag name. only the first few characters will do
Example Command:
> ./masliner_auto.sh -p CASCADE -d 085605 -r array7 -w 488 -i 25 -g 1-8
============================
"
source sourcefile.sh
#Make sure all the required shell scripts are in the desired scripts directory
#specified in sourcefile.sh



#parsing out the parameters
while getopts ":hd:p:r:w:i:g:" opt; do
        case $opt in
                h) echo "${usage}"
                   exit
                ;;
                d) design_id="$OPTARG"
                ;;
                w) wave="$OPTARG"
                ;;
                r) array="$OPTARG"
                ;;
                p) project="$OPTARG"
		;;
		i) imagetag="$OPTARG"
		;;
                \?) printf "Wait, that's illegal.\n\n\n\n"
                    echo "$usage"
                    exit
	esac
done


declare -a shell_scripts=( "masliner_auto.sh"  "spatial_detrend_auto.sh" "averaging_auto.sh" "data_matrix_auto.sh" )
declare -a not_executable


#check if required shell scripts exist/are executable
echo "Checking  status of required scripts"
for f in ${shell_scripts[@]}
do
	if [[ ! -x "${autoscript_dir}$f" ]]
		then
			not_executable+=( "$f" )
		else
			continue
	fi
done
echo
if [ ! ${#not_executable[@]} -eq 0  ]
	then
		echo "${#not_executable[@]} file(s) are not executable or do not exist in ${autoscript_dir}"
		for  f in ${not_executable[@]} 
		do
			echo "$f"
		done
		echo "please run 'chmod +x [files]' before you continue,"
		echo "or move the appropriate files to ${autoscript_dir}. "
		echo "If you do not have permissions, ask your administrator."
		exit 1		
	else
		echo "All required files exist and are executable"
fi



${autoscript_dir}masliner_auto.sh -d ${design_id} -r ${array} -w ${wave} -i ${imagetag} -p ${project}
 




