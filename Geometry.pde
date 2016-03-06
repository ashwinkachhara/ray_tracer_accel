abstract class Geometry{
  public abstract float intersects(PVector d, PVector P);
  public abstract PVector getNormal(PVector P);
  public abstract PVector getNormal(PVector P, float t);
  public abstract PVector calcDiffuse(PVector P, PVector n, int l);
  public abstract PVector calcAmbient(int l);
  public abstract void printval();
  public abstract boolean isMoving();
  public abstract float intersects(PVector d, PVector P, float t);
  public abstract PVector getM1d(PVector d, PVector P);
  public abstract PVector getM1P(PVector P);
  public abstract PVector getMP(PVector P);
}