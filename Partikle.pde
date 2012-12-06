
class Partikle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
 
  Partikle(PVector a, PVector v, PVector l, float r_) {
    acc = a;
    vel = v;
    loc = l;
    r = r_;
    timer = 50.0;
  }
   
  void run() {
    update();
    render();
  }
 
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc = new PVector();
    timer -= 0.5f;
  }
  
  void render() {
    stroke(#ffffff, timer*2);
    point(loc.x,loc.y);
   // ellipse(loc.x,loc.y,5,5);
  }
  
 void add_force(PVector force) {
    acc.add(force);
  } 
 
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

