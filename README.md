# IoT-Cloud


## About The Project
Collecting indoor temperature and humidity

## System Overview

esp32 (with DHT22 sensor) - (Linode, Ubuntu running:) Thingsboard - PostgreSQL   

SMHI - cron (python script) - thingsboard

## Security

Use MQTT over SSL 


REST API Client - automatically create users and devices

## Setup
Clone this repository:
```bash
git clone https://github.com/DanielGrenehed/IoT-Cloud
```
cd into VPS/Thingsboard and run the setup.sh file (You are responsible for your own computer, maybe don't run scripts from random github repos) this will install all dependencies, setup a PostgreSQL database, create a database and user for thingsboard then install and start thingsboard:
```
sudo ./setup.sh
```

After a few minutes you should be able to access thingsboard from your ip on port 8080.
There are a few accounts present:
| Role | Email | Password |
| - | - | - |
| System Administrator | sysadmin@thingsboard.org | sysadmin |
| Tenant Administrator | tenant@thingsboard.org | tenant |
| Customer User | customer@thingsboard.org | customer |
