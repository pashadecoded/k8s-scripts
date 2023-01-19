#!/bin/bash

get_logs(){
        local blue=`tput setaf 4`
        local green=`tput setaf 2`
        local red=`tput setaf 1`
        local magenta=`tput setaf 5`
        local reset=`tput sgr0`
        # Get current date
        today=Logs@$(date +"%F#%T")
        # Get the namespace name
        namespace=<Name-Space>
        # Create a directory to store the logs with the current date
        mkdir -p $today
        # Get a list of all deployments in the specified namespace
        deployments=$(kubectl get deployments -n $namespace -o jsonpath=‘{.items[*].metadata.name}‘)
        pods=$(kubectl get pods -n $namespace -o jsonpath=‘{.items[*].metadata.name}‘)
        # Loop through the deployments
        echo -e "${red}#############################################${reset}"
        echo -e "${green}\nCollecting Logs from all the available pods."
        echo -e "\nFrom Namespace: $namespace"
        echo -e "\nPlease wait.\n${reset}"
        #echo -e "${red}#############################################${reset}"
        for pod in $pods; do
        # Get the logs for the deployment and save to a file
        kubectl logs $pod --all-containers=true -n $namespace > $today/$pod.log 2>>$today/err.log
        done
}

install_zip(){

        if dpkg-query -W -f='${Status}' zip 2>/dev/null | grep -q "ok installed"; then
        # echo "zip is already installed"
        :
        else
        # Install zip
                sudo apt-get update >/dev/null 2>&1
                sudo apt-get install -y zip >/dev/null 2>&1
        # echo "zip has been installed"
        fi

}

log_zip(){

        local blue=`tput setaf 4`
        local green=`tput setaf 2`
        local red=`tput setaf 1`
        local magenta=`tput setaf 5`
        local reset=`tput sgr0`
        zip -r -1 -9 -q $today.zip $today
        echo -e "${green}Done.\n${reset}"
        echo -e "${red}#############################################${reset}"
}

get_logs
install_zip
log_zip