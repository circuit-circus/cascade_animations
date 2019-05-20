class TemperatureAnimation extends Animation {

  float noiseX = 0;
  float temperature = 0; 
  color cold;
  color hot;

  TemperatureAnimation() {
    animationType = "TemperatureAnimation";
    colorMode(HSB);
    cold = color(150, 60, 255);
    hot = color(27, 250, 255);
  }

  void animate() { 
    colorMode(HSB); 
    temperature = myWeatherInterface.getLatestTemperature();
    float colorIncrement = norm(temperature, -5, 25);
    //colorIncrement = 0.9;
    color c = lerpColor(cold, hot, colorIncrement);
    //println(temperature + " " + colorIncrement + " " + hex(c));
    for (int i = 0; i < map.length; i++) {
      float noiseVal = 0; 
      if (i > pixelList.length/2) {
        noiseVal = noise(noiseX+i/10)*200;
      } else {
        noiseVal = noise(noiseX-i/10)*200;
      }
      int index = map[i];
      //println(noiseVal);
      //float bright = brightness(c) - noiseVal;
      //c = color(hue(c), saturation(c), bright);
      pixelList[index] = c;
    }
    noiseX += 0.1;
  }
}
