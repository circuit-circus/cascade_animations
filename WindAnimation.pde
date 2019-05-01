class WindAnimation extends Animation { 

  /*
  A specific animation to evoke the connotations of wind
  */
  
  CompoundCurve movement; 
  CompoundCurve brightness;
  int windStartIndex = 0;
  int windLength = 50; //This can cause the program to hang if its longer than the pixelList size
  float movementBaseSpeed = 2; 

  WindAnimation() {
    AnimationType = "WindAnimation";
    movement = new CompoundCurve();
    movement.addCurve(0.3, 1, 1, 0.3, 50);
    movement.addCurve(0.3, 1, 0, 0.3, 100);
  }

  void animate() {
    for (int i = 0; i < windLength ; i++) { 
      if (i > map.length-1) { 
        i = i - map.length; 
      }
      
      int indexToWrite =  windStartIndex - i;
      if (indexToWrite < 0){ 
      indexToWrite += map.length;
      } else if (indexToWrite >= map.length) {
      indexToWrite = 0;
      }
      colorMode(RGB);
      pixelList[map[indexToWrite]] = color(255 - ((255 / windLength) * i), 255 - ((255 / windLength) * i), 255 - ((255 / windLength) * i));
    }
    windStartIndex += round(movementBaseSpeed * movement.animate());
    //println(movement.animate() + " " + windStartIndex);
    if (windStartIndex > map.length) {
      windStartIndex = windStartIndex - map.length-1;
    }
  }
}
