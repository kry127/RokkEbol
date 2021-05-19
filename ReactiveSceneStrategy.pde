// use this interface to describe scene animating strategy
// this pattern binds various inputs (e.g. sound level or specific sound event) to
// scene controls
interface ReactiveSceneStrategy {
  void draw(int globalTick);
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
