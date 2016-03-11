class List extends Geometry {
  AABB bbox;

  Geometry[] items;
  int numItems = 0;
  public int hitObIndex = 0;

  List(int start, int end) {
    items = new Geometry[end-start];
    for (int i = start; i<end; i++) {
      items[numItems] = objects[i];
      numItems++;
    }
    //compute box
    //println("Hello",items.length);
    bbox = new AABB(new PVector(-2, -2, -2), new PVector(2, 2, 2));
  }
  float intersects(PVector d, PVector P) {
    float minT = MAX_INT; 
    boolean found = false;
    if (bbox.intersects(d, P) == -1000){
      //println("no box");
      return -1000;
    } else {
      //println("box");
      for (int i=0; i<numItems; i++) {
        float t;
        t = items[i].intersects(d, P);
        if (t > 0 && t<minT) {
          //println(t);
          found = true;
          minT = t;
          hitObIndex = i;
        }
      }
      return minT;
    }
  }
  PVector getNormal(PVector P) {
    return items[hitObIndex].getNormal(P);
  }
  PVector calcDiffuse(PVector P, PVector n, int l) {
    return items[hitObIndex].calcDiffuse(P, n, l);
  }
  PVector calcAmbient(int l) {
    return items[hitObIndex].calcAmbient(l);
  }

  void printval() {
  }
  PVector getM1d(PVector d, PVector P) {
    return d;
  }
  PVector getM1P(PVector P) {
    return P;
  }
  PVector getMP(PVector P) {
    return P;
  }
}