#!/usr/bin/env bash 
#The following describes the steps to deploy a jar application.

ERROR="\e[0;31m"
ENDERROR="\e[m"
option_1=$1
option_2=$2
if [ -z ${option_2:+x} ]; then
    #taking the format `alias path/to/file.jar`
    location=$(dirname ${option_1})
    jarfilename=$(basename ${option_1})
else
    # taking the format `alias [options] path/to/file.jar`
    undeploy=${option_1}
    location=$(dirname ${option_2})
    jarfilename=$(basename ${option_2})
fi
echo "location ${location} jarfilename ${jarfilename}"

if true; then
	#second parameter not present, check if first parameter is present
	#echo "reading first param only"
	if [ -z ${jarfilename:+x} ]; then
		>&2 echo -e "${ERROR}jar file not found:- applications in current dir include${ENDERROR}"
		find ${location}/*.jar -type f -printf "%f\n"
	
	else
		search=$(find ${location} -maxdepth 1 -type f -name $jarfilename -printf "%f")
		DEPLOYAPP=false
		if [ -z ${search:+x} ]; then
        		>&2 echo -e "${ERROR}jar file not found:- applications in current dir include${ENDERROR}"
        		find ${location}/*.jar -type f -printf "%f\n"
        	
		else
			PID=$(pgrep -a java | grep ${search} | awk '{ print $1 }')
			if [ -z ${PID:+x} ]; then
				echo -e "Found undeployed application ${ERROR}${search}${ENDERROR}"
				DEPLOYAPP=true
			else
				PORT=$(ss -l -p -n | grep ${PID} | awk '{print $5}' | sed  's/[^0-9]*//g')
                        	echo -e "Found application ${ERROR}${search}${ENDERROR} process id ${ERROR}${PID}${ENDERROR} running on Port ${ERROR}${PORT}${ENDERROR}"
				##kill running application
				echo -e "${ERROR}To proceed, kill running process to free up port${ENDERROR}"
				if [ ${undeploy} == "undeploy" ]; then
					response="y"
				else
					read -p "Are you sure? [Y/N] " response
				fi
				case $response in [yY][eE][sS]|[yY])
					echo -e "${ERROR}Killing PID ${PID}${ENDERROR}"
					DEPLOYAPP=true
					kill -9 ${PID}
					#echo "Application ${search} undeployed...creating application backup"
					#datevalue=$(date +%d%B%Y_%H:%M:%S)
					#sudo cp $PWD/${search} $PWD/backups/${search}.bak.${datevalue}
					;;
					*)
					echo "Deployment aborted"
					;;
				esac
			fi
			if [ ${DEPLOYAPP} = true ]; then
				cd ${location}
				echo -e "Deploying application $PWD/${search}"
				nohup nice java -jar $PWD/${search} &
				sleep 5 & NEWPID=$!
				echo "Retrieving deployment status for ${NEWPID}"
				wait $NEWPID
				echo $?
				echo "Check log files for deployment status"
				exit
			else
				echo "Process finished without errors"
			fi
		fi
	fi
else 
	#second parameter is present, different action configured
	#echo "reading first and second param"
	if [ ${action} = "undeploy" ]; then
		if [ -z ${jarfilename:+x} ]; then
                	>&2 echo -e "${ERROR}jar file not found:- applications in current dir include${ENDERROR}"
        	        find $PWD/*.jar -type f -printf "%f\n"

	        else
                	search=$(find $PWD  -maxdepth 1 -type f -name $jarfilename -printf "%f")
        	        DEPLOYAPP=false
	                if [ -z ${search:+x} ]; then
                        	>&2 echo -e "${ERROR}jar file not found:- applications in current dir include${ENDERROR}"
                	        find $PWD/*.jar -type f -printf "%f\n"

        	        else
	                        PID=$(pgrep -a java | grep ${search} | awk '{ print $1 }')
                        	if [ -z ${PID:+x} ]; then
                	                echo -e "Application ${ERROR}${search}${ENDERROR} is not running"
        	                        DEPLOYAPP=true
	                        else
                                	PORT=$(ss -l -p -n | grep ${PID} | awk '{print $5}' | sed  's/[^0-9]*//g')
                        	        echo -e "Found application ${ERROR}${search}${ENDERROR} process id ${ERROR}${PID}${ENDERROR} running on Port ${ERROR}${PORT}${ENDERROR}"
                	                ##kill running application
        	                        echo -e "${ERROR}To proceed, kill running process to free up port${ENDERROR}"
	                                read -p "Are you sure? [Y/N]" response
                                	case $response in [yY][eE][sS]|[yY])
                                        	echo -e "${ERROR}Killing PID ${PID}${ENDERROR}"
                                        	DEPLOYAPP=true
                                        	kill -9 ${PID}
                                        	#echo "Application ${search} undeployed..."
                                        	;;
                                        	*)
                                        	echo "Process aborted"
                                        	;;
                                	esac
                        	fi                                        
                	fi
        	fi
	else
		echo -e "${ERROR}Invalid command ${action}${ENDERROR}"
	fi	
fi
