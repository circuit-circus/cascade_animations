import processing.serial.*;

SerialInterface mySerialInterface;
DataPusher myDataPusher; 
AnimationCreator animationCreator;
WeatherInterface myWeatherInterface;
WebMonitor myWebMonitor;

boolean serialActive = false;                     // Use this to turn off the Serial when running this without a microcontroller connected.
boolean showLeds = false;                          // Shows Turning this off improves performance
boolean showPixels = false;                       // Turning this off improves performance greatly

void setup() {
  size(800, 800);
  frameRate(25);
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
  if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) != myWeatherInterface.getLastUpdatedHour()) {
  //if(Calendar.getInstance().get(Calendar.MINUTE) != myWeatherInterface.getLastUpdatedHour()) {
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
  case 'n': 
    myWeatherInterface.update();
    myWeatherInterface.printLastWeatherData();
    break;
  case 'm': 
    myWebMonitor.sendAlive();
    break;
  }
  myDataPusher.keyPressed();
}

void updateWeather(){
  myWeatherInterface.updateThread();
}

void sendAliveMonitor(){
  myWebMonitor.sendAliveThread();
}
