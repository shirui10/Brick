PImage ball;
int    x, y;         //the coordinates of the ball
int    deltax,deltay;       //the wall of bricks;  brick size = 100 X 20
int[]  wall;
boolean Big;
boolean Slow;
float length;
int m = 10;
float z = 0;
float p = 0;

class Bat{
    Bat(){
        length = 200;
    }
    
    void drawMe(){
        //Display the bat centered at mouseX
        fill(0,0,255);
        rect( mouseX -length/2   , height-20 ,  length, 20);
    }
    
    void decreaseLength(){
        if(length>200)  
        length = length-0.2;
    }
 
}

class Brick{
  Brick(){
        if (Big == true) length = 300;
        else length = 200;
    }
  
  boolean intersectsBall(int x, int y){
     float ballCenterX = x+20;
     if(y+40>=height-20)     //height-20 is top border of bat (because bat's height=20)
         if( (ballCenterX>=mouseX-length/2) && (ballCenterX<=mouseX+length/2))
              return true;
     return false;
  }
    
  void draw(){
     for(int i=0;i<wall.length;i++)
        if(wall[i]==1){     //if brick i is not yet destroyed (alive)
            fill(0,255,255);
            rect(i*100,0,100,20);
            checkIntersectWall();
        }
  }
  
  boolean isDestroyed(){
    for(int i=0;i<wall.length;i++)
        if(wall[i]==1){     //if brick i is not yet destroyed (alive)
            if(y<=20)       //if ball may touch the brick
                if( (x+20>=i*100)&& (x+20<=i*100+100) ){
                    return true;
                }
        }
        return false;
  }
  
  void destroyMe(){
    boolean flag;  
    for(int i=0;i<wall.length;i++){
      flag = isDestroyed();
      if (flag == true) wall[i]=0;
    }
  }
    
}

void checkIntersectWall(){
  for(int i=0;i<wall.length;i++)
            if(y<=20)       //if ball may touch the brick
                if( (x+20>=i*100)&& (x+20<=i*100+100) ){
                  wall[i] = 0;  
                  deltay  = 5;
                }
}

void Big_Bat(){
   for(int i=0;i<wall.length;i++){
            if(wall[0]==0&&z<height-40){
              z = z + 0.3;
              fill(0,255,255);
              rect(25, z, 50, 20);
              textSize(12);
              fill(0,0,0);
              text("Big Bat", 30, z+12);
              if((z>=height-40)&&(75>=mouseX-100)&&(25<=mouseX+100))
                 length = 300;
                 Big = true; 
            }  
   }
}

void Slowdowm(){
   for(int i=0;i<wall.length;i++){
            if(wall[7]==0&&p<height-40){
              p = p + 0.3;
              fill(255,0,0);
              rect(725, p, 50, 20);
              textSize(12);
              fill(0,0,0);
              text("Slow", 735, p+12);
              if((p>=height-40)&&(775>=mouseX-100)&&(725<=mouseX+100))
                 Slow = true; 
            }  
   }
}

void checkWin(){
  int n=0;
  for(int i=0;i<wall.length;i++){
            if(wall[i]==0)  n++;
  }
  if(n == 8){
    textSize(35);
    fill(255,0,0);
    text("YOU WIN!",320,300);
    noLoop();
  }
}

Bat myBat = new Bat();
Brick myBrick = new Brick();

void setup(){
    size(800,600);
    ball = loadImage("ball40.png");//it has a size of 40 X 40 pixels
                                   //To be sure the image can be found, you may put here the whole complete path to the image
    deltax = 5;
    deltay = 5;
    x      = (int)random(1000);
    y      = 100;
    
    wall   = new int[8];
    for(int i=0;i<wall.length;i++)
        wall[i] = 1;

}


void draw(){
    background(200);        //clears the canvas with a light gray color
    x = x + deltax;         //the position of image/ball moves horizontally to right (assuming deltax>0)
    y = y + deltay;         //move down (when delta>=0)
    image(ball,x,y);        //paste the image: (x,y) is the top-left corner of the ball image
                            //the image/ball is displayed from pixel (x,y) to (x+40, y+40)
    if(x+40>=width)         //x+40 is the right border of the image
        deltax = -5;        //-5 means "move left"
    if(x<=0)
        deltax = 5;         //5 means "move right"
    if(y<=0)
        deltay = 5;
    if(y+40>=height){       //y+40 is the bottom border of the image/ball
        textSize(35);
        fill(255,0,0);
        text("YOU LOST!",320,300);
        noLoop();
    }

    myBat.drawMe();
    myBrick.draw();
    if(myBrick.intersectsBall(x,y))
       deltay = -5; 
    myBrick.destroyMe();
    Big_Bat();
    Slowdowm();
    if(Big==true) {
      myBat.decreaseLength(); 
    }
   
   if(Slow==true){
      frameRate(m);
      if(m<90) m++;
    }
    else  frameRate(90);
    checkWin();
}
