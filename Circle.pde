class Circle extends Display {

  int numInnerLeds, numOuterLeds, numInnerPixels, numOuterPixels;
  color[]  innerLeds, outerLeds, innerPixels, outerPixels; 
  float x, y;
  float radius = 400;
  float innerRadius = radius * 0.5;
  float outerRadius = radius * 0.9;
  int ledDiameter = 10;

  ArrayList<Animation> myAnimations;

  SerialInterface mySerialInterface;

  int myID;

  Circle(float x_, float y_, int numOuterLeds_, int numInnerLeds_, SerialInterface si, int id) {

    numInnerLeds = numInnerLeds_;
    numOuterLeds = numOuterLeds_;
    numInnerPixels = numInnerLeds * virtualDensity;
    numOuterPixels = numOuterLeds * virtualDensity;
    innerPixels = new color[numInnerPixels];
    outerPixels = new color[numOuterPixels];
    innerLeds = new color[numInnerLeds];
    outerLeds = new color[numOuterLeds];

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
    noStroke();
    ellipseMode(CENTER);

    //Drawing virtual pixels    
    for (int i = 0; i < numInnerPixels; i++) {          
      float vAngle = (TWO_PI / numInnerPixels) * i;
      fill(innerPixels[i]);
      ellipse(cos(vAngle) * innerRadius, sin(vAngle) * innerRadius, ledDiameter, ledDiameter);
    }

    for (int i = 0; i < numOuterPixels; i++) {
      float vAngle = (TWO_PI / numOuterPixels) * i;
      fill(outerPixels[i]);
      ellipse(cos(vAngle) * outerRadius, sin(vAngle) * outerRadius, ledDiameter, ledDiameter);
    }

    stroke(0);
    if (showLeds) {
      //Drawing physical LEDs
      for (int i = 0; i < numOuterLeds; i++) {
        float pAngle = (TWO_PI / numOuterLeds) * i;
        fill(outerLeds[i]);
        ellipse(cos(pAngle) * outerRadius, sin(pAngle) * outerRadius, ledDiameter, ledDiameter);
      }
      for (int i = 0; i < numInnerLeds; i++) {
        float pAngle = (TWO_PI / numInnerLeds) * i;
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
