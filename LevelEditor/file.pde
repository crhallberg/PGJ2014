void openFile() {
  selectInput("Select a file to process:", "loadFromFile");
}

void loadFromFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    return;
  }
  JSONObject file = loadJSONObject(selection.getAbsolutePath());
  parts = new Rect[file.getInt("size")];
  JSONArray bits = file.getJSONArray("rects");
  for (int i=0; i<bits.size (); i++) {    
    JSONObject item = bits.getJSONObject(i);
    parts[i] = new Rect(item.getFloat("x"), item.getFloat("y"), item.getFloat("w"), item.getFloat("h"));
  }
}

void printToFile() {
  Date d = new Date();
  println();  

  JSONObject level = new JSONObject();
  level.setInt("x", 0);
  level.setInt("y", 0);
  level.setInt("size", parts.length);

  JSONArray bits = new JSONArray();
  for (int i=0; i<parts.length; i++) {
    JSONObject square = new JSONObject();

    square.setFloat("x", parts[i].x);
    square.setFloat("y", parts[i].y);
    square.setFloat("w", parts[i].w);
    square.setFloat("h", parts[i].h);

    bits.setJSONObject(i, square);
  }

  level.setJSONArray("rects", bits);
  saveJSONObject(level, "data/"+d.getTime()+".json");
  println("data/"+d.getTime()+".json");
}

