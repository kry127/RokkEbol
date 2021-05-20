import processing.sound.*;

/**
 * This class encapsulates custom work with standard FFT package in processing library.
 * Here constant 512 is chosen with the following octave bindings:
 *  C3 -> spectrum[3]
 *  C4 -> spectrum[6]
 *  C5 -> spectrum[12]
 *  C6 -> spectrum[24]
 *  ...
 */
class FFTCustomAnalyzer {
  // FFT array size, should be power of two, eg 2, 4, 8, 16, 32
  // TIP: choose 512 for measuring, but focus on bars 5-64, because the fifth bar, for example, is the C3 is spectrum[3], C4 is spectrum[6], C5 is spectrum[12] and so on
  private final int measureBands = 512;
  private final float[] spectrum = new float[measureBands];
  
  private AudioIn in;
  private Amplitude amp; // TODO could it be removed?? maybe it returns average on whole spectrum 
  private FFT fft;
  
  public FFTCustomAnalyzer(PApplet parent, int channel) {
    in = new AudioIn(parent, channel);
    in.start();
    // launch amplitude analyzer
    amp = new Amplitude(parent);
    amp.input(in);
    // launch FFT analyzing
    fft = new FFT(parent, measureBands);
    fft.input(in);
  }
  
  /**
   * The user of the class should call this class in order to get spectrogram and extra info
   */
  public float analyze() {
    fft.analyze(this.spectrum);
    return amp.analyze();
  }
  
  /**
   * Computes average on the interval [start, end). Start is included, end is not included.
   */
  public float averageOn(int start, int end) {
    float acc = 0;
    for (int i = start; i < end; i++) {
      acc += this.spectrum[i];
    }
    return acc / (end - start);
  }
  
  public float[] getSpectrum() {
    return spectrum;
  }
  
  public float bassLevel() {
    return averageOn(1, 3); // the first bar may contain a lot of noize
  }
  public float smallOctaveLevel() {
    return averageOn(3, 6);
  }
  public float firstOctaveLevel() {
    return averageOn(6, 12);
  }
  public float secondOctaveLevel() {
    return averageOn(12, 24);
  }
  public float thirdOctaveLevel() {
    return averageOn(24, 48);
  }
  
  // stubs for analyzing spectrograms for snare and bass drums (should be coded onsite when soundcheck)
  public boolean snare() {
    return false;
  }
  public boolean bassBarrel() {
    return false;
  }
}
