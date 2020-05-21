#!/bin/bash

	red=`tput setaf 1`
	green=`tput setaf 2`
	reset=`tput sgr0`
    
    username=`osascript -e "long user name of (system info)"`
    echo "Hello...${green}$username,${reset}"
    echo "\n"
read -p "Choose environment you want to launch/use EMR cluster ? ${red}prod${reset}/${green}dev${reset} " env
echo "\n"

case $env in

	 prod)
     echo "${red}You have choosen production environment${reset}\n"
	 echo "${red}Note:${green}Please make sure you have below prerequisits ${reset}\n"
	 echo "${red}1. Install jq on your laptop.${reset} You can install by brew install jq \n"
	 echo "${red}2. prodvpc is connected${reset} \n"
	 echo "${red}3. Latest awscli is installed${reset}. You can install awscli using brew install awscli or run brew update \n"


     USERNAME=sandeepb
	 mkdir -p ~/.aws
	 security delete-internet-password -l "git-codecommit.us-east-1.amazonaws.com" ~/Library/Keychains/login.keychain-db -q

	 echo "\nDownloading temporary AWS credentials..waiting for ${red}5${reset} seconds\n"
	 ssh ${USERNAME}@assume-role.data.insideview.com "touch /var/tmp/users/`whoami` ; sleep 1"
	 scp ${USERNAME}@assume-role.data.insideview.com:./credentials ~/.aws/  
	 #scp ${USERNAME}@assume-role.data.insideview.com:./aws-console-login-url.txt ~/
     rm -rf create_cluster_prod_local.sh
     aws s3 cp s3://ivops-prod-emr-dp/create_cluster_prod_local.sh . --force --quiet --region us-east-1
     sh create_cluster_prod_local.sh
     ;;

	 dev)
	 echo "${red}You have choosen development environment${reset}\n"
	 echo "${red}Note:${green}Please make sure you have below prerequisits ${reset}\n"
	 echo "${red}1. Install jq on your laptop.${reset} You can install by brew install jq \n"
	 echo "${red}2. DevVPN is connected${reset} \n"
	 echo "${red}3. Latest awscli is installed${reset}. You can install awscli using brew install awscli or run brew update \n"

	 USERNAME=sandeepb
	 mkdir -p ~/.aws
	 security delete-internet-password -l "git-codecommit.us-east-1.amazonaws.com" ~/Library/Keychains/login.keychain-db -q
	 echo "\nDownloading temporary AWS credentials..waiting for ${red}5${reset} seconds\n"
	 ssh ${USERNAME}@assume-role.dev.insideview.com "touch /var/tmp/users/`whoami` ; sleep 1"
	 scp ${USERNAME}@assume-role.dev.insideview.com:./credentials ~/.aws/
	 #scp ${USERNAME}@assume-role.dev.insideview.com:./aws-console-login-url.txt ~/
	 rm -rf create_cluster_dev_local.sh
	 aws s3 cp s3://ivops-emr-dp/create_cluster_dev_local.sh . --force --quiet --region us-east-1
     sh create_cluster_dev_local.sh
	 ;;

	 *)
     echo "${red}your choice does not match any so exiting script ${reset}\n"
	 exit 0
	 ;;
esac