
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

void defaultStrategy() {
  strategy = new StaticRokkEbolSceneStrategy(rokkEbol);
}

void defaultBackground() {
  background = new FadingBackgroundSceneStrategy();
  //background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
  background.setGreyAlpha(0, 24);
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
  rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
  // do not forget to update strategy and background
  defaultStrategy();
  defaultBackground();
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


// some key analyzers
boolean alt, control, shift; // also, use this holy triple in your script as well
void keyPressed() {
  alt |= keyCode == ALT;
  control |= keyCode == CONTROL;
  shift |= keyCode == SHIFT;
  if (keyCode != ALT || keyCode != CONTROL || keyCode != SHIFT) {
    if (control && keyCode == 48) { // CTRL + 0
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      defaultStrategy();
    }
    if (control && keyCode == 49) { // CTRL + 1
      rokkEbol = new RokkEbolVibes(new String[] {"  Oasis", "", "The Shock", " Of The", "Lightning"}); // track 1
      defaultStrategy();
    }
    if (control && keyCode == 50) { // CTRL + 2
      rokkEbol = new RokkEbolVibes(new String[] {"Miles", "Kane", "", " Hot", "Stuff"}); // track 2
      defaultStrategy();
    }
    if (control && keyCode == 51) { // CTRL + 3
      rokkEbol = new RokkEbolVibes(new String[] {" The ", "Racon", " teurs", "", "Stedy", "As She", " Goes"}); // track 3
      defaultStrategy();
    }
    if (control && keyCode == 52) { // CTRL + 4
      rokkEbol = new RokkEbolVibes(new String[] {" The", "Black", "Keys", "", "I Got", "Mine"}); // track 4
      defaultStrategy();
    }
    if (control && keyCode == 53) { // CTRL + 5
      rokkEbol = new RokkEbolVibes(new String[] {"Iggy", "Pop", "", "Lust", "For", "Life"}); // track 4
      defaultStrategy();
    }
    if (control && keyCode == 54) { // CTRL + 6
      rokkEbol = new RokkEbolVibes(new String[] {" Jet ", "", " Are ", " You ", "Gonna ", "Be My", "Girl"}); // track 4
      defaultStrategy();
    }
    if (control && keyCode == 55) { // CTRL + 7
      rokkEbol = new RokkEbolVibes(new String[] {"Casa", "bian", "", "Club", "Foot"}); // track 4
      defaultStrategy();
    }
    if (control && keyCode == 56) { // CTRL + 8
      rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"}); // track 4
      defaultStrategy();
    }
    if (control && keyCode == 57) { // CTRL + 9
      rokkEbol = new RokkEbolVibes(new String[] {"PРЕ", "OОБ", "LКО", "YКЛ"}); // track 4
      defaultStrategy();
    }
    
    
    if (control && !alt && !shift && keyCode == 77) { // CTRL + M
      // turn on matrix mode
      background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
      background.setGreyAlpha(0, 24);
    }
    if (control && alt && !shift && keyCode == 77) { // CTRL + M
      // turn off matrix mode
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 24);
    }
    println("Key pressed with code: " + keyCode + "; alt=" + alt + ", ctrl=" + control + ", shift=" + shift);
  }
}

void keyReleased() {
  alt &= keyCode != ALT;
  control &= keyCode != CONTROL;
  shift &= keyCode != SHIFT;
}
