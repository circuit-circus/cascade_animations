class Circle extends Display {

  int numInnerLeds, numOuterLeds, numInnerPixels, numOuterPixels;
  color[]  innerLeds, outerLeds, innerPixels, outerPixels; 
  float x, y;
  float radius, innerRadius, outerRadius;
  int ledDiameter = 5;

  ArrayList<Animation> myAnimations;

  SerialInterface mySerialInterface;

  int myID;

  Circle(float x_, float y_, float r, int numOuterLeds_, int numInnerLeds_, SerialInterface si, int id) {

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

    myID = id;

    x = x_;
    y = y_;

    mySerialInterface = si;
    si.registerDisplay(this);

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
        float vAngle = (TWO_PI / numOuterPixels) * i  + (TWO_PI/4);;
        fill(outerPixels[i]);
        ellipse(cos(vAngle) * outerRadius, sin(vAngle) * outerRadius, ledDiameter, ledDiameter);
      }
    }


    if (showLeds) {
      stroke(0);
      //Drawing physical LEDs
      for (int i = 0; i < numOuterLeds; i++) {
        float pAngle = (TWO_PI / numOuterLeds) * i  + (TWO_PI/4);;
        fill(outerLeds[i]);
        ellipse(cos(pAngle) * outerRadius, sin(pAngle) * outerRadius, ledDiameter, ledDiameter);
      }
      for (int i = 0; i < numInnerLeds; i++) {
        float pAngle = (TWO_PI / numInnerLeds) * i  + (TWO_PI/4);;
        fill(innerLeds[i]);
        ellipse(cos(pAngle) * innerRadius, sin(pAngle) * innerRadius, ledDiameter, ledDiameter);
      }
    }
    popMatrix();

    clearPixels();
  } //<>// //<>//

  void update() {
    for (Animation animation : myAnimations) {
      animation.animate();
    }
    outerLeds = downsample(outerPixels, numOuterLeds, true);
    innerLeds = downsample(innerPixels, numInnerLeds, true);
  }

  void addAnimation(Animation ani, int i) {
    myAnimations.add(ani);
    //ani.addPixels(innerLeds);

    if (i == 0) {
      ani.addPixels(outerPixels);
    } else if (i == 1) {
      ani.addPixels(innerPixels);
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
}
