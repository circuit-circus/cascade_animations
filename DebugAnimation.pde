class DebugAnimation extends Animation {
  
  DebugAnimation(){}
  
  void animate(){
    for (int i = 0; i < pixelList.length; i++) {
      //pixelList[i] = color(100,110,111);
      pixelList[i] = color(0,0,255);
      //pixelList[i] = color(0,0,255);  
  }
    
  }

}
