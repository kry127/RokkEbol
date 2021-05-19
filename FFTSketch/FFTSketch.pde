  
import processing.sound.*;

Amplitude amp;
FFT fft;
AudioIn in;
int measureBands = 512;
int bands = 16;
float[] spectrum = new float[measureBands];
PFont f;

void setup() {
  size(860, 640);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, measureBands);
  in = new AudioIn(this, 0);
  
  // launch amplitude analyzer
  amp = new Amplitude(this);
  amp.input(in);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  
  //printArray(PFont.list());
  f = createFont("Comic Sans MS", 144);
  textFont(f);
  textAlign(CORNER, TOP);
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);
  float volume = amp.analyze();
  
  rectMode(CORNERS);
  fill(20, 220, 0);
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  // line( i, height, i, height - spectrum[i]*height*5 );
    rect( i * width / bands, height, (i + 1) * width / bands, height - spectrum[i]*height*3);
  }
  float spectrumIntegral = 0;
  for (int i = 0; i < spectrum.length; i++) {
    spectrumIntegral += spectrum[i];
  }
  fill(0);
  text(volume, 0, 0);
  text(spectrumIntegral, 0, 150);
}
