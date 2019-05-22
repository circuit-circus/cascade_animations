class TemperatureAnimation extends Animation {
  float temp, minTemp = -5, breakingPoint = 5, maxTemp = 35;
  float multiplier = 25, foundation = 100, r, g, b, noise;

  TemperatureAnimation() {
    animationType = "TemperatureAnimation";
  }

  void animate() { 
    temp = myWeatherInterface.getLatestTemperature();
    //temp = map(mouseX, 0, width, minTemp, maxTemp);
    temp = constrain(temp, minTemp, maxTemp);

    colorMode(RGB);
    if (temp <= 5) {
      r = map(temp, minTemp, breakingPoint, 0, -multiplier*2);
      g = map(temp, minTemp, breakingPoint, multiplier*4, 0);
      b = map(temp, minTemp, breakingPoint, multiplier*10, multiplier*8);
    } else {
      r = 150;
      g = map(temp, breakingPoint, maxTemp, multiplier*5, -multiplier*2);
      b = map(temp, breakingPoint, maxTemp, multiplier, -multiplier*2);
    }

    for (int i = 0; i < map.length; i++) {
      float noiseVal = 0; 
      if (i > pixelList.length/2) {
        noiseVal = noise(noise+i/10)*map(temp, minTemp, maxTemp, multiplier*2, multiplier*8);
      } else {
        noiseVal = noise(noise-i/10)*map(temp, minTemp, maxTemp, multiplier*2, multiplier*8);
      }
      int index = map[i];

      color c = color(foundation+r-noiseVal, foundation+g-noiseVal, foundation+b-noiseVal);
      pixelList[index] = c;
    }
    noise += map(temp, minTemp, maxTemp, 0.001, 0.05);
  }
}
