class SerialInterface {

  Serial myPort;    
  boolean serialActive = true;                    // Use this to turn off the Serial when running this without a microcontroller connected.
  ArrayList<StripPair> myStrips; 
  boolean firstContact = false;                    // Whether we've heard from the microcontroller
  int serialCount = 0;                             // A count of how many bytes we receive
  int expectedBytes = 4;                           // The number of bytes we expect from the Teensy
  int[] serialInArray = new int[expectedBytes];    // Where we'll put what we receive
  int[] touchArray = new int[4];                   //Holds the touch data coming from the Teensy 

  SerialInterface(PApplet pApp) {
    myStrips = new ArrayList();

    if (serialActive) {
      String portName = Serial.list()[0];
      myPort = new Serial(pApp, portName, 2000000);
      println("Serial Port: " + portName);
    }
  }

  void registerStrips(color[] is, color[] os, int id) {
    myStrips.add(new StripPair(is, os, id));
  }

  class StripPair { 
    color[] innerStripData;
    color[] outerStripData;
    int circleID;

    StripPair(color[] is, color[] os, int id) {
      innerStripData = is;
      outerStripData = os;
      circleID = id;
    }

    int getID() {
      return circleID;
    }

    color[] getInnerData() {
      return innerStripData;
    }

    color[] getOuterData() {
      return outerStripData;
    }
  }

  int[] getTouch() {
    return touchArray;
  }

  void serialEvent(Serial myPort) {
    // read a byte from the serial port:
    int inByte = myPort.read();
    println(inByte);
    // if this is the first byte received, and it's an A,
    // clear the serial buffer and note that you've
    // had first contact from the microcontroller. 
    // Otherwise, add the incoming byte to the array:
    if (firstContact == false) {
      if (inByte == 'A') { 
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller //<>//
        myPort.write('A');       // ask for more //<>//
      }
    } else {
      // Add the latest byte from the serial port to array:
      serialInArray[serialCount] = inByte;
      serialCount++;


      // If we have 3 bytes:
      if (serialCount > expectedBytes) {
        touchArray = serialInArray; // Make the data available to other parts of the program
                         //Used to denote the start of a data transfer
        //Send the color data
        for (StripPair stripPair : myStrips) {
          myPort.write(stripPair.getID());               //Begin with the ID of the Circle the data belongs to
          for (color c : stripPair.getInnerData() ) {
            myPort.write(c >> 16 & 0xFF);                 //Getting red data
            myPort.write(c >> 8 & 0xFF);                  //Getting green data
            myPort.write(c & 0xFF);                       //Getting blue data
          }
          myPort.write('+'); //Let the Teensy know that the first strip is complete
          for (color c : stripPair.getOuterData()) {
            myPort.write(c >> 16 & 0xFF); //Getting red data
            myPort.write(c >> 8 & 0xFF);  //Getting green data
            myPort.write(c & 0xFF);       //Getting blue data
          }
          myPort.write('!'); //Let the Teensy know that the second strip is complete
        }

        // print the values (for debugging purposes only):
        //println(xpos + "\t" + ypos + "\t" + fgcolor);

        // Send a capital A to request new sensor readings:
        myPort.write('A');
        // Reset serialCount:
        serialCount = 0;
      }
    }
  }
}
