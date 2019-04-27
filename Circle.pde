class Circle extends Display {

  int numInnerLeds, numOuterLeds, numInnerPixels, numOuterPixels;
  color[] innerLeds, outerLeds, innerPixels, outerPixels; 
  int[][][] areaMaps;
  int numAreas = 2; 
  float x, y;
  float radius, innerRadius, outerRadius;
  int ledDiameter = 5;
  String[] areaModes = {"inOut", "split", "mix", "time"}; 
  int[] currentAreaMap;

  Circle(float x_, float y_, float r, int numOuterLeds_, int numInnerLeds_, SerialInterface si) {

    radius = r;
    innerRadius = radius * 0.3;
    outerRadius = radius * 0.9;
    numInnerLeds = numInnerLeds_;
    numOuterLeds = numOuterLeds_;
    numInnerPixels = numInnerLeds * virtualDensity;
    numOuterPixels = numOuterLeds * virtualDensity;
    innerPixels = new color[numInnerPixels];
    outerPixels = new color[numOuterPixels];
    innerLeds = new color[numInnerLeds];
    outerLeds = new color[numOuterLeds];
    totalLeds = numInnerLeds + numOuterLeds; 

    x = x_;
    y = y_;

    mySerialInterface = si;
    si.registerDisplay(this);

    myAnimations = new ArrayList();
  }

  Circle(float x_, float y_, float r, int numOuterLeds_, int numInnerLeds_) {

    radius = r;
    innerRadius = radius * 0.3;
    outerRadius = radius * 0.9;
    numInnerLeds = numInnerLeds_;
    numOuterLeds = numOuterLeds_;
    numInnerPixels = numInnerLeds * virtualDensity;
    numOuterPixels = numOuterLeds * virtualDensity;
    innerPixels = new color[numInnerPixels];
    outerPixels = new color[numOuterPixels];
    innerLeds = new color[numInnerLeds];
    outerLeds = new color[numOuterLeds];
    totalLeds = numInnerLeds + numOuterLeds; 

    x = x_;
    y = y_;

    myAnimations = new ArrayList();
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
        fill(innerPixels[i]);
        ellipse(cos(vAngle) * innerRadius, sin(vAngle) * innerRadius, ledDiameter, ledDiameter);
      }

      for (int i = 0; i < numOuterPixels; i++) {
        float vAngle = (TWO_PI / numOuterPixels) * i  + (TWO_PI/4);
        fill(outerPixels[i]);
        ellipse(cos(vAngle) * outerRadius, sin(vAngle) * outerRadius, ledDiameter, ledDiameter);
      }
    }


    if (showLeds) { //<>// //<>// //<>// //<>//
      stroke(0); //<>// //<>// //<>// //<>// //<>//
      //Drawing physical LEDs //<>//
      for (int i = 0; i < numOuterLeds; i++) { //<>// //<>// //<>//
        float pAngle = (TWO_PI / numOuterLeds) * i  + (TWO_PI/4); //<>// //<>// //<>// //<>// //<>// //<>//
        ;
        fill(outerLeds[i]);
        ellipse(cos(pAngle) * outerRadius, sin(pAngle) * outerRadius, ledDiameter, ledDiameter);
      }
      for (int i = 0; i < numInnerLeds; i++) {
        float pAngle = (TWO_PI / numInnerLeds) * i  + (TWO_PI/4);
        ;
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
    outerLeds = downsample(outerPixels, numOuterLeds, true);
    innerLeds = downsample(innerPixels, numInnerLeds, true);
  } 

  void addAnimation(Animation ani, int location) {
    //The Animation should accept a set of all pixels in the display, plus a map. 
    
    myAnimations.add(ani);
    //ani.setPixels(innerLeds);
    if (location == 0) {
      ani.setPixels(outerPixels);
    } else if (location == 1) {
      ani.setPixels(innerPixels); //<>//
    }
  } 
   //<>//
  void addAnimation(String animationClassName, int location) { //<>//
    Animation ani = animationCreator.create(animationClassName);   //<>//
    if (ani == null) {  //<>//
      return; 
    }  
    myAnimations.add(ani);  
    if (location == 0) { 
      ani.setPixels(outerPixels);
    } else if (location == 1) {
      ani.setPixels(innerPixels);
    }
  }

  //Set all pixels to black
  void clearPixels() {
    for (int i = 0; i < outerPixels.length; i++) {
      outerPixels[i] = color(0, 0, 0);
    }
    for (int i = 0; i < innerPixels.length; i++) {
      innerPixels[i] = color(0, 0, 0);
    }
  }

  color[] getLedData() {
    color[] ledData = concat(outerLeds, innerLeds);
    return ledData;
  }
  
  void setAreaMode(int index){
    setAreaMode(areaModes[index]);
  }
  void setAreaMode(String areaMode){
    
    switch (areaMode){
      case "inOut" : ;
      break;
      case "split" : ;
      break;
      case "mix" : ;
      break;
      case "time": ;
      break;
      default : println("No such location mode: " + areaMode);
    
    }
    
  }
  
  void generateAreaMaps(){
    int offset = 0; //Used to offset to the right location on the physical LED string
    
    //Generate outer part of InOut mode
    int[] inOutOutMap = new int[outerPixels.length];
    for (int i = 0; i < outerPixels.length; i++){
      inOutOutMap[i] = i;
    } 
    areaMaps[0][0] = inOutOutMap;
    
    //Generate inner part of InOut mode
    int[] inOutInMap = new int[innerPixels.length];
    offset = outerPixels.length;
    for (int i = 0; i < innerPixels.length; i++){
      inOutInMap[offset+i] = i;
    } 
    areaMaps[0][1] = inOutInMap;
    
    //Generate lower part of split mode
    int[] splitDownMap = new int[outerPixels.length/2 + innerPixels.length/2];
    for (int i = 0; i < outerPixels.length/2; i++){
      splitDownMap[i] = i;
    } 
    offset = outerPixels.length;
    for (int i = 0; i < innerPixels.length/2; i++){
      splitDownMap[offset+i] = i;
    }
    areaMaps[1][0] = splitDownMap;
    
    //Generate upper part of split mode 
    int[] splitUpMap = new int[outerPixels.length/2 + innerPixels.length/2];
    offset = 0;
    for (int i = outerPixels.length/2; i < outerPixels.length; i++){
      splitUpMap[i] = i;
      offset++;
    } 
    for (int i = innerPixels.length/2; i < innerPixels.length; i++){
      splitUpMap[offset+i] = i;
    }
    areaMaps[1][1] = splitUpMap;
  }
  
 
}
