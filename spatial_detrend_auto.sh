#!/bin/bash


#I'll write the help text later

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
scriptdir="/projectnb/siggers/data/callen_project/test_pipeline/scripts"
source ${scriptdir}/sourcefile.sh

#create local session variables
source /projectnb/siggers/data/callen_project/test_pipeline/scripts/sourcefile.sh
cd ${testdir}${project}/${design_id}/${array}/${wave}/
ls madj_*.gpr > ${testdir}${project}/${design_id}/${array}/${wave}/madj_gpr.list

## create process_custom_probes.com file based on user inputs
echo -e "perl ${perldir}GENEPIX/gpr_file_process_conc_series.pl
-i ${testdir}${project}/${design_id}/${array}/${wave}/madj_gpr.list
-a ${testdir}${project}/${design_id}/make_analysis_file/demo_sep17.txt
-keep_ctrl
-output_norm_files
-o norm
-f1med\n"> ${testdir}/${project}/${design_id}/make_analysis_file/process_custom_probes.com

#relative ree
#echo -e "perl ${perldir}GENEPIX/gpr_file_process_conc_series.pl
#-i madj_gpr.list
#-a ${testdir}${project}/${design_id}/make_analysis_file/demo_sep17.txt
##-keep_ctrl
#-output_norm_files
#-o norm
#-f1med\n"> ${testdir}/${project}/${design_id}/make_analysis_file/process_custom_probes.com



#echo "cd ${testdir}/${project}/${design_id}/make_analysis_file/"
(cd ${testdir}${project}/${design_id}/${array}/${wave}/ && perl ${perldir}MISC/run_comfile_alert.pl -com ${testdir}${project}/${design_id}/make_analysis_file/process_custom_probes.com -qsub hellyeah) 
