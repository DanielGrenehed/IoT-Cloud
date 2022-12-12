#include <DHTesp.h>         // DHT for ESP32 library
#include <WiFi.h>           // WiFi control for ESP32
#include <ThingsBoard.h>    // ThingsBoard SDK.................
#include "cred.h"

// Baud rate for debug serial
#define SERIAL_DEBUG_BAUD    115200

// Initialize ThingsBoard client
WiFiClient espClient;
// Initialize ThingsBoard instance
ThingsBoard tb(espClient);

// DHT object
DHTesp dht;
// ESP32 pin used to query DHT22
#define DHT_PIN 23

// Main application loop delay
int quant = 20;

// Period of sending a temperature/humidity data.
int send_delay = 10000;

// Time passed after temperature/humidity data was sent, milliseconds.
int send_passed = 0;


// Setup an application
void setup() {
  // Initialize serial for debugging
  Serial.begin(SERIAL_DEBUG_BAUD);
  ConnectToWiFi();

  // Initialize temperature sensor
  dht.setup(DHT_PIN, DHTesp::DHT22);
}

// Main application loop
void loop() {
  delay(quant);
  send_passed += quant;
  // Reconnect to WiFi, if needed
  if (WiFi.status() != WL_CONNECTED) {
    ConnectToWiFi();
    return;
  }

  // Reconnect to ThingsBoard, if needed
  if (!tb.connected()) {
    ConnectToThingsboard();
  }


  // Check if it is a time to send DHT22 temperature and humidity
  if (send_passed > send_delay) {
    SendData();
    send_passed = 0;
  }

  // Process messages
  tb.loop();
}

void ConnectToWiFi() {
  // Loop until we're reconnected
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(WIFI_AP_NAME, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println("Connected to AP");
    Serial.println(WiFi.localIP());
  }
}

void ConnectToThingsboard() {
    // Connect to the ThingsBoard
    Serial.print("Connecting to: ");
    Serial.print(THINGSBOARD_SERVER);
    Serial.print(" with token ");
    Serial.println(TOKEN);
    if (!tb.connect(THINGSBOARD_SERVER, THINGSBOARD_TOKEN)) {
      Serial.println("Failed to connect");
      return;
    }
    Serial.println("Connected!");
}

void SendData() {
    Serial.print(".");

    // Uploads new telemetry to ThingsBoard using MQTT. 
    // See https://thingsboard.io/docs/reference/mqtt-api/#telemetry-upload-api 
    // for more details

    TempAndHumidity lastValues = dht.getTempAndHumidity();    
    if (isnan(lastValues.humidity) || isnan(lastValues.temperature)) {
      Serial.println("Failed to read from DHT sensor!");
    } else {
      tb.sendTelemetryFloat("temperature", lastValues.temperature);
      tb.sendTelemetryFloat("humidity", lastValues.humidity);
    }
}
