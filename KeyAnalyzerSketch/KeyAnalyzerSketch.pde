// use this script as follows:
// press key combination and see log output for keycode to process

boolean alt, control, shift; // also, use this holy triple in your script as well

void draw() {
}

void keyPressed() {
  alt |= keyCode == ALT;
  control |= keyCode == CONTROL;
  shift |= keyCode == SHIFT;
  if (keyCode != ALT || keyCode != CONTROL || keyCode != SHIFT) {
    println("Key pressed with code: " + keyCode + "; alt=" + alt + ", ctrl=" + control + ", shift=" + shift);
  }
}

void keyReleased() {
  alt &= keyCode != ALT;
  control &= keyCode != CONTROL;
  shift &= keyCode != SHIFT;
}
