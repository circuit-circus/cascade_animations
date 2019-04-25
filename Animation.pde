abstract class Animation extends Object {
  
  color[] pixelList; 
  String AnimationType = "Animation";
  
  Animation(){
    
  }
  
  Animation(Display d){
    setPixels(d.getLedData());
  }

  abstract void animate();
  
  void setPixels(color[] pix){
    pixelList = pix;
  }
  
  String getType(){
    return AnimationType;
  }
  
  
}
