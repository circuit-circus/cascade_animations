class WindAnimation extends Animation { //<>// //<>// //<>// //<>//

  CompoundCurve movement; 
  int windStartIndex = 0;
  int windLength = 40;
  int windSpeed = 2; 

  WindAnimation() {
    movement = new CompoundCurve();
    movement.addCurve(0, 1, 0, 0, 100);
    //movement.addCurve(0, 0.2, 0, 0, 30);
  }


  void animate() {
    for (int i = 0; i < windLength ; i++) { 
      if (i > pixelList.length-1) { 
        i = i - pixelList.length; 
      }
      
      int indexToWrite =  windStartIndex - i;
      if (indexToWrite < 0){ 
      indexToWrite += pixelList.length;
      } else if (indexToWrite >= pixelList.length) {
      indexToWrite = 0;
      }
      
      pixelList[indexToWrite] = color(255 - ((255 / windLength) * i), 255 - ((255 / windLength) * i), 255 - ((255 / windLength) * i));
    }
    windStartIndex = windStartIndex + round(windSpeed * movement.animate());
    //println(windStartIndex);
    if (windStartIndex > pixelList.length) {
      windStartIndex = windStartIndex - pixelList.length-1;
    }
  }
}
