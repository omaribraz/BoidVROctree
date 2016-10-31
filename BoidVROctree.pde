import processing.cardboard.*;
import java.util.*;
import toxi.geom.*;
//import peasy.*;
Flock flock;
//PeasyCam cam;
PShape obj;
Octree boidoctree;

void setup() {
   fullScreen(PCardboard.STEREO);
   orientation(LANDSCAPE);
   
  //size(600, 300, P3D);
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(1);
  //cam.setMaximumDistance(2000);

  obj = loadShape("drone.obj");
  obj.scale(1);
  obj.setFill(color(255, 255, 255));

  boidoctree = new Octree(new Vec3D(-1, -1, -1).scaleSelf(new Vec3D(600, 600, 600)), 1500);


  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(new Vec3D(random(-500, 500), random(-500, 500), random(-500, 500)), new Vec3D(random(-TWO_PI, TWO_PI), random(-TWO_PI, TWO_PI), random(-TWO_PI, TWO_PI))));
  }
  
 
}

void draw() {
  background(0);
  boidoctree.run();
  pushMatrix();
  translate(0, 0, 700);
  flock.run();
  stroke(255);
  noFill();
  box(1200);
  popMatrix();
}