
/* TWEAKABLE CONSTANTS */
int displayNumber = 1; // choose display number

/* constants initialized during 'setup' procedure */
PImage sprite, bg;
RokkEbolVibes rokkEbol;
FFTCustomAnalyzer fft;

void setup() {
  /// SCENE UTILITIES
  // set up full screen landscape mode with selected monitor
  //size(400, 600, P3D);
  fullScreen(P3D, displayNumber); // uncomment to use in fullscreen mode
  orientation(LANDSCAPE);
  background(0); // initial color
  
  /// AUDIO UTILITIES
  // start traking audio input number 0
  fft = new FFTCustomAnalyzer(this, 0);
  
  /// RESOURCES AND PARTICLE SYSTEMS
  // upload images
  sprite = loadImage("Pub_White_Mini.png");
  bg = loadImage("logo5.png");
  
  // initialize custom classes
  rokkEbol = new RokkEbolVibes(new String[] {"  Oasis", "", "The Shock", " Of The", "Lightning"}); // track 1
  rokkEbol = new RokkEbolVibes(new String[] {"Miles", "Kane", "", " Hot", "Stuff"}); // track 2
  rokkEbol = new RokkEbolVibes(new String[] {"   The", "Raconteurs", "", "   Stedy", "As She Goes"}); // track 3
  rokkEbol = new RokkEbolVibes(new String[] {" The", "Black", "Keys", "", "I Got", "Mine"}); // track 4
  rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
  //rokkEbol.setWaveVector(500, 0);
}

int time = 0;

void draw() {
  /* Input data preprocessing */
  // retrieve input audio spectrum
  float loudness = fft.analyze();
  
  /* Graphics part */
  fill(0, 24);
  rect(0, 0, width, height);
  
  // sample of whole scene rotation:
  //translate beggining in left upper corner
  // translate(width / 2, height / 2);
  // rotateZ(time / 80.0);
  // translate(- width / 2, - height / 2);
  // image(bg, 0, 0, width, height);
  
  // you can change rokkebol parameters dynamically
  // rokkEbol.setWaveAmplitude((int)(100 * sin(2 * PI * time / 360)));
  // rokkEbol.setWaveCycleTicks((int)(100 * abs(sin(2 * PI * time / 360))) + 10);
  // draw rokkebol
  rokkEbol.draw();
  time++;
  // save frame
  // saveFrame("frames/####.png");
}
