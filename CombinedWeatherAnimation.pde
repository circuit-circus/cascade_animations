class CombinedWeatherAnimation extends Animation {
  
   float noiseX = 0;
      
  ArrayList<Drop> myDrops = new ArrayList();
  int numDrops = 400; 
  
    CompoundCurve movement; 
  CompoundCurve brightness;
  int windStartIndex = 0;
  int windLength = 50; //This can cause the program to hang if its longer than the pixelList size
  float movementBaseSpeed = 2; 
  
  CombinedWeatherAnimation(){
    
  }
  
  void animate(){
      colorMode(HSB); 
    for (int i = 0; i < pixelList.length; i++){
      float noiseVal = noise(noiseX+i/10)*100;
      noiseX += 0.001;
      pixelList[i] = color(27, 250, 255 - (noiseVal));
    }
    
     if (myDrops.size() < numDrops) {
      myDrops.add(new Drop(round(random(0, pixelList.length-1))));
    }

    for (int i = 0; i < myDrops.size(); i++) {
      if (myDrops.get(i).hasEnded()) {
        myDrops.remove(i);
      } else {
        myDrops.get(i).update();
      }
    }
  
  }
  
  class Drop {
    int index;
    int life = 100;
    CompoundCurve fade;
    Drop(int i) {
      index = i;
      fade = new CompoundCurve();
      fade.addCurve(1, 1, 0, 0, 20);
    }

    void update() {
      colorMode(HSB);
      pixelList[index] = color(150, 200, fade.animate()*255);
    }

    boolean hasEnded() {
      return fade.hasEnded();
    }
  }

}
