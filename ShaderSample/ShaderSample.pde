PShader julia;

void setup() {
  size(640, 360, P3D);
  noStroke();
  fill(204);
  julia = loadShader("JuliaFrag.glsl", "JuliaVert.glsl");
  julia.set("cRe", 0.2);
  julia.set("cIm", 0.5);
  julia.set("iter", 11);
  julia.set("zoom", 0.5 * min(height, width));
}

float hueOffset = 0.0;
float cIm = 0.5;
long tick = 0;
void draw() {
  hueOffset = (tick % 100) / 100.0;
  cIm = 1.5*sin(2 * PI * (tick % 150) / 150.0);
  shader(julia);
  julia.set("hueOffset", hueOffset);
  julia.set("cIm", cIm);
  background(0);
  rect(0, 0, width, height);
  tick++;
}
