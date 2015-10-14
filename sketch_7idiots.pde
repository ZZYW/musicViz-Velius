import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;
import ddf.minim.analysis.*;
import ddf.minim.*;


Minim       minim;
AudioPlayer jingle;
FFT         fft;

PeasyCam cam;
PImage background;
PShader blur;
color[] imagePixels;


void setup()
{

  size(600, 600, P3D);  

  background(10);
  pixelDensity(2);
  minim = new Minim(this);
  blur = loadShader("blur.glsl"); 
  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have 
  // a power-of-two buffer size and this is a good size.
  jingle = minim.loadFile("Velius.mp3", 1024);

  // loop the file indefinitely
  jingle.loop();

  // create an FFT object that has a time-domain buffer 
  // the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  // calculate the averages by grouping frequency bands linearly. use 30 averages.
  fft.logAverages( 22, 2);
  //
  //  cam = new PeasyCam(this, 100);
  //  cam.setMinimumDistance(50);
  //  cam.setMaximumDistance(5000);
  //

  background = loadImage("universe.jpg");
  background.loadPixels();
  imagePixels = background.pixels;
}


float rotate_x_angle;
float rotate_y_angle;


void draw()
{



  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( jingle.mix );

  float instr[] = new float[] {
    fft.getBand(11), //ding ling 
    fft.getBand(13), //ding ling 2
    fft.getBand(39), //echo 
    fft.getBand(1) //beat
  };



  //cube
  {
    pushMatrix();
    fill(0, 10);
    translate(width/2, height/2);
    sphereDetail(2);
    
    strokeWeight(0.5);
    rotateX(rotate_x_angle);
    rotateY(rotate_y_angle);
    sphere(instr[1]*2);
    popMatrix();
  }

  rotate_x_angle+=0.01;
  rotate_y_angle+=0.01;
  //ding ling
  if (instr[0]>30) {
    Stain another_stain = new Stain(instr[0]*20);
    another_stain.fillC = imagePixels[ floor(another_stain.center_y * background.width) + floor(another_stain.center_x)];
    another_stain.alphaModifier = map(instr[0], 30, 120, 100, 255);
    another_stain.display();
  }

  //beat
  if (instr[3]>30) {
    int temp_x = int(random(0, width));
    int temp_y = int(random(0, height));
    int temp_x_2 = temp_x + int(instr[3]);
    int temp_y_2 = temp_y + int(instr[3]);
    strokeWeight(1);

    //beginShape(LINES);
    //color temp_c = imagePixels[ floor(temp_y * background.width) + floor(temp_x)];
    //fill(temp_c);
    //vertex(temp_x_2, temp_y_2);
    //vertex(temp_x, temp_y);
    //fill(red(temp_c), green(temp_c), blue(temp_c), 20);
    //endShape(CLOSE);
  }



  //  //  for (int i=0; i<1; i++) {

  //  //  }
  //  drawBands();
}

void drawBands() {
  int w = 20;
  for (int i=0; i<fft.specSize (); i++) {
    strokeWeight(w-1);
    stroke(255);
    line(i*w, height, i*w, height-fft.getBand(i));
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(6);
    text(i, i*w, height-20);
  }
  strokeWeight(0.5);
  stroke(0, 255, 0);

  for (int o=10; o<100; o+=10) {
    line(0, height-o, width, height-o);
  }
}