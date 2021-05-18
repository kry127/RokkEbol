class RokkEbolVibes {
  PFont f;
  final String[] rokk = {"РЕМОНТ", "ОБУВИ", "КОПИR", "КЛЮЧЕЙ"};
  int tick = 0;
  int fontSize = height / 12;
  int step = (int) (fontSize * 1.277777777);
  int rex = (width - step * (rokk.length - 1)) / 2;
  int rey = (height - step * 5) / 2;
  int rez = 100;
  
  // add simple ripple to letters
  int waveX = 225; // wave X component
  int waveY = 127; // wave Y component
  int waveSq = waveX * waveX + waveY * waveY;
  int amplZ = 15; // wave Z amplitude
  int waveCycleTicks = 45; // amount of ticks for complete wave cycle

  public RokkEbolVibes() {
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
        float epochs = sqrt((float)(((double)xLattice + xyLatticeRegularizer) * waveX + (yLattice + xyLatticeRegularizer) * waveY)/waveSq);
        epochs = epochs - floor(epochs);
        int ticksOffset = (tick + (int)(epochs * waveCycleTicks)) % waveCycleTicks;
        float factor = sin(2 * PI * ticksOffset / (float)waveCycleTicks);
        float coFactor = cos(2 * PI * ticksOffset / (float)waveCycleTicks);
        
        pushMatrix();
        translate(rex + xLattice, rey + yLattice, (int)(rez + factor * amplZ));
        rotateX((float)coFactor * PI/24 * waveX / sqrt(waveSq));
        rotateY((float)coFactor * PI/24 * waveY / sqrt(waveSq));
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
