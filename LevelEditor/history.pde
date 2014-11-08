void pushHistory() {
  println("SAVE");
  history.push(pstate);
  pstate = deepCopy(parts);
}

void popHistory() {
  println("UNDO", history.size());
  if (history.size() > 1) {
    parts = deepCopy((Rect[]) history.pop());
    selected = -1;
  }
}

Rect[] deepCopy(Rect[] orig)
{
  println(orig.length);
  Rect[] dest = new Rect[orig.length];
  for (int i=0; i<orig.length; i++) {
    dest[i] = new Rect(orig[i].x, orig[i].y, orig[i].w, orig[i].h);
  }
  return dest;
}
