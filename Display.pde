class Display {
  /*
  This class should generalize the concept of have physical and virtual pixels and attaching animations to them. 
   It should maybe be abstract
   */
  int totalLeds = 0;
  int myID;
  int virtualDensity = 5; //Default resolution
  boolean showLeds = true;
  boolean showPixels = false;
  ArrayList<Animation> myAnimations;

  SerialInterface mySerialInterface;


  Display() {
  }

  color[] getLedData() {
    color[] ledData = new color[1];
    return ledData;
  }

  int getID() {
    return myID;
  }

  color[] downsample(color[] inArray, int numOutLeds, boolean isCircular) {
    color[] outArray = new color[numOutLeds];
    int j = 0;
    for (int i = 0; i < inArray.length; i++) {
      if (1 == i % virtualDensity ) { //Make some more sophisticated downsampling code here
        outArray[j] = inArray[i];
        //println(j + " " + hex(outArray[j]));
        j++;
      }
    }
    return outArray;
  }
  
  void addAnimation(){}
  
  void removeAnimation(int index){
    if (index < myAnimations.size() && index >= 0){
    myAnimations.remove(index);
    }
  }
  
  Animation copyAnimation(int index){
    return myAnimations.get(index);
  }
  
  Animation copyAnimation(){
    return copyAnimation(0);
  }
}
