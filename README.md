
Zabbix templates scripts repository for smart devices in and around my home.

Devices

* Radio Thermostat of America's CT50 (via Wifi)
* Tesla Model S (via teslams/ruby and the Tesla APIs)

Set-up Steps

1.  Download or clone the repository.
2.  See the README.md file for each device
3.  Import the template for the device on to the Zabbix Server via Zabbix Frontend.
4.  Create a host of "Zabbix Trapper" type for the device and associate the template you just imported.
5.  Set-up any login information in the appropriate .files or in the script themselves.
6.  "chmod +x" the script file.
7.  Manually run the script and watch "Latest Data" page in the Zabbix Frontend (make sure to select all types & all hosts w/ no filters), if you see data proceed, if not troubleshoot. 
8.  Set-up a cronjob to execute the script file on a regular interval.
9.  (optional) create triggers in Zabbix for things that interest you and submit them back.
10. Enjoy the pretty graphs and historical data from your devices.

