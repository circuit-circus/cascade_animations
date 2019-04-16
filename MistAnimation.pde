class MistAnimation extends Animation {

  float noiseX = 0;

  MistAnimation() {
  }

  void animate() {
    colorMode(HSB); 
    for (int i = 0; i < pixelList.length; i++) {
      float noiseVal = noise(noiseX+i*2)*200;
      pixelList[i] = color(27, 0, 255 - (noiseVal));
    }
    noiseX += 0.01;
  }
}
