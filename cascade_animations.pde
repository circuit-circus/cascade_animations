
import processing.serial.*;
SerialInterface mySerialInterface;

ArrayList<Circle> circles; 

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

  circles = new ArrayList();
  circles.add(new Circle(width/4*1, height/4*3, 200, 67, 17, mySerialInterface, 1)); //It is very important that the total number of LEDs correspond to the number of LEDs registered on the Teensy
  //circles.add(new Circle(width/  4*1, height/4*3, 200, 34, 8, mySerialInterface, 1)); //It is very important that the total number of LEDs correspond to the number of LEDs registered on the Teensy
  //circles.add(new Circle(width/4*1, height/4*1, 100, 30, 10, mySerialInterface, 2));
  //circles.add(new Circle(width/4*2, height/4*1, 100, 30, 10, mySerialInterface, 3));
  //circles.add(new Circle(width/4*3, height/4*3, 100, 30, 10, mySerialInterface, 4));
  //circles.add(new Circle(width/4*3, height/4*2, 100, 30, 10, mySerialInterface, 5));


  circles.get(0).addAnimation(new DebugAnimation(), 0);
  circles.get(0).addAnimation(new DebugAnimation(), 1);
  //circles.get(0).addAnimation(new RainAnimation(), 0);
  //circles.get(0).addAnimation(new RainAnimation(), 1);
  //circles.get(0).addAnimation(new WindAnimation(), 0);
  //circles.get(0).addAnimation(new WindAnimation(), 1);
  //circles.get(1).addAnimation(new RainAnimation(), 0);
  //circles.get(1).addAnimation(new RainAnimation(), 1);
  //circles.get(2).addAnimation(new WindAnimation(), 0);
  //circles.get(2).addAnimation(new WindAnimation(), 1);
  //circles.get(3).addAnimation(new HeatAnimation(), 0);
  //circles.get(3).addAnimation(new HeatAnimation(), 1);
  //circles.get(4).addAnimation(new MistAnimation(), 0);
  //circles.get(4).addAnimation(new MistAnimation(), 1);
}

void draw() {
  background(0);
  for (Circle circle : circles) {
    circle.update();
    if (displayAnimations) {
      circle.display();
    }
  }
  mySerialInterface.update();
  fill(255);
  textSize(15);
  text("FPS: " + frameRate, 20, 20);
}

void serialEvent(Serial myPort) {
  mySerialInterface.serialEvent();
  //println("Serial Event");
}
