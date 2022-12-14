import requests
import json
import sys

station = 97100#159880

# Set the API endpoint
api_endpoint = f'https://opendata-download-metobs.smhi.se/api/version/1.0/parameter/1/station/{station}/period/latest-hour/data.json'

# Make the SMHI API request and get the response
def getSMHIData():

    response = requests.get(api_endpoint)
    print(response)

    # Parse the response as JSON
    data = json.loads(response.text)

    return data


def extractData(source):
    value = source["value"][0]["value"]
    time = source["value"][0]["date"]
    station = source["station"]["name"]
    station_id = source["station"]["key"]
    data = {"ts": time, "temperature":value, "station":station, "station_id":station_id}
    return data



# Replace the following variables with your own values
ACCESS_TOKEN = ""
HOST = ""

if len(sys.argv) > 1:
    HOST = sys.argv[1]
    if len(sys.argv) > 2:
        ACCESS_TOKEN = sys.argv[2]

print(sys.argv)

PORT = 8080
SERVER_URL = f"http://{HOST}:{PORT}"
url = f"{SERVER_URL}/api/v1/{ACCESS_TOKEN}/telemetry"


# Set the headers for the HTTP request
headers = {
    "Content-Type": "application/json",
}

data = extractData(getSMHIData())

# Send the POST request to ThingsBoard
response = requests.post(url, json=data)
print(response)

# Print the response from ThingsBoard
print(response.text)