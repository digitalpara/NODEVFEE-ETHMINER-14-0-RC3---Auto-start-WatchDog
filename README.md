# NODEVFEE-ETHMINER-15-0-dev8---Auto-start-WatchDog
Features
OpenCL mining
Nvidia CUDA mining
realistic benchmarking against arbitrary epoch/DAG/blocknumber
on-GPU DAG generation (no more DAG files on disk)
stratum mining without proxy
OpenCL devices picking
farm failover (getwork + stratum)

ETHminerWatchDog-SMSK is a simple script (Windows/Linux) WachDog for ETHminer.

Working on Windows (7 / 8 / 10) [x86 / x64] and Linux (Any Dist / Any Ver / Any Arch).

Table of Contents
Features
Download
Install
Usage
Feedback
Maintainers
Contribute
License
Donations
Features
Simple script (Windows/Linux) WachDog for ETHminer.

ETHminerWatchDog-SMSK:

Run ethminer
Restart ethminer up to 4 times
Reboot the system
CUDA support removed because ethminer added --exit parameter to exit whenever an error occurred! ([#757] P.R.)
AutoFix #189 issue of Ethminer.
AutoFix #385 issue of Ethminer.
Log file RunTimes.log.
Auto Turn off the Error Dialog (Windows).
On all systems, it is necessary for the user to have reboot permissions.
Οn Linux systems create a file /etc/sudoers.d/reboot with username ALL=NOPASSWD:/sbin/reboot
