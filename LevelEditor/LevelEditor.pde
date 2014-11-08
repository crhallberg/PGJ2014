import java.util.Stack;

Rect[] parts = new Rect[1];
Rect[] pstate = new Rect[1];
Stack history = new Stack();
boolean pmousePressed = false;
boolean pkeyPressed = false;
float startX, startY;
boolean controlPressed = false;
boolean cornering = false;
boolean dragging = false;
int cornerSize = 20;

void setup()
{
  size(600, 600);
  parts[0] = new Rect(200, 0, 200, height);
  pushHistory();
}

int selected = -1;
void draw() {
  background(0);
  for (int i=0; i<parts.length; i++) {
    parts[i].draw(selected == i);
  }

  if (controlPressed) {
    if (mousePressed) {
      if (!pmousePressed) {
        startX = mouseX;
        startY = mouseY;
        parts =(Rect[]) append(parts, new Rect(startX, startY, 1, 1));
        selected = parts.length-1;
      } else {
        parts[selected].w += mouseX-pmouseX;
        parts[selected].h += mouseY-pmouseY;
      }
    } else if(pmousePressed) {
      pushHistory();
    }
  } else {
    if (mousePressed) {
      if (selected >= 0) {
        if (cornering) {
          parts[selected].w += mouseX-pmouseX;
          parts[selected].h += mouseY-pmouseY;
        } else {
          dragging = true;
          parts[selected].x += mouseX-pmouseX;
          parts[selected].y += mouseY-pmouseY;
        }
      }
      if (!pmousePressed) {
        selected = -1;
        for (int i=parts.length-1; i>=0; i--) {
          if (parts[i].inside(mouseX, mouseY)) {
            selected = i;
            if (parts[i].x+parts[i].w - mouseX < cornerSize && parts[i].y+parts[i].h - mouseY < cornerSize) {
              cornering = true;
            }
            break;
          }
        }
      }
    }
  }
  if (!mousePressed && (cornering || dragging)) {
    pushHistory();
    cornering = false;
    dragging = false;
    if (selected >= 0) {
      Rect op = parts[selected];
      if (op.w < 0) {
        op.x += op.w;
        op.w = abs(op.w);
      }
      if (op.w < 0) {
        op.w = 10;
      }
      if (op.h < 0) {
        op.y += op.h;
        op.h = abs(op.h);
      }
      if (op.h < 0) {
        op.h = 10;
      }
    }
  }
  if (keyPressed && !pkeyPressed) {
    if (selected >= 0) {
      if (key == 'a') {
        parts[selected].x -= 2;
      } else if (key == 'd') {
        parts[selected].x += 2;
      } else if (key == 'w') {
        parts[selected].y -= 2;
      } else if (key == 's') {
        parts[selected].y += 2;
      } else if (keyCode == UP) {
        parts[selected].h += 2;
        parts[selected].y -= 1;
      } else if (keyCode == DOWN) {
        parts[selected].h -= 2;
        parts[selected].y += 1;
      } else if (keyCode == LEFT) {
        parts[selected].w -= 2;
        parts[selected].x += 1;
      } else if (keyCode == RIGHT) {
        parts[selected].w += 2;
        parts[selected].x -= 1;
      }
    }
  }
  pkeyPressed = keyPressed;
  pmousePressed = mousePressed;
}

void keyPressed() {
  switch(key) {
  case 'h':
  case '1':
    splitH();
    break;
  case 'v':
  case '2':
    splitV();
    break;
  case 'x':
  case '3':
    removeBlock();
    break;
  }
  if (keyCode == CONTROL) {
    controlPressed = true;
  }
}
void keyReleased()
{
  if (controlPressed && keyCode == 90) {
    popHistory();
  } 
  if (keyCode == CONTROL) {
    controlPressed = false;
  }
}

void printToFile() {
}

class Rect
{
  float x, y, w, h;
  boolean dead;
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  void draw(boolean selected) {
    if (this.dead) return;
    boolean colliding = false;
    for (int i=0; i<parts.length; i++) {
      if (this == parts[i]) continue;
      Rect op = parts[i];
      if (op.inside(this.x, this.y) || op.inside(this.x+this.w, this.y) || op.inside(this.x, this.y+this.h) || op.inside(this.x+this.w, this.y+this.h)) {
        colliding = true;
        break;
      }
    }
    if (selected) {
      fill(200, 200, 255);
      stroke(0, 0, 255);
    } else {
      fill(255);
      stroke(0);
    }
    if (colliding) {
      fill(255, 155, 155, 200);
      if (!selected) {
        stroke(255, 0, 0);
      }
    }
    rect(this.x, this.y, this.w, this.h);
    noFill();
    rect(this.x+this.w-cornerSize, this.y+this.h-cornerSize, cornerSize, cornerSize);
  }
  boolean inside(float x, float y) {
    return !dead && x >= this.x && x <= this.x+this.w && y >= this.y && y <= this.y+this.h;
  }
}

