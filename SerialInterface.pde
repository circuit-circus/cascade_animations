class SerialInterface {   //<>// //<>// //<>// //<>// //<>//

  Serial myPort;    
  boolean serialActive = true;                     // Use this to turn off the Serial when running this without a microcontroller connected.
  ArrayList<Display> myDisplays;                   // Stores references to the displays that led data should be pulled from. 
  boolean firstContact = false;                    // Whether we've heard from the microcontroller
  int serialCount = 0;                             // A count of how many bytes we receive
  int expectedBytes = 4;                           // The number of bytes of serial data we expect from the Teensy
  int[] serialInArray = new int[expectedBytes];    // Where we'll put what we receive
  int[] sensorData = new int[expectedBytes];       // Holds the touch data coming from the Teensy 
  int longestStrip = 84;                           // Because of the way the OctoWS2811 library works. Everything needs to be scaled to the longest strip length * 8 (the number of pins on the OctoWS2811 board). 
  int bufferChar = int('#');                       // Character that triggers SerialEvent 

  int[] gammatable = new int[256];                 // The gamma table is used for color correction on the LEDs. It is necessary to make the leds show the right colors. 
  float gamma = 1.7;                               // The gamma correction code is copied from Paul Stoffregens Movie2serial example. 

  SerialInterface(PApplet pApp) {
    myDisplays = new ArrayList();

    if (serialActive) {
      String portName = Serial.list()[0];
      myPort = new Serial(pApp, portName);
      println("Serial Port: " + portName);
      myPort.bufferUntil(bufferChar);
    }
    for (int i=0; i < 256; i++) {
      gammatable[i] = (int)(pow((float)i / 255.0, gamma) * 255.0 + 0.5); //Sets up a gamma table
    }
  }

  //Lets the SerialInterface object know which displays to pull led data from. 
  void registerDisplay(Display d) {
    myDisplays.add(d);
  }

  int[] getSensorData() {
    return sensorData;
  }

  //Stores the sensor values received via serial
  void serialEvent() {
    byte[] sensorIn = new byte[expectedBytes]; // The length of the array should correspond to the amount of sensors
    myPort.readBytes(sensorIn);
    sensorData = int(sensorIn);
    //println(sensorData[0] + " " + sensorData[1] + " " + sensorData[2] + " " + sensorData[3]);
    myPort.clear();
  }

  //Called every loop
  void update() {
    if (serialActive) {
      send();
    }
  }

  //Wraps and sends led data to serial
  void send() {
    int offset = 0;
    int pixel[] = new int[8];
    int mask; 
    int dataToSend = longestStrip * 3 * 8;
    byte[] sendData = new byte[dataToSend]; 

    //Wrapping the data to fit the OctoWS2811 expectation of a YX grid, where Y is the pins and X is the strip length. 
    //Always generate enough data for all of the pins * the longest strip. 
    for (int x = 0; x < longestStrip; x++) {
      for (int y = 0; y < 8; y++) { 
        if ( y >= myDisplays.size() || x >= myDisplays.get(y).getLedData().length) {
          pixel[y] = color(0, 0, 0);
        } else {
          //println("Sending data for display ID: " + myDisplays.get(y).getID() + " Number of LEDs: " + myDisplays.get(y).getLedData().length);
          pixel[y] = myDisplays.get(y).getLedData()[x];
        }
        pixel[y] = colorWiring(pixel[y]); // Change from RGB to GRB and apply gamma correction. 
      }

      // Convert 8 pixels to 24 bytes. Copied from Paul Stoffregens Movie2Serial example
      for (mask = 0x800000; mask != 0; mask >>= 1) {
        byte b = 0;
        for (int i=0; i < 8; i++) {
          if ((pixel[i] & mask) != 0) b |= (1 << i);
        }
        sendData[offset++] = b;
      }
    }
    myPort.write('!');
    myPort.write(sendData);
    //println(sendData);
  }

  // This changes the color order to GRB and applies gamma correction as it is on the WS2812B. 
  int colorWiring(int c) {
    int red = (c & 0xFF0000) >> 16;
    int green = (c & 0x00FF00) >> 8;
    int blue = (c & 0x0000FF);
    red = gammatable[red];
    green = gammatable[green];
    blue = gammatable[blue];
    return (green << 16) | (red << 8) | (blue); // GRB - most common wiring
  }
}
