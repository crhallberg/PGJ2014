// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Basic example of falling rectangles

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;

float money = 0;
boolean pmousePressed = false;
boolean playerStarted = false;

void setup() {
  size(1366, 768, P2D);
  textAlign(CENTER);
  //smooth();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  // Create ArrayLists	
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(-100, 0, 100, height));
  boundaries.add(new Boundary(width, 0, 100, height));
  boundaries.add(new Boundary(0, height, width, 100));

  float largest = 0;
  for (int i=0; i<100; i++) {
    Box n = new Box(random(0, width), random(100, height-100));
    if (n.w > largest) largest = n.w;
    boxes.add(n);
  }
  for (Box b : boxes) {
    b.setWorth(largest);
  }
}

void mousePressed() {
  playerStarted = true;
  for (Box b : boxes) {
    if (b.price <= money && b.inside(mouseX, mouseY)) {
      money -= b.killBody();
    }
  }
}

void draw() {
  background(255);

  // We must always step through time!
  for (int i=0; !playerStarted && i<20; i++) {
    box2d.step();
  }
  box2d.step();

  // Display all the boxes
  for (Box b : boxes) {
    money += b.display();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size ()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }

  textSize(32);
  String cash = "$"+nfc(money, 2);
  fill(255);
  text(cash, width/2, 49);
  text(cash, width/2, 53);
  text(cash, width/2-1, 50);
  text(cash, width/2+1, 50);
  fill(0);
  text(cash, width/2, 50);

  pmousePressed = mousePressed;
}


