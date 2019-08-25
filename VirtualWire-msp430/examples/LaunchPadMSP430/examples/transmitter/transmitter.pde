// transmitter.pde
//
// Simple example of how to use VirtualWire to transmit messages
// Implements a simplex (one-way) transmitter with an TX-C1 module
//
// See VirtualWire.h for detailed API docs
// Author: Mike McCauley (mikem@open.com.au)
// Copyright (C) 2008 Mike McCauley
// $Id: transmitter.pde,v 1.3 2009/03/30 00:07:24 mikem Exp $
//
//	Port to Energia / MPS430 by Yannick DEVOS XV4Y - (c) 2013
//	http://xv4y.radioclub.asia/
//	

#include <VirtualWire.h>

void setup()
{
    Serial.begin(9600);	  // Debugging only
    Serial.println("setup");

    // Initialise the IO and ISR
	pinMode(RED_LED, OUTPUT);     
    vw_set_ptt_inverted(true); // Required for DR3100
    vw_set_tx_pin(P2_2);
    vw_setup(2000);	 // Bits per sec
}

void loop()
{
    const char *msg = "hello";

    digitalWrite(RED_LED, true); // Flash a light to show transmitting
    vw_send((uint8_t *)msg, strlen(msg));
    vw_wait_tx(); // Wait until the whole message is gone
    digitalWrite(RED_LED, false);
    delay(200);
}
