float cellSize;
int frametally, score;
int xlen, ylen;
int hi_s, lo_s;
int lenaMode = 8;
PFont f;

int p_modulo(int a, int b) {
  if (a < 0) {
    return abs(a + b) % b;
  } else {
    return a % b;
  }
}

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

ArrayList<Square> fallenpieces;

void fallenpieces_check() {
  int[] tally_arr = new int[ylen];
  
  for (int i: tally_arr) {
    i = 0;
  }
  
  for (Square s: fallenpieces) {
    //println(s.x, s.y);
    tally_arr[s.y]++;
  }
  
  //println(tally_arr);
  //println(xlen, ylen);
  
  for (int y = 0; y < ylen; y++) {
    if (tally_arr[y] == (xlen + 1) / 2) {
      //println(y, tally_arr[y]);
      for (int i = fallenpieces.size() - 1; i >= 0; i--) {
        Square s = fallenpieces.get(i);
        if (s.y == y) {
          fallenpieces.remove(i);
          score++;
        } else if (s.y < y) {
          s.y += 2;
        }
      }
    }
  }
}

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

Piece currpiece;

void setup() {
  size(610, 810);
  frameRate(30);
  //println(-1 % 4);
  cellSize = 20;
  hi_s = 8;
  lo_s = 30;
  xlen = (int)(width / cellSize) - 1;
  ylen = (int)(height / cellSize) - 1;
  frametally = 0;
  score = 0;
  f = createFont("Arial", 16, true);
  currpiece = new Piece(10, 0);
  fallenpieces = new ArrayList<Square>();
}

void keyPressed() {
  switch (keyCode) {
    case LEFT:
      currpiece.left();
      break;
    case UP:
      currpiece.aclockwise();
      break;
    case RIGHT:
      currpiece.right();
      break;
    case DOWN:
      currpiece.clockwise();
      break;
    case ' ':
      currpiece.fall();
      break;
    case 'L':
      if (lenaMode == hi_s) {
        lenaMode = lo_s;
      } else {
        lenaMode = hi_s;
      }
      break;
    case 'R':
      setup();
      break;
  }
}

void draw() {
  translate(15, 0);
  scale(cellSize);
  background(0);
  stroke(255);
  fill(255);
  rect(0, 0, xlen, 5);
  if (frametally % lenaMode == 0) {
    currpiece.fall();
  }
  
  if (currpiece.donew) {
      currpiece = new Piece(10, 0);
  }
  
  currpiece.drawpiece();
  
  for (Square s: fallenpieces) {
    s.drawsquare();
  }
  
  stroke(0);
  fill(0);
  
  textFont(f, 01);
  
  text("score " + String.valueOf(score), 0.5, 0.5);
  
  frametally++;
}