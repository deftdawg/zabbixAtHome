#!/bin/bash 
# -x

### API documentation @ http://docs.timdorr.apiary.io/

function debug() {
  echo "$(date) -- $*"
}

if [ -z "${TESLA_USER_ID}${TESLA_PASSWORD}" ]; then
  if [ ! -e .tesla.id ] && [ ! -e ~/.tesla.id ]; then
     echo create ~/.tesla.id containing TESLA_USER_ID and TESLA_PASSWORD environment variables for this script to load.
     exit
  fi
  . .tesla.id 2>/dev/null
  . ~/.tesla.id 2>/dev/null
fi

ZABBIX_HOST='Tesla'
ZABBIX_SERVER='127.0.0.1'

## TODO add check for .zab file and submit that directly to zabbix sender
if [ -z "$1" ]; then
  TESLA_DATA_FILE="/tmp/$(basename $0).$(date +%F_%H%M).tmp"
  /usr/local/bin/teslacmd -u ${TESLA_USER_ID} -p ${TESLA_PASSWORD} -c -t -d -i -v -g > "${TESLA_DATA_FILE}"
else
  TESLA_DATA_FILE="$1"
  debug Running replay with data file ${TESLA_DATA_FILE}...
fi

ZABBIX_DATA_FILE=${TESLA_DATA_FILE}.zab
TIMESTAMP=$(grep gps_as_of "${TESLA_DATA_FILE}" | cut -d" " -f4 || date +%s)
# TIMESTAMP=$(date +%s)

find "${TESLA_DATA_FILE}" -size -350c -delete
if [ ! -e "${TESLA_DATA_FILE}" ]; then exit; fi

cat "${TESLA_DATA_FILE}" | grep -ve "error" | cut -d "{" -f2 | cut -d"}" -f1 | sed -e 's/ //g' | rev | cut -d, -f2 | rev | sed -e 's/:/ /g' | while read LINE; do
  if [ ! -z "$(echo ${LINE} | grep timeout)" ]; then
    exit
  fi

  if [ ! -z "${LINE}" ]; then
    KEY=$(echo "${LINE}" | cut -d" " -f1)
    VALUE=$(echo "${LINE}" | cut -d" " -f2)
    if [ "${VALUE}" == "null" ]; then
      VALUE=0
    else
      echo "${ZABBIX_HOST} tesla.${KEY} ${TIMESTAMP} ${VALUE}"
    fi
#    echo "${ZABBIX_HOST} tesla.${KEY} ${TIMESTAMP} ${VALUE}"
  fi
done > "${ZABBIX_DATA_FILE}"

cat "${ZABBIX_DATA_FILE}"| zabbix_sender -vv -z ${ZABBIX_SERVER} -T -i - # >/dev/null || debug "Data error occurred."

# debug "Finished download"

# rm "${TESLA_DATA_FILE}"
