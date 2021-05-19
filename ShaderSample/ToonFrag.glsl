#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float cRe;
uniform float cIm;
uniform int iter;
uniform float hueOffset = 0.0;
uniform float zoom = 1.0;

varying vec2 pos2d;
varying vec4 vertColor;

void main() {
  vec2 c;
  c.x = cRe;
  c.y = cIm;
  vec2 z;
  z.x = pos2d.x / zoom;
  z.y = pos2d.y / zoom;

  int i;
  for (i=0; i<iter; i++) {
    float x = (z.x * z.x - z.y * z.y) + c.x;
    float y = (z.x * z.y + z.y * z.x) + c.y;

    if ((x * x + y * y) > 16.0) break;
    z.x = x;
    z.y = y;
  }

  float val = float(i) / float(iter);
  val += hueOffset;
  if (val > 1) { val--; }
  if (val < 0.3) {
    gl_FragColor = vec4((0.3 - val)/0.3, val/0.3, 0, vertColor.w);
  } else if (val < 0.6) {
    gl_FragColor = vec4(0, (0.6 - val)/0.3, (val - 0.3) / 0.3, vertColor.w);
  } else {
    gl_FragColor = vec4((val - 0.6)/0.4, 0, (1.0 - val) / 0.4, vertColor.w);
  }
  // gl_FragColor = vec4(vertColor.x * (1. - val), vertColor.y * (1. - val), vertColor.z*(1. - val), 1);
}