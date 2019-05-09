class HeatAnimation extends Animation {

  float noiseX = 0;

  HeatAnimation() {
    animationType = "HeatAnimation";
  }

  void animate() { 
    colorMode(HSB); 
    for (int i = 0; i < map.length; i++) {
      float noiseVal = 0; 
      if (i > pixelList.length/2) {
        noiseVal = noise(noiseX+i/10)*200;
      } else {
        noiseVal = noise(noiseX-i/10)*200;
      }
      int index = map[i];
      pixelList[index] = color(27, 250, 255 - (noiseVal)); //<>//
    }
    noiseX += 0.1;
  }
}
