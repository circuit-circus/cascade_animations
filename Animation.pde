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

  void setPixels(color[] pix, int[] m,  int id) {
    pixelList = pix;
    map = m;
    areaID = id;
  }

  String getType() {
    return AnimationType;
  }
  
  int getAreaID(){
    return areaID;
  }
}
