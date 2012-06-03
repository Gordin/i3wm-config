
#!/bin/sh
# shell script to prepend i3status with more stuff

i3status | while :
do
        read line
        ram_both=`free -k | sed -n -e '3 p' | sed 's/-\/+ buffers\/cache:\s*//'`
        used=`echo $ram_both | sed "s/\([0-9]*\)\s*\([0-9]*\)/\1/"`
        free=`echo $ram_both | sed "s/\([0-9]*\)\s*\([0-9]*\)/\2/"`
        used=`echo "scale=1; $used / 1024 / 1024" | bc`
        free=`echo "scale=1; $free / 1024 / 1024" | bc`
        gb=2.0
        if [ $(echo "$free < $gb"|bc) -eq 1 ]
        then
            color=FF0000
        else
            color=00FF00
        fi
        
        sedline="s/cpu_usage/ram_usage\",\"color\":\"#${color}\",\"full_text\":\"RAM: ${used}G used ${free}G free\"},{\"name\":\"cpu_usage/"
        final=`echo $line | sed -e "$sedline" | sed -e "s/% \"/%\"/"`
        echo "$final" || exit 1
done
