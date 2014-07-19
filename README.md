arp-scan-install
================
Automates the install of arp-scan (and its dependency libpcap) on the supported platforms.
The install consists of downloading and "make" the source code, and eventually install the compiled files.
Source code is saved in temporary folder, which gives the option to re-install arp-scan and libpcap.
Updating the source code and do the install procedure is supported as well.

Installation with arp-scan-install is supported as well on the Raspberry Pi platform,
by detecting it and installing its platform-specific compiler.

Current libpcap version
-------------------------
libpcap-1.6.1

TODO
----
Detect errors in the script during execution, and take actions.
Automatic detection of the latest downloadable libpcap version.
Automatic deletion of unnecessary source code files and downloaded files.
(Bear with me with my bash skills, beginner ;) )