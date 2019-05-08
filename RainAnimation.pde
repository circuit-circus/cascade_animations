class RainAnimation extends Animation {

  /*
    A specific animation to evoke the connotations of rain
   */
 
  ArrayList<Drop> myDrops = new ArrayList();
  int numDrops = 400; 
  RainAnimation() {
    AnimationType = "RainAnimation";
  }

  void animate() {
    numDrops = round(600 * norm(myWeatherInterface.getLatestPrecipitation(),0, 20));
    if (myDrops.size() < numDrops) {
      myDrops.add(new Drop(round(random(0, map.length-1))));
    }

    for (int i = 0; i < myDrops.size(); i++) {
      if (myDrops.get(i).hasEnded()) {
        myDrops.remove(i);
      } else {
        myDrops.get(i).update();
      }
    }
  }
  
   void setPixels(color[] pix, int[] m,  int id) {
    pixelList = pix;
    map = m;
    areaID = id;
    myDrops.clear();
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
      pixelList[map[index]] = color(150, 200, fade.animate()*255);
    }

    boolean hasEnded() {
      return fade.hasEnded();
    }
  }
}
