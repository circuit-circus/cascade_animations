class DataPusher{
  /*
      This class determines which animation to be shown where and pushes weather data accordingly.
  */
  SerialInterface mySerialInterface;
  Circle preview;
  Circle analysis;
  Circle result;
  int sensorThreshold = 50;
  int previewIndex = 0;
  int analysisIndex = 0;
  int resultLastPosition = 0;
  
  ArrayList<String> allAnimations;
  
  DataPusher(SerialInterface si){
    mySerialInterface = si; 
    result = new Circle(width/4*2.5, height/4*3, 200, 67, 17, mySerialInterface);
    preview = new Circle(width/4*1, height/4*1, 100, 67, 17);
    analysis = new Circle(width/4*3, height/4*1, 70, 67, 17);
 //<>//
    allAnimations = new ArrayList();  //<>//
    allAnimations.add("HeatAnimation");  //<>//
    allAnimations.add("MistAnimation");  //<>//
    allAnimations.add("RainAnimation");  //<>//
    allAnimations.add("WindAnimation");
 //<>//
    preview.addAnimation(animationCreator.create("HeatAnimation"), 0);  //<>//
    preview.addAnimation(animationCreator.create("HeatAnimation"), 1);  //<>//
    result.addAnimation(new HeatAnimation(),0);  //<>//
    result.addAnimation(new HeatAnimation(),1);
    analysis.addAnimation(new RedAnimation(),0);
    analysis.addAnimation(new BlueAnimation(),1);
  }
  
  void update(){
    readStates();
    preview.update();
    analysis.update();
    result.update();
    preview.display();
    analysis.display();
    result.display();
  }
  
  void readStates(){
    int[] data = mySerialInterface.getSensorData(); 
    
    if (data[0] > sensorThreshold){
      //submitPreview();
    }
  
  }
  
  //Used to emulate touch events
  void keyPressed(){
    switch (key) {
      case '1': changePreview(false);
        break; 
      case '2': changePreview(true);
        break;
      case '3': submitPreview();
        break;
      case '4': changeAnalysis(false);
        break;
      case '5': changeAnalysis(true);
        break;
      case '6': submitAnalysis();
        break;
      case '7':
        break;
      case '8':
        break;
    }
    
  }
  
  void submitPreview(){
    result.removeAnimation(0);
    if (resultLastPosition == 0){
      resultLastPosition = 1; 
    } else {
      resultLastPosition = 0;
    }
    
    result.addAnimation(animationCreator.create(preview.getAnimationType(0)),resultLastPosition);
    println("Submit preview");
  }
  
  void changePreview(boolean forward){
    if(forward){
      previewIndex++;
    } else {
      previewIndex--; 
    }
    if (previewIndex > allAnimations.size()-1){
      previewIndex = 0;
    } else if (previewIndex < 0) {
      previewIndex = allAnimations.size()-1;
    }
    preview.removeAnimations();
    preview.addAnimation(animationCreator.create(allAnimations.get(previewIndex)),0);
    preview.addAnimation(animationCreator.create(allAnimations.get(previewIndex)),1);
    println("Changing preview to: " + previewIndex);
  }
  
  void submitAnalysis(){
    println("Submit analysis");
  }
  
  void changeAnalysis(boolean forward){
    if(forward){
      analysisIndex++;
    } else {
      analysisIndex--; 
    }
     println("Change analysis");
  }
  
}
