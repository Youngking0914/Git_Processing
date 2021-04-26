/************************************************/
/*             Car 2D in Processing             */
/************************************************/
//description
//
// MVC Pattern
// MODEL : Class(Button, Car), Object
// VIEW : Screen(Menu, Game, Setting);
// CONTROLLER : Event(Mouse, Keyboard)
//
/************************************************/
/*                   Variables                  */
/************************************************/
// gameScreen : select Screen
// difficulty : game`s difficulty (1 ~ 3)
// objMinSpeed : It changes with difficulty
// objMaxSpeed : It changes with difficulty
// traffic : amount of object
// scroll : scroll the background image infinity
// initScrollSpeed : inital Scroll Speed for return to origin speed
// ScrollSpeed : current background image scroll speed
// bAccel, bBrake, .. : pressed the Button THEN True ELSE False

int gameScreen = 0;
int difficulty = 2;
int objMinSpeed = 4;
int objMaxSpeed = 8;
int traffic = 10;
float scroll = 0;
float initScrollSpeed = 50.0;
float scrollSpeed = initScrollSpeed;
boolean bAccel, bBrake, bLeft, bRight;
boolean pressedSpacebar;
PImage menuScreenImg;
PImage gameScreenImg;
PImage settingScreenImg;

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
  menuScreenImg = loadImage("menuScreenImg.png");
  gameScreenImg = loadImage("gameScreenImg.png");
  settingScreenImg = loadImage("settingScreenImg.jpg");
}

void setButton() {
  startBtn = new Button(360, 260, 100, 40, "START", buttonColor);
  settingBtn = new Button(360, 320, 100, 40, "Setting", buttonColor);
  exitBtn = new Button(360, 380, 100, 40, "EXIT", buttonColor);
  difficultyEasyBtn = new Button(240, 400, 100, 40, "Easy", buttonColor);
  difficultyNormalBtn = new Button(360, 400, 100, 40, "Normal", buttonColor);
  difficultyHardBtn = new Button(480, 400, 100, 40, "Hard", buttonColor);
  previousBtn = new Button(110, 400, 100, 40, "Previous", buttonColor);
}

void setObject() {
  myCar = new Car(300, 700, 40, 60, color(137, 156, 183));
  obj = new ObjectCar[traffic];
  for (int i = 0; i < traffic; i++) {
    obj[i] = new ObjectCar();
  }
}

/************************************************/
/*                SCREEN VIEW                   */
/************************************************/

void draw() {
  background(255); // Screen Initialize

  // menu Screen
  if (gameScreen == 0) {
    menuScreen();
  }

  // game Screen
  else if (gameScreen == 1) {
    gameScreen();
  }

  // setting Screen
  else if (gameScreen == 2) {
    settingScreen();
  }
}

void menuScreen() {
  /**** Background *****/
  tint(255, 230); // tint(gray, alpha);
  image(menuScreenImg, 0, 0, width, height);
  noTint();
  /*********************/

  /****** Button ******/
  startBtn.create();
  settingBtn.create();
  exitBtn.create();
  /*********************/
}

void gameScreen() {
  /**** Background *****/
  if (pressedSpacebar) {
    tint(255, 230);
    image(gameScreenImg, 0, scroll, width, height);
    image(gameScreenImg, 0, scroll-height, width, height);
    noTint();
    scroll += scrollSpeed;
    if (scroll >= height) scroll = 0;
  } else {
    image(gameScreenImg, 0, scroll, width, height);
    image(gameScreenImg, 0, scroll-height, width, height);
    scroll += scrollSpeed;
    if (scroll >= height) scroll = 0;
  }
  /*********************/

  myCar.move();
  for (ObjectCar o : obj) {
    o.move();
  }
}

void settingScreen() {
  /**** Background *****/
  tint(255, 200);
  image(settingScreenImg, 0, 0, width, height);
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
  if (gameScreen == 0) {
    if (startBtn.isClicked(mouseX, mouseY)) {
      startBtn.changeColorPressed();
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      settingBtn.changeColorPressed();
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exitBtn.changeColorPressed();
    }
  }
  // process in gameScreen
  else if (gameScreen == 1) {
  }
  // process in settingScreen
  else if (gameScreen == 2) {
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
  if (gameScreen == 0) {
    // the color of button is return to origin
    startBtn.changeColorReleased();
    settingBtn.changeColorReleased();
    exitBtn.changeColorReleased();
    if (startBtn.isClicked(mouseX, mouseY)) {
      gameScreen = 1;
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      gameScreen = 2;
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exit();
    }
  }

  // process in gameScreen
  else if (gameScreen == 1) {
  }

  // process in settingScreen
  else if (gameScreen == 2) {
    // the color of button is return to origin
    previousBtn.changeColorReleased();
    difficultyEasyBtn.changeColorReleased();
    difficultyNormalBtn.changeColorReleased();
    difficultyHardBtn.changeColorReleased();
    if (previousBtn.isClicked(mouseX, mouseY)) {
      gameScreen = 0;
    } else if (difficultyEasyBtn.isClicked(mouseX, mouseY)) {
      difficulty = 1;
    } else if (difficultyNormalBtn.isClicked(mouseX, mouseY)) {
      difficulty = 2;
    } else if (difficultyHardBtn.isClicked(mouseX, mouseY)) {
      difficulty = 3;
    }
  }
  println("mousRealesed() Event is called (" + mouseX + ", " + mouseY + ")");
}

public void keyPressed() {
  // process in menuScreen
  if (gameScreen == 0) {
  }

  // process in gameScreen
  if (gameScreen == 1) {
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
  if (gameScreen == 2) {
  }
}

public void keyReleased() {
  // process in menuScreen
  if (gameScreen == 0) {
  }

  // process in gameScreen
  if (gameScreen == 1) {
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
    if (gameScreen == 2) {
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
    fill(carColor);
    rect(0, 0, carW, carH);
    fill(241, 255, 49);
    rect(-13, -25, 14, 10);
    rect(13, -25, 14, 10);
    popMatrix();
  }

  void move() {
    carX += sin(carRot) * carSpeed;
    carY -= cos(carRot) * carSpeed;
    isCollide(carX, carY);
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
      carSpeed -= .3;
    } else {
      carSpeed -= .25;
    }

    carSpeed = constrain(carSpeed, 0, 10); // speed 0 ~ 10
    //println(carX, carY);
  }

  void isCollide(float inputX, float inputY) {
    float x = inputX / 2;
    float y = inputY / 2;
    for (ObjectCar o : obj) {
      //if (x > o.carX - (o.carW / 2) && x < o.carX + (o.carW / 2) 
      //  && y > o.carY1 - (o.carH / 2) && y < o.carY1 + (o.carH / 2)) {
      //    carX--;
      //    carSpeed = 0;
      //}
      if(o.lane = "reverseFirst"
      if (x > o.carY1 + (o.carH / 2)) {
        carX--;
        carSpeed = 0;
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
      if (carX == 195 || carX == 300) {
        lane = "reverse";
      }
      if (carX == 415 || carX == 530) {
        lane = "forward";
      }
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
      switch(lane) {
      case "reverse":
        carY1 += carSpeed;
        break;
      case "forward":
        carY2 -= carSpeed;
        break;
      }
      load();

      // infinity reverse lane
      if (carY1 - (carH/2) > height) {
        carY1 = 0 - (carH/2);
        changePos();
        changeColor();
      }
      // infinity forward lane
      if (carY2 + (carH/2) < 0) {
        carY2 = height + (carH/2);
        changePos();
        changeColor();
      }
    }
    void changePos() {
      carX = spawnPosX[(int)random(0, 4)];
    }
    void changeColor() { 
      carColor = color(random(0, 255), random(0, 255), random(0, 255));
    }
  }
