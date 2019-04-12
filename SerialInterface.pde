class SerialInterface {  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

  Serial myPort;    
  boolean serialActive = true;                    // Use this to turn off the Serial when running this without a microcontroller connected.
  ArrayList<Display> myDisplays; 
  boolean firstContact = false;                    // Whether we've heard from the microcontroller
  int serialCount = 0;                             // A count of how many bytes we receive
  int expectedBytes = 4;                           // The number of bytes we expect from the Teensy
  int[] serialInArray = new int[expectedBytes];// Where we'll put what we receive
  int[] touchArray = new int[expectedBytes];                   //Holds the touch data coming from the Teensy 

  SerialInterface(PApplet pApp) {
    myDisplays = new ArrayList();

    if (serialActive) {
      String portName = Serial.list()[0];
      myPort = new Serial(pApp, portName, 2000000);
      println("Serial Port: " + portName);
      //myPort.bufferUntil('A');
    }
  }

  void registerDisplay(Display d) {
    myDisplays.add(d);
  }

  int[] getTouch() {
    return touchArray;
  }

  //  void update() {
  //    println("Transmitting color data for this many strips: " + myDisplays.size());
  //    myPort.write('S'); //Let the Teensy know that the transmission is complete
  //    for (Display d : myDisplays) {
  //      myPort.write(d.getID());               //Begin with the ID of the Circle the data belongs to
  //      //println("Sending data for display ID: " + d.getID() + " size: " + d.getLedData().length);
  //      for (color c : d.getLedData()) {             
  //        int r = c >> 16 & 0xFF;   //Getting red data
  //        int g = c >> 8 & 0xFF;    //Getting green data
  //        int b = c & 0xFF;         //Getting blue data
  //        //println("Color: " + r + " " + g + " " + b);
  //        myPort.write(r);                 
  //        myPort.write(g);                  
  //        myPort.write(b);
  //      }                    
  //      myPort.write('!'); //Let the Teensy know that the transmission is complete
  //    }
  //  }

  void serialEvent(Serial myPort) {

    int inByte = myPort.read();

    if (firstContact == false) {
      if (inByte == 'A') { 
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      }
    } else {
      serialInArray[serialCount] = inByte;
      serialCount++;

      if (serialCount == expectedBytes) {
        
        touchArray = serialInArray;
        println("Receiving Touch data: " + " " + serialInArray[0] + " " + serialInArray[1] + " " +serialInArray[2] + " " + serialInArray[3] + " " + serialCount);

        println("Transmitting color data for this many strips: " + myDisplays.size());
        myPort.write('S'); //Let the Teensy know to expect displaydata
        for (Display d : myDisplays) {
          myPort.write(d.getID());               //Begin with the ID of the Circle the data belongs to
          //println("Sending data for display ID: " + d.getID() + " size: " + d.getLedData().length);
          for (color c : d.getLedData()) {             
            int r = c >> 16 & 0xFF;   //Getting red data
            int g = c >> 8 & 0xFF;    //Getting green data
            int b = c & 0xFF;         //Getting blue data
            //println("Color: " + r + " " + g + " " + b);
            myPort.write(r);                 
            myPort.write(g);                  
            myPort.write(b);
          }
          serialCount = 0;
          myPort.write('!'); //Let the Teensy know that the transmission is complete
        }
      }
    }
  }
}
