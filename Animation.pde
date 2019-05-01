abstract class Animation extends Object {

  color[] pixelList; 
  int[] map;
  String AnimationType = "Animation";
  int areaID;

  Animation() {
  }

  Animation(Display d) {
    //setPixels(d.getLedData());
  }

  abstract void animate();

  void setPixels(color[] pix, int[] m,  int areaID) {
    pixelList = pix;
    map = m;
  }

  String getType() {
    return AnimationType;
  }
  
  int getAreaID(){
    return areaID;
  }
}
