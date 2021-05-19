
/* TWEAKABLE CONSTANTS */
int displayNumber = 1; // choose display number

/* constants initialized during 'setup' procedure */
PImage sprite, bg;
RokkEbolVibes rokkEbol;
FFTCustomAnalyzer fft;
BackgroundSceneStrategy background;
ReactiveSceneStrategy strategy;

void newStrategy() {
  switch((int)random(3)) {
    case 0:
      strategy = new StaticRokkEbolSceneStrategy(rokkEbol);
      break;
    case 1:
      strategy = new SoundReactiveRokkEbolSceneStrategy(rokkEbol, fft);
      break;
    case 2:
      strategy = new SoundReactiveAndRotatingRokkEbolSceneStrategy(rokkEbol, fft);
      break;
  }
}

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
  // do not forget to update strategy
  //newStrategy();
  strategy = new SoundReactiveAndRotatingRokkEbolSceneStrategy(rokkEbol, fft);
  //background = new FadingBackgroundSceneStrategy();
  background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
  background.setGreyAlpha(0, 24);
}

int time = 0;
void draw() {
  //if (time > 600) {
  //  newStrategy();
  //  time = 0;
  //}
  background.draw(time);
  strategy.draw(time);
  time++;
  // save frame
  // saveFrame("frames/####.png");
}
