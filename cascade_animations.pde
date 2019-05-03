
import processing.serial.*;
SerialInterface mySerialInterface;
DataPusher myDataPusher; 
AnimationCreator animationCreator;

boolean serialActive = true;                     // Use this to turn off the Serial when running this without a microcontroller connected.
boolean showLeds = true;                          // Shows Turning this off improves performance
boolean showPixels = false;                       // Turning this off improves performance greatly

void setup() {
  size(800, 800);
  frameRate(60);
  try { // Try to establish connection to the Teensy
    mySerialInterface = new SerialInterface(this);
  } 
  catch (Exception e) {
    println(e);
    println("Could not start serial connection");
  }

  animationCreator = new AnimationCreator();
  myDataPusher = new DataPusher(mySerialInterface);
}

void draw() {
  background(0);
  mySerialInterface.update();
  myDataPusher.update();
  fill(255);
  textSize(15);
  text("FPS: " + frameRate, 20, 20);
}

void serialEvent(Serial myPort) {
  if (mySerialInterface != null) {
    mySerialInterface.serialEvent();
  }
  //println("Serial Event");
}

void keyPressed() {
  myDataPusher.keyPressed();
}
