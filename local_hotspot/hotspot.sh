#!/bin/bash

# Ensures that apt is up-to-date.
sudo apt-get update
sudo apt-get upgrade

# Downloads software needed for the AP.
sudo apt-get install dnsmasq hostapd

# Ensures that both installed programs are not running.
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# In order to assign a static IP to the wlan0 interface,
# we edit the file "/etc/dhcpcd.conf".
sudo cp dhcpcd.conf /etc/dhcpcd.conf

# Finally we restart the changes.
sudo service dhcpcd restart

# Now we need to define a range of IPs used by our DHCP server.
# NOTE: If you want to preserve the original configuration, run the following command (manually):
# "sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig"
# By default it is provided a range of IPs between 192.168.4.2 to 192.168.4.254
sudo cp dnsmasq.conf /etc/dnsmasq.conf

# Now we can configure the AP.
# By default the network name will be "RoboinoNetwork" and its passphrase "roboinonetwork"
sudo cp hostapd.conf /etc/hostapd/hostapd.conf

# Now we have to link the previous configuration by editing the following file.
sudo cp default_hostapd.conf /etc/default/hostapd.conf

# Finally WE NEED to empty our WIFI hotspots list.
sudo cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

# Start up!
sudo systemctl start dnsmasq
sudo systemctl start hostapd

echo "Hotspot ready"
