class AnimationCreator {
  /*
    Utility class for creating animation by name. Should probably be static.
   */

  AnimationCreator() {
  }

  Animation create(String animationType) {
    switch (animationType) {
    case "TemperatureAnimation" : 
      return new TemperatureAnimation();
    case "WindAnimation" : 
      return new WindAnimation();
    case "RainAnimation" : 
      return new RainAnimation();
    case "CloudAnimation" : 
      return new CloudAnimation();
    default : 
      println("No Such Animation " + animationType); 
      return null;
    }
  }
}
