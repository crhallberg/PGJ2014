void splitH() {
  if (selected < 0 || parts[selected].h < 20) return;
  Rect op = parts[selected];
  op.dead = true;
  float h2 = op.h/2;
  parts =(Rect[]) append(parts, new Rect(op.x, op.y, op.w, h2-1));
  parts =(Rect[]) append(parts, new Rect(op.x, op.y+h2, op.w, h2));
  selected = parts.length - 2;
  pushHistory();
}

void splitV() {
  if (selected < 0 || parts[selected].w < 20) return;
  Rect op = parts[selected];
  op.dead = true;
  float w2 = op.w/2;
  parts =(Rect[]) append(parts, new Rect(op.x, op.y, w2-1, op.h));
  parts =(Rect[]) append(parts, new Rect(op.x+w2, op.y, w2, op.h));
  selected = parts.length - 2;
  pushHistory();
}

void removeBlock() {
  Rect op = parts[selected];
  op.dead = true;
  selected = -1;
  pushHistory();
}
