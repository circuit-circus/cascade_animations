class Curve {
  /*
    This class is used to contain 1 dimensional bezier curves
  */
  
  float[] curve = {0.0, 0.0, 1.0, 1.0, 20}; //Default curve

  Curve() {

  }
  
  Curve(float y1, float cy1, float cy2, float y2, float d) {
    curve[0] = y1;
    curve[1] = cy1;
    curve[2] = cy2;
    curve[3] = y2;
    curve[4] = d;
  }

}
