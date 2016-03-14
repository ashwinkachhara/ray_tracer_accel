class Voxel {
  ArrayList<Integer> items;
  public int hitObIndex = 0;
  
  Voxel(){
    items = new ArrayList<Integer>();
  }
  
  void addGeometry(int g){
    items.add(g);
  }
  
  float intersects(PVector d, PVector P){
    float minT = MAX_INT; 
    boolean found = false;
    for (int i=0; i<items.size(); i++) {
      float t;
      t = primitives[items.get(i)].intersects(d, P);
      if (t > 0 && t<minT) {
        //println(t);
        found = true;
        minT = t;
        hitObIndex = i;
      }
    }
    if (minT != MAX_INT)
      return minT;
    else
      return -1000;
  }
}