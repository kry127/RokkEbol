
/* TWEAKABLE CONSTANTS */
int displayNumber = 1; // choose display number

/* constants initialized during 'setup' procedure */
PImage sprite, oxyPubBg, polyRockBg;
PShader julia;
RokkEbolVibes rokkEbol;
FFTCustomAnalyzer fft;
BackgroundSceneStrategy background;
ReactiveSceneStrategy strategy;

boolean isLsdOnManually = false;
void turnOffLsdOption() {
  isLsdOnManually = false;
  setLSD(isLsdOnManually);
}
void flipLsdOption() {
  isLsdOnManually = !isLsdOnManually;
  setLSD(isLsdOnManually);
}
void setLSD(boolean setLSD) {
  if (setLSD || isLsdOnManually) {
    // hello happy weed world
    shader(julia);
  } else {
    resetShader();
  }
}

// chooses some text to render, but not spoil song name
void standardRandomRokkEbol() {
  switch((int)random(10)) {
    case 0:
    case 1:
      // РОКК ЕБОЛ
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      break;
    case 2:
    case 3:
      // Group name anagram: Oxygen Pub
      rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"});
      break;
    case 4:
    case 5:
      // tribute to the festival 'PolyRock 2021'
      rokkEbol = new RokkEbolVibes(new String[] {"POLY", "ROCK", "2021"});
      break;
    case 6:
      // tribute to the festival 'PolyRock'
      rokkEbol = new RokkEbolVibes(new String[] {"PР", "OО", "LК", "YК"});
      break;
    case 7:
    case 8:
      // tribute to the festival 'PolyRock' with love
      rokkEbol = new RokkEbolVibes(new String[] {"POLY", "ROCK", " -- ", "LOVE"});
    case 9:
      // tribute to the festival 'PolyRock' in the form of "POLY РОКК ЕБОЛ"
      rokkEbol = new RokkEbolVibes(new String[] {"PРЕ", "OОБ", "LКО", "YКЛ"});
      break;
  }
}

void newStrategy() {
  switch((int)random(2)) {
    case 0:
      strategy = new StaticRokkEbolSceneStrategy(rokkEbol);
      break;
    case 1:
      strategy = new SoundReactiveRokkEbolSceneStrategy(rokkEbol, fft);
      break;
  }
  switch((int)random(7)) {
    case 0:
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 24);
      break;
    case 1:
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 255);
      break;
    case 2:
      background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
      background.setGreyAlpha(0, 24);
      break;
    case 3:
      background = new SoundDependentAlphaBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 255);
      break;
    case 4:
      background = new FftBarsBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 32);
      break;
    case 5:
      background = new FftSquaresBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 32);
      break;
  }
  // some probability to turn on LSD
  // setLSD(random(1) < 0.2);
}

void defaultStrategy() {
  strategy = new StaticRokkEbolSceneStrategy(rokkEbol);
}

void defaultBackground() {
  background = new FadingBackgroundSceneStrategy();
  //background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
  //background = new SoundDependentAlphaBackgroundSceneStrategy(fft);
  //background = new FftBarsBackgroundSceneStrategy(fft);
  // background = new FftSquaresBackgroundSceneStrategy(fft);
  
  background.setGreyAlpha(0, 255); // make nontraceable background by default
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
  oxyPubBg = loadImage("logo5.png");
  polyRockBg = loadImage("PolyRock.jpg");
  
  /// SHADERS
  julia = loadShader("ShaderSample/JuliaFrag.glsl", "ShaderSample/JuliaVert.glsl");
  julia.set("cRe", 0.2);
  julia.set("cIm", 0.5);
  julia.set("iter", 11);
  julia.set("zoom", 0.5 * min(height, width));
  
  // initialize custom classes
  rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
  // do not forget to update strategy and background
  defaultStrategy();
  defaultBackground();
}

int time = 0;
int timeNow = 0, timeFrom = 0;
float hueOffset;
float cIm;
float bpm = 60;
int bpmToMillis(float bpm) {
  return (int)max(1000 * 60 / bpm, 1);
}
// this function accepts time as millisecond and bpm and returns [0, 1] float 
float timeCrop(int millis, float bpm) {
  int millisSpan = bpmToMillis(bpm);
  return millis % millisSpan / (float)millisSpan;
}

boolean changeStrategies = false;
  
void draw() {
  timeNow = millis();
  time = timeNow - timeFrom;
  if (time > 25 * 1000 && changeStrategies) {
    timeFrom = timeNow;
    time = 0;
    newStrategy();
  }
  float volume = fft.analyze();
  // LCD hue frequency bpm depends on volume
  int hueFreqBpm = (int)min(40 + volume * 40, 60);
  hueOffset = timeCrop(time, hueFreqBpm);
  
  cIm = 1.5*sin(2 * PI * timeCrop(time, bpm / 2));
  julia.set("hueOffset", hueOffset);
  julia.set("cIm", cIm);
  
  background.draw(time);
  strategy.draw(time);
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
    if (control && !alt &&  keyCode == 48) { // CTRL + 0
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      defaultStrategy();
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 60;
    }
    if (control && !alt && keyCode == 49) { // CTRL + 1
      if (shift) { 
        // change font only on SHIFT pressed
        rokkEbol = new RokkEbolVibes(new String[] {"  Oasis", "", "The Shock", " Of The", "Lightning"}); // track 1
      } else {
        // otherwise choose from standard set of lables
        rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      }
      defaultStrategy();
      turnOffLsdOption();
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 32); // produce traces
      changeStrategies = false; // turn off changing strategies
      bpm = 139; // also you SHOULD set bpm for every music
    }
    if (control && !alt && keyCode == 50) { // CTRL + 2
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {"Miles", "Kane", "", " Hot", "Stuff"}); // track 2
      } else {
        rokkEbol = new RokkEbolVibes(new String[] {"POLY", "ROCK", " -- ", "LOVE"}); // track 4
      }
      defaultStrategy();
      turnOffLsdOption();
      background = new FftSquaresBackgroundSceneStrategy(fft); // should be disco background :)
      background.setGreyAlpha(0, 40); // produce traces
      changeStrategies = false; // turn off changing strategies
      bpm = 122;
    }
    if (control && !alt && keyCode == 51) { // CTRL + 3
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {" The ", "Racon", " teurs", "", "Stedy", "As She", " Goes"}); // track 3
      } else {
        rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"}); // track 4
      }
      strategy = new SoundReactiveRokkEbolSceneStrategy(rokkEbol, fft);
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 25); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 125;
    }
    if (control && !alt && keyCode == 52) { // CTRL + 4
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {" The", "Black", "Keys", "", "I Got", "Mine"}); // track 4
      } else {
        rokkEbol = new RokkEbolVibes(new String[] {"PР", "OО", "LК", "YК"}); // track 4
      }
      defaultStrategy();
      background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
      background.setGreyAlpha(0, 18); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 80;
    }
    if (control && !alt && keyCode == 53) { // CTRL + 5
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {"Iggy", "Pop", "", "Lust", "For", "Life"}); // track 5
      } else {
        rokkEbol = new RokkEbolVibes(new String[] {"POLY", "ROCK", "2021"});
      }
      defaultStrategy();
      background = new FftBarsBackgroundSceneStrategy(fft); // should be disco background :)
      background.setGreyAlpha(0, 22); // produce traces
      turnOffLsdOption();
      changeStrategies = true; // turn on changing strategies
      bpm = 200;
    }
    if (control && !alt && keyCode == 54) { // CTRL + 6
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {" Jet ", "", " Are ", " You ", "Gonna ", "Be My", "Girl"}); // track 6
      } else {
        rokkEbol = new RokkEbolVibes(new String[] {"PРЕ", "OОБ", "LКО", "YКЛ"}); // track 4
      }
      defaultStrategy();
      turnOffLsdOption();
      bpm = 205;
    }
    if (control && !alt && keyCode == 55) { // CTRL + 7
      if (shift) { 
        rokkEbol = new RokkEbolVibes(new String[] {"Kasa", "bian", "", "Club", "Foot"}); // track 7
      } else {
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      }
      defaultStrategy();
      turnOffLsdOption();
      changeStrategies = true; // turn off changing strategies
      bpm = 102;
    }
    if (control && !shift && !alt && keyCode == 56) { // CTRL + 8
      rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"}); // Oxygen Pub
      defaultStrategy();
      background = new ImageBackgroundSceneStrategy(oxyPubBg);
      background.setGreyAlpha(0, 55); // produce traces
      turnOffLsdOption();
      bpm = 60;
    }
    if (control && !shift && !alt && keyCode == 57) { // CTRL + 9
      rokkEbol = new RokkEbolVibes(new String[] {"PРЕ", "OОБ", "LКО", "YКЛ"}); // Poly Rock
      defaultStrategy();
      background = new ImageBackgroundSceneStrategy(polyRockBg);
      background.setGreyAlpha(0, 55); // produce traces
      turnOffLsdOption();
      bpm = 60;
    }
    
    
    if (!control && !shift && alt && keyCode == 49) { // ALT + 1
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"});
      defaultStrategy();
      background = new FftSquaresBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 30); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 100;
    }
    if (!control && !shift && alt && keyCode == 50) { // ALT + 2
      rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"}); // Track 4
      defaultStrategy();
      background = new FftSquaresBackgroundSceneStrategy(fft); // should be disco background :)
      background.setGreyAlpha(0, 30); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 80;
    }
    if (!control && !shift && alt && keyCode == 51) { // ALT + 3
      rokkEbol = new RokkEbolVibes(new String[] {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"}); // Track5 + 5.1
      strategy = new SoundReactiveRokkEbolSceneStrategy(rokkEbol, fft);
      background = new FftSquaresBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 30); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 200;
    }
    if (!control && !shift && alt && keyCode == 52) { // ALT + 4
      rokkEbol = new RokkEbolVibes(new String[] {"OGP", "XEU", "YNB"}); // Track 6
      defaultStrategy();
      background = new FftSquaresBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 30); // produce traces
      turnOffLsdOption();
      changeStrategies = false; // turn off changing strategies
      bpm = 102;
    }
    
    // background shortcuts
    if (!control && alt && !shift && keyCode == 68) { // CTRL + D
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 255);
    }
    if (!control && alt && !shift && keyCode == 71) { // CTRL + G
      background = new FadingBackgroundSceneStrategy();
      background.setGreyAlpha(0, 24);
    }
    if (!control && alt && !shift && keyCode == 77) { // CTRL + M
      background = new MatrixBackgroundSceneStrategy(new int[] {25, 50, 100}, 0, -200);
      background.setGreyAlpha(0, 24);
    }
    if (!control && alt && !shift && keyCode == 66) { // CTRL + B
      background = new FftBarsBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 22);
    }
    if (!control && alt && !shift && keyCode == 80) { // CTRL + P
      background = new FftSquaresBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 40);
    }
    if (!control && alt && !shift && keyCode == 82) { // CTRL + R
      background = new SoundDependentAlphaBackgroundSceneStrategy(fft);
      background.setGreyAlpha(0, 255);
    }
    
    // behaviour control
    if (control && !alt && !shift && keyCode == 83) { // CTRL + S
      // turn on changing strategies
      changeStrategies = true;
    }
    if (control && alt && !shift && keyCode == 83) { // CTRL + ALT + S
      // turn off changing strategies
      changeStrategies = false;
    }
    if (control && !alt && shift && keyCode == 83) { // CTRL + SHIFT + S
      // change strategy immediately
      newStrategy();
    }
    if (control && !alt && shift && keyCode == 84) { // CTRL + SHIFT + T
      // change strategy and text immediately
      standardRandomRokkEbol();
      newStrategy();
    }
    if (control && alt && !shift && keyCode == 76) { // CTRL + ALT + L
      flipLsdOption();
    }
    if (control && keyCode == 37) { // CTRL + LEFT
      bpm -= 5;
    }
    if (control && keyCode == 39) { // CTRL + RIGHT
      bpm += 5;
    }
    println("Key pressed with code: " + keyCode + "; alt=" + alt + ", ctrl=" + control + ", shift=" + shift);
  }
}

void keyReleased() {
  alt &= keyCode != ALT;
  control &= keyCode != CONTROL;
  shift &= keyCode != SHIFT;
}
