abstract class Animation {
  
  color[] pixelList; 
  
  Animation(){
  }


  abstract void animate();
  
  void addPixels(color[] pix){
    pixelList = pix;
  }
}
