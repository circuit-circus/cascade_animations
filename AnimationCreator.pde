class AnimationCreator{
  /*
    Utility class for creating animation by name. Should probably be static.
  */
  
  AnimationCreator(){}
  
  Animation create(String animationType){
  
    switch (animationType){
    case "HeatAnimation" : return new HeatAnimation();
    case "WindAnimation" : return new WindAnimation();
    case "MistAnimation" : return new MistAnimation();
    case "RainAnimation" : return new RainAnimation();
    case "TemperatureAnimation" : return new TemperatureAnimation();
    case "CoverAnimation" : return new CoverAnimation();
    case "CloudAnimation" : return new CloudAnimation();
    case "PrecipitationAnimation" : return new PrecipitationAnimation();
    default : println("No Such Animation " + animationType); return null;
    }
  }

}
