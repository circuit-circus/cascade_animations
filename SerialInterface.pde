class SerialInterface {  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

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
    //establishContact(); // When initialized try established contact with the GazeDisplay
  }

  void registerDisplay(Display d) {
    myDisplays.add(d);
  }

  int[] getTouch() {
    return touchArray;
  }

  void serialEvent() {
    int inByte = myPort.read();
    //println(inByte);
    if (inByte == '#') {
      send();
    } else if (inByte == '!') {
      byte[] sensorIn = new byte[4];
      myPort.readBytes(sensorIn);
      touchArray = int(sensorIn);
      println(touchArray[0] + " " + touchArray[1] + " " + touchArray[2] + " " + touchArray[3]);
    }
  }

  void send() {
    int dataToSend = 0;
    for(Display d : myDisplays){
      dataToSend += d.totalLeds * 3 + 1; //Add one to account for the ID
    }
    byte[] sendData = new byte[dataToSend]; 
    for (Display d : myDisplays) {
      int count = 0;
      sendData[count] = byte(d.getID());  //Begin with the ID of the Circle the data belongs to
      count++;
      
      //println("Sending data for display ID: " + d.getID() + " size: " + d.getLedData().length);
      for (color c : d.getLedData()) {             
        int r = c >> 16 & 0xFF;   //Getting red data
        int g = c >> 8 & 0xFF;    //Getting green data
        int b = c & 0xFF;         //Getting blue data
        //println("Color: " + r + " " + g + " " + b);
        sendData[count] = byte(r);  
        count++;
        sendData[count] = byte(g);
        count++;                  
        sendData[count] = byte(b);
        count++;
        //println("Count: " + count + " " + dataToSend);
      }
    }
    myPort.write(sendData);
  }
}
