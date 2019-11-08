#!/bin/bash

autoscript_dir="/projectnb/siggers/data/callen_project/test_pipeline/scripts/"
set_gpr_dir() {
	read -p "Please specify the root directory of gpr files: `echo $'\n> '`" gpr_dir
	if [ ! -d "${gpr_dir}" ]; then
		printf "${gpr_dir} does not exist. Try again, or make the directory.\n"
		return 1
	else
		echo  "OK. setting gpr directory[GPR_DIR] as ${gpr_dir} "
		export GPR_DIR="${autoscript_dir}${gpr_dir}"
		source_file="${autoscript_dir}sourcefile.sh"
		touch "${source_file}"
		echo "export GPR_DIR='${gpr_dir}'">>${source_file}
		source ${source_file}
		return 0
	fi
}

confirm_gpr_dir() {

	read -p "Are you sure you want to set ${gpr_dir} as your gpr directory(yes/no)?" gpr_confirm
	case ${gpr_confirm,,} in
		y|yes) 
			echo "OK. Setting gpr directory as $gpr_dir for this session"
	   		export GPR_DIR="${gpr_dir}"
	   		return 1
		;;
		n|no)
			echo "Exiting make_analysis_auto_config without setting gpr directory"
	    		return 1
        	;;
		*) echo "Please enter y[yes] or n[no]"
		   return 0
	esac
}


until set_gpr_dir; do : ; source "${autoscript_dir}sourcefile.sh";  done
