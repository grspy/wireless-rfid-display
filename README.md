
# Wireless RFID display using Arduino and MSP430

Transmit RFID information acquired by one microcontroller (Arduino) wirelessly to another microcontroller (MSP430) and display it on an LCD.

The scenario is as follows:
The RFID reader along with a simple 433MHz transmitter are connected to the Arduino Uno. The 433MHz receiver and the LCD (via an I2C adapter) is connected to the MSP430F5529. When a tag is tapped on the RFID reader, its UID is being read and sent via the 433MHz transmitter to the MSP430, which receives the UID and displays it on the LCD. Since the LCD I used is 16 characters, it will only display 4-byte UIDs (like Mifare Classic, which is also supported by the MFRC522 RFID library), or just the first 4 bytes of a 7-byte UID.

I used the Arduino IDE to compile and upload the transmitter code to Arduino Uno and the Energia IDE for the receiver code to MSP430. You will need the [MFRC522](https://github.com/miguelbalboa/rfid) and [VirtualWire](https://www.resistorpark.com/arduino-virtualwire-library-download/) libraries for Arduino and the [LiquidCrystal_I2C](https://github.com/MicroJoe/msp430-liquidcrystal-i2c) and VirtualWire libraries for Energia. The VirtualWire library for Energia was tweaked to support my MSP430F5529, thus included (you should put the VirtualWire-msp430 directory inside the libraries directory of Energia). Should work out of the box for MSP430G2, but you should change the SDA and SCL pins to P1_7 and P1_6 accordingly in the setup section of the receiver.


Arduino | Transmitter | MFRC522
------- | ----------- | -------
GND | GND | GND
+3.3V | - | VCC
+5V | VCC | -
D7 | DATA | -
D10 | - | SDA
D13 | - | SCK
D11 | - | MOSI
D12 | - | MISO
D9 | - | RST	


MSP430 | Receiver | LCD (I2C)
------ | -------- | ---------
GND | GND | GND
3V3 | - | VCC
5V | VCC | -
P2.2 | DATA | -
P3.0 | - | SDA
P3.1 | - | SCL


