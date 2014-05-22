/*
    Author: Richard Vu
    
    A simple serial program i wrote to test the iRobot Motors.
    basically make sure you have it connected to the right port.
    Run the program and mouse over the application window, 
    X direction of mouse moves the right motor forward or backward.
    Y direction of mouse moves the left motor forward or backward.
*/

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

int vel_R = 0;
int vel_L = 0;

void setup() 
{
    size(1000, 1000);
    // I know that the first port in the serial list on my mac
    // is always my  FTDI adaptor, so I open Serial.list()[9].
    // On Windows machines, this generally opens COM9.
    // Open whatever port is the one you're using.
    println(Serial.list());
    String portName = Serial.list()[5];
    println(portName);
    myPort = new Serial(this, portName, 57600);
}

void draw() {
    
    background(255);
    
    vel_R=mouseX-500;
    vel_L=mouseY-500;
 
    move(vel_L, vel_R);
    
    println(vel_R+" Left: "+vel_L);
  
}

void move(int left, int right) {
    
    // Full Mode
    myPort.write(128);
    myPort.write(131);
    
    // Motor Operator
    myPort.write(145);
    
    // 2's complement right velocity 
    if(right < 0) {
        right = ~(-right) + 1;   
    }
    int highByte_R = (right >> 8) & 0xFF;
    int lowByte_R = right & 0xFF;
    myPort.write(highByte_R);
    myPort.write(lowByte_R);
    
    // 2's complement left velocity
    if(left < 0) {
        left = ~(-left) + 1;
    }
    int highByte_L = (left >> 8) & 0xFF;
    int lowByte_L = left & 0xFF;
    myPort.write(highByte_L);
    myPort.write(lowByte_L);
    
}

/*
  // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
 char val; // Data received from the serial port
 int ledPin = 4; // Set the pin to digital I/O 4
 
 void setup() {
 pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
 Serial.begin(9600); // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 }
 if (val == 'H') { // If H was received
 digitalWrite(ledPin, HIGH); // turn the LED on
 } else {
 digitalWrite(ledPin, LOW); // Otherwise turn it OFF
 }
 delay(100); // Wait 100 milliseconds for next reading
 }
 
 */
