![PlantTinker](screenshots/plant_tinker_cover.png)

IoT based plant monitoring system which is connected to Firebase. A Flutter app is used to display the live data from the sensors attached to the plant on a mobile device.

## Hardwares

The hardwares used to create the IoT system are as follows:

* Node MCU (ESP-32S)
* DH-11 (temperature and humidity sensor)
* Soil moisture sensor (capacitive)
* LDR (to capture light exposure)
* LEDs
* Resistors (3 1K-resistors used)
* Breadboard
* Jumper wires
* Power adapter / Battery (as power source) with connector (USB micro-B)

> WiFi access with stable internet connectivity required to upload the sensor data to Firebase.

## Softwares

The softwares used to build this project are as follows:

* Arduino IDE (with node mcu board and the necessary libraries)
* Flutter framework (for the app)
* Code Editor (VS Code, IntelliJ or Android Studio recommended)

## Dependencies

This project required the following dependencies:

### Arduino

* Node MCU (ESP-32S Wroover board driver)
* DHT (include from Library Manager of Arduino IDE)
* WiFI (pre-installed)
* Firebase_ESP_Client (include from Library Manager of Arduino IDE)
* time (pre-installed)

### Flutter

The packages used in Flutter are:

* firebase_core
* firebase_auth
* cloud_firestore
* google_sign_in
* fl_chart
* intl

## License

Copyright (c) 2021 Souvik Biswas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
