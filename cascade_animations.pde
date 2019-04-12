
import processing.serial.*;
SerialInterface mySerialInterface;

ArrayList<Circle> circles; 


void setup() {
  size(800, 800);
  
  try { // Try to establish connection to the Teensy
    mySerialInterface = new SerialInterface(this);
  } 
  catch (Exception e) {
    println(e);
    println("Could not start serial connection");
  }
  
  circles = new ArrayList();
  circles.add(new Circle(width/2, height/2, 17, 4, mySerialInterface, 1)); //It is very important that the total number of LEDs correspond to the number of LEDs registered on the Teensy
  //circles.add(new Circle(width/2, height/2, 15, 20, mySerialInterface, 1));

  circles.get(0).addAnimation(new WindAnimation(), 0);
  circles.get(0).addAnimation(new WindAnimation(), 1);
  
}

void draw() {
  background(0);

  for (Circle circle : circles) {
    circle.update();
    circle.display();
  }
  //mySerialInterface.update();
}

void serialEvent(Serial myPort) {
  mySerialInterface.serialEvent(myPort);
}
