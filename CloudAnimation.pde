class CloudAnimation extends Animation {
  float percentage = 100, cloudThresHoldOffset, cloudiness;
  float noise, time, timer;
  boolean makeCloud;
  color c;


  CloudAnimation() {
    animationType = "CloudAnimation";
  }

  void animate() {
    cloudThresHoldOffset = map(cloudiness, 0, percentage, 10, -20);
    cloudiness = myWeatherInterface.getLatestCloudiness()+cloudThresHoldOffset;
    //Uncomment to test cloudiness percentage with mouseX
    //cloudiness = map(mouseX, 0, width, 0, 100)+cloudThresHoldOffset; println("Cloudiness: " + cloudiness);
    
    cloudiness = constrain(cloudiness, 0, percentage);

    float[] cloudChance = new float[map.length];
    for (int i = 0; i < map.length; i++) {
      time = i/15.0;
      cloudChance[i] = map(noise(time+timer), 0, 1, 0, percentage);
      if (cloudChance[i] < cloudiness) {
        makeCloud = true;
      } else {
        makeCloud = false;
      }

      colorMode(RGB);
      if (makeCloud) {
        c = color(150+map(cloudChance[i], 0, percentage, percentage, 25));
      } else {
        c = color(5, 20+cloudChance[i]/2, 100+cloudChance[i]/2);
      }

      int index = map[i];
      pixelList[index] = c;
    }
    timer += 0.0025;
  }
}
