#!/bin/bash

#help text
usage="==============OVERVIEW==============
script for automating making the analysis file,
given a design id.
-h  show this help text
-d  The design ID of the microarray
-w  The wavelength at which you ran the microarray
-r  array name [e.g.'array_7']
-f  The image file you wish to analyze. full path is not required currently,
    as the script assumes a set file structure
-a  name of the output analysis file. assumed to be written under
    /..../make_analysis_file/
-p  project name. e.g. CASCADE, CoRec. project name is child directory of
    whatever you set the rootdir variable to be in sourcefile.sh

Example Command:
> ./make_analysis_auto.sh -d 085605 -w 488 -f 258560510001_G400_488_1-8.gpr -a hellyeah_demo.txt -r array7 -p CASCADE
============================
"
source sourcefile.sh

#parsing out the parameters
while getopts ":hd:p:r:w:f:a:" opt; do
	case $opt in
		h)echo "${usage}"
		  exit
		;;
		d) design_id="$OPTARG"
		;;
		w) wave="$OPTARG"
		;;
		f) imagefile="$OPTARG"
		;;
		a) outfile="$OPTARG"
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

#============Initializing directory name variables for downstream usage============
design_dir="${rootdir}${project}/${design_id}"
#where the image file will be expected to exist in
gprimagefile_dir="${GPR_DIR}${project}/${design_id}/${array}/${wave}/"
#where to put the make_analysis_file.com file along with other possible analyses
makeanalysisfile_dir="${design_dir}/make_analysis_file/"
dotcomfile="${makeanalysisfile_dir}make_analysis_file.com"
#output of creating the analysis file
analysisoutput_file="${makeanalysisfile_dir}${outfile}"
zipdir="${design_dir}/zip_contents/"
mkdir -p "${zipdir}"
zipfile="${design_dir}/${design_id}.zip"
#============End directory variable initialization============

#============Quality Checking/Unpacking Contents============
#checking length of design id. 
#right now it's artificially set to be at character length 6, given previous inputs
d_len=${#design_id}
if [ "$d_len" !=  "6" ] 
then
		echo "ERROR; Design ID not specified or insufficient length"
		exit

else
	if [ ! -d "${design_dir}" ]
		then
			echo "ERROR: Design ID ${design_id} does not have a directory. did you perhaps mistype and/or forget to download its zip file?"
			echo "looking in: ${design_dir}"
			exit
	else
		echo "===========Running Analysis on Design ID ${design_id}==========="
	fi
fi

#unzip the design's zip file accordingly
echo "* Unzipping ${design_id}.zip into ${design_dir}/zip_contents (will make dir if it doesn't exist already)
----------------------------------------------------------"

#check if the zip file exists in the first place in the appropriate directory
if [ -f $zipfile ]; then
	unzip "${design_dir}/${design_id}.zip" -d "${zipdir}"
else
	echo "ERROR: zipfile is not residing in appropriate directory(${design_dir})"
	echo "zipfile path input: ${zipfile}"
	echo "Make sure you downloaded the zip file from https://earray.chem.agilent.com/suredesign/ .
		Contact your administrator if you cannot access this site"
	echo "'Find Designs'>CGH>My Designs>[find your ID]"
	exit	
fi
#============End Quality Checking/Unpacking Contents============

#============Making and Running make_analysis_file============
echo "If it doesn't exist already, making 'make_analysis_file' directory under ${design_id}
----------------------------------------------------------"
mkdir -p "${design_dir}/make_analysis_file"
echo "writing the make_analysis_file.com contents"
echo "
perl ${perldir}PBM/make_PBM_analysis_file.pl
-i ${zipdir}*_${design_id}_D_DNAFront_BCBottom_*.tdt
-j ${zipdir}*_${design_id}_D_SequenceList_*.txt
-g ${gprimagefile_dir}${imagefile}
" > ${dotcomfile}
echo "running this bad boi"
echo "Writing analysis file as ${analysisoutput_file}"
perl "${perldir}/MISC/run_comfile_alert.pl" -com $dotcomfile > "${analysisoutput_file}"
#============END Making and Running make_analysis_file============

