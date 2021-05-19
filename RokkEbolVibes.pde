class RokkEbolVibes {
  private final double STEP_TO_FONTSIZE_RATIO = 1.277777777; // ratio of font size and gap between letters
  
  private PFont f;
  private String[] rokk; // array of strings to render
  // this fields are calculated to center the text array 'rokk' in the center of the screen:
  private int fontSize;
  private int step;
  private int rex;
  private int rey;
  // this is depth of scene:
  private int rez = 100;
  
  private int tick = 0;
  
  // add simple ripple to letters
  private int waveX = 225; // wave X component
  private int waveY = 127; // wave Y component
  private int waveSq = waveX * waveX + waveY * waveY; // precalculated square
  private int amplZ = 15; // wave Z amplitude
  private int waveCycleTicks = 45; // amount of ticks for complete wave cycle
  
  public void setWaveVector(int x, int y) {
    waveX = x;
    waveY = y;
    waveSq = waveX * waveX + waveY * waveY;
  }

  public void setWaveAmplitude(int amplitude) {
    amplZ = amplitude;
  }
  public void setWaveCycleTicks(int ticks) {
    waveCycleTicks = ticks;
  }
  
  public RokkEbolVibes(String[] text) {
    rokk = text;
    int m = text[0].length();
    for (int i = 0; i < text.length; i++) {
      if (text[i].length() > m) {
        m = text[i].length();
      }
    }
    fontSize = height / (2 * m);
    step = (int) (fontSize * STEP_TO_FONTSIZE_RATIO);
    rex = (width - step * (rokk.length - 1)) / 2;
    rey = (height - step * (m - 1)) / 2;
    // upload font
    // printArray(PFont.list()); // uncomment to get whole list of available fonts
    f = createFont("Ponter-X.ttf", fontSize);
  }
  
  public void draw() {
    textFont(f);
    textAlign(CENTER, CENTER);
    fill(255);
    
    // draw 'РОКК ЕБОЛ'
    for (int col = 0; col < rokk.length; col++) {
      String line = rokk[col];
      for (int i = 0; i < line.length(); i++) {
        // calculate letter lattice position
        int xLattice = step * col;
        int yLattice = step * i;
        // calculate ticks offset
        int xyLatticeRegularizer = 30; // regularization constant, needed for zero'th element
        float epochs = 0, ticksOffset = tick;
        float factor = 0.0, coFactor = 0.0;
        if (waveSq != 0) { // has waves
          epochs = sqrt((float)(((double)xLattice + xyLatticeRegularizer) * waveX + (yLattice + xyLatticeRegularizer) * waveY)/waveSq);
          epochs = epochs - floor(epochs);
          ticksOffset = (tick + (int)(epochs * waveCycleTicks)) % waveCycleTicks;
          factor = sin(2 * PI * ticksOffset / (float)waveCycleTicks);
          coFactor = cos(2 * PI * ticksOffset / (float)waveCycleTicks);
        }
        
        pushMatrix();
        translate(rex + xLattice, rey + yLattice, (int)(rez + factor * amplZ));
        if (waveSq != 0) {
          rotateY((float)coFactor * PI/24 * waveX / sqrt(waveSq));
          rotateX((float)coFactor * PI/36 * waveY / sqrt(waveSq));
        }
        text(line.charAt(i), 0, 0);
        popMatrix();
      }
    }
    tick++;
    if (tick >= waveCycleTicks) {
      tick = 0;
    }
  }
}
