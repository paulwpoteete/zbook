# zbook
HP ZBook Fury Elan Touchpad tools for Linux Mint

## Overview
The new HP ZBook Laptop is an excellent option for Linux Mint Users; however, if you do not order Linux pre-installed, then you will need to upgrade the kernel to use the full features of the laptop. Below, I will give my specifications, grub settings, and my touchpad enable / disable script for your perusal. I hope that it helps.

## Specifications
```
$ inxi -F

System:    Host: furyfoo Kernel: 5.13.0-40-generic x86_64 bits: 64 Desktop: Cinnamon 5.2.7 Distro: Linux Mint 20.3 Una 
Machine:   Type: Laptop System: HP product: HP ZBook Fury 17.3 inch G8 Mobile Workstation PC v: N/A 
           serial: <superuser/root required> 
           Mobo: HP model: 886D v: KBC Version 52.27.00 serial: <superuser/root required> UEFI: HP v: T95 Ver. 01.08.20 
           date: 03/14/2022 
Battery:   ID-1: BAT0 charge: 92.8 Wh condition: 92.8/94.1 Wh (99%) 
CPU:       Topology: 8-Core model: 11th Gen Intel Core i7-11800H bits: 64 type: MT MCP L2 cache: 24.0 MiB 
           Speed: 788 MHz min/max: 800/4600 MHz Core speeds (MHz): 1: 954 2: 1098 3: 772 4: 1042 5: 801 6: 1056 7: 965 8: 938 
           9: 769 10: 800 11: 1007 12: 975 13: 812 14: 965 15: 807 16: 974 
Graphics:  Device-1: NVIDIA driver: nvidia v: 510.60.02 
           Display: x11 server: X.Org 1.20.13 driver: nvidia unloaded: fbdev,modesetting,nouveau,vesa 
           resolution: 1920x1080~60Hz 
           OpenGL: renderer: NVIDIA RTX A3000 Laptop GPU/PCIe/SSE2 v: 4.6.0 NVIDIA 510.60.02 
Audio:     Device-1: Intel driver: sof-audio-pci-intel-tgl 
           Device-2: NVIDIA driver: snd_hda_intel 
           Sound Server: ALSA v: k5.13.0-40-generic 
Network:   Device-1: Intel driver: iwlwifi 
           IF: wlan0 state: up mac: 5c:e4:2a:fa:29:40 
           Device-2: Intel Ethernet I219-V driver: e1000e 
           IF: eth0 state: down mac: c8:5a:cf:6c:12:57 
           IF-ID-1: vboxnet0 state: down mac: 0a:00:27:00:00:00 
Drives:    Local Storage: total: 1.82 TiB used: 996.96 GiB (53.5%) 
           ID-1: /dev/nvme0n1 vendor: Samsung model: MZVLB1T0HBLR-000H1 size: 953.87 GiB 
           ID-2: /dev/nvme1n1 vendor: Samsung model: SSD 970 EVO Plus 2TB size: 1.82 TiB 
Partition: ID-1: / size: 914.76 GiB used: 131.73 GiB (14.4%) fs: ext4 dev: /dev/dm-1 
           ID-2: /boot size: 704.5 MiB used: 331.6 MiB (47.1%) fs: ext4 dev: /dev/nvme0n1p2 
           ID-3: swap-1 size: 976.0 MiB used: 256 KiB (0.0%) fs: swap dev: /dev/dm-2 
Sensors:   System Temperatures: cpu: 42.0 C mobo: 40.0 C gpu: nvidia temp: 41 C 
           Fan Speeds (RPM): N/A 
Info:      Processes: 422 Uptime: 4d 5h 04m Memory: 31.10 GiB used: 8.43 GiB (27.1%) Shell: bash inxi: 3.0.38 
```
## XINPUTS
```
$ xinput

⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
⎜   ↳ ELAN0750:00 04F3:313A                   	id=19	[slave  pointer  (2)]
⎜   ↳ ELAN0750:00 04F3:313A                   	id=18	[slave  pointer  (2)]
⎜   ↳ ELAN0750:00 04F3:313A                   	id=17	[slave  pointer  (2)]
⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
    ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
    ↳ Power Button                            	id=6	[slave  keyboard (3)]
    ↳ Video Bus                               	id=7	[slave  keyboard (3)]
    ↳ Power Button                            	id=8	[slave  keyboard (3)]
    ↳ Sleep Button                            	id=9	[slave  keyboard (3)]
    ↳ HP HD Camera: HP HD Camera              	id=15	[slave  keyboard (3)]
    ↳ HP HD Camera: HP IR Camera              	id=16	[slave  keyboard (3)]
    ↳ Intel HID events                        	id=20	[slave  keyboard (3)]
    ↳ Intel HID 5 button array                	id=21	[slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard            	id=22	[slave  keyboard (3)]
    ↳ HP Wireless hotkeys                     	id=23	[slave  keyboard (3)]
    ↳ HP WMI hotkeys                          	id=24	[slave  keyboard (3)]
```
## GRUB
```
$ cat /etc/default/grub | grep -Ev "^$|^#"

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX="net.ifnames=0 ipv6.disable=1"
```
## Touchpad Tools
```
$ cat /opt/elan_touchpad.sh 

#!/bin/bash
#Control the ELAN Touchpad in Linux Mint

#Find the xinput IDs and enable/disable them
func_enable (){
for id in `xinput | grep ELAN | awk -F"\t" '{ print $2 }' | sed s/id=//gi`
	do xinput enable $id
done
}

func_disable () {
for id in `xinput | grep ELAN | awk -F"\t" '{ print $2 }' | sed s/id=//gi`
        do xinput disable $id
done
}

#Read the command line argument and act upon it.
if [ $1 == 'enable' ]
then
	func_enable
elif [ $1 == 'disable' ]
then
	func_disable
else
	echo -e "Usage:\n\t$0 enable\n\t\tor\n\t$0 disable"
fi
```
## Touchpad Desktop Icons
```
$ cat *able.desktop 

#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Elan Touchpad Disable
GenericName=Touchpad Control
Comment=This controls the Elan Touchpad on the HP Z Book
Exec=/opt/elan_touchpad.sh disable
Icon=input-touchpad
Name[en_US]=Elan Touchpad Disable
Icon[en_US]=input-touchpad

#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name=Elan Touchpad Enable
GenericName=Touchpad Control
Comment=This controls the Elan Touchpad on the HP Z Book
Exec=/opt/elan_touchpad.sh enable
Icon=input-touchpad
Name[en_US]=Elan Touchpad Enable
Icon[en_US]=input-touchpad
```
