# IoT-Cloud


## About The Project
Collecting indoor temperature and humidity

## System Overview

esp32 (with DHT22 sensor) - (Linode, Ubuntu running:) Thingsboard - PostgreSQL   

SMHI - cron (python script) - thingsboard

## Security

Use MQTT over SSL 


REST API Client - automatically create users and devices