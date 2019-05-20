class MistAnimation extends Animation {

  float noiseX = 0;

  MistAnimation() {
    animationType = "MistAnimation";
  }

  void animate() {
    colorMode(HSB); 
    for (int i = 0; i < map.length; i++) {
      float noiseVal = noise(noiseX+i*2)*200;
      pixelList[map[i]] = color(27, 0, 255 - (noiseVal));
    }
    noiseX += 0.01;
  }
}
