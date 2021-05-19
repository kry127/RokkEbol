uniform mat4 transform;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec2 pos2d;
varying vec4 vertColor;

void main() {
  gl_Position = transform * position;
  pos2d = gl_Position.xy;
  vertColor = color;
}