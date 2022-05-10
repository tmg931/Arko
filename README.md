# Arko

An Android App to help Seniors living with Mild Cognitive impairments navigate home from a walk, or navigate to one of their favorite locations.

## About

This project was sponsored by the FSU Institute for Successful Longevity as a part of their Navigation Design Challenge.
Our team was tasked with finding a solution to one of three problems.

1. Aid elderly to navigate healthcare facilities or malls
2. Aid elderly to return home after a walk
3. Aid elderly to use public transportation or ridesharing services

Our team chose the second problem and developed a solution that consists of two parts: a phone app and a secondary device.

The phone app contains the navigation screen using Google Maps API as well as the settings, which allows the user to add or remove locations and add a emergency contact.

The device is connected via Bluetooth to the phone and features three buttons for: navigating back home, navigating to a favorite location, and calling the emergency contact.

## App and Device Demo

[![Demo](https://img.youtube.com/vi/l0S_EsO-n4k/0.jpg)](https://www.youtube.com/watch?v=l0S_EsO-n4k)

## Building - App

This app was built using flutter and Android studios. You will need to have up-to-date versions of both of these.

You will also need a Google Maps API key from the [Google Cloud Platform website.](https://console.cloud.google.com/google/maps-apis)
With that key you will need to repalce the string "ENTER_KEY_HERE" with your key in the following files:

- lib/map.dart
- lib/location.dart
- android/app/src/main/AndroidManifest.xml

## Building - Device

The device uses an Arduino ESP-32 board. To build it, you will need Arduino IDE and the ESP-32 library.

Open /device/Bluetooth-ESP32.ino using Arduino IDE and download it to the board.

The default pins for the buttons are 15 for home, 4 for emergency contact, and 18 for favorite location.

Wire the three pushbuttons from those pins to the 3.3V pin on the board (Active High voltage).

## License

Arko is licensed under the MIT license.