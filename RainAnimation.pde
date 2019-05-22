class RainAnimation extends Animation {
  ArrayList<Drop> myDrops = new ArrayList();
  int numDrops = 100, maxDrops = 500;
  float rain, dry = 0, rainstorm = 20;
  float noise, noiseMax = 25, time, timer;
  int baseBlue = 140;

  RainAnimation() {
    animationType = "RainAnimation";
  }

  void animate() {          
    rain = myWeatherInterface.getLatestPrecipitation();
    //Uncomment to debug number of raindrops with mouseX
    //rain = map(mouseX, 0, width, dry, rainstorm); println("rain: " + rain, "numDrops:" + numDrops);

    numDrops = round(maxDrops * norm(rain, dry, rainstorm));
    numDrops = int(constrain(numDrops, dry, maxDrops));

    colorMode(HSB);
    for (int i = 0; i < map.length; i++) {
      time = i/5.0 + timer;
      noise = map(noise(time), 0, 1, -noiseMax, noiseMax);
      pixelList[map[i]] = color(baseBlue+noise, 200, 255);
    }
    timer += 0.05;

    for (int i = 0; i<int(numDrops/20); i++) {
      if (myDrops.size() < numDrops) {
        myDrops.add(new Drop(round(random(0, map.length-1))));
      }
      //println(myDrops.size());
    }


    for (int i = 0; i < myDrops.size(); i++) {

      if (myDrops.get(i).hasEnded()) {
        myDrops.remove(i);
      } else {
        myDrops.get(i).update();
      }
    }
  }

  void setPixels(color[] pix, int[] m, int id) {
    pixelList = pix;
    map = m;
    areaID = id;
    myDrops.clear();
  }

  class Drop {
    int index;
    CompoundCurve fade;
    Drop(int i) {
      index = i;
      fade = new CompoundCurve();
      fade.addCurve(0, 0, 1, 1, map(myDrops.size(), 0, numDrops, 150, 10));
      fade.addCurve(1, 1, 0, 0, map(myDrops.size(), 0, numDrops, 150, 10));
    }

    void update() {
      colorMode(HSB);
      pixelList[map[index]] = color(baseBlue+noise, 200, fade.animate()*255);
    }

    boolean hasEnded() {
      return fade.hasEnded();
    }
  }
}
