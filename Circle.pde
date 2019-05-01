class Circle extends Display {

  int numInnerLeds, numOuterLeds, numInnerPixels, numOuterPixels;
  color[] innerLeds, outerLeds;
  color[] allPixels; 
  float x, y;
  float radius, innerRadius, outerRadius;
  int ledDiameter = 5;
  //String[] areaModes = {"inOut", "split", "mix", "time"};
  String[] areaModes = {"inOut", "split"};
  int numAreas = 2; 
  int[][][] areaMaps = new int[areaModes.length][numAreas][]; //This way of storing maps work but is a bit tricky to read
  int[][] currentAreaMap;

  Circle(float x_, float y_, float r, int numOuterLeds_, int numInnerLeds_, SerialInterface si) {

    radius = r;
    innerRadius = radius * 0.3;
    outerRadius = radius * 0.9;
    numInnerLeds = numInnerLeds_;
    numOuterLeds = numOuterLeds_;
    numInnerPixels = numInnerLeds * virtualDensity;
    numOuterPixels = numOuterLeds * virtualDensity;
    allPixels = new color[numInnerPixels+numOuterPixels];
    innerLeds = new color[numInnerLeds];
    outerLeds = new color[numOuterLeds];
    totalLeds = numInnerLeds + numOuterLeds; 

    x = x_;
    y = y_;

    mySerialInterface = si;
    si.registerDisplay(this);

    myAnimations = new ArrayList();

    generateAreaMaps(); 
    currentAreaMap = areaMaps[0];
  }

  Circle(float x_, float y_, float r, int numOuterLeds_, int numInnerLeds_) {

    radius = r;
    innerRadius = radius * 0.3;
    outerRadius = radius * 0.9;
    numInnerLeds = numInnerLeds_;
    numOuterLeds = numOuterLeds_;
    numInnerPixels = numInnerLeds * virtualDensity;
    numOuterPixels = numOuterLeds * virtualDensity;
    allPixels = new color[numInnerPixels+numOuterPixels];
    innerLeds = new color[numInnerLeds];
    outerLeds = new color[numOuterLeds];
    totalLeds = numInnerLeds + numOuterLeds; 

    x = x_;
    y = y_;

    myAnimations = new ArrayList();
    generateAreaMaps(); 
    currentAreaMap = areaMaps[0];
  }

  void display() {
    pushMatrix();
    translate(x, y);

    ellipseMode(CENTER);

    //Drawing virtual pixels
    if (showPixels) {
      noStroke();
      for (int i = 0; i < numInnerPixels; i++) {          
        float vAngle = (TWO_PI / numInnerPixels) * i + (TWO_PI/4);
        fill(allPixels[areaMaps[0][1][i]]);
        ellipse(cos(vAngle) * innerRadius, sin(vAngle) * innerRadius, ledDiameter, ledDiameter);
      }

      for (int i = 0; i < numOuterPixels; i++) {
        float vAngle = (TWO_PI / numOuterPixels) * i  + (TWO_PI/4);
        fill(allPixels[areaMaps[0][0][i]]);
        ellipse(cos(vAngle) * outerRadius, sin(vAngle) * outerRadius, ledDiameter, ledDiameter);
      }
    }
    if (showLeds) {    //<>//
      stroke(0);    //<>//
      //Drawing physical LEDs   //<>//
      for (int i = 0; i < numOuterLeds; i++) {     //<>//
        float pAngle = (TWO_PI / numOuterLeds) * i  + (TWO_PI/4);    //<>//
        fill(outerLeds[i]);  //<>//
        ellipse(cos(pAngle) * outerRadius, sin(pAngle) * outerRadius, ledDiameter, ledDiameter);  //<>//
      }
      for (int i = 0; i < numInnerLeds; i++) {
        float pAngle = (TWO_PI / numInnerLeds) * i  + (TWO_PI/4);
        fill(innerLeds[i]);
        ellipse(cos(pAngle) * innerRadius, sin(pAngle) * innerRadius, ledDiameter, ledDiameter);
      }
    }
    popMatrix();

    clearPixels();
  } 

  void update() {
    for (Animation animation : myAnimations) {
      animation.animate();
    } 
    outerLeds = downsample(allPixels, areaMaps[0][0], true);
    innerLeds = downsample(allPixels, areaMaps[0][1], true);
  } 

  void addAnimation(Animation ani, int location) {
    myAnimations.add(ani);
    //ani.setPixels(innerLeds);  
    ani.setPixels(allPixels, currentAreaMap[location], location);
  }  

  void addAnimation(String animationClassName, int location) { 
    Animation ani = animationCreator.create(animationClassName);    
    if (ani == null) {    //<>//
      return;
    }    //<>//
    myAnimations.add(ani); //<>//
    if (location == 0) {    //<>//
      ani.setPixels(allPixels, currentAreaMap[location], location); //<>//
    } else if (location == 1) {  //<>//
      ani.setPixels(allPixels, currentAreaMap[location], location); //<>//
    }
  }

  //Set all pixels to black
  void clearPixels() {
    for (int i = 0; i < allPixels.length; i++) {
      allPixels[i] = color(0, 0, 0);
    }
  }

  color[] getLedData() {
    color[] ledData = concat(outerLeds, innerLeds);
    return ledData;
  }

  void setAreaMode(int index) {
    setAreaMode(areaModes[index]);
    
  }
  void setAreaMode(String areaMode) {

    switch (areaMode) {
    case "inOut" : 
      currentAreaMap = areaMaps[0];
      updateAnimationPixels();
      break;
    case "split" : 
      currentAreaMap = areaMaps[1];
      updateAnimationPixels();
      break;
    case "mix" : 
      currentAreaMap = areaMaps[2];
      updateAnimationPixels();
      break;
    case "time": 
      currentAreaMap = areaMaps[3];
      updateAnimationPixels();
      break;
    default : 
      println("No such location mode: " + areaMode);
    }
  }
  
  void updateAnimationPixels(){
    for (Animation a : myAnimations){
      int loc = a.getAreaID();
      a.setPixels(allPixels, currentAreaMap[loc], loc);
    }  
  }

  int getNumberOfMaps() {
    return areaMaps.length;
  }

  void generateAreaMaps() {
    int offset = 0; //Used to offset to the right location on the physical LED string
    int count = 0; //Used to count to the right position in the array

    //Generate outer part of InOut mode
    int[] inOutOutMap = new int[numOuterPixels];
    for (int i = 0; i < numOuterPixels; i++) {
      inOutOutMap[i] = i;
      count++;
    } 
    areaMaps[0][0] = inOutOutMap;

    //Generate inner part of InOut mode
    offset = numOuterPixels;
    int[] inOutInMap = new int[numInnerPixels];
    for (int i = 0; i < numInnerPixels; i++) {
      inOutInMap[i] = offset + i;
    } 
    areaMaps[0][1] = inOutInMap;

    //Generate lower part of split mode
    offset = 0;
    count = 0;
    int[] splitDownMap = new int[numOuterPixels/2 + numInnerPixels/2];
    for (int i = 0; i < numOuterPixels/2; i++) {
      splitDownMap[i] = i;
      count++;
    } 
    offset = numOuterPixels;
    for (int i = 0; i < numInnerPixels/2; i++) {
      splitDownMap[i+count] = offset+i;
    }
    areaMaps[1][0] = splitDownMap;

    //Generate upper part of split mode 
    offset = numOuterPixels/2;
    count = 0;
    int[] splitUpMap = new int[numOuterPixels/2 + numInnerPixels/2];
    for (int i = 0; i < numOuterPixels/2; i++) {
      splitUpMap[i] = offset + i;
      count++;
    } 
    offset = numOuterPixels + numInnerPixels/2;
    for (int i = 0; i < numInnerPixels/2; i++) {
      splitUpMap[count+i] = offset + i;
    }
    areaMaps[1][1] = splitUpMap;
  }
}
