
import traer.physics.*; 
import peasy.*;



//import ketai.sensors.*;
//KetaiSensor sensor;
//PVector accelerometer;


int numParticles = 100;
float xoff = 0.0;
ArrayList particles = new ArrayList();


PVector grav = new PVector(0.0, 0.0);
PVector origin;
boolean deploybullet = false;
boolean impact = false;
float centerX;
float centerY;
float explRad = 2.6f;
float theta = 0.0f;


ParticleSystem physics;
Particle[] p;
Particle mousep;
PImage meteor;
int nr=280;
int curmet=0;
float velo=1;
float mass=3;
float min_size=10;
float max_size=100;
float[] msize = new float[nr];
float[] m_angle = new float [nr];
float gravi=0.02;
float startshit=5;
int poistopaukku;

boolean dead=false;

int maximpacts=200;
Impact[] impacts = new Impact[maximpacts];
int blowc=0;




int maxhp=50;
int hitpoints=maxhp;

int kkk=0;

int starttime, timer, timer2, starttime2;

float rotationX, rotationY, rotationZ;
float player_x, player_y;
PImage alus_img;
ArrayList bullets;
float aspeed;
float suunta=0;
float alus_mspeed=4;
boolean slow=false;
float velx, vely;
int ls=0;
PImage tausta, tausta2;
float taustay, taustay2;
float buttonx, buttony, button_size;
float smoothx, smoothy, smoothz;
float taustaspeed=0.2;


class Impact {
  float x, y;
  float stime, timerz;
  boolean alive=false;
}

void setup () {
  size(1200, 800, P3D); 
  frameRate(60);
 
  t=0;
  frame=0;


  sparks=new spark[numsparks];  
  x=mouseX;
  y=mouseY;
  id=0;
  maxid=0;




  //   orientation(LANDSCAPE);
  //   sensor = new KetaiSensor(this);
  //   sensor.start();
  //   sensor.list();
  //   accelerometer = new PVector();


  smooth();
  
  tausta = loadImage("space-collision-1.jpg");
  tausta.resize(width, height);
  
  tausta2 = loadImage("space-collision-1.jpg");
  tausta2.resize(width, height);
  
  for (int i=0;i<maximpacts;i++) {
    Impact impact = new Impact();
    impacts[i] = impact;
    impacts[i].alive=false;
  }


  alus_img = loadImage("spaceship.png");
  imageMode(CENTER);
  alus_img.resize(100, 100);

  meteor = loadImage("meteorite.png");

  player_y=height-50; 
  player_x=width/2;

  bullets = new ArrayList();
  float nappi1, nappi2;
  buttonx=30;
  buttony=height-30;
  button_size=30;

  taustay=0;
  taustay2=height/2;

  poistopaukku =9999;

  physics = new ParticleSystem( gravi, 0.0002 );
  mousep=physics.makeParticle();
  mousep.makeFixed();

  p=new Particle[nr]; 

  curmet=0;
  for (int i=0; i<startshit;i++) {  
    p[i]=physics.makeParticle(random(mass), random(width), random(-height), 0);
    p[i].velocity().set(random(velo), 0, 0);
    msize[i]=random(min_size, max_size);
    m_angle[i]=random(360);
    physics.makeAttraction(mousep, p[i], 1800, 200);
  }

  starttime=millis();
  starttime2=millis();
  origin = new PVector(100, 100);
}

void addstone() {
  if (curmet<nr) {

    p[curmet]=physics.makeParticle(random(mass), random(width), random(-height), 0);
    p[curmet].velocity().set(random(-velo, velo), 0, 0);
    msize[curmet]=random(min_size, max_size);
    m_angle[curmet]=random(360);
    physics.makeAttraction(mousep, p[curmet], 1800, 200);
    curmet=curmet+1;
  }
}

void drawplayer(float x, float y, float size, int col) {
  image(alus_img, x, y);
}

void mousePressed() {
  if (mouseButton==LEFT) bullets.add(new Bullet(player_x-2, player_y-(alus_img.height/2), 5, 5, true));
  if (mouseButton==RIGHT) {
    addstone();
  }
  if (mouseButton==CENTER) {
    gravi+=.002;
    physics.setGravity(gravi);
  }

  //bullets.add(new Bullet(player_x-2, player_y-(alus_img.height/2), 5, 5,true));
}

class Bullet {

  float xPos;
  float yPos;
  float hPos;
  float wPos;  
  float speed = 5;
  int idd; /*********************************/
  boolean keys = false;
  boolean visible=false;


  Bullet(float _xPos, float _yPos, float _h, float _w, boolean _visible)
  {
    xPos = _xPos;
    yPos = _yPos;
    hPos = _h;
    wPos = _w;
    visible = _visible;
  }

  void movement() {
    if (visible) {
      yPos = yPos - speed;

      for (int i=0; i<curmet;i++) {

        float xp, yp, sizz;
        xp=p[i].position().x();
        yp=p[i].position().y();
        sizz=msize[i];


        if  ( (impacts[blowc].alive==true) || (yPos>0) ) {
          if ( abs(xPos - xp) < msize[i]  && abs(yPos - yp) < msize[i] ) {

            p[i]=physics.makeParticle(random(mass), random(width), random(-height), 0);
            p[i].velocity().set(random(-velo, velo), 0, 0);
            msize[i]=random(min_size, max_size);
            physics.makeAttraction(mousep, p[i], 1800, 200);
            visible=false;
            if (blowc<1) blowc=1;
            impacts[blowc].stime=millis();
            impacts[blowc].x=xPos;
            impacts[blowc].y=yPos;
            impacts[blowc].alive=true;
            blowc=blowc+1;
            // bullets.remove(index);

            origin.set(xp, yp, 0); 
            //if (blowc>maximpacts) blowc=0;
            if  (yPos>1) {
              for (int z = 0; z < numParticles; z++) {

                // circle-like initial position of explosion's Particles
                float x = explRad * cos(theta);
                float y = explRad * sin(theta);
                x = noise(xoff) * x;
                y = noise(xoff) * y;
                x += origin.x;
                y += origin.y;

                xoff = xoff + 0.5f;
                theta += 0.1f;

                PVector a = new PVector();
                PVector l = new PVector(x, y, 0);
                PVector v = PVector.sub(l, origin); 

                particles.add(new Partikle(a, v, l, random(0.1f, 0.9f)));
              }
            }
          }
        }
      }
    }
    println(blowc);
  }

  void display() {
    fill(255, 100, 0);
    strokeWeight(2);
    stroke(100, 0, 0);
    if (visible) rect(xPos, yPos, wPos, hPos);
  }
}

void explode() {
  for (int i = particles.size()-1; i >= 0; i--) {
    Partikle prt = (Partikle) particles.get(i);  
    prt.add_force(grav);
    prt.run();

    if (prt.dead()) {
      particles.remove(i);
    }
  }
}

void draw_impacts() {
  for (int i=maximpacts-1; i>0; i--) {
    if (impacts[i].alive) {
      impacts[i].timerz=millis()-impacts[i].stime;
      if (impacts[i].timerz>500) {
        impacts[i].alive=false;
         blowc=blowc-1;
         impacts[i].stime=millis();
         impacts[i].timerz=0;
        
      }
    }
    if (impacts[i].alive) {

      explode();
    }
  }
 
}

void movepaukkus() {

  for (int i = bullets.size()-1; i>=0; i--)
  {
    Bullet bullet =(Bullet) bullets.get(i);
    bullet.movement();
    bullet.display();
  }
}

void draw () { 

  player_x=mouseX;
  timer=millis()-starttime;
  timer2=millis()-starttime2;
  if (timer>5000) {
    addstone();
    starttime=millis();
  }
  if (timer2>15000) {
    starttime2=millis();
    gravi+=.002;
    physics.setGravity(gravi);
  }


  mousep.position().set( player_x, player_y, 0 );
  physics.tick();  

  drawbackground();

  drawplayer(player_x, player_y, 20, 255);

  movepaukkus();
  draw_impacts();

  taustay=taustay+taustaspeed;
  taustay2=taustay2+taustaspeed;
  if (taustay>tausta.height) {
    taustay=0;
  }
  if (taustay2>tausta2.height) {
    taustay2=0;
  }
  draw_enemy();
  if (!dead) drawpercentage(80, 30, 200, (hitpoints*100)/maxhp);
  if (hitpoints<1) {
    text("YOU ARE NOW DEAD MF", width/2, height/2);
    dead=true;
  } 
  else {
    fill(255);
    text("HP %: "+((hitpoints*100)/maxhp), 210, 40);
  }
}


void draw_enemy() {
  for (int i=0; i<curmet;i++) {  
    imageMode(CENTER);

    pushMatrix();
    translate(p[i].position().x(), p[i].position().y());
    m_angle[i]=m_angle[i]+1;
    if (m_angle[i]>=360) m_angle[i]=0;
    rotate(radians(m_angle[i]));
    translate(-p[i].position().x(), -p[i].position().y());
    image(meteor, p[i].position().x(), p[i].position().y(), msize[i], msize[i]);

    popMatrix();

    //  image(meteor,p[i].position().x(), p[i].position().y(),msize[i],msize[i]);
    float tex=p[i].position().x();
    float tey=p[i].position().y();

    if ( abs(tex - player_x) < alus_img.width  && abs(tey - player_y) < alus_img.height  ) {

      loopppi(tex, tey);
      hitpoints=hitpoints-1;
    }

    if (p[i].position().y()>height) {
      //p[i].removeParticle(i);         
      p[i].position().set(random(width), random(-height), 0);
      p[i].velocity().set(random(velo), 0, 0);
      p[i].setMass(random(mass));
      msize[i]=random(min_size, max_size);
      physics.makeAttraction(mousep, p[i], 1200, -50);
    }
  }
}

void drawbackground() {  
  pushMatrix();
  imageMode(CENTER); 
  translate(width/2, height/2);
//  tausta.blend(tausta2,0,0,tausta2.width,tausta2.height,0,0,tausta.height,tausta.width,
//  BLEND);
  image(tausta, 0, taustay);
  image(tausta, 0, taustay-(tausta.height));
  
//  image(tausta2, 0, taustay2);
//  image(tausta2, 0, taustay2-(tausta2.height));
  translate(-width/2, -height/2);
  popMatrix();
}

void drawpercentage(float x, float y, float x2, float per) {

  rectMode(CORNER);
  fill(255, 100, 0);
  strokeWeight(2);
  stroke(100, 0, 0);

  float percentage=(x2-x)*(per/100);


  fill(155, 0, 0); 
  rect(x, (int)y, x2-x, 10);


  fill(0, 0, 100);  
  rect(x, (int)y+1, percentage, 10);
}


// void onGyroscopeEvent(float x, float y, float z)
// {
// rotationX = x;
// rotationY = y;
// rotationZ = z; 
// }
// 
// void onAccelerometerEvent(float x, float y, float z, long time, int accuracy)
// {
// smoothx += 0.1 * (x - smoothx);
// smoothy += 0.1 * (y - smoothy);
// smoothz += 0.1 * (z - smoothz);
// accelerometer.set(smoothx, smoothy, smoothz);
// player_x=(width/2)+(smoothy*50);
// }


class spark
{
  float x, y;
  float theta, dtheta;
  float v;
  int age;
  float oldx, oldy;

  spark(int _x, int _y, float _dx, float _dy)
  {
    x=_x;
    y=_y;
    v=sqrt(_dx*_dx+_dy*_dy);
    theta=atan2(_dy, _dx);
    dtheta=(random(PI)-HALF_PI)*0.1;

    age=0;
    oldx=x;
    oldy=y;
  }

  void move()
  {
    oldx=x;
    oldy=y;
    if (random(50)<age)
      dtheta+=random(0.6)-0.3;
    theta+=dtheta;
    v+=random(0.2)-0.1;
    v*=0.96;
    float dx=v*cos(theta);
    float dy=v*sin(theta);
    x+=dx;
    y+=dy;
  }

  void draw()
  {

    age++;
    for (int i=0;i<random(2)+2;i++)
    {
      stroke(255, 100+random(55), 0+random(3));
      line(x, y, x+(random(-3, 3)), y+random(-3, 3));
    }
    line(oldx, oldy, x, y);
  }

  boolean old()
  {
    if (age>10)
      return true;
    else
      return false;
  }
}




spark[] sparks;
int x, y;
int oldx, oldy;
int id;
int maxid;
int t;
int frame;
int numsparks=8;



void loopppi(float xx, float yy) {

  frame++;
  oldx=x;
  oldy=y;
  x=(int) xx;
  y=(int) yy;
  sparks[id]=new spark(x, y, (x-oldx)/10, (y-oldy)/10);
  for (int i=0;i<maxid+1;i++)
  {
    sparks[i].move();
    sparks[i].draw();
  }
  id=(id+1)%sparks.length;
  if (id>maxid)
    maxid=id;
}

