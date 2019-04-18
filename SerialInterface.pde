class SerialInterface {   //<>// //<>// //<>// //<>// //<>//

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
      println(touchArray[0] + " " + touchArray[1] + " " + touchArray[2] + " " + touchArray[3]);
      myPort.clear();
    //}
  }
  
  void update(){
  send();
  }

  void send() {
    int dataToSend = longestStrip * 3 * 8;
    byte[] sendData = new byte[dataToSend]; 
    //Wrapping the data to fit the OctoWS2811 expectation of a XY grid. 
    for (int y = 0; y < 8; y++) { 
      color[] displayData;
      if ( y >= myDisplays.size()){
        displayData = new color[1];
      } else {
      println("Sending data for display ID: " + myDisplays.get(y).getID() + " Number of LEDs: " + myDisplays.get(y).getLedData().length);
      displayData = myDisplays.get(y).getLedData();
      }
      for (int x = 0; x < longestStrip; x++){ 
        int rgb;
        if (x >= displayData.length){
        rgb = 0;  
        } else {
        rgb = displayData[x];
        }
        int r = rgb >> 16 & 0xFF;   //Getting red data
        int g = rgb >> 8 & 0xFF;    //Getting green data
        int b = rgb & 0xFF;         //Getting blue data
        
        //Pack the data in GRB order to accomodate for the Neopixel wiring
        sendData[x * 3 + y * longestStrip] = byte(g); 
        sendData[x * 3 + y * longestStrip + 1] = byte(r); 
        sendData[x * 3 + y * longestStrip + 2] = byte(b); 
      }
    }
    myPort.write('!');
    myPort.write(sendData);
    //println(sendData.length);
  }
}
