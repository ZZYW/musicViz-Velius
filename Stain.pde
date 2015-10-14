class Stain {
  float stainSize;

  color fillC;    
  float aa;
  float bb;
  float alphaModifier;
  int center_x ;
  int center_y;

  Stain (float ss) {
    center_x = int(random(0, width));
    center_y = int(random(0, height));

    stainSize = ss;
    aa = random(0, 1);
    bb = random(0, 1);
  }


  void display() {
    for (int i=0; i<stainSize; i++) {
      strokeWeight(1);
      fillC = color(red(fillC), green(fillC), blue(fillC), random(alphaModifier, 255));
      stroke(fillC);
      float x_offset = map(noise(aa), 0, 1, -100, 100);
      float y_offset = map(noise(bb), 0, 1, -100, 100);
      point(center_x + x_offset, center_y + y_offset);
      aa+=0.1;
      bb+=0.1;
    }
  }
}

