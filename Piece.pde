class Piece {
  int x, y, pieceType;
  int orient = 0;
  float r, g, b;
  boolean donew = false;
  Square[] squares = new Square[4];
  
  int[][][] types = new int[][][]{
    {
      {0, -4,  0, -2,  0, 0,  0, 2},
      {-4, 0,  -2, 0,  0, 0,  2, 0},
      {0, -4,  0, -2,  0, 0,  0, 2},
      {-4, 0,  -2, 0,  0, 0,  2, 0}
  
    }, {
      {-2, 0,  0, 0,  2, 0,  0, 2},
      {0, 0,  2, 0,  0, 2,  0, -2},
      {-2, 0,  0, 0,  2, 0,  0, -2},
      {-2, 0,  0, 0,  0, 2,  0, -2}
    }, {
      {0, 0,  2, 0,  2, 2,  0, 2},
      {0, 0,  2, 0,  2, 2,  0, 2},
      {0, 0,  2, 0,  2, 2,  0, 2},
      {0, 0,  2, 0,  2, 2,  0, 2}
    }, {
      {-2, 2,  -2, 0,  0, 0,  2, 0},
      {0, 4,  0, 2,  0, 0,  -2, 0},
      {-4, 2,  -2, 2,  0, 2,  0, 0},
      {-2, 2,  -2, 0,  -2, -2,  0, 2}
    }, {
      {2, 2,  2, 0,  0, 0,  -2, 0},
      {0, 4,  0, 2,  0, 0,  2, 0},
      {4, 2,  2, 2,  0, 2,  0, 0},
      {2, 2,  2, 0,  2, -2,  0, 2}
    }, {
      {-2, 4,  -2, 2,  0, 2,  0, 0},
      {-2, 2,  0, 2,  -4, 0,  -2, 0},
      {-2, 4,  -2, 2,  0, 2,  0, 0},
      {-2, 2,  0, 2,  -4, 0,  -2, 0}
    }, {
      {2, 4,  2, 2,  0, 2,  0, 0},
      {2, 2,  0, 2,  4, 0,  2, 0},
      {2, 4,  2, 2,  0, 2,  0, 0},
      {2, 2,  0, 2,  4, 0,  2, 0}
    }
  };
  
  void updateSquares() {
    for (int i = 0; i < 4; i++) {
      this.squares[i] = new Square(this.x + this.types[this.pieceType][this.orient][i * 2],
                                   this.y + this.types[this.pieceType][this.orient][i * 2 + 1],
                                   this.r, this.g, this.b);
    }
  }
  
  Piece(int x, int y) {
    this.x = x;
    this.y = y;
    this.pieceType = (int)random(types.length);
    this.updateSquares();
    
    float rth = this.pieceType  / (1.0 * this.types.length) * 2 * PI;
    float gth = rth + 2 * PI / 3.0;
    float bth = rth + 4 * PI / 3.0;
    
    this.r = (sin(rth) + 1) * 255 / 2.0;
    this.g = (sin(gth) + 1) * 255 / 2.0;
    this.b = (sin(bth) + 1) * 255 / 2.0;
    
    //println(r, g, b);
  }
  
  boolean hitsfallen() {
    boolean hits = false;
    
    for (Square ts: this.squares) {
      if (ts.y > ylen | ts.x < 0 | ts.x > xlen) {
        hits = true;
        break;
      }
      for (Square fs: fallenpieces) {
        if (ts.hits(fs)) {
          hits = true;
          break;
        }
      }
      if (hits) {
        break;
      }
    }
    return hits;
  }
  
  void fall() {
    if (!this.donew) {
      this.y += 2;
      //println(this.x, this.y);
      this.updateSquares();
      if (this.hitsfallen()) {
        this.y -= 2;
        this.updateSquares();
        for (Square s: this.squares) {
          if (s.y < 6) {
            setup();
            break;
          }
          fallenpieces.add(s);
        }
        fallenpieces_check();
      
        this.donew = true;
      }
    }
  }
  
  void left() {
    this.x -= 2;
    updateSquares();
    if (this.hitsfallen()) {
      this.x += 2;
      this.updateSquares();
    }
  }
  
  void right() {
    this.x += 2;
    updateSquares();
    if (this.hitsfallen()) {
      this.x -= 2;
      this.updateSquares();
    }
  }
  
  void clockwise() {
    this.orient = p_modulo(this.orient - 1, 4);
    updateSquares();
    if (this.hitsfallen()) {
      this.orient = p_modulo(this.orient + 1, 4);
      this.updateSquares();
    }
  }
  
  void aclockwise() {
    this.orient = p_modulo(this.orient + 1, 4);
    updateSquares();
    if (this.hitsfallen()) {
      this.orient = p_modulo(this.orient - 1, 4);
      this.updateSquares();
    }
  }
  
  void drawpiece() {
    for (Square s: this.squares) {
      s.drawsquare();
    }
  }
  
}


