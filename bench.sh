#! /bin/bash

NETWORK_ADAPTER=enp10s0

# Change the first number to speed in Mbit
NETWORK_UPLOAD_SPEED=$(expr 400 \* 1024 \* 1024 / 8)
NETWORK_DOWNLOAD_SPEED=$(expr 400 \* 1024 \* 1024 / 8)

# Sample period in seconds
SAMPLE_PERIOD=1

IPERF_COMMAND=$1
LOG_FILE=$2


function get_network_usage {
    upload_t0=$(cat /sys/class/net/$1/statistics/tx_bytes)
    download_t0=$(cat /sys/class/net/$1/statistics/rx_bytes)
    sleep $SAMPLE_PERIOD

    upload_t1=$(cat /sys/class/net/$1/statistics/tx_bytes)
    download_t1=$(cat /sys/class/net/$1/statistics/rx_bytes)
    let UPLOAD="$upload_t1 - $upload_t0"
    let DOWNLOAD="$download_t1 - $download_t0"
}

function appendLog {
    LOG_FILE=$1
    NEW_DATA=$2

    tmp=$(mktemp)
    jq -s add $LOG_FILE $NEW_DATA > "$tmp"
    cat $tmp > $LOG_FILE
    rm $tmp
}

function benchmark {
  LOG=$1
  # Add network usage to last entry
  tmp=$(mktemp)
  UPLOAD_STAT='.[length-1].usage = {"upload": "'$UPLOAD'","download":"'$DOWNLOAD'"}'
  DATE='.[length-1].date = "'$(date +%s)'"'

  cat $LOG | jq $"($UPLOAD_STAT)" | jq $"($DATE)" > $tmp
  cat $tmp > $LOG && rm $tmp
}

# Get current network usage
get_network_usage $NETWORK_ADAPTER

# Benchmark network


echo "one"
RESULT=$($IPERF_COMMAND)

echo "two"
new_tmp=$(mktemp)

echo "thre"
echo [ $RESULT ] > $new_tmp

echo "four"
appendLog $LOG_FILE $new_tmp

benchmark $LOG_FILE
