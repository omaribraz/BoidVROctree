class trail {
  PVector position;
  PVector orientation;
  public int  trailNo = 200;
  public int strength = trailNo;
  Boid b;

  trail( PVector p, PVector o, Boid _b) {
    PVector p1 = new PVector();;
    p1.set(p);
    position = p1;
    b = _b;
    PVector o1 = new PVector();;
    o1.set(o);
    orientation = o1;
    orientation.normalize();
    b.trailPop.add(this);
    
  }

  void update() {
    strength = strength - 5;
    if (strength < 1) {
      b.trailPop.remove(this);
    }
  }
}