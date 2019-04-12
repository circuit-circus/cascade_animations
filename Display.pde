class Display {
  /*
  This class should generalize the concept of have physical and virtual pixels and attaching animations to them. 
   It should maybe be abstract
   */
  
  int myID;
  int virtualDensity = 16; //Default resolution
  boolean showLeds = true;

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
      if (1 == i % virtualDensity ) { //Make 1ome more sophisticated downsampling code here
        outArray[j] = inArray[i];
        //println(j + " " + hex(outArray[j]));
        j++;
      }
    }
    return outArray;
  }
}
