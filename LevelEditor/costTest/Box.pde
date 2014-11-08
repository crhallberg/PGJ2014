// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A rectangular box

int priceFactor = 20;
int worthFactor = 3;

class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w, h, worth;
  int price;
  boolean dead = false;
  Vec2 prev;

  // Constructor
  Box(float x, float y) {
    w = random(max(10, y/6), max(20, y/3));
    h = w;
    price = ceil(w*priceFactor);
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
    prev = new Vec2(x, y);
  }

  void setWorth(float largest) {
    this.worth = this.w*worthFactor/largest;
  }

  // This function removes the particle from the box2d world
  float killBody() {
    box2d.destroyBody(body);
    dead = true;
    return price;
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
    }
    return dead;
  }

  // Drawing the box
  float display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    if (price > money) {
      stroke(255, 0, 0);
      fill(255, 200, 200);
    } else {
      if (inside(mouseX, mouseY)) {
        stroke(0, 0, 255);
      } else {
        stroke(0, 255, 0);
      }
      fill(200, 255, 200);
    }
    rect(0, 0, w, h);

    fill(0, 150);
    textSize(min(h/2, 24));
    text("$"+nfc(price, 0), 0, 0);
    popMatrix();

    float d = dist(prev.x, prev.y, pos.x, pos.y);
    prev = pos;
    if(playerStarted) {
      return d * worth;
    } else {
      return d/10;
    }
  }

  boolean inside(float x, float y)
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    float a2 = atan2(pos.x-x, pos.y-y);
    float da = a2-a;
    float d = dist(x, y, pos.x, pos.y);
    float tx = d*sin(-da);
    float ty = -d*cos(da);
    //ellipse(tx, ty, 5, 5);
    return tx > -w/2 && tx < w/2 && ty > -h/2 && ty < h/2;
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

