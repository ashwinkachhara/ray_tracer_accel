class GridAccel extends Geometry{
  public ArrayList<Geometry> items;
  int numItems = 0;
  Voxel[] voxels;
  
  AABB bounds;
  PVector nVoxels = new PVector(0,0,0);
  PVector voxWidth = new PVector(0,0,0);
  PVector invVoxWidth = new PVector(0,0,0);
  int nv;
  
  
  GridAccel(int start, int end){
    items = new ArrayList<Geometry>();
    for (int i = start; i<end; i++) {
      items.add(objects[i]);
      numItems++;
    }
    PVector pmax = getPMax();
    PVector pmin = getPMin();
    bounds = new AABB(pmin, pmax);
    calcBoundsResolution();
    
    voxels = new Voxel[nv];
    
    addGeometryToVoxels();
  }
  
  float intersects(PVector d, PVector P){
  
  }
  PVector getNormal(PVector P){}
  PVector calcDiffuse(PVector P, PVector n, int l){}
  PVector calcAmbient(int l){}
  void printval(){}
  PVector getM1d(PVector d, PVector P){
    return d;
  }
  PVector getM1P(PVector P){
    return P;
  }
  PVector getMP(PVector P){
    return P;
  }
  PVector getPMax(){
    PVector Pmax = new PVector (-MAX_FLOAT,-MAX_FLOAT,-MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = items.get(i).getPMax();
      Pmax = new PVector(max(Pmax.x,pp.x), max(Pmax.y,pp.y), max(Pmax.z,pp.z));
    }
    return Pmax;
  }
  PVector getPMin(){
    PVector Pmin = new PVector (MAX_FLOAT,MAX_FLOAT,MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = items.get(i).getPMin();
      Pmin = new PVector(min(Pmin.x,pp.x), min(Pmin.y,pp.y), min(Pmin.z,pp.z));
    }
    return Pmin;
  }
  
  void calcBoundsResolution(){
    PVector pMax, pMin;
    pMax = getPMax();
    pMin = getPMin();
    
    PVector delta = PVector.sub(pMax,pMin);
    
    float maxdelta = max(delta.x,delta.y,delta.z);
    float invMaxWidth = 1.0/maxdelta;
    float cubeRoot = 3.0 * pow(float(numItems),1.0/3.0);
    float voxelsPerUnitDist = cubeRoot * invMaxWidth;
    
    nVoxels.x = int(delta.x*voxelsPerUnitDist);
    if (nVoxels.x > 64) nVoxels.x = 64;
    if (nVoxels.x < 1) nVoxels.x = 1;
    
    nVoxels.y = int(delta.y*voxelsPerUnitDist);
    if (nVoxels.y > 64) nVoxels.y = 64;
    if (nVoxels.y < 1) nVoxels.y = 1;
    
    nVoxels.z = int(delta.z*voxelsPerUnitDist);
    if (nVoxels.z > 64) nVoxels.z = 64;
    if (nVoxels.z < 1) nVoxels.z = 1;
    
    voxWidth.x = delta.x/nVoxels.x;
    voxWidth.y = delta.y/nVoxels.y;
    voxWidth.z = delta.z/nVoxels.z;
    
    invVoxWidth.x = (voxWidth.x == 0)? 0.0: 1.0/voxWidth.x;
    invVoxWidth.y = (voxWidth.y == 0)? 0.0: 1.0/voxWidth.y;
    invVoxWidth.z = (voxWidth.z == 0)? 0.0: 1.0/voxWidth.z;
    
    nv = int(nVoxels.x*nVoxels.y*nVoxels.z);
  }
  
  PVector voxelToPos(PVector V){
    PVector P = new PVector(0,0,0);
    
    P.x = bounds.Pmin.x + P.x*voxWidth.x;
    P.y = bounds.Pmin.y + P.y*voxWidth.y;
    P.z = bounds.Pmin.z + P.z*voxWidth.z;
    
    return P;
  }
  
  PVector posToVoxel(PVector P){
    PVector v = new PVector(0,0,0);
    
    v.x = int((P.x - bounds.Pmin.x)*invVoxWidth.x);
    if (v.x > nVoxels.x-1) v.x = nVoxels.x-1;
    if (v.x < 0) v.x = 0;
    
    v.y = int((P.y - bounds.Pmin.y)*invVoxWidth.y);
    if (v.y > nVoxels.y-1) v.y = nVoxels.y-1;
    if (v.y < 0) v.y = 0;
    
    v.z = int((P.z - bounds.Pmin.z)*invVoxWidth.z);
    if (v.z > nVoxels.z-1) v.z = nVoxels.z-1;
    if (v.z < 0) v.z = 0;
    
    return v;
  }
  
  void addGeometryToVoxels(){
    PVector pMax, pMin;
    for (int i = 0; i<numItems; i++){
      // voxel extent of geometry
      pMax = posToVoxel(items.get(i).getPMax());
      pMin = posToVoxel(items.get(i).getPMin());
      
      // add geometry to overlapping voxels
      for (int z = int(pMin.z); z < int(pMax.z); z++){
        for (int y = int(pMin.y); y < int(pMax.y); y++){
          for (int x = int(pMin.x); x < int(pMax.x); x++){
            int o = offset(x,y,z);
            voxels[o].addGeometry(i);
          }
        }
      }
    }
  }
  
  int offset(int x, int y, int z){
    return int(z*nVoxels.x*nVoxels.y + y*nVoxels.y + x);
  }
}