#!/bin/bash

#help text
usage="==============OVERVIEW==============
script for automating making the analysis file,
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


declare -A list_prefixes=( [o1o2top_br_]="br" [or_]="or" [o_]="o" [o1match_r_]="o1"  [o2match_r_]="o2" )
thedate=$(date +%m%d%Y)
 
for x in "${!list_prefixes[@]}"; 
do 
	#echo "$x";
	#echo "${list_prefixes[$x]}";
	
	ls -1 ${gpmdir}/${x}* > "${gpmdir}/${list_prefixes[$x]}_gpr.list"
	#echo "${gpmir}/make_datamatrix_${list_prefixes[$x]}.com"
	echo -e "perl ${perldir}GENEPIX/control_sequence_process.pl
-l ${gpmdir}/${list_prefixes[$x]}_gpr.list
-o ${gpmdir}/ENH_CASCADE_data_matrix_${list_prefixes[$x]}_${thedate}.dat
" > "${gpmdir}/make_datamatrix_${list_prefixes[$x]}.com"
#echo "${gpmdir} && Perl ${perldir}MISC/run_comfile_alert.pl -com make_datamatrix_${list_prefixes[$x]}.com -qsub ${list_prefixes[$x]}"
(cd ${gpmdir} && perl ${perldir}MISC/run_comfile_alert.pl -com make_datamatrix_${list_prefixes[$x]}.com -qsub ${list_prefixes[$x]})
done

