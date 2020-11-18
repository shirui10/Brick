PImage ball40;
int columns = 5;
int rows = 4;
int min_column_length;
int max_column_length;
boolean game_start = false;
int bat_width;
int brick_width;
int brick_height = 20;
int total_brick=20;
int win_brick = 0;
boolean game_over;
Ball ball;
Bat myBat;
ArrayList bricks = new ArrayList<Brick>();
int x = int(random(600));
float p = 0;
float m;


void setup() {
  size(800, 600);
  background(255, 255, 255);
  smooth();
  noCursor();
  ball = new Ball(width/2, height-55, 20.0);//
  myBat = new Bat((width/2)+5, height-20, 20);
  game_over = false;
  min_column_length = 3;
  max_column_length = int((0.55 * height)/brick_height);
  bat_width = width/5;
  brick_width = (width/columns);

  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      if (i==2) {
        UnbreakableBrick unbreakablebrick = new UnbreakableBrick(true, (i*brick_width)+5, j*(brick_height+5));
        bricks.add(unbreakablebrick);
      } else {
        Brick brick = new Brick(true, (i*brick_width)+5, j*(brick_height+5));
        bricks.add(brick);
      }
    }
  }
}

void draw() {
  background(200);
  ball40 = loadImage("ball40.png");
  if (!game_start && !game_over) {
    PFont start_text = createFont("Arial", 30, true);
    textFont(start_text);
    fill(0, 255, 0);
    textAlign(CENTER);
    text("Left click to start", width/2, height*.75);
  }

  if (game_over) {
    PFont game_over_text = createFont("Arial", 30, true);
    textFont(game_over_text);
    fill(255, 0, 0);
    textAlign(CENTER);
    text("Game Over", width/2, height/2);
    text("Bricks Left: " + total_brick, width/2, (height/2) + 30);
  } else if (total_brick == win_brick) {
    PFont win_text = createFont("Arial", 30, true);
    textFont(win_text);
    fill(0, 0, 255);
    textAlign(CENTER);
    text("You Win!", width/2, height/2);
  } else {
    PFont game_text = createFont("Arial", 15, true);
    textFont(game_text);
    fill(255, 0, 0);
    text("Bricks: " + total_brick, 50, height-20);
    for (int b = 0; b < bricks.size(); b++) {
      Brick brick = (Brick) bricks.get(b);
      brick.ball_touch(ball);
      brick.display();
    }
    ball.draw_ball();
    myBat.draw_bat();
    ball.update();
    myBat.update();
    ball.checkCollisions();
    myBat.ball_touch(ball);
    flag_check();
    frameRate(m);
  }
}

void mouseClicked() {
  game_start = true;
}

class Brick {
  boolean active;
  float x;
  float y;
  color c;

  public Brick(boolean a, float xpos, float ypos) {
    active = a;
    x = xpos;
    y = ypos;
  }

  void display() {
    if (active) {
      stroke(0);
      fill(0, 0, 255);
    } else {
      noStroke();
      noFill();
    }
    rect(x, y, brick_width - 10, brick_height, 5);
  }

  void destoryMe() {
    if (active) {
      active = false;
      total_brick--;
    }
  }

  void ball_touch(Ball ball) {
    if (active) {
      if (ball.x >= x && ball.x <= x+brick_width && ball.y + ball.radius > y && ball.y - ball.radius < y+brick_height) {
        ball.ySpeed *= -1;
        destoryMe();
      }

      if (ball.y > y && ball.y < y+brick_height && ball.x + ball.radius > x && ball.x - ball.radius < x+brick_width) {
        ball.xSpeed *= -1;
        destoryMe();
      }
    }
  }
}

void flag_check() {
  if (total_brick%3==0) {
    if (p<height-40) {
      p = p + 3;
      fill(255, 0, 0);
      rect(x, p, 50, 20);
      textSize(12);
      fill(0, 0, 0);
      text("Slow", x+20, p+12);
      if ((p>=height-40)&&(x+50>=mouseX-100)&&(x<=mouseX+100))
        m=25;
    }
  }
  if (total_brick%3!=0) {
    p=0;
    m=60;
  }
}


class UnbreakableBrick extends Brick {
  public UnbreakableBrick(boolean a, float xpos, float ypos) {
    super(a, xpos, ypos);
  }
  void display() {
    stroke(0);
    fill(255);
    rect(x, y, brick_width - 10, brick_height, 5);
  }
  void destoryMe() {
    if (active) {
      active = true;
    }
  }
}

class Bat {
  float xpos;
  float ypos;
  float bat_height;

  Bat(float x, float y, float yn) {
    xpos = x;
    ypos = y;
    bat_height = yn;
  }

  void update() {
    xpos = mouseX-(bat_width/2);
  }

  void draw_bat() {
    fill(128, 128, 128);
    stroke(0);
    rect(xpos, ypos, bat_width, bat_height, 10);
  }

  void ball_touch(Ball ball) {
    if (ball.x >= xpos && ball.x <= xpos+brick_width && ball.y + 35  > ypos && ball.y - 35 < ypos+brick_height) {
      ball.ySpeed *= -1;
    }
    if (ball.y  > ypos && ball.y < ypos+brick_height && ball.x + ball.radius > xpos && ball.x - ball.radius < xpos+brick_width) {
      ball.xSpeed *= -1;
    }
  }
}

class Ball {
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  float ball_size;
  float radius;

  Ball(float xpos, float ypos, float size) {
    x = xpos;
    y = ypos;
    ball_size=size;
    radius = ball_size/2;
    xSpeed = -4;
    ySpeed = -4;
  }

  void update() {
    if (game_start) {
      x += xSpeed;
      y += ySpeed;
    } else {
      x = mouseX;
    }
  }

  void checkCollisions() {
    float r = radius/2;
    if ( (x<20) || (x>width-20)) {
      xSpeed = -xSpeed;
    }
    if (y<r) {
      ySpeed = -ySpeed;
    }
    if (y>height-r) {
      game_over = true;
    }
  }

  void draw_ball() {
    image(ball40, x-20, y);
  }
}
