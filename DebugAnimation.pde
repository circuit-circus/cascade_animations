class DebugAnimation extends Animation {
  
  DebugAnimation(){}
  
  void animate(){
    for (int i = 0; i < pixelList.length; i++) {
      pixelList[i] = color(111,222,333);
    }
  }

}
