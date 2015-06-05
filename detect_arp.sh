#!/bin/sh --

# Get the BSSID IP address of Wi-Fi
BSSID_IP=$(route -n | awk '$1~/^0.0.0.0/ {print $2}')

# Get the MAC address of ARP table
ARP_MAC=$(arp -a -i wlan1 | awk '$2~/'"$BSSID_IP"'/ {print toupper($4)}')

# Maximum circulation count
MAX_LOOP=500
Count=0

IS_ARP=0

while [[ $Count -lt $MAX_LOOP ]]; do
	# Get the MAC address of BSSID IP
	# This function needs root privilege
	BSSID_MAC=$(arping -I wlan1 -f $BSSID_IP | awk '$4~/'"$BSSID_IP"'/ {print toupper($5)}')

	# Wipe off '[]' from BSSID MAC address format
	BSSID_MAC=$(echo $BSSID_MAC | awk -F '[][]' '{print $2}')

	# Format BSSID MAC which address filed without only one alpha
	# 17 is constant length of MAC
	if [ ${#BSSID_MAC} -lt 17 ]; then
		BSSID_MAC=$(echo $BSSID_MAC | awk -F '[][:]' '{i=1;while(i<=NF){if(length($i)<2){$i="0"$i;};if(i==1){j=$i;}else{j=j":"$i;}i++;}print j}')
	fi

	if [ "$BSSID_MAC" != "$ARP_MAC" ]; then
		IS_ARP=1
		break
	fi

	Count=$(($Count+1));
done

echo "Detection date is:" $(date)
echo "BSSID MAC is:" $BSSID_MAC
echo "ARP table MAC is:" $ARP_MAC

if [ $IS_ARP = 1 ]; then
	source led_controller.sh red
else
	source led_controller.sh green
fi
