// use this interface to describe scene animating strategy
// this pattern binds various inputs (e.g. sound level or specific sound event) to
// scene controls
interface ReactiveSceneStrategy {
  void draw(int globalTick);
}

/**
 * This class describes static strategy for scene
 */
class StaticRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  public StaticRokkEbolSceneStrategy(RokkEbolVibes rev) {
    this.scene = rev;
    this.scene.setWaveVector(0, 0);
    this.scene.setWaveAmplitude(0);
  }
  
  void draw(int globalTick) {
    // just static drawing strategy
    fill(0);
    rect(0, 0, width, height);
    this.scene.draw();
  }
}

/**
 * This class describes static strategy for scene
 */
class SoundReactiveRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  FFTCustomAnalyzer fft;
  public SoundReactiveRokkEbolSceneStrategy(RokkEbolVibes rev, FFTCustomAnalyzer fft) {
    this.scene = rev;
    this.fft = fft;
    this.scene.setWaveVector(-500, -250);
    this.scene.setWaveAmplitude(3);
  }
  
  void draw(int globalTick) {
    // first of all, analyze loudness
    float loudness = fft.analyze();
    // then draw background
    fill(0, 24);
    rect(0, 0, width, height);
    // change waves based on loudness of the scene
    this.scene.setWaveAmplitude((int)(3 + 30 * loudness));
    this.scene.setWaveCycleTicks((int)(45 - 30 * loudness));
    this.scene.draw();
  }
}


/**
 * This class describes static strategy for scene
 */
class SoundReactiveAndRotatingRokkEbolSceneStrategy implements ReactiveSceneStrategy {
  RokkEbolVibes scene;
  FFTCustomAnalyzer fft;
  public SoundReactiveAndRotatingRokkEbolSceneStrategy(RokkEbolVibes rev, FFTCustomAnalyzer fft) {
    this.scene = rev;
    this.fft = fft;
    this.scene.setWaveVector(-500, -250);
    this.scene.setWaveAmplitude(3);
  }
  
  void draw(int globalTick) {
    // first of all, analyze loudness
    float loudness = fft.analyze();
    // then draw background
    fill(0, 24);
    rect(0, 0, width, height);
    //translate beggining in left upper corner
    translate(width / 2, height / 2);
    rotateZ(time / 80.0);
    translate(- width / 2, - height / 2);
    // change waves based on loudness of the scene
    this.scene.setWaveAmplitude((int)(3 + 30 * loudness));
    this.scene.setWaveCycleTicks((int)(45 - 30 * loudness));
    this.scene.draw();
  }
}
