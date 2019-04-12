class CompoundCurve {
  ArrayList<Curve> myCurves;
  float duration;
  int iterator = 0;
  boolean hasEnded = false;
  float t;  
  
  CompoundCurve() {
    myCurves = new ArrayList();
  }

  void addCurve(float y1, float cy1, float cy2, float y2, float duration) {
    myCurves.add(new Curve(y1, cy1, cy2, y2, duration));
  }

  void removeCurve(int i) {
    myCurves.remove(i);
  }

  boolean hasEnded() {
    return hasEnded;
  }

  void rewind() {
    hasEnded = false;
  }
  
  void stepForward(){
    t += 1 / myCurves.get(iterator).curve[8];

      if (t > 1) {
        t = 0;  

        iterator++;
        if (iterator > myCurves.size() - 1) {
          iterator = 0;
          hasEnded = true;
        }
      } else {
        hasEnded = false;
      }
  }
  
  void stepBackward(){
    t -= 1 / myCurves.get(iterator).curve[8];

      if (t < 0) {
        t = 1;  

        iterator--;
        if (iterator < 0) {
          iterator = 0;
          hasEnded = true;
        }
      } else {
        hasEnded = false;
      }
  }

  float getDuration() {
    duration = 0;
    for (int i = 0; i < myCurves.size(); i++) {
      duration += myCurves.get(i).curve[8];
    }
    return duration;
  }

  float getPosition() {
    float p = 0;

    for (int i = 0; i < iterator; i++) {
      p += myCurves.get(i).curve[8];
    }

    p += myCurves.get(iterator).curve[8] * t;

    return p;
  }

  float animate() {

    float y = 0;

    y = bezierPoint(myCurves.get(iterator).curve[0], myCurves.get(iterator).curve[1], myCurves.get(iterator).curve[2], myCurves.get(iterator).curve[3], t);

      t += 1 / myCurves.get(iterator).curve[4];

      if (t > 1) {
        t = 0;  

        iterator++;
        if (iterator > myCurves.size() - 1) {
          iterator = 0;
          hasEnded = true;
        }
      } else {
        hasEnded = false;
      }

    //println(t + " " + iterator + " " + y );

    return y;
  }
}
