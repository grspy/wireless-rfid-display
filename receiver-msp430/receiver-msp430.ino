#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <VirtualWire.h>

LiquidCrystal_I2C lcd(0x3f,16,2);  // set the LCD address to 0x27 for a 16 character, 2 line display

void setup()
{
  Wire.begin(3);
  Wire.setModule(0);
  pinMode(P3_0,INPUT_PULLUP); // I2C3SDA
  pinMode(P3_1,INPUT_PULLUP); // I2C3SCL

  Serial.begin(9600);  // Debugging only
  Serial.println("setup");

  // Initialise the IO and ISR
  pinMode(RED_LED, OUTPUT);     
  vw_set_ptt_inverted(true); // Required for DR3100
  vw_set_rx_pin(P2_2);
  vw_setup(2000);  // Bits per sec
  vw_rx_start();       // Start the receiver PLL running
  
  lcd.begin(); // initialize the lcd

  // Print a message to the LCD
  lcd.backlight();
  lcd.print("Waiting for tag!");
  lcd.setCursor(0,1);
  
}

void loop()
{
    uint8_t buf[VW_MAX_MESSAGE_LEN];
    uint8_t buflen = VW_MAX_MESSAGE_LEN;

    if (vw_get_message(buf, &buflen)) // Non-blocking
    {
      int i;

      digitalWrite(RED_LED, true); // Flash a light to show received good message
      // Message with a good checksum received, dump it.
      Serial.print("Got: ");

      lcd.clear();
      lcd.print("Got a tag!      ");
      lcd.setCursor(0,1);
      lcd.print("UID:");

      for (i = 0; i < buflen; i++)
      {
          if(buf[i] < 0x10) {
              Serial.print(F(" 0"));
              lcd.print(F(" 0"));
          }
          else {
              Serial.print(F(" "));
              lcd.print(F(" "));
          }
          Serial.print(buf[i], HEX);
          lcd.print(buf[i], HEX);
      }
      Serial.println("");
      digitalWrite(RED_LED, false);
    }
}
