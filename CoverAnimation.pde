class CoverAnimation extends Animation {

  float noiseX = 0;
  ArrayList<Cloud> clouds = new ArrayList();
  int maxClouds = 0;
  int cloudSize = 50;

  CoverAnimation() {
    AnimationType = "CoverAnimation";
  }

  void animate() { 
    maxClouds = ceil((map.length / (cloudSize/1.3)) * (myWeatherInterface.getLatestCloudiness()/100));
    colorMode(HSB); 
    for (int i = 0; i < map.length; i++) {
      int index = map[i];
      pixelList[index] = color(150, 200, 255);
    }

    if (clouds.size() < maxClouds) {
      clouds.add(new Cloud(round(random(0, map.length-1))));
    }

    for (int i = 0; i < clouds.size(); i++) {
      if (clouds.get(i).hasEnded()) {
        clouds.remove(i);
      } else {
        clouds.get(i).update();
      }
    }

    noiseX += 0.01;
  }

  class Cloud {

    int pos;
    float size;
    CompoundCurve grow;

    Cloud(int p) {
      pos = p;
      grow = new CompoundCurve();
      grow.addCurve(0, 1, 1, 0,random(800,2000));
    }

    void update() {
      size = grow.animate() * cloudSize;
      colorMode(RGB);
      for (int i = 0; i < size ;i++){
      float noiseVal = noise(noiseX+(i/10))*100;
      int index = round(i + (pos - (size/2)));
      index = constrain(index, 0,map.length-1);
      pixelList[map[index]] = blendColor(pixelList[map[index]] , color( 255-noiseVal,  255-noiseVal, 255-noiseVal), BLEND);
      }
    }

    boolean hasEnded() {
      return grow.hasEnded();
    }
  }
}
