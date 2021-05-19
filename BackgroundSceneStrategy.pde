/*Background scene strategy is a variant of reactive scene strategy with background color
 * which overlays scene over and over again with specified color.
 * Background strategies has red green blue and alpha channels
 */
abstract class BackgroundSceneStrategy implements ReactiveSceneStrategy {
  protected int red = 0;
  protected int green = 0;
  protected int blue = 0;
  protected int alpha = 255;
  public void setRgba(int red, int green, int blue, int alpha) {
    this.red   = red;
    this.green = green;
    this.blue  = blue;
    this.alpha = alpha;
  }
  public void setRgb(int red, int green, int blue) {
    this.setRgba(red, green, blue, 255);
  }
  public void setGreyAlpha(int grey, int alpha) {
    this.setRgba(grey, grey, grey, alpha);
  }
  public void setGrey(int grey) {
    this.setGreyAlpha(grey, 255);
  }
}

///// BACKGROUNDS
/**
 * Just simple background
 */
class FadingBackgroundSceneStrategy extends BackgroundSceneStrategy {
  void draw(int globalTick) {
    // just static drawing strategy
    pushMatrix();
    translate(0, 0, -1000);
    fill(this.red, this.green, this.blue, this.alpha);
    rect(-3*width, -3*height, 6*width, 6*height);
    popMatrix();
  }
}

// TODO oh, this is really a full-scale implementation, rather than strategy. Should be moved to separate class instead
class MatrixBackgroundSceneStrategy extends BackgroundSceneStrategy {
  private int[] nparticles;
  private int zOffset;
  private int zDelta;
  private PFont f;
  
  // particle is a letter
  private class JustCharacter {
    int code;
    int x;
    int y;
    int lifetime;
    int initialLifetime;
    JustCharacter() {
      rebirth();
      lifetime = initialLifetime = (int) random(64, 512);
    }
    void rebirth() {
      code = (int)random(65, 90);
      initialLifetime = 512 + (int)random(0, 32);
      lifetime = initialLifetime;
      x = (int)random(-width, width);
      y = (int)random(-height, height);
    }
    void draw(int z) {
      if (isDead()) {
        rebirth();
        return;
      }
      pushMatrix();
      translate(width / 2 + x, height / 2 + y, z);
      fill(25, 240, 0, (initialLifetime - lifetime < 64) ? 4 * (initialLifetime - lifetime) : lifetime > 64 ? 255 :  4 * lifetime);
      text((char)code, 0, 0);
      popMatrix();
      y += 1;
      lifetime--;
      if (lifetime % 10 == 0) {
         code = (int)random(65, 90);
      }
    }
    boolean isDead() {
      if (lifetime <= 0 || y < - height || y > height || x < -width || x > width) {
        // if not visible, set lifetime to zero
        lifetime = 0;
        return true;
      }
      return false;
    }
  }
  
  private java.util.List<JustCharacter>[] charLayers;
  public MatrixBackgroundSceneStrategy(int[] nparticles, int zOffset, int zDelta) {
    this.nparticles = nparticles;
    this.zOffset = zOffset;
    this.zDelta = zDelta;
    charLayers = new java.util.List[nparticles.length];
    for (int iLayer = 0; iLayer < nparticles.length; iLayer++) {
      charLayers[iLayer] = new java.util.ArrayList<JustCharacter>();
      for (int k = 0; k < nparticles[iLayer]; k++) {
        charLayers[iLayer].add(new JustCharacter());
      }
    }
    
    
    f = createFont("matrix.ttf", 32);
  }
  void draw(int globalTick) {
    // just static drawing strategy
    pushMatrix();
    translate(0, 0, -1000);
    fill(0, alpha);
    rect(-3*width, -3*height, 6*width, 6*height);
    popMatrix();
    
    textFont(f);
    textAlign(CENTER, CENTER);
    for (int iLayer = 0; iLayer < nparticles.length; iLayer++) {
      int z = zOffset + iLayer * zDelta;
      for (JustCharacter jc : charLayers[iLayer]) {
        jc.draw(z);
      }
    }
  }
}
