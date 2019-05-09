class RedAnimation extends Animation {
  /*
    Creates a flat red color
   */

  RedAnimation() {
    animationType = "red";
  }

  void animate() {
    colorMode(RGB);
    for (int i = 0; i < map.length; i++) {
      pixelList[map[i]] = color(150, 50, 50);
    }
  }
}
