/************************************************/
/*             Car 2D in Processing             */
/************************************************/
//description
//
// MVC Pattern
// MODEL : Class(Button, Car), Object
// VIEW : Scene(Menu, Game, Setting);
// CONTROLLER : Event(Mouse, Keyboard)
//
/************************************************/
/*                   Variables                  */
/************************************************/
// scene : select Scene
// difficulty : game`s difficulty (1 ~ 3)
// objMinSpeed : It changes with difficulty
// objMaxSpeed : It changes with difficulty
// traffic : amount of object
// life : if detected collision then life -1
// scroll : scroll the background image infinity
// initScrollSpeed : inital Scroll Speed for return to origin speed
// ScrollSpeed : current background image scroll speed
// bAccel, bBrake, .. : pressed the Button THEN True ELSE False

int scene = 0;
int difficulty = 2;
int objMinSpeed = 4;
int objMaxSpeed = 8;
int traffic = 10;
int life = 5;
float scroll = 0;
float initScrollSpeed = 50.0;
float scrollSpeed = initScrollSpeed;
boolean bAccel, bBrake, bLeft, bRight;
boolean pressedSpacebar;
PImage menuSceneImg;
PImage gameSceneImg;
PImage settingSceneImg;

color buttonColor = color(160, 160, 160, 200);

Button startBtn;
Button exitBtn;
Button settingBtn;
Button difficultyEasyBtn;
Button difficultyNormalBtn;
Button difficultyHardBtn;
Button previousBtn;

Car myCar;
ObjectCar[] obj;

/************************************************/
/*                  Initialize                  */
/************************************************/

void setup() {
  size(720, 900);
  smooth();
  frameRate(60);
  rectMode(CENTER);
  setImage(); // load images
  setButton(); // create Button
  setObject(); // create cars
}

void setImage() {
  menuSceneImg = loadImage("menuSceneImg.png");
  gameSceneImg = loadImage("gameSceneImg.png");
  settingSceneImg = loadImage("settingSceneImg.jpg");
}

void setButton() {
  startBtn = new Button(360, 350, 100, 40, "START", buttonColor);
  settingBtn = new Button(360, 410, 100, 40, "Setting", buttonColor);
  exitBtn = new Button(360, 470, 100, 40, "EXIT", buttonColor);
  difficultyEasyBtn = new Button(260, 750, 100, 40, "Easy", buttonColor);
  difficultyNormalBtn = new Button(380, 750, 100, 40, "Normal", buttonColor);
  difficultyHardBtn = new Button(500, 750, 100, 40, "Hard", buttonColor);
  previousBtn = new Button(130, 750, 100, 40, "Previous", buttonColor);
}

void setObject() {
  myCar = new Car(300, 700, 40, 60, color(240, 240, 240));
  obj = new ObjectCar[traffic];
  for (int i = 0; i < traffic; i++) {
    obj[i] = new ObjectCar();
  }
}

void setTraffic(int difficult) {
  switch(difficult) {
  case 1:
    traffic = 5;
    break;
  case 2:
    traffic = 10;
    break;
  case 3:
    traffic = 15;
    break;
  }
  setObject();
}

/************************************************/
/*                SCENE VIEW                   */
/************************************************/

void draw() {
  background(255); // Screen Initialize

  // menu Screen
  if (scene == 0) {
    menuScene();
  }

  // game Screen
  else if (scene == 1) {
    gameScene();
  }

  // setting Screen
  else if (scene == 2) {
    settingScene();
  }
}

void menuScene() {
  /**** Background *****/
  tint(255, 230); // tint(gray, alpha);
  image(menuSceneImg, 0, 0, width, height);
  noTint();
  /*********************/

  /****** Button ******/
  startBtn.create();
  settingBtn.create();
  exitBtn.create();
  /*********************/
}

void gameScene() {
  /**** Background *****/
  if (pressedSpacebar) {
    tint(255, 230);
    image(gameSceneImg, 0, scroll, width, height);
    image(gameSceneImg, 0, scroll-height, width, height);
    noTint();
    scroll += scrollSpeed;
    if (scroll >= height) scroll = 0;
  } else {
    image(gameSceneImg, 0, scroll, width, height);
    image(gameSceneImg, 0, scroll-height, width, height);
    scroll += scrollSpeed;
    if (scroll >= height) scroll = 0;
  }
  /*********************/

  myCar.move();
  for (ObjectCar o : obj) {
    o.move();
  }
}

void settingScene() {
  /**** Background *****/
  tint(255, 200);
  image(settingSceneImg, 0, 0, width, height);
  noTint();
  /*********************/

  /****** Button ******/
  difficultyEasyBtn.create();
  difficultyNormalBtn.create();
  difficultyHardBtn.create();
  previousBtn.create();
  /*********************/
}


/************************************************/
/*              EVENT CONTROLLER                */
/************************************************/

public void mousePressed() {
  // process in muneScreen
  if (scene == 0) {
    if (startBtn.isClicked(mouseX, mouseY)) {
      startBtn.changeColorPressed();
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      settingBtn.changeColorPressed();
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exitBtn.changeColorPressed();
    }
  }
  // process in gameScreen
  else if (scene == 1) {
  }
  // process in settingScreen
  else if (scene == 2) {
    if (previousBtn.isClicked(mouseX, mouseY)) {
      previousBtn.changeColorPressed();
    } else if (difficultyEasyBtn.isClicked(mouseX, mouseY)) {
      difficultyEasyBtn.changeColorPressed();
    } else if (difficultyNormalBtn.isClicked(mouseX, mouseY)) {
      difficultyNormalBtn.changeColorPressed();
    } else if (difficultyHardBtn.isClicked(mouseX, mouseY)) {
      difficultyHardBtn.changeColorPressed();
    }
  }
  println("mousePressed() Event is called (" + mouseX + ", " + mouseY + ")");
}

public void mouseReleased() {
  // process in muneScreen
  if (scene == 0) {
    // the color of button is return to origin
    startBtn.changeColorReleased();
    settingBtn.changeColorReleased();
    exitBtn.changeColorReleased();
    if (startBtn.isClicked(mouseX, mouseY)) {
      scene = 1;
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      scene = 2;
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exit();
    }
  }

  // process in gameScreen
  else if (scene == 1) {
  }

  // process in settingScreen
  else if (scene == 2) {
    // the color of button is return to origin
    previousBtn.changeColorReleased();
    difficultyEasyBtn.changeColorReleased();
    difficultyNormalBtn.changeColorReleased();
    difficultyHardBtn.changeColorReleased();
    if (previousBtn.isClicked(mouseX, mouseY)) {
      scene = 0;
    } else if (difficultyEasyBtn.isClicked(mouseX, mouseY)) {
      setTraffic(1);
    } else if (difficultyNormalBtn.isClicked(mouseX, mouseY)) {
      setTraffic(2);
    } else if (difficultyHardBtn.isClicked(mouseX, mouseY)) {
      setTraffic(3);
    }
  }
  println("mousRealesed() Event is called (" + mouseX + ", " + mouseY + ")");
}

public void keyPressed() {
  // process in menuScreen
  if (scene == 0) {
  }

  // process in gameScreen
  if (scene == 1) {
    if (key == CODED) {
      if (keyCode == UP) {
        println("bAccel");
        bAccel = true;
      }
      if (keyCode == LEFT) {
        println("bLeft");
        bLeft = true;
      }
      if (keyCode == RIGHT) {
        println("bRight");
        bRight = true;
      }
      if (keyCode == DOWN) {
        println("bBrake");
        bBrake = true;
      }
    } else if (keyCode == 32) { // SpaceBar
      scrollSpeed = initScrollSpeed / 3; // scrollSpeed -> 1/3
      for (ObjectCar o : obj) {
        o.carSpeed = o.initCarSpeed / 2; // objectSpeed -> 1/2
      }
      pressedSpacebar = true;
    } else if (keyCode == 80) { // P
      println("pause");
    }
  }

  // process in settingScreen
  if (scene == 2) {
  }
}

public void keyReleased() {
  // process in menuScreen
  if (scene == 0) {
  }

  // process in gameScreen
  if (scene == 1) {
    if (keyCode == 32) {
      scrollSpeed = initScrollSpeed; // scrollSpeed -> origin
      for (ObjectCar o : obj) {
        o.carSpeed = o.initCarSpeed;
      }
      pressedSpacebar = false;
    }
    if (key == CODED) {
      if (keyCode == UP) {
        bAccel = false;
      }
      if (keyCode == LEFT) {
        bLeft = false;
      }
      if (keyCode == RIGHT) {
        bRight = false;
      }
      if (keyCode == DOWN) {
        bBrake = false;
      }
    }

    // process in settingScreen
    if (scene == 2) {
    }
  }
}

/************************************************/
/*                CLASS MODEL                   */
/************************************************/

class Button {
  int btnX; // X position of Button
  int btnY; // Y position of Button
  int btnW; // Width of Button
  int btnH; // height of Button
  color btnColor; // color of Button
  color btnCurColor; // current Color of Button
  String btnName; // name of Button

  // constructor
  public Button(int inputX, int inputY, int inputW, int inputH, String inputName, color inputColor) {
    this.btnX = inputX;
    this.btnY = inputY;
    this.btnW = inputW;
    this.btnH = inputH;
    this.btnColor = inputColor;
    this.btnCurColor = btnColor;
    this.btnName = inputName;
  }

  //create Button
  void create() {
    noStroke();
    fill(btnCurColor);
    rect(btnX, btnY, btnW, btnH);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(btnName, btnX, btnY);
  }

  boolean isClicked(int inputX, int inputY) {
    if (inputX > btnX - (btnW / 2) && inputX < btnX + (btnW / 2) && inputY > btnY - (btnH / 2) && inputY < btnY + (btnH / 2)) {
      return true;
    } else 
    return false;
  }

  void changeColorPressed() {
    float r = red(this.btnCurColor);
    float g = green(this.btnCurColor);
    float b = blue(this.btnCurColor);
    this.btnCurColor = color(r-50, g-50, b-50);
  }
  void changeColorReleased() {
    this.btnCurColor = btnColor;
  }
}

class Car {
  float carX;
  float carY;
  float prevX;
  float prevY;
  int carW;
  int carH;
  float carSpeed = 0.0;
  float carRot = 0.0;
  color carColor;

  float inertia; // gwanseong

  public Car(int startX, int startY, int inputW, int inputH, color inputColor) {
    carX = startX; // car spawn X position
    carY = startY; // car spawn Y position
    carW = inputW;
    carH = inputH;
    carColor = inputColor;
  }

  void load() {
    pushMatrix();
    translate(carX, carY);
    rotate(carRot);

    //bumper
    stroke(0, 0, 255);
    fill(255, 255, 255);
    ellipse(0, -28, 40, 15);
    ellipse(0, 28, 42, 15);
    noStroke();

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // body
    fill(carColor);
    rect(0, 0, carW, carH);

    // light
    stroke(100);
    strokeWeight(1);
    fill(241, 255, 49);
    rect(-13, -25, 14, 10);
    rect(13, -25, 14, 10);
    noStroke();

    // up
    fill(198, 198, 198);
    rect(0, 0, 30, 40);

    // center : White
    stroke(0);
    strokeWeight(2);
    fill(255, 255, 255);
    rect(0, 0, 8, 8);
    noStroke();

    // left : Red
    stroke(0);
    strokeWeight(2);
    fill(255, 0, 0);
    rect(-8, 0, 8, 8);
    noStroke();

    // right : Blue
    stroke(0);
    strokeWeight(2);
    fill(0, 0, 255);
    rect(8, 0, 8, 8);
    noStroke();

    //side line
    stroke(0, 0, 255);
    strokeWeight(3);
    line(-20, -20, -20, 20);
    line(20, 20, 20, -20);
    noStroke();

    //back light
    stroke(255, 0, 0);
    strokeWeight(3);
    line(-18, 25, -8, 25);
    line(8, 25, 18, 25);
    noStroke();

    popMatrix();
  }

  void move() {
    prevX = carX;
    prevY = carY;
    carX += sin(carRot) * carSpeed;
    carY -= cos(carRot) * carSpeed;
    isCollide(carX, carY, prevX, prevY);
    load();

    //left Wall Collision
    if (carX < 145 ) {
      carX = 145;
    }
    //Right Wall Collision
    if (carX > 570) {
      carX = 570;
    }
    if (carY < 0 ) {
      carY = height;
    }  
    if (carY > height) {
      carY = 0;
    }

    if (bAccel == true) {
      carSpeed = inertia += .1;
    }
    if (bLeft == true) {
      carRot -= .065;
    }
    if (bRight == true) {
      carRot += .065;
    }
    if (bBrake == true) {
      carSpeed -= .4;
    } else {
      carSpeed -= .15;
    }

    carSpeed = constrain(carSpeed, 0, 8); // speed 0 ~ 8
    println(carSpeed);
  }

  void isCollide(float x, float y, float prevX, float prevY) {
    for (ObjectCar o : obj) {
      if (o.lane == "reverse") {
        if (dist(x, y, o.carX, o.carY1) < 40) {
          //carX = prevX + 20;
          carY = prevY + 20;
          carSpeed = 0;
          println("collide()");
        }
      } 
      if (o.lane == "forward") {
        if (dist(x, y, o.carX, o.carY2) < 40) {
          //carX = prevX -20;
          carY = prevY - 20;
          carSpeed = 0;
          println("collide()");
        }
      }
    }
  }
}

class ObjectCar {
  float carSpeed = random(objMinSpeed, objMaxSpeed);
  float initCarSpeed = carSpeed;
  color carColor = color(random(0, 255), random(0, 255), random(0, 255));
  color[] carLightColor = {color(255, 255, 255), color(241, 255, 49)};
  int[] spawnPosX = {195, 300, 415, 530};
  int carX = spawnPosX[(int)random(0, 4)];
  float carY1 = 0;
  float carY2 = height;
  int carW = 40;
  int carH = 60;
  String lane;

  ObjectCar() {
    changeLane();
  }

  void load() {
    if (lane == "reverse") {
      pushMatrix();
      translate(carX, carY1);
      fill(carColor);
      rect(0, 0, carW, carH);
      fill(241, 255, 49);
      rect(-13, 25, 14, 10);
      rect(13, 25, 14, 10);
      popMatrix();
    } 
    if (lane == "forward") {
      pushMatrix();
      translate(carX, carY2);
      fill(carColor);
      rect(0, 0, carW, carH);
      fill(241, 255, 49);
      rect(-13, -25, 14, 10);
      rect(13, -25, 14, 10);
      popMatrix();
    }
  }

  void move() {
    if (lane == "reverse") {
      carY1 += carSpeed;
    }
    if (lane == "forward") {
      carY2 -= carSpeed;
    }

    load();

    // infinity reverse lane
    if (carY1 - (carH/2) > height) {
      carY1 = 0 - (carH/2);
      changePos();
      changeLane();
      changeColor();
    }
    // infinity forward lane
    if (carY2 + (carH/2) < 0) {
      carY2 = height + (carH/2);
      changePos();
      changeLane();
      changeColor();
    }
  }
  void changePos() {
    carX = spawnPosX[(int)random(0, 4)];
  }
  void changeColor() { 
    carColor = color(random(0, 255), random(0, 255), random(0, 255));
  }
  void changeLane() {
    if (carX == 195 || carX == 300) {
      lane = "reverse";
    }
    if (carX == 415 || carX == 530) {
      lane = "forward";
    }
  }
}
