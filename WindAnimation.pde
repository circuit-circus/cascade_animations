class WindAnimation extends Animation { 

  /*
  A specific animation to evoke the connotations of wind
   */

  CompoundCurve movement; 
  CompoundCurve brightness;
  float windStartIndex = 0.0;
  float lengthMax = 15, lengthMin = lengthMax/3, windLength = lengthMin; //This can cause the program to hang if its longer than the pixelList size
  float movementBaseSpeed, minSpeed = 1, maxSpeed = 30;
  //Hurricane entails windspeeds of approx. 33 m/s 
  float windSpeed, windStill = 0, windHurricane = 33;

  WindAnimation() {
    animationType = "WindAnimation";
    movement = new CompoundCurve();
    
    windSpeed = myWeatherInterface.getLatestWind();
    //comment out to debug windSpeed with mouseX
    //windSpeed = map(mouseX, 0, width, windStill, windHurricane); println(windSpeed);

    windSpeed = constrain(windSpeed, windStill, windHurricane);
    println(windSpeed);

    movementBaseSpeed = map(windSpeed, windStill, windHurricane, minSpeed, maxSpeed) ;
    movementBaseSpeed = constrain(movementBaseSpeed, minSpeed, maxSpeed);
    
    println(movementBaseSpeed);

    windLength = map(movementBaseSpeed, minSpeed, maxSpeed, lengthMin, lengthMax);
    
    println(windLength);
        
    movement.addCurve(0.5, 1, 1, 0.5, movementBaseSpeed);
    movement.addCurve(0.5, 1, 1, 0.5, movementBaseSpeed);
  }

  void animate() {
   
    for (int i = 0; i < windLength; i++) { 
      if (i > map.length-1) { 
        i = i - map.length;
      }

      int indexToWrite =  round(windStartIndex - i);
      if (indexToWrite < 0) { 
        indexToWrite += map.length;
      } else if (indexToWrite >= map.length) {
        indexToWrite = 0;
      }
      colorMode(RGB);
      pixelList[map[indexToWrite]] = color(255 - ((255 / windLength) * i));
    }
    
    windStartIndex += movementBaseSpeed * movement.animate() / 5.0;
    //println(movement.animate() + " " + windStartIndex);
    if (windStartIndex > map.length) {
      windStartIndex = windStartIndex - map.length-1;
    }
  }
}
