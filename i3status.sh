#!/bin/sh
# shell script to add RAM-usage to i3status
# needs sed, free and bc
## config
# status command has to be this script
## i3status.conf
# showing cpu_usage has to be enabled (because ram_usage is prepended to that with sed...)
# output_format has to be set to "i3bar"

i3status | while :
do
        read line

        # get free and used RAM (this excludes cache)
        ram_both=`free -k | sed -n -e '3 p' | sed 's/-\/+ buffers\/cache:\s*//'`
        used=`echo $ram_both | sed "s/\([0-9]*\)\s*\([0-9]*\)/\1/"`
        free=`echo $ram_both | sed "s/\([0-9]*\)\s*\([0-9]*\)/\2/"`
        used=`echo "scale=1; $used / 1024 / 1024" | bc`
        free=`echo "scale=1; $free / 1024 / 1024" | bc`

        # if free RAM is less than 2GB show text in red, else green
        if [ $(echo "$free < 2" | bc) -eq 1 ]
        then
            color=FF0000
        else
            color=00FF00
        fi
        
        # put ram_usage before cpu_usage
        sedline="s/cpu_usage/ram_usage\",\"color\":\"#${color}\",\"full_text\":\"RAM: ${used}G used ${free}G free\"},{\"name\":\"cpu_usage/"
        final=`echo $line | sed -e "$sedline" | sed -e "s/% \"/%\"/"`

        echo "$final" || exit 1
done
