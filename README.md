# Speedlogger

## About
This is a small tool I use to log daily speed test results. 
It was build for fun to learn a bit bash scripting. 

The script is used to benchmark an internet connection with `iperf3`. 
It also logs the current internet usage, since you might have some traffic besides this script. 

## Usage
The `bench.sh` takes 2 arguments: A `iperf3` command of your choice, and a log file. 
It appends results to the log file given. 
Change `NETWORK_ADAPTER` to your network adapter. 

## Cron example

The first job runs daily at 09:46 and tests the download speed, while the second job runs at 09:37 and tests the upload speed. 
```
# m h  dom mon dow   command
46 9 * * * /home/carljh/Projects/speedlogger/bench.sh 'iperf3 -c speedtest.serverius.net -p 5002 -b 300Mbps -O 2 -R -J' /var/log/networkbench/download.json
37 9 * * * /home/carljh/Projects/speedlogger/bench.sh 'iperf3 -c speedtest.serverius.net -p 5002 -b 300Mbps -O 2 -J' /var/log/networkbench/upload.json
```
