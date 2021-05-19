// use this interface to describe scene animating strategy
// this pattern binds various inputs (e.g. sound level or specific sound event) to
// scene controls
interface ReactiveSceneStrategy {
  void draw(int globalTick);
}

// background strategies has red green blue and alpha channels
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
 * Just background
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

///// FOREGROUNDS

/**
 * This class describes default strategy for scene
 */
class StaticRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  public StaticRokkEbolSceneStrategy(RokkEbolVibes rev) {
    this.scene = rev;
    this.scene.setWaveVector(250, 250);
    this.scene.setWaveCycleTicks(75);
    this.scene.setWaveAmplitude(30);
  }
  
  void draw(int globalTick) {
    // just static drawing strategy
    this.scene.draw();
  }
}

/**
 * This strategy is immobilized text renderer
 */
class ImmobilizedRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  public ImmobilizedRokkEbolSceneStrategy(RokkEbolVibes rev) {
    this.scene = rev;
    this.scene.setWaveVector(0, 0);
    this.scene.setWaveAmplitude(0);
  }
  
  void draw(int globalTick) {
    // just static drawing strategy
    this.scene.draw();
  }
}

/**
 * This class describes reactive flaggy strategy
 */
class SoundReactiveRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  FFTCustomAnalyzer fft;
  public SoundReactiveRokkEbolSceneStrategy(RokkEbolVibes rev, FFTCustomAnalyzer fft) {
    this.scene = rev;
    this.fft = fft;
    this.scene.setWaveVector(-500, -250);
    this.scene.setWaveAmplitude(0);
  }
  
  void draw(int globalTick) {
    // first of all, analyze loudness
    float loudness = fft.analyze();
    // change waves based on loudness of the scene
    this.scene.setWaveAmplitude((int)(50 * loudness));
    this.scene.setWaveCycleTicks((int)(55 - 30 * loudness));
    this.scene.draw();
  }
}


/**
 * This class describes reactive and rotating scene
 */
class SoundReactiveAndRotatingRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  FFTCustomAnalyzer fft;
  public SoundReactiveAndRotatingRokkEbolSceneStrategy(RokkEbolVibes rev, FFTCustomAnalyzer fft) {
    this.scene = rev;
    this.fft = fft;
    this.scene.setWaveVector(-500, -250);
    this.scene.setWaveAmplitude(0);
  }
  
  float angle = 0;
  float angleSpeed = 0;
  void draw(int globalTick) {
    // first of all, analyze loudness
    float loudness = fft.analyze();
    if (loudness > 0.17) {
      if (angle >= 0) {
        angle -= 128 * PI;
      }
      angleSpeed = (loudness - 0.18) * 10;
    } else {
      if (angle < 0) {
        angleSpeed = 0.1;
      } else {
        angleSpeed = 0;
      }
    }
    angle += angleSpeed;
    //translate beggining in left upper corner
    translate(width / 2, height / 2);
    rotateZ(angle / 64);
    translate(- width / 2, - height / 2);
    // change waves based on loudness of the scene
    this.scene.setWaveAmplitude((int)(50 * loudness));
    this.scene.draw();
  }
}
