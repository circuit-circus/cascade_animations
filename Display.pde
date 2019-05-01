abstract class Display {
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

  color[] downsample(color[] inArray, int[] map, boolean isCircular) {
    color[] outArray = new color[map.length / virtualDensity];
    int j = 0;
    for (int i = 0; i < map.length; i++) {
      if (1 == i % virtualDensity ) { //Make some more sophisticated downsampling code here
        outArray[j] = inArray[map[i]];
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
  
  void removeAnimations(){
    myAnimations.clear();
  }
  
  String getAnimationType(int index){
    return myAnimations.get(index).getType();
  }
}
