Features
* Caclulated Items - Convert Mi to KM for Battery range and Speed stats
* Trigger - Interrupted charging while vehicle locked
* Trigger - Speeding over 65
* Trigger - Not enough power to heat cabin

Acknowledgements
* Hans Jespersen for writing the TeslaMS utilities
** I could have something to go against the APIs, but being he wrote his utils before I got my car and his utils are a lot better then anything I would have made for this purpose, it was really easy to grab the data.

Dependencies
* Install Node.js server and npm
* sudo npm install -g teslams # this should fetch TeslaMS from https://github.com/hjespers/teslams and install it in your system path

Set-up Steps
1. see ../README.md

TODO
[ ] Fix the teslams2zabbix_sender.sh script to throttle itself when multiple copies start because its taking too long to download stats from Tesla
[ ] Determine Speed units in Drive State
