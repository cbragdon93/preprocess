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
> ./masliner_auto.sh -p CASCADE -d 085605 -r array7 -w 488 -i 25 -g 1-8
============================
"
source /projectnb/siggers/data/callen_project/test_pipeline/scripts/sourcefile.sh

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
                \?) printf "Wait, that's illegal.\n\n"
                    echo "$usage"
                    exit
	esac
done

if [ ${wave} = "647" ]; then
	perl ${perldir}GENEPIX/change_fluor.pl -i gpr.list
	${wave}="488"
fi

wavecheck=${testdir}/${project}/${design_id}/${array}/${wave}
mkdir -p ${wavecheck}
cd ${wavecheck}
desc_file="${wavecheck}/experiment_description.txt"

expdesc_header="###Experiment Description###
#PROJECT: ${project}
#DESIGN: ${design_id}
#ARRAY: ${array}
#WAVELENGTH: ${wave}
#-----------------------------------------------"

for i in {1..8}
	do	
description_header="#-----------------------------------------------
#WELL NUMBER: ${i}
Pbm=1
Concentration=100
Cy3=FOO\n\n"
	expdesc_list=$(ls -1 ${imagetag}*_${wave}*${i}-8*)
	if [ ! -f ${desc_file} ]; 
		then
			touch ${desc_file}
			echo -e "${expdesc_header}\n" >> ${desc_file}
	fi
        echo -e "${description_header}\n${expdesc_list}\n" >> ${desc_file}
done

perl ${perldir}GENEPIX/masliner_list.pl -i ${desc_file}
#perl ${perldir}MISC/run_comfile_alert.pl -com masliner.com -qsub masliner.com
