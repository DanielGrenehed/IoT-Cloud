#! /bin/bash
scriptdir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
ps_dir="${scriptdir}/api_fetch.py"

while getopts h:t: flag
do
    case "${flag}" in
        h) host=${OPTARG};;
        t) token=${OPTARG};;
    esac
done

if [ -z "$host" ]
then 
    echo "Thingsboard host: "
    read host
fi

if [ -z "$token" ]
then 
    echo "Thingsboard access token: "
    read token
fi

#echo $ps_dir $host $token
#@hourly /usr/bin/python3 $ps_dir $host $token
crontab -l | { cat; echo "@hourly /usr/bin/python3 ${ps_dir} ${host} ${token}"; } | crontab -