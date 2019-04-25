class DebugAnimation extends Animation {
  
    float noiseX = 0;
    int hue = 0;

  DebugAnimation() {
    AnimationType = "DebugAnimation";
  }

  void animate() {
    colorMode(HSB); 
    for (int i = 0; i < pixelList.length; i++) {
      float noiseVal = 0; 
      if (i > pixelList.length/2) {
        noiseVal = noise(noiseX+i/10)*200;
      } else {
        noiseVal = noise(noiseX-i/10)*200;
      }
      pixelList[i] = color(hue, 250, 255 - (noiseVal));
    }
    noiseX += 0.1;
     hue++;
     if(hue > 255){
     hue = 0;
   }
  }
  
 
}
