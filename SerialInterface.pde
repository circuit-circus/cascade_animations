class SerialInterface {   //<>// //<>// //<>// //<>// //<>// //<>// //<>//

  Serial myPort;    
  boolean serialActive = true;                    // Use this to turn off the Serial when running this without a microcontroller connected.
  ArrayList<Display> myDisplays; 
  boolean firstContact = false;                    // Whether we've heard from the microcontroller
  int serialCount = 0;                             // A count of how many bytes we receive
  int expectedBytes = 4;                           // The number of bytes we expect from the Teensy
  int[] serialInArray = new int[expectedBytes];    // Where we'll put what we receive
  int[] touchArray = new int[expectedBytes];       //Holds the touch data coming from the Teensy 
  int longestStrip = 84; 
  int bufferChar = int('#');                       // Character that triggers SerialEvent 

  SerialInterface(PApplet pApp) {
    myDisplays = new ArrayList();

    if (serialActive) {
      String portName = Serial.list()[0];
      myPort = new Serial(pApp, portName);
      println("Serial Port: " + portName);
      myPort.bufferUntil(bufferChar);
    }
  }

  void registerDisplay(Display d) {
    myDisplays.add(d);
  }

  int[] getTouch() {
    return touchArray;
  }

  void serialEvent() {
    //int inByte = myPort.peek();
    //println(inByte);
    //if (inByte == '#' || inByte == '&') {
    //  //send();
    //} else if (inByte == '!') {
    byte[] sensorIn = new byte[4];
    myPort.readBytes(sensorIn);
    touchArray = int(sensorIn);
    //println(touchArray[0] + " " + touchArray[1] + " " + touchArray[2] + " " + touchArray[3]);
    myPort.clear();
    //}
  }

  void update() {
    if (serialActive) {
      send();
    }
  }

  void send() {
    int offset = 0;
    int pixel[] = new int[8];
    int mask; 
    int dataToSend = longestStrip * 3 * 8;
    byte[] sendData = new byte[dataToSend]; 
    //Wrapping the data to fit the OctoWS2811 expectation of a YX grid, where Y is the pins and X is the strip length. 
    //Always generate enough data for all of the pins. 
    for (int x = 0; x < longestStrip; x++) {
      for (int y = 0; y < 8; y++) { 
        if ( y >= myDisplays.size() || x >= myDisplays.get(y).getLedData().length) {
          pixel[y] = color(0, 0, 0);
        } else {
          //println("Sending data for display ID: " + myDisplays.get(y).getID() + " Number of LEDs: " + myDisplays.get(y).getLedData().length);
          pixel[y] = myDisplays.get(y).getLedData()[x];
        }
      }
      
      // convert 8 pixels to 24 bytes. Copied from Paul Stoffregens Movie2Serial example
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
}
