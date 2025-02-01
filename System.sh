#! /bin/bash

sudo apt install lolcat -y

# display system information #

show_system_info() {
	echo
	echo "System Information : " | lolcat
	echo "--------------------" 
	echo
	echo "Hostname -> $(hostname)" | lolcat
	echo
	echo "Uptime -> $(uptime -p)" | lolcat
	echo
	echo "Packages -> $(dpkg --list | wc -l)" | lolcat
	echo
	echo "Kernel Version -> $(uname -r)" | lolcat
	echo
	echo "Operating System -> $(lsb_release -d | cut -f2)" | lolcat
	echo
}

# list running services #

list_services() {
	echo
	echo "Running Services List : " | lolcat
	echo "-----------------------"
	echo
	sudo systemctl list-units --type=service --state=running
	echo
	sleep 1
}
	echo "--------------------" | lolcat

# start / stop / restart services #

manage_service() {
	echo
	echo "Available Services : " | lolcat
	echo "--------------------"
	echo
	sudo systemctl list-unit-files --type=service | grep enabled
	echo
	read -p "Enter the Service name (e.g., apache2) : " service_name
	echo 
	echo "1. Start Service"
	echo "2. Stop Service"
	echo "3. Restart Service"
	read -p "Choose an Option (1-3) : " action

	case $action in 
	1) sudo systemctl start $service_name ;;
	2) sudo systemctl stop $service_name ;;
	3) sudo systemctl restart $service_name ;;
	*) echo "Invalid Option, Please try again (1-3) " ;;
esac
echo
}

# install and monitor the disk usage # 

monitor_disk_usage() {
	echo 
	echo "Disk Usage (Press q to quit) : " | lolcat
	echo "------------"
	echo
	sudo apt update -y
	echo
	sudo apt install ncdu -y
	echo
	ncdu / 
	echo
}

# install and run system monitor, to measure the system cpu, ram, processes in real-time #

monitor_system() {
	echo
	echo "Monitoring System Resources (Press CTRL+C to stop) : " | lolcat
	echo "----------------------------------------------------"
	echo
	sudo apt update -y
	echo
	sudo apt install glances -y
	echo
	glances
	echo
}

# check system logs for errors #

check_system_logs() {
	echo
	echo "System Logs (Last 10 ERRORS) : " | lolcat
	echo "------------------------------"
	sleep 1
	echo
	sudo journalctl -p 3 -xb --no-pager | tail -n 10 | column --table
	echo 
}

# install, enable and configure ufw #

enable_ufw() {
	echo
	sudo apt update -y
	echo
	sudo apt install ufw -y
	echo 
	echo "Enabling UFW..." | lolcat
	echo
	sudo ufw enable
	echo
	echo "UFW is now enabled!"
	echo
	echo "Default Rules : " | lolcat
	echo "---------------"
	echo 
	sudo ufw status numbered verbose
	echo 
}

# install and run lynis for system audits #

run_lynis() {
	echo
	sudo apt update -y
	echo
	sudo apt install lynis -y
	echo
	echo "Auditing the System!" | lolcat
	echo
	sudo lynis audit system --verbose
	echo
}

# install and check for rootkits #

check_rootkits() {
	echo
	sudo apt update -y
	echo
	sudo apt install rkhunter -y
	echo
	echo "Checking for rootkits!" | lolcat
	echo
	sudo rkhunter --check --sk
	echo
}

# add a new user to the system #

add_user() {
	echo
	read -p "Enter the username for the new user : " username
	echo
	sudo adduser $username
	echo 
	echo "New User $username added to the system!"
	echo
}

# delete a user from the system #

delete_user() {
	echo
	read -p "Enter the username you want to delete : " username
	echo
	sudo deluser $username
	echo
	echo "User $username has been deleted from the system!"
	echo
}

# list all users on the system #

list_users() {
	echo
	echo "System Users : " | lolcat
	echo "--------------"
	echo
	cut -d: -f1 /etc/passwd
	echo
}

# reboot the system #

reboot_system() {
	echo
	echo "Rebooting the System!" | lolcat
	sleep 1
	sudo reboot
}

# shut down the system #

shutdown_system() {
	echo
	echo "Shutting Down the System!" | lolcat
	sleep 1
	sudo shutdown now
}

#############

# MAIN MENU

#############

while true; do
	echo
	echo "-----------------"
	echo "System Services" | lolcat
	echo "-----------------"
	echo
	echo "1.  Show System Information"
	echo
	echo "2.  List Running Services"
	echo
	echo "3.  Manage Services (Start / Stop / Restart)"
	echo
	echo "4.  Monitor Disk Usage (q to quit)"
	echo
	echo "5.  System Monitor (CPU / RAM / Processes)"
	echo
	echo "6.  Check recent system Logs for ERRORS"
	echo
	echo "7.  Enable and Configure firewall"
	echo
	echo "8.  Audit the System"
	echo
	echo "9.  Check for Rootkits"
	echo
	echo "10. Add a New User to the System"
	echo
	echo "11. Delete a User from the System"
	echo
	echo "12. List all Active Users on the System"
	echo
	echo "13. Reboot the System"
	echo
	echo "14. Shutdown the System"
	echo
	echo "15. Exit"
	echo
	read -p "Choose an Option (1-15) : " choice
	echo

case $choice in
	1) show_system_info ;;
	2) list_services ;;
	3) manage_service ;;
	4) monitor_disk_usage ;;
	5) monitor_system ;;
	6) check_system_logs ;;
	7) enable_ufw ;;
	8) run_lynis ;;
	9) check_rootkits ;;
	10) add_user ;;
	11) delete_user ;;
	12) list_users ;;
	13) reboot_system ;;
	14) shutdown_system ;;
	15) echo "Exiting!" ; break ;;
	*) echo "Invalid Option, Please Try Again!" ;;
	esac
done

