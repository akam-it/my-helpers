#!/bin/bash

# Kamailio CPS
# watch online cps and concurrent calls

stats_pre=`sudo /usr/sbin/kamctl stats`
while(true)
do
    stats=`sudo /usr/sbin/kamctl stats`
    dialogs=`echo "$stats" | grep rcv_requests_invite | cut -d'=' -f2 | sed 's/[^0-9]//g'`
    dialogs_pre=`echo "$stats_pre" | grep rcv_requests_invite | cut -d'=' -f2 | sed 's/[^0-9]//g'`
    active_calls=`echo "$stats" | grep dialog:active_dialogs | cut -d'=' -f2 | sed 's/[^0-9]//g'`
    early_calls=`echo "$stats" | grep dialog:early_dialogs | cut -d'=' -f2 | sed 's/[^0-9]//g'`
    dialogs_diff=$(($dialogs - $dialogs_pre))
    echo -ne "CPS: $dialogs_diff, Active calls: $active_calls, Early calls: $early_calls"\\r
    sleep 1
    stats_pre=$stats
done
