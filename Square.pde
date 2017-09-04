class Square {
  int x, y;
  float r, g, b;
  
  Square(int x, int y, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.g = g;
    this.b = b;
    //println(x, y);
  }
  
  void drawsquare() {
    //println("draw");
    fill(this.r, this.g, this.b);
    stroke(this.r, this.g, this.b);
    rect(this.x, this.y, 1, 1);
  }
  
  boolean hits(Square s) {
    return s.x == this.x & s.y == this.y;
  }
}
