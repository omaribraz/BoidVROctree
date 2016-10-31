class Octree extends PointOctree {



    Octree(Vec3D o, float d){
        super(o,d);
    }
    void addBoid(Boid b) {
        addPoint(b);
    }


    void run() {
        updateTree();
        //drawNode(this);
    }

    private void updateTree() {
        empty();
        for (Boid b : flock.boids) {
            addBoid(b);
        }
    }

    void draw() {
        drawNode(this);
    }

    private void drawNode(PointOctree n) {
        if (n.getNumChildren() > 0) {
            noFill();
            stroke(255);
            pushMatrix();
            translate(n.x, n.y, n.z);
            box(n.getNodeSize());
            popMatrix();
            PointOctree[] childNodes=n.getChildren();
            for (int i = 0; i < 8; i++) {
                if (childNodes[i] != null) drawNode(childNodes[i]);
            }
        }
    }

}