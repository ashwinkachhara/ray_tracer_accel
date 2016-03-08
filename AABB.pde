class AABB extends Geometry {
  PVector Pmin, Pmax;
  PVector Ca = new PVector();
  PVector Cd = new PVector();
  AABB(PVector pmin, PVector pmax, PVector ka, PVector kd){
    Pmin = pmin.copy();
    Pmax = pmax.copy();
    Ca = ka.copy();
    Cd = kd.copy();
  }
  float intersects(PVector d, PVector P){
    float txm, txM, tym, tyM, tzm, tzM;
    txm = (Pmin.x-P.x)/d.x;
    txM = (Pmax.x-P.x)/d.x;
    tym = (Pmin.y-P.y)/d.y;
    tyM = (Pmax.y-P.y)/d.y;
    tzm = (Pmin.z-P.z)/d.z;
    tzM = (Pmax.z-P.z)/d.z;
    
    float tmin, tmax;
    tmin = min(txm, txM);
    tmax = max(txm, txM);
    tmin = min(tmin, min(tym, tyM));
    tmax = max(tmax, max(tym, tyM));
    tmin = min(tmin, min(tzm, tzM));
    tmax = max(tmax, max(tzm, tzM));
    
    //println(tmax+ " " + tmin);
    if (tmax < tmin)
      return -1000;
    else{
      if (tmin>0)
        return tmin;
      else
        return tmax;
    }
  }
  PVector getNormal(PVector P){
    PVector n = new PVector(0,0,0);
    if (P.x == Pmin.x)
      n = new PVector(-1,0,0);
    else if (P.x == Pmax.x)
      n = new PVector(1,0,0);
    else if (P.y == Pmin.y)
      n = new PVector(0,-1,0);
    else if (P.y == Pmax.y)
      n = new PVector(0,1,0);
    else if (P.z == Pmin.z)
      n = new PVector(0,0,-1);
    else if (P.z == Pmax.z)
      n = new PVector(0,0,1);
    return n;
  }
  PVector calcDiffuse(PVector P, PVector n, int l){
    PVector col = new PVector(0,0,0);
    PVector L = lights[l].vec2Light(P);//PVector.sub(lights[l].pos,P);
    L.normalize();
    if (PVector.dot(L,n) < 0){
      n.x = -n.x;
      n.y = -n.y;
      n.z = -n.z;
    }
    PVector lColor = lights[l].getColor();
    col.x = Cd.x*(PVector.dot(L,n))*lColor.x;
    col.y = Cd.y*(PVector.dot(L,n))*lColor.y;
    col.z = Cd.z*(PVector.dot(L,n))*lColor.z;
    return col;
  }
  PVector calcAmbient(int l){
    PVector col = new PVector(0,0,0);
    PVector lColor = lights[l].getColor();
    col.x = Ca.x*lColor.x;
    col.y = Ca.y*lColor.y;
    col.z = Ca.z*lColor.z;
    return col;
  }
  void printval(){
    
  }
  PVector getM1d(PVector d, PVector P){
    return d;
  }
  PVector getM1P(PVector P){
    return P;
  }
  PVector getMP(PVector P){
    return P;
  }
}