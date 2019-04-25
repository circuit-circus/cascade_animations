class RedAnimation extends Animation {
  /*
    Creates a flat red color
   */

  RedAnimation() {
  }

  void animate() {
    colorMode(RGB);
    for (int i = 0; i < pixelList.length; i++) {
      pixelList[i] = pixelList[i] + color(150, 50, 50);
    }
  }
}
