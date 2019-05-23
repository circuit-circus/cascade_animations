import processing.serial.*;

SerialInterface mySerialInterface;
DataPusher myDataPusher; 
AnimationCreator animationCreator;
WeatherInterface myWeatherInterface;
WebMonitor myWebMonitor;

boolean serialActive = true;                     // Use this to turn off the Serial when running this without a microcontroller connected.
boolean showLeds = false;                          // Shows Turning this off improves performance
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
  myWeatherInterface = new WeatherInterface();
  myWebMonitor = new WebMonitor(true);
  //myWebMonitor.sendAlive();
}

void draw() {
  background(0);
  mySerialInterface.update();
  myDataPusher.update();
  fill(255);
  textSize(15);
  text("FPS: " + frameRate, 20, 20);

  // Check if an hour has passed. In that case, we should get new weather data and send an update to the monitor server
  // if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) != myWeatherInterface.getLastUpdatedHour()) {
  if(Calendar.getInstance().get(Calendar.MINUTE) != myWeatherInterface.getLastUpdatedHour()) {
    myWeatherInterface.update();

    myWebMonitor.sendAlive();
  }
}

void serialEvent(Serial myPort) {
  if (mySerialInterface != null) {
    mySerialInterface.serialEvent();
  }
  //println("Serial Event");
}

void keyPressed(){
  switch (key) {
  case 'w': 
    myWeatherInterface.update();
    myWeatherInterface.printLastWeatherData();
    break;
  case 'm': 
    myWebMonitor.sendAlive();
    break;
  }
  myDataPusher.keyPressed();
}

//Saturating color function
//color addColors(color c1, color c2) {
//  colorMode(RGB);
//  color c;

//  int r1 = (c1 >> 16) & 0xFF;  // Faster way of getting red(argb)
//  int g1 = (c1 >> 8) & 0xFF;   // Faster way of getting green(argb)
//  int b1 = c1 & 0xFF;          // Faster way of getting blue(argb)

//  int r2 = (c2 >> 16) & 0xFF;  // Faster way of getting red(argb)
//  int g2 = (c2 >> 8) & 0xFF;   // Faster way of getting green(argb)
//  int b2 = c2 & 0xFF;          // Faster way of getting blue(argb)

//  int r = min(255, r1+r2);
//  int g = min(255, g1+g2);
//  int b = min(255, b1+b2);

//  c = color(r, g, b);

//  return c;
//}
