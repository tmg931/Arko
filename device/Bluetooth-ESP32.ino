#include "esp_bt_main.h"
#include "esp_bt_device.h"
#include "esp_gap_bt_api.h"
#include "BluetoothSerial.h"

BluetoothSerial SerialBT;
const int PushButton0 = 15;
const int PushButton1 = 4;
const int PushButton2 = 18;

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

bool initBluetooth (const char *deviceName)
{
  if (!btStart()) {
    Serial.println("Failed to initialize controller");
    return false;
  }
  if (esp_bluedroid_init() != ESP_OK) {
    Serial.println("Failed to initialize bluedroid");
    return false;
  }
  if (esp_bluedroid_enable() != ESP_OK) {
    Serial.println("Failed to enable bluedroid");
    return false;
  }
  SerialBT.begin(deviceName);
  //  esp_bt_dev_set_device_name(deviceName);
  //  esp_bt_gap_set_scan_mode(ESP_BT_SCAN_MODE_CONNECTABLE_DISCOVERABLE);

}

void printDeviceAddress() {
  const uint8_t* point = esp_bt_dev_get_address();
  for (int i = 0; i < 6; i++) {
    char str[3];
    sprintf(str, "%02X", (int)point[i]);
    Serial.print(str);
    if (i < 5) {
      Serial.print(":");

    }
  }
}



void setup() {
  Serial.begin(115200);

  initBluetooth("ESP32 BT");
  printDeviceAddress();
  pinMode(PushButton0, INPUT);
  pinMode(PushButton1, INPUT);
  pinMode(PushButton2, INPUT);

}

void loop ()  {
  int PB0 = digitalRead(PushButton0);
  int PB1 = digitalRead(PushButton1);
  int PB2 = digitalRead(PushButton2);
  
    if ( PB0 == HIGH )
    {
      Serial.println("Sending 0\n");
      SerialBT.write(48);
      delay(3500);
    }
    else if ( PB1 == HIGH )
    {
      Serial.println("Sending 1\n");
      SerialBT.write(49);
      delay(3500);
    }
    else if ( PB2 == HIGH )
    {
      Serial.println("Sending 2\n");
      SerialBT.write(50);
      delay(3500);
    }
  delay(200);

}
