PVector car;
float speed; 
float rot; 
boolean leftBoolean, rightBoolean, speedBoolean; 

void setup() {
  size (740, 400);
  rectMode(CENTER);
  smooth();
  car = new PVector(width/2, height/2);
  speed = 0;
}

void draw() {
  //background(200);
  fill(255);
  text("스피드 : " + speed, 100, 100);
  text("전진 : UP키", 100, 120);
  text("좌회전 : LEFT키", 100, 140);
  text("우회전 : RIGHT키", 100, 160);
  fill(0, 30);
  rect(width,height, width*2, height*2);
  //이동
  car.x +=  cos(rot)*(speed); // current location + the next "step"
  car.y +=  sin(rot)*(speed);
  println(cos(rot) + ", " + sin(rot));
  println(rot);
  //ship
  /***
  pushMatrix();
  fill(255);
  translate(car.x, car.y); 
  rotate(rot); 
  rect(0, 0, 50, 20); 
  fill(100);
  rect(-18, 15, 10, 5);
  rect(18, 15, 10, 5);
  rect(-18, -15, 10, 5);
  rect(18, -15, 10, 5);
  fill(255, 255, 0);
  ellipse(29, 5, 10, 10);
  ellipse(29, -5, 10, 10);
  popMatrix();  
  ***/
  
  //반대 반향으로 다시 나오게 한다.
  if (car.x < 0 ){
    car.x = width;
  }
  if (car.x > width) {
    car.x = 0;
  }
  if (car.y < 0 ) {
    car.y = height;
  }  
  if (  car.y > height) {
    car.y = 0;
  }

  //방향키 
  if (leftBoolean == true) {
    rot -= .05;
  } 
  else if (rightBoolean == true) {
    rot += .05;
  } 
  if (speedBoolean == true) { 
    speed += .1;
  }
  else {
    speed -= .25;
  }
  
  //속도제한
  speed = constrain(speed, 0, 6);
}

void keyPressed() {
  println(keyCode); 
  if (keyCode == LEFT) {
    leftBoolean = true;
  }
  if (keyCode == RIGHT) {
    rightBoolean = true;
  }
  if (keyCode == UP) {
    speedBoolean = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    leftBoolean = false;
  }
  if (keyCode == RIGHT) {
    rightBoolean = false;
  }
  if (keyCode == UP) {
    speedBoolean = false;
  }
}
