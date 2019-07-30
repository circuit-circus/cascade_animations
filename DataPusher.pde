class DataPusher {  //<>//
  /*
      This class determines which animation to be shown where.
   */
  SerialInterface mySerialInterface;
  Circle preview;
  Circle analysis;
  Circle result;
  int sensorThreshold = 20;
  int numSensors = 6;
  boolean sensorsReady[] = new boolean[numSensors];
  int previewIndex = 0;
  int analysisIndex = 0;
  int resultLastPosition = 0;
  
  int oldData[] = {0, 0, 0, 0, 0, 0};

  ArrayList<String> allAnimations;

  DataPusher(SerialInterface si) {
    mySerialInterface = si; 
    result = new Circle(width/4*2.5, height/4*3, 200, 117, 29, mySerialInterface);
    preview = new Circle(width/4*1, height/4*1, 100, 64, 16, mySerialInterface);
    analysis = new Circle(width/4*3, height/4*1, 70, 32, 9, mySerialInterface);

    allAnimations = new ArrayList();   
    allAnimations.add("TemperatureAnimation");
    allAnimations.add("RainAnimation");    
    allAnimations.add("WindAnimation");
    allAnimations.add("CloudAnimation");
    preview.addAnimation(animationCreator.create("TemperatureAnimation"), 0);   
    preview.addAnimation(animationCreator.create("TemperatureAnimation"), 1);
    result.addAnimation(new TemperatureAnimation(), 0);    
    result.addAnimation(new TemperatureAnimation(), 1);
    analysis.addAnimation(new RedAnimation(), 0);
    analysis.addAnimation(new BlueAnimation(), 1);
  }

  void update() {
    readStates();
    preview.update();
    analysis.update();
    result.update();
    preview.display();
    analysis.display();
    result.display();
  }

  void readStates() {
    int[] data = mySerialInterface.getSensorData(); 
    //println(data);
    for (int i = 0; i < data.length; i++) {
      if (oldData[i] - data[i] > sensorThreshold && sensorsReady[i]) {
        sensorsReady[i] = false;
        toggle(str(i+1));
      } else if (oldData[i] - data[i] <= sensorThreshold) {
        sensorsReady[i] = true;
      }
    }
    oldData = data;
    //println(sensorsReady[1]);
  }

  //Used to emulate touch events
  void keyPressed() {
    toggle(str(key));
  }

  void toggle(String c) {
    switch (c) {
    case "1": 
      submitPreview();
      break; 
    case "2": 
      changePreview(false);
      break;
    case "3": 
      changeAnalysis(false);
      break;
    case "4": 
      submitAnalysis();
      break;
    case "5": 
      changeAnalysis(true);
      break;
    case "6": 
      changePreview(true);
      break;
    case "q": 
      showLeds = !showLeds;
      break;
    case "w": 
      showPixels = !showPixels;
      break;
    }
  }

  void submitPreview() {
    result.addAnimation(animationCreator.create(result.getAnimationType(1)), 0);
    result.removeAnimation(0);
    result.removeAnimation(0);
    result.addAnimation(animationCreator.create(preview.getAnimationType(0)), 1);
    println("Submitting preview");
  }

  void changePreview(boolean forward) {
    if (forward) {
      previewIndex++;
    } else {
      previewIndex--;
    }
    if (previewIndex > allAnimations.size()-1) {
      previewIndex = 0;
    } else if (previewIndex < 0) {
      previewIndex = allAnimations.size()-1;
    }
    preview.removeAnimations();
    preview.addAnimation(animationCreator.create(allAnimations.get(previewIndex)), 0);
    preview.addAnimation(animationCreator.create(allAnimations.get(previewIndex)), 1);
    println("Changing preview to: " + previewIndex + " " + preview.getAnimationType(0));
  }

  void submitAnalysis() {
    result.setAreaMode(analysisIndex);
    println("Submitting analysis");
  }

  void changeAnalysis(boolean forward) {
    if (forward) {
      analysisIndex++;
    } else {
      analysisIndex--;
    }
    if (analysisIndex > analysis.getNumberOfMaps()-1) {
      analysisIndex = 0;
    } else if (analysisIndex < 0) {
      analysisIndex = analysis.getNumberOfMaps()-1;
    }
    analysis.setAreaMode(analysisIndex);
    println("Changing analysis to: " + analysisIndex );
  }
}
