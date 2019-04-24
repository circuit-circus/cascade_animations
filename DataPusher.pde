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
  
  ArrayList<Animation> allAnimations;
  
  DataPusher(SerialInterface si){
    mySerialInterface = si; 
    result = new Circle(width/4*1, height/4*3, 200, 67, 17, mySerialInterface);
    preview = new Circle(width/4*2, height/4*1, 100, 67, 17);
    analysis = new Circle(width/4*1, height/4*3, 70, 67, 17);
    
    allAnimations = new ArrayList();
    allAnimations.add(new HeatAnimation());
    allAnimations.add(new RainAnimation());
    allAnimations.add(new MistAnimation());
    allAnimations.add(new WindAnimation());
    
    preview.addAnimation(allAnimations.get(0), 0);
    preview.addAnimation(allAnimations.get(0), 1);
  
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
      submitPreview();
    }
  
  }
  
  //Used to emulate touch events
  void keyPressed(){
    switch (key) {
      case 1: changePreview(false);
        break; 
      case 2: changePreview(true);
        break;
      case 3: submitPreview();
        break;
      case 4: changeAnalysis(false);
        break;
      case 5: changeAnalysis(true);
        break;
      case 6: submitAnalysis();
        break;
      case 7:
        break;
      case 8:
        break;
    }
    
  }
  
  void submitPreview(){
    result.addAnimation(preview.copyAnimation(0),0);
    result.addAnimation(preview.copyAnimation(1),1);
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
    preview.removeAnimation(0);
    preview.removeAnimation(1);
    preview.addAnimation(allAnimations.get(previewIndex),0);
    preview.addAnimation(allAnimations.get(previewIndex),1);
    println(previewIndex);
  }
  
  void submitAnalysis(){
    println("Submit analysis");
  }
  
  void changeAnalysis(boolean forward){
     println("Change analysis");
  }
  
}
