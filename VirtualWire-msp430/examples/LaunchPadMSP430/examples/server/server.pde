// server.pde
//
// Simple example of how to use VirtualWire to send and receive messages
// with a DR3100 module.
// Wait for a message from another arduino running the 'client' example,
// and send a reply.
// You can use this as the basis of a remote control/remote sensing system
//
// See VirtualWire.h for detailed API docs
// Author: Mike McCauley (mikem@open.com.au)
// Copyright (C) 2008 Mike McCauley
// $Id: server.pde,v 1.1 2008/04/20 09:24:17 mikem Exp $
//
//	Port to Energia / MPS430 by Yannick DEVOS XV4Y - (c) 2013
//	http://xv4y.radioclub.asia/
//

#include <VirtualWire.h>

void setup()
{
    Serial.begin(9600);	// Debugging only
    Serial.println("setup");

    // Initialise the IO and ISR
	pinMode(RED_LED, OUTPUT);     
    vw_set_ptt_inverted(true); // Required for DR3100
    vw_setup(2000);	 // Bits per sec
    vw_set_rx_pin(P2_2);
    vw_rx_start();       // Start the receiver PLL running
}

void loop()
{
    const char *msg = "hello";
    uint8_t buf[VW_MAX_MESSAGE_LEN];
    uint8_t buflen = VW_MAX_MESSAGE_LEN;

    // Wait for a message
    vw_wait_rx();
    if (vw_get_message(buf, &buflen)) // Non-blocking
    {
	int i;
	const char *msg = "goodbye";

        digitalWrite(RED_LED, true); // Flash a light to show received good message
	// Message with a good checksum received, dump it.
	Serial.print("Got: ");
	
	for (i = 0; i < buflen; i++)
	{
	    Serial.print(buf[i], HEX);
	    Serial.print(" ");
	}
	Serial.println("");

	// Send a reply
	vw_send((uint8_t *)msg, strlen(msg));
        digitalWrite(RED_LED, false);
    }
}
