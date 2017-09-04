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
