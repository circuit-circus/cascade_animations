class AnimationCreator{
  /*
    Utility class for creating animation by name. Should probably be static.
  */
  
  AnimationCreator(){}
  
  Animation create(String AnimationType){
  
    switch (AnimationType){
    case "HeatAnimation" : return new HeatAnimation();
    case "WindAnimation" : return new WindAnimation();
    case "MistAnimation" : return new MistAnimation();
    case "RainAnimation" : return new RainAnimation();
    default : println("No Such Animation " + AnimationType); return null;
    }
  }

}
