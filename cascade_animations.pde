
import processing.serial.*;
SerialInterface mySerialInterface;
DataPusher myDataPusher; 

boolean displayAnimations = true;


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
  mySerialInterface.serialEvent();
  //println("Serial Event");
}

void keyPressed(){
  myDataPusher.keyPressed();
}
