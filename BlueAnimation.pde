class BlueAnimation extends Animation {
  /*
    Creates a flat blue color
  */
  
   BlueAnimation(){
  
  }
  
  void animate(){
    colorMode(RGB);
        for (int i = 0; i < map.length; i++) {
      pixelList[map[i]] = color(84,84,255);
    }
  }
}
