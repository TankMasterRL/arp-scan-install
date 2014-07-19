arp-scan-install
================
Bash script that automates the install of arp-scan (and its dependency libpcap) on the supported platforms.
The install consists of downloading and "make" the source code, and eventually install the compiled files.
Source code is saved in a temporary folder, which gives the option to re-install arp-scan and libpcap.
Updating the source code and do the install procedure is supported as well.

Installation with arp-scan-install is supported as well on the Raspberry Pi platform,
by detecting it and installing its platform-specific compiler.

Script options
--------------
For installation do nothing, a "temp" folder will be created where the script is located:
sh arp-scan-install.sh
For re-installation, just run the script again:
sh arp-scan-install.sh
For update, add "update" as argument:
sh arp-scan-install.sh update

The last two shall of course be executed in the same folder where the "temp" folder is located.

Current libpcap version
-------------------------
libpcap-1.6.1

TODO
----
Detect errors in the script during execution, and take actions.
Automatic detection of the latest downloadable libpcap version.
Automatic deletion of unnecessary source code files and downloaded files.
(Bear with me with my bash skills, beginner ;) )