#!/bin/bash

#help text
usage="==============OVERVIEW==============
script for automating the averaging process,
given a design id.
-h  show this help text
-d  The design ID of the microarray
-w  The wavelength at which you ran the microarray
-r  array name [e.g.'array_7']
-p  project name. e.g. CASCADE, CoRec. project name is child directory of
    whatever you set the rootdir variable to be in sourcefile.sh
-i  Image tag name. only the first few characters will do
Example Command:
> ./averaging_auto.sh -p CASCADE -d 085605 -r array7 -w 488 
============================
"
#would be best to use some environment variable 
#denoting a script directory path here. This file is 
#required for downstream use
source ./sourcefile.sh

#parsing out the parameters
while getopts ":hd:p:r:w:g:" opt; do
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
                \?) printf "Wait, that's illegal.\n\n\n\n"
                    echo "$usage"
                    exit
        esac
done

#placeholder
gpmdir=${testdir}${project}/${design_id}/${array}/${wave}

declare -a avg_types=( "or" "r" "o" "br" )
ls -1 ${gpmdir}/norm_madj_*.gpr > ${gpmdir}/norm_gpr.list
for g in "${avg_types[@]}"
	do
		filename="${g}_average_probes.com"
echo -e "perl ${perldir}GENEPIX/average_replicate_rc_custom_probes.pl 

-l norm_gpr.list 
-op ${g} 
-avg ${g} 
no_gfilter" > ${gpmdir}/${filename}

chmod +x ${gpmdir}/${filename}
#for qsub
(cd ${gpmdir} && perl ${perldir}MISC/run_comfile_alert.pl -com ${filename} -qsub "avg")
#(cd ${gpmdir} && perl ${perldir}MISC/run_comfile_alert.pl -com ${filename})
done




