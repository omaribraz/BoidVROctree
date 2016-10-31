class Boid extends Vec3D {
  private Vec3D vel;
  private Vec3D acc;
  private float maxforce;
  private float maxspeed;
  public ArrayList<trail> trailPop;


  Boid( Vec3D pos, Vec3D _vel) {
    super(pos);
    vel = _vel;
    acc = new Vec3D(0, 0, 0);
    maxspeed = 2;
    maxforce = 0.07f;
    trailPop = new ArrayList<trail>();
  }

  void run() {
    flock();
    update();
    borders();
    render();
  }

  private void applyForce(Vec3D force) {
    acc.addSelf(force);
  }


  void flock() {

    List boidpos = boidoctree.getPointsWithinSphere(this.copy(), 70);

    if (boidpos != null) {

      Vec3D sep = separate(boidpos);
      Vec3D ali = align(boidpos);
      Vec3D coh = cohesion(boidpos);
      //Vec3D stig = seektrail(flock.trailPop);

      sep.scaleSelf(4.0f);
      ali.scaleSelf(0.6f);
      coh.scaleSelf(0.1f);
      //stig.scaleSelf(0.5);

      applyForce(sep);
      applyForce(ali);
      applyForce(coh);
      //applyForce(stig);
    }
  }


  void update() {

    vel.addSelf(acc);
    vel.limit(maxspeed);
    this.addSelf(vel);
    acc.scaleSelf(0);
  }

  Vec3D seek(Vec3D target) {
    Vec3D desired = target.subSelf(this);
    desired.normalize();
    desired.scaleSelf(maxspeed);
    Vec3D steer = desired.subSelf(vel);
    steer.limit(maxforce);
    return steer;
  }

  void trail() {
    //new trail(this.copy(), vel.copy(), this);
  }

  void trailupdate() {
    //noFill();
    //strokeWeight(2);
    //beginShape();
    //for (int i = 0; i < trailPop.size(); i++) {
    //  trail t = trailPop.get(i);
    //  t.update();
    //  float lerp1 = PApplet.map(t.strength, 0, t.trailNo, 0, 1);
    //  int c1 = color(60, 120, 255, 20);
    //  int c2 =color(255, 165, 0, 255);
    //  int c = lerpColor(c1, c2, lerp1);
    //  stroke(c);
    //  curveVertex(t.x, t.y, t.z);
    //}
    //endShape();
  }


  private void render() {
    stroke(255);
    pushMatrix();
    translate(x, y, z);
    obj.setFill(color(255, 255, 255));
    shape(obj);
    popMatrix();
  }

  // Separation
  Vec3D separate(List<Boid> boids) {
    float desiredseparation = 25.0f * 25.0f;
    Vec3D steer = new Vec3D(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < desiredseparation)) {
        Vec3D diff = this.sub(other);
        diff.normalize();
        diff.scaleSelf(1 / d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.scaleSelf(1 / (float) count);
    }
    if (steer.magnitude() > 0) {
      steer.normalize();
      steer.scaleSelf(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  Vec3D align(List<Boid> boids) {
    float neighbordist = 50.0f * 50.0f;
    Vec3D sum = new Vec3D(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1 / (float) count);
      sum.normalize();
      sum.scaleSelf(maxspeed);
      Vec3D steer = sum.subSelf(vel);
      steer.limit(maxforce);
      return steer;
    } else {
      return new Vec3D(0, 0, 0);
    }
  }


  // Cohesion
  Vec3D cohesion(List<Boid> boids) {
    float neighbordist = 50.0f * 50.0f;
    Vec3D sum = new Vec3D(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other);
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1 / (float) count);
      return seek(sum);
    } else {
      return new Vec3D(0, 0, 0);
    }
  }

  boolean inView(Vec3D target, float angle) {
    boolean resultBool;
    Vec3D vec = target.copy().subSelf(this.copy());
    float result = vel.copy().angleBetween(vec);
    result = degrees(result);
    resultBool = result < angle;
    return resultBool;
  }

  // Wraparound
  void borders() {
    if (x < -600) vel.scaleSelf(-3);
    if (z < -600) vel.scaleSelf(-3);
    if (y < -600) vel.scaleSelf(-3);
    if (x > 600) vel.scaleSelf(-3);
    if (z > 600) vel.scaleSelf(-3);
    if (y > 600) vel.scaleSelf(-3);
  }
}