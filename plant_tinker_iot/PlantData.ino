#include <WiFi.h>
#include <DHT.h>
#include <Firebase_ESP_Client.h>

#include "addons/TokenHelper.h"
#include "Secrets.h"
#include "time.h"

#define DHTPIN 23
#define SOILPIN 32
#define LDRPIN 33
#define LEDGREENPIN 15
#define LEDREDPIN 16
#define SOILPOWER 4

DHT dht(DHTPIN, DHT11);

FirebaseData data;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long epochTime; 
unsigned long dataMillis = 0;

const char* ntpServer = "pool.ntp.org";

void setup()
{
    Serial.begin(115200);
    dht.begin();
    pinMode(LEDGREENPIN, OUTPUT);
    pinMode(LEDREDPIN, OUTPUT);
    pinMode(SOILPOWER, OUTPUT);

    digitalWrite(LEDGREENPIN, LOW);
    digitalWrite(LEDREDPIN, LOW);
    digitalWrite(SOILPOWER, LOW);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    configTime(0, 0, ntpServer);

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback;

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void loop()
{

    if (Firebase.ready() && (millis() - dataMillis > 15000 || dataMillis == 0))
    {
        dataMillis = millis();

        epochTime = getTime();
        Serial.print("Epoch Time: ");
        Serial.println(epochTime);

        float temperature = dht.readTemperature();
        float humidity = dht.readHumidity();

        digitalWrite(SOILPOWER, HIGH);
        delay(10);
        float moisture = analogRead(SOILPIN);
        float moisturePercent = 100.00 - ( (moisture / 4095.00) * 100.00 );
        digitalWrite(SOILPOWER, LOW);

        float ldr = analogRead(LDRPIN);
        float ldrPercent = (ldr / 4095.00) * 100.00;

        Serial.print("Temperature: ");
        Serial.print(String(temperature));
        Serial.print(" C\nHumidity: ");
        Serial.print(String(humidity));
        Serial.print("\nMoisture: ");
        Serial.print(String(moisturePercent));
        Serial.print(" %");
        Serial.print("\nLight: ");
        Serial.print(String(ldrPercent));
        Serial.print(" %");
        Serial.println("\n");

        FirebaseJson content;

        String documentPath = "plant/" + String(epochTime);

        content.set("fields/temperature/doubleValue", temperature);
        content.set("fields/humidity/doubleValue", humidity);
        content.set("fields/moisture/doubleValue", moisturePercent);
        content.set("fields/light/doubleValue", ldrPercent);
        content.set("fields/timestamp/integerValue", epochTime);

        Serial.print("Create a document... ");

        if (Firebase.Firestore.createDocument(&data, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw())) {
          digitalWrite(LEDGREENPIN, HIGH);
          Serial.printf("ok\n%s\n\n", data.payload().c_str());
          delay(200);
          digitalWrite(LEDGREENPIN, LOW);
        }
        else {
          digitalWrite(LEDREDPIN, HIGH);
          Serial.println(data.errorReason());
          delay(200);
          digitalWrite(LEDREDPIN, LOW);
        }
    }
}

// Function that gets current epoch time
unsigned long getTime() {
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    return(0);
  }
  time(&now);
  return now;
}
