class WindAnimation extends Animation { 

  /*
  A specific animation to evoke the connotations of wind
   */

  CompoundCurve movement; 
  CompoundCurve brightness;
  int windStartIndex = 0;
  float lengthMax = 20, lengthMin = lengthMax/3, windLength = lengthMin; //This can cause the program to hang if its longer than the pixelList size
  float movementBaseSpeed, minSpeed = 1, maxSpeed  = 7;
  //Hurricane entails windspeeds of approx. 33 m/s 
  float windSpeed, windStill = 0, windHurricane = 35;

  WindAnimation() {
    animationType = "WindAnimation";
    movement = new CompoundCurve();
  }

  void animate() {
    windSpeed = myWeatherInterface.getLatestWind();
    //comment out to debug windSpeed with mouseX
    //windSpeed = map(mouseX, 0, width, windStill, windHurricane); println(windSpeed);

    windSpeed = constrain(windSpeed, windStill, windHurricane);

    movementBaseSpeed = map(windSpeed, windStill, windHurricane, minSpeed, maxSpeed);
    movementBaseSpeed = constrain(movementBaseSpeed, minSpeed, maxSpeed);

    windLength = map(movementBaseSpeed, minSpeed, maxSpeed, lengthMin, lengthMax);
    
    movement.addCurve(0.5, 1, 1, 0.5, movementBaseSpeed);
    movement.addCurve(0.5, 1, 1, 0.5, movementBaseSpeed);


    for (int i = 0; i < windLength; i++) { 
      if (i > map.length-1) { 
        i = i - map.length;
      }

      int indexToWrite =  windStartIndex - i;
      if (indexToWrite < 0) { 
        indexToWrite += map.length;
      } else if (indexToWrite >= map.length) {
        indexToWrite = 0;
      }
      colorMode(RGB);
      pixelList[map[indexToWrite]] = color(255 - ((255 / windLength) * i));
    }
    windStartIndex += round(movementBaseSpeed * movement.animate());
    //println(movement.animate() + " " + windStartIndex);
    if (windStartIndex > map.length) {
      windStartIndex = windStartIndex - map.length-1;
    }
  }
}
