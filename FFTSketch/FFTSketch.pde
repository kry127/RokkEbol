  
import processing.sound.*;

FFT fft;
AudioIn in;
int measureBands = 512;
int bands = 16;
float[] spectrum = new float[measureBands];

void setup() {
  size(512, 360);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, measureBands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);
  
  rectMode(CORNERS);
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  // line( i, height, i, height - spectrum[i]*height*5 );
    rect( i * width / bands, height, (i + 1) * width / bands, height - spectrum[i]*height*5);
  } 
}
