# IoT-Cloud


## About The Project
Collecting indoor temperature and humidity

## System Overview
[![architecture image](https://github.com/DanielGrenehed/IoT-Cloud/blob/main/res/architecture.png)]()
### Built With
* Thingsboard
* PostgreSQL
* C++ and Python

## Security Considerations
There are several things to do to make this somewhat secure. Consider using MPTTS (MQTT over SSL) for the device. One thing to note here is that the esp used does not have an HSM module and even while the 'cred.h' is excluded from git-commits, this does nothing in terms of hiding your WiFi and thingsboard credentials when on device and they are readable by anyone with access to the actual device and some basic hardware hacking experience.
Running the setup in this repo will load the demo setup of thingsboard, this means there will be some accounts with default user/passwords, so if this is deployed open to the internet please consider changing, at least, the passwords of the users.

## Scalability
No


## Setup
These instructions are for setting up this project on a device running debian linux, but the project was built and ran on a Linode VPS with 2GB ram running ubuntu.      

Clone this repository:
```bash
git clone https://github.com/DanielGrenehed/IoT-Cloud
```
cd into VPS/Thingsboard and run the setup.sh file (You are responsible for your own computer, maybe don't run scripts from random github repos) this will install all dependencies, setup a PostgreSQL database, create a database and user for thingsboard then install and start thingsboard, use ```-s``` if you set this up on a computer with 1GB of ram or less:
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

### Setup device
Sign in as a Tenant, go to Devices, click on the plus sign, then add new device. Name the device, go to credentials and add credentials. Provide an access token for the device, then click Add. Then in the Devices view, assign the new device to your customer.

Now to create the firmware for your esp32, create a file named 'cred.h' in Device/esp32_dht22_device/ and define your configuration: 
```C
#define WIFI_AP_NAME        "YOUR_WIFI_SSID"
#define WIFI_PASSWORD       "YOUR_WIFI_PASSWORD"
#define THINGSBOARD_TOKEN   "YOUR_THINGSBOARD_DEVICE_TOKEN"
#define THINGSBOARD_SERVER  "YOUR_THINGSBOARD_SERVER"
```
Then compile and flash your esp32, connecting the dht22 data pin to esp32 pin G23. The code requires DHTesp , WiFi and ThingsBoard libraries installed to compile.   
   
Now If all went well the esp should begin publishing to thingsboard.

### Setup SMHI api data fetching
As Tenant, go to Devices and add a device with an access token. Then run the setup_job.sh script in the VPS/SMHI subfolder and provide the thingsboard server address and the newly added device access token. This will create a crontab running once every hour that gets the temperature of the preprogrammed station(in the api_fetch.py script) and posts it to thingsboard. Assign the new device to the customer.

### Create a Dashboard
As Tenant, go to Dashboards, and add a new dashboard and give it a flashy title, save then open the new empty dashboard. Click the orange pen button in the lower right corner to edit the dashboard. Add a new widget, maybe a simple card to display the latest value, add a datasource, create an entity, set filter type to single entity and type as device. Now select the device you want to add then select datakeys and add the widget.   
To add a chart is basically done the same way but you can add multiple datasources.


