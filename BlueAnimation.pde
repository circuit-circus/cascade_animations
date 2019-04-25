class BlueAnimation extends Animation {
  /*
    Creates a flat blue color
  */
  
   BlueAnimation(){
  
  }
  
  void animate(){
    colorMode(RGB);
        for (int i = 0; i < pixelList.length; i++) {
      pixelList[i] = color(50,50,150);
    }
  }
}
