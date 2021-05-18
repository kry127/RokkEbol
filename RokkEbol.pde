
// constants initialized during 'setup' procedure
PImage sprite, bg;
RokkEbolVibes rokkEbol;

// tweakable constants
// choose display number
int displayNumber = 1;

void setup() {
  // set up full screen landscape mode with selected monitor
  size(400, 600, P3D);
  //fullScreen(P3D, displayNumber); // uncomment to use in fullscreen mode
  orientation(LANDSCAPE);
  background(0); // initial color
  
  // upload images
  sprite = loadImage("Pub_White_Mini.png");
  bg = loadImage("logo5.png");
  
  // initialize custom classes
  rokkEbol = new RokkEbolVibes();
}

void draw() {
  fill(0, 24);
  rect(0, 0, width, height);
  // the coordinates are beggining in left upper corner
  // image(bg, 0, 0, width, height);
  // draw rokkebol
  rokkEbol.draw();
  // save frame
  // saveFrame("frames/####.png");
}
