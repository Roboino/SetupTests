# Bluetooth setup
This document contains the instructions to setup bluetooth in a raspberry pi 0 w with raspbian lite installed.

## Preconditions
To make sure that this guide works I formatted my Raspberry and copied the instructions that I follow,
the only precondition I have now is a brand-new copy of a raspbian lite (Release Date: 2018-03-13), a `wpa-supplicant.conf` file
to connect it to the WI-FI network and a `ssh` file to enable ssh.

## Start
### Library setup
First it's a good idea to upgrade the system if it's the first time you boot it up.
```
sudo apt update
sudo apt upgrade
sudo apt update
```
The last update seems to be required because the `upgrade` operation updates the mirrors.
<br>After that we'll need to install the packages required to build python-bluez:
```
sudo apt install python-dev libbluetooth-dev python-pip
```
And we'll install (build) the pybluez library, that will provide us a bluetooth interface to use from python
```
sudo pip install pybluez
```

### Bluetooth setup
Then we'll need to put the bluetooth service in compatibility mode (or it won't start as a server, no-one knows why).
First make sure that it's running
```
pi@raspberrypi:~ $ sudo service bluetooth status
● bluetooth.service - Bluetooth service                                                                             
   Loaded: loaded (/lib/systemd/system/bluetooth.service; enabled; vendor preset: enabled)                          
   Active: active (running) since Tue 2018-03-13 22:53:47 UTC; 2 weeks 3 days ago                                   
     Docs: man:bluetoothd(8)
 Main PID: 359 (bluetoothd)
   Status: "Running"
   CGroup: /system.slice/bluetooth.service
           └─359 /usr/lib/bluetooth/bluetoothd

Mar 13 22:53:45 raspberrypi systemd[1]: Starting Bluetooth service...
Mar 13 22:53:47 raspberrypi bluetoothd[359]: Bluetooth daemon 5.43
Mar 13 22:53:47 raspberrypi systemd[1]: Started Bluetooth service.
Mar 13 22:53:47 raspberrypi bluetoothd[359]: Starting SDP server
Mar 13 22:53:48 raspberrypi bluetoothd[359]: Bluetooth management interface 1.14 initialized
Mar 13 22:53:48 raspberrypi bluetoothd[359]: Failed to obtain handles for "Service Changed" characteristic
Mar 13 22:53:48 raspberrypi bluetoothd[359]: Sap driver initialization failed.
Mar 13 22:53:48 raspberrypi bluetoothd[359]: sap-server: Operation not permitted (1)
```
Don't worry about the errors in the log.
To put it in compability mode we need to change the file in `/lib/systemd/system/bluetooth.service`
```
sudo nano /lib/systemd/system/bluetooth.service
```
Append a ` -C` in the line that begins with `ExecStart`, the result will be like this:
```
ExecStart=/usr/lib/bluetooth/bluetoothd -C
```
Then save and exit from the editor.
To make the changes work we'll need to reboot:
```
sudo reboot
```
After the reboot we'll see the `-C` flag in action in the service status:
```
pi@raspberrypi:~ $ sudo service bluetooth status
● bluetooth.service - Bluetooth service
   Loaded: loaded (/lib/systemd/system/bluetooth.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2018-03-31 07:40:54 UTC; 1min 24s ago
     Docs: man:bluetoothd(8)
 Main PID: 343 (bluetoothd)
   Status: "Running"
   CGroup: /system.slice/bluetooth.service
           └─343 /usr/lib/bluetooth/bluetoothd -C

Mar 31 07:40:54 raspberrypi systemd[1]: Starting Bluetooth service...
Mar 31 07:40:54 raspberrypi bluetoothd[343]: Bluetooth daemon 5.43
Mar 31 07:40:54 raspberrypi systemd[1]: Started Bluetooth service.
Mar 31 07:40:54 raspberrypi bluetoothd[343]: Starting SDP server
Mar 31 07:40:54 raspberrypi bluetoothd[343]: Bluetooth management interface 1.14 initialized
Mar 31 07:40:54 raspberrypi bluetoothd[343]: Failed to obtain handles for "Service Changed" characteristic
Mar 31 07:40:54 raspberrypi bluetoothd[343]: Sap driver initialization failed.
Mar 31 07:40:54 raspberrypi bluetoothd[343]: sap-server: Operation not permitted (1)
```

### Pair bluetooth
In this section we'll enable the bluetooth service and we'll pair to the other device (I'm using an android phone).
To make this we'll use the `bluetoothctl` tool that should be preinstalled in the raspbian distribution.
```
pi@raspberrypi:~ $ sudo bluetoothctl
[NEW] Controller B8:27:EB:3D:FB:25 raspberrypi [default]
[bluetooth]# power on
Changing power on succeeded
[bluetooth]# pairable on
Changing pairable on succeeded
[bluetooth]# discoverable on
Changing discoverable on succeeded
[CHG] Controller B8:27:EB:3D:FB:25 Discoverable: yes
[bluetooth]# agent on
Agent registered
[bluetooth]# default-agent
Default agent request successful
```
After that open the phone and, in the bluetooth settings, pair with the `raspberrypi` device 
```
[NEW] Device F4:F5:DB:D8:E9:6C Snowy
Request confirmation
[agent] Confirm passkey 123456 (yes/no): yes
[CHG] Device F4:F5:DB:D8:E9:6C Modalias: bluetooth:v001Dp1200d1436
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001105-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000110a-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000110c-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000110e-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001112-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001115-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001116-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000111f-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000112d-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 0000112f-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001132-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001200-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001800-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C UUIDs: 00001801-0000-1000-8000-00805f9b34fb
[CHG] Device F4:F5:DB:D8:E9:6C ServicesResolved: yes
[CHG] Device F4:F5:DB:D8:E9:6C Paired: yes
[CHG] Device F4:F5:DB:D8:E9:6C ServicesResolved: no
[CHG] Device F4:F5:DB:D8:E9:6C Connected: no
```
The device now is paired but we also explicitly need to trust the device if we want to use it:
```
[bluetooth]# trust F4:F5:DB:D8:E9:6C
[CHG] Device F4:F5:DB:D8:E9:6C Trusted: yes
Changing F4:F5:DB:D8:E9:6C trust succeeded
```
(NOTE: if you don't want to copy manually the address you can just press TAB)
<br>After this everything is set-up, you won't need to repeat this step every time but only if you want to pair with another device.
```
[bluetooth]# exit
Agent unregistered
[DEL] Controller B8:27:EB:3D:FB:25 raspberrypi [default]
```
### Connection
First  we'll need to enable the serial serice, this step is required at every startup so the best option is to copy-paste this into a script
```
#!/bin/bash
# File: start_bluetooth_serial
sudo hciconfig hci0 piscan
sudo sdptool add SP
```
If you run that it should give you a `Serial Port service registered` feedback line, to make sure that the command worked correctly.
If that worked as expected you should be able to use your python server from your raspberry, Congratulations!

### Server Test
If you want to run a test you can use the [pybluez RFCOMM server test](https://github.com/karulis/pybluez/blob/master/examples/simple/rfcomm-server.py)
```
wget https://raw.githubusercontent.com/karulis/pybluez/master/examples/simple/rfcomm-server.py
sudo python rfcomm-server.py
```
Next connect from your phone with a RFCOMM app, I use "Bluetooth Terminal" as it seems to work well.
Open the app, open the settings tab (upper-left corner) and click `Connect a device - Insecure`. Then click your raspberry.
If everything is correct the app should connect an you should be able to send text between your android phone and your raspberry.
