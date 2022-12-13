#! /bin/bash

# Construct path to api_fetch.py script
script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
script_path="${script_dir}/api_fetch.py"

# Get flag arguments
while getopts h:t: flag
do
    case "${flag}" in
        h) host=${OPTARG};;
        t) token=${OPTARG};;
    esac
done

# Prompt host if undefined
if [ -z "$host" ]
then 
    echo "Thingsboard host: "
    read host
fi

# Prompt access token if undefined
if [ -z "$token" ]
then 
    echo "Thingsboard access token: "
    read token
fi

# Append api_fetch.py script to crontab
crontab -l | { cat; echo "@hourly /usr/bin/python3 ${script_path} ${host} ${token}"; } | crontab -
echo "Hourly cron job added"