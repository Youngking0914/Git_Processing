/************************************************/
/*             Car 2D in Processing             */
/************************************************/
// made by YoungKyu

// select Scene
static enum SceneEnum {
  main, game, setting, gameOver
}

// select difficulty
static enum difficultyEnum {
  easy, normal, hard
}

// global variables
int objMinSpeed = 4;
int objMaxSpeed = 8;
int traffic = 10;
int life = 100;
int score = 0;
int abillity = 100;
float scroll = 0;
float initScrollSpeed = 50.0;
float scrollSpeed = initScrollSpeed;
boolean bAccel, bBrake, bLeft, bRight;
boolean pressedSpacebar;
boolean isNight = false;

PImage[] sceneImgs;
PImage[] previewImgs;
PImage currentPreviewImg;

PFont font;

color menuButtonColor;
color settingButtonColor;
color textColor;

// const int for clean code
static final int LEFT_WALL = 145;
static final int RIGHT_WALL = 570;

// Initialize
difficultyEnum currentDifficulty = difficultyEnum.normal;
SceneEnum currentScene = SceneEnum.main;

Button startBtn;
Button exitBtn;
Button settingBtn;
Button difficultyEasyBtn;
Button difficultyNormalBtn;
Button difficultyHardBtn;
Button dayBtn;
Button nightBtn;
Button previousBtn;

// MyCar : Character
Car myCar;
// Objects
ObjectCar[] obj;

/************************************************/
/*                  Initialize                  */
/************************************************/

void setup() {
  size(720, 900);
  smooth();
  frameRate(30); // for gameSpeed
  rectMode(CENTER);
  setFont(); // load fonts
  setImage(); // load images
  setButton(); // create Button
  setObject(); // create cars
  setTraffic(); // set Objects Traffic
  setAppearance(); // set Day or Night
}

void setFont() {
  font = loadFont("ArialRoundedMTBold-120.vlw");
}

void setImage() {
  sceneImgs = new PImage[4];
  previewImgs = new PImage[2];
  sceneImgs[0] = loadImage("menuSceneImg.png");
  sceneImgs[1] = loadImage("gameSceneImg.png");
  sceneImgs[2] = loadImage("settingSceneImg.jpg");
  sceneImgs[3] = loadImage("gameOverSceneImg.jpg");
  previewImgs[0] = loadImage("dayPlayImg.png");
  previewImgs[1] = loadImage("nightPlayImg.png");
}

void setButton() {
  menuButtonColor = color(25, 25, 25, 200);
  settingButtonColor = color(25, 25, 25, 150);
  textColor = color(255);

  startBtn = new Button(360, 410, 150, 60, "START");
  settingBtn = new Button(360, 490, 150, 60, "Setting");
  exitBtn = new Button(360, 570, 150, 60, "EXIT");

  difficultyEasyBtn = new Button(130, 140, 150, 60, "Easy");
  difficultyNormalBtn = new Button(130, 210, 150, 60, "Normal");
  difficultyHardBtn = new Button(130, 280, 150, 60, "Hard");
  dayBtn = new Button(130, 510, 150, 60, "Day");
  nightBtn = new Button(130, 580, 150, 60, "Night");
  previousBtn = new Button(130, 800, 150, 60, "Previous");

  startBtn.setColor(menuButtonColor, textColor);
  settingBtn.setColor(menuButtonColor, textColor);
  exitBtn.setColor(menuButtonColor, textColor);

  difficultyEasyBtn.setColor(settingButtonColor, textColor);
  difficultyNormalBtn.setColor(settingButtonColor, textColor);
  difficultyHardBtn.setColor(settingButtonColor, textColor);
  dayBtn.setColor(settingButtonColor, textColor);
  nightBtn.setColor(settingButtonColor, textColor);
  previousBtn.setColor(settingButtonColor, textColor);

  startBtn.setTextSize(30);
  settingBtn.setTextSize(30);
  exitBtn.setTextSize(30);

  difficultyEasyBtn.setTextSize(30);
  difficultyNormalBtn.setTextSize(30);
  difficultyHardBtn.setTextSize(30);
  dayBtn.setTextSize(30);
  nightBtn.setTextSize(30);
  previousBtn.setTextSize(30);
}

void setObject() {
  myCar = new Car(300, 700, 40, 60, color(240, 240, 240));
  obj = new ObjectCar[traffic];
  for (int i = 0; i < traffic; i++) {
    obj[i] = new ObjectCar();
  }
}

void setTraffic() {
  switch(currentDifficulty) {
  case easy:
    traffic = 5;
    break;
  case normal:
    traffic = 10;
    break;
  case hard:
    traffic = 15;
    break;
  }
  setObject();
}

void setAppearance() {
  currentPreviewImg = previewImgs[0];
}

/************************************************/
/*                     SCENE                    */
/************************************************/

void draw() {
  background(255); // Scene Initialize

  switch(currentScene) {
  case main:
    menuScene();
    break;
  case game:
    gameScene();
    break;
  case setting:
    settingScene();
    break;
  case gameOver:
    gameOverScene();
    break;
  }
}

void menuScene() {
  /**** Background *****/
  tint(255, 190); // tint(gray, alpha);
  image(sceneImgs[0], 0, 0, width, height);
  noTint();
  /*********************/

  /****** Button ******/
  startBtn.create();
  settingBtn.create();
  exitBtn.create();
  /*********************/

  /****** TEXT *********/
  pushMatrix();
  textSize(140);
  textFont(font, 140);
  textAlign(CENTER);
  fill(60, 60, 60);
  text("Car 2D !", 365, 305);
  fill(160, 131, 203);
  text("Car 2D !", 360, 300);
  popMatrix();
  /*********************/
}

void gameScene() {
  /**** Background *****/
  if (pressedSpacebar) {
    tint(100);
    image(sceneImgs[1], 0, scroll, width, height);
    image(sceneImgs[1], 0, scroll-height, width, height);
    noTint();
    tint(255, 250);
    fill(255, 255, 255, 125);
    ellipseMode(CENTER);
    ellipse(myCar.carX, myCar.carY, 100, 125);
    noTint();
    scroll += scrollSpeed;
  } else {
    image(sceneImgs[1], 0, scroll, width, height);
    image(sceneImgs[1], 0, scroll-height, width, height);
    scroll += scrollSpeed;
  }
  if (scroll >= height) scroll = 0;
  if (isNight) {
    fill(0, 0, 0, 150);
    rect(0, 0, width*2, height*2);
  }
  /*********************/

  myCar.load();
  for (ObjectCar o : obj) {
    o.load();
  }
  score++;

  if (pressedSpacebar == true) {
    if (abillity > 0) {
      abillity--; 
      scrollSpeed = initScrollSpeed / 3; // scrollSpeed -> 1/3
      for (ObjectCar o : obj) {
        o.carSpeed = o.initCarSpeed / 2; // objectSpeed -> 1/2
      }
    } else {
      pressedSpacebar = false;
    }
  } else {  
    abillity++;
    scrollSpeed = initScrollSpeed; // scrollSpeed -> origin
    for (ObjectCar o : obj) {
      o.carSpeed = o.initCarSpeed;
    }
  }
  abillity = constrain(abillity, 0, 100);

  /****** TEXT *********/
  textSize(30);
  fill(0, 255, 40);
  String f = Float.toString(Math.round(frameRate));
  text("fps", 50, 30);
  text(f, 50, 65);

  fill(0, 0, 0, 100);
  rect(655, 100, 70, 140);

  fill(255, 255, 0);
  textSize(25);
  text("LIFE", 655, 60);
  text(life, 655, 90);
  textSize(18);
  text("SCORE", 655, 120);
  textSize(20);
  text(score, 655, 150);

  fill(0, 0, 0, 100);
  rect(655, 270, 70, 170);
  fill(90, 234, 190);
  textSize(15);
  text("ABILLITY", 655, 205);
  if (abillity > 0) {
    rect(655, 330, 60, 20);
  }
  if (abillity >= 30) {
    rect(655, 305, 60, 20);
  }
  if (abillity >= 60) {
    rect(655, 280, 60, 20);
  }
  if (abillity >= 90) {
    rect(655, 255, 60, 20);
  }
  if (abillity >= 100) {
    rect(655, 230, 60, 20);
  }
  /***********************/
}

void settingScene() {
  /**** Background *****/
  tint(255, 200);
  image(sceneImgs[2], 0, 0, width, height);
  noTint();
  if (isNight) {
    fill(0, 0, 0, 150);
    rect(0, 0, width*2, height*2);
  }
  /*********************/

  /****** Button *******/
  difficultyEasyBtn.create();
  difficultyNormalBtn.create();
  difficultyHardBtn.create();
  dayBtn.create();
  nightBtn.create();
  previousBtn.create();
  /**********************/

  /****** TEXT *********/
  pushMatrix();
  textSize(60);
  textFont(font, 60);
  textAlign(CENTER);
  fill(70, 70, 70);
  text("Difficulty", 133, 83);
  fill(255, 255, 255);
  text("Difficulty", 130, 80);
  fill(70, 70, 70);
  textSize(45);
  text("Appearance", 141, 453);
  fill(255, 255, 255);
  text("Appearance", 138, 450);
  fill(70, 70, 70);
  textSize(60);
  text("Preview", 493, 83);
  fill(255, 255, 255);
  text("Preview", 490, 80);
  popMatrix();

  /*********************/

  /**** Image *****/
  pushMatrix();
  tint(255, 225);
  image(currentPreviewImg, 300, 150, width/1.8, height/1.8);
  noTint();
  popMatrix();
  /*********************/
}

void gameOverScene() {
  /**** Background *****/
  tint(255, 100); // tint(gray, alpha);
  image(sceneImgs[3], 0, 0, width, height);
  noTint();
  fill(255, 0, 0);
  textSize(60);
  text("Game Over", 360, 180);
  textSize(40);
  text("Your Score", 360, 250);
  textSize(80);
  fill(240, 197, 80); 
  text(score, 360, 350);
  fill(255, 0, 0);
  textSize(50);
  text("Click to Continue !", 360, 700);
  /*********************/
}

void isGameOver(int life) {
  if (life <= 0)
    currentScene = SceneEnum.gameOver;
}

/************************************************/
/*                    EVENT                     */
/************************************************/

public void mousePressed() {
  // process in muneScreen
  if (currentScene == SceneEnum.main) {
    if (startBtn.isClicked(mouseX, mouseY)) {
      startBtn.changeColorPressed();
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      settingBtn.changeColorPressed();
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exitBtn.changeColorPressed();
    }
  }
  // process in gameScreen
  else if (currentScene == SceneEnum.game) {
  }
  // process in settingScreen
  else if (currentScene == SceneEnum.setting) {
    if (previousBtn.isClicked(mouseX, mouseY)) {
      previousBtn.changeColorPressed();
    } else if (difficultyEasyBtn.isClicked(mouseX, mouseY)) {
      difficultyEasyBtn.changeColorPressed();
    } else if (difficultyNormalBtn.isClicked(mouseX, mouseY)) {
      difficultyNormalBtn.changeColorPressed();
    } else if (difficultyHardBtn.isClicked(mouseX, mouseY)) {
      difficultyHardBtn.changeColorPressed();
    } else if (dayBtn.isClicked(mouseX, mouseY)) {
      dayBtn.changeColorPressed();
    } else if (nightBtn.isClicked(mouseX, mouseY)) {
      nightBtn.changeColorPressed();
    }
  }
  // process in gameOverScreen
  else if (currentScene == SceneEnum.gameOver) {
  }
  println("mousePressed() Event is called (" + mouseX + ", " + mouseY + ")");
}

public void mouseReleased() {
  // process in muneScreen
  if (currentScene == SceneEnum.main) {
    // the color of button is return to origin
    startBtn.changeColorReleased();
    settingBtn.changeColorReleased();
    exitBtn.changeColorReleased();
    if (startBtn.isClicked(mouseX, mouseY)) {
      currentScene = SceneEnum.game;
    } else if (settingBtn.isClicked(mouseX, mouseY)) {
      currentScene = SceneEnum.setting;
    } else if (exitBtn.isClicked(mouseX, mouseY)) {
      exit();
    }
  }

  // process in gameScreen
  else if (currentScene == SceneEnum.game) {
  }

  // process in settingScreen
  else if (currentScene == SceneEnum.setting) {
    // the color of button is return to origin
    previousBtn.changeColorReleased();
    difficultyEasyBtn.changeColorReleased();
    difficultyNormalBtn.changeColorReleased();
    difficultyHardBtn.changeColorReleased();
    dayBtn.changeColorReleased();
    nightBtn.changeColorReleased();
    if (previousBtn.isClicked(mouseX, mouseY)) {
      currentScene = SceneEnum.main;
    } else if (difficultyEasyBtn.isClicked(mouseX, mouseY)) {
      setTraffic();
    } else if (difficultyNormalBtn.isClicked(mouseX, mouseY)) {
      setTraffic();
    } else if (difficultyHardBtn.isClicked(mouseX, mouseY)) {
      setTraffic();
    } else if (dayBtn.isClicked(mouseX, mouseY)) {
      currentPreviewImg = previewImgs[0];
      isNight = false;
    } else if (nightBtn.isClicked(mouseX, mouseY)) {
      currentPreviewImg = previewImgs[1];
      isNight = true;
    }
  }
  // process in gameOverScreen
  else if (currentScene == SceneEnum.gameOver) {
    currentScene = SceneEnum.main;
    score = 0;
    life = 100;
    setObject();
  }
  println("mousRealesed() Event is called (" + mouseX + ", " + mouseY + ")");
}

public void keyPressed() {
  // process in menuScreen
  if (currentScene == SceneEnum.main) {
  }

  // process in gameScreen
  if (currentScene == SceneEnum.game) {
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
      pressedSpacebar = true;
    } else if (keyCode == 80) { // P
      println("pause");
    }
  }

  // process in settingScreen
  if (currentScene == SceneEnum.setting) {
  }
}

public void keyReleased() {
  // process in menuScreen
  if (currentScene == SceneEnum.main) {
  }

  // process in gameScreen
  if (currentScene == SceneEnum.game) {
    if (keyCode == 32) {
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
    if (currentScene == SceneEnum.setting) {
    }
  }
}

/************************************************/
/*                    CLASS                     */
/************************************************/

class Button {
  int btnX; // X position of Button
  int btnY; // Y position of Button
  int btnW; // Width of Button
  int btnH; // height of Button
  int textSize; // size of Text
  color btnColor; // color of Button
  color btnCurColor; // current Color of Button
  color textColor; // color of Text
  String btnName; // name of Button

  // constructor
  public Button(int inputX, int inputY, int inputW, int inputH, String inputName) {
    this.btnX = inputX;
    this.btnY = inputY;
    this.btnW = inputW;
    this.btnH = inputH;
    this.btnName = inputName;
  }

  //create Button
  void create() {
    noStroke();
    fill(btnCurColor);
    rect(btnX, btnY, btnW, btnH);
    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(btnName, btnX, btnY);
  }

  void setColor(color inputBtnColor, color inputTextColor) {
    this.btnColor = inputBtnColor;
    this.btnCurColor = btnColor;
    this.textColor = inputTextColor;
  }

  void setTextSize(int inputSize) {
    textSize = inputSize;
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
    move();
    pushMatrix();
    translate(carX, carY);
    rotate(carRot);

    //bumper
    stroke(255);
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
    stroke(220);
    strokeWeight(1);
    fill(255, 255, 0);
    rect(-15, -25, 10, 6);
    rect(15, -25, 10, 6);
    noStroke();

    //window
    fill(90, 90, 90);
    ellipse(0, -15, 30, 7);

    //top
    fill(200, 200, 200);
    rect(0, 0, 32, 16);

    //backWindow
    fill(90, 90, 90);
    ellipse(0, 15, 28, 7);
    stroke(20);
    fill(20);
    rect(0, 42, 46, 8);
    rect(-8, 34, 6, 10);
    rect(8, 34, 6, 10);
    noStroke();

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
    carCollide(carX, carY, prevX, prevY);
    wallCollide(carX);
    carLoop(carY);


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

    carSpeed = constrain(carSpeed, 0, 10); // speed 0 ~ 8
    println(carSpeed);
  }

  void carCollide(float x, float y, float prevX, float prevY) {
    for (ObjectCar o : obj) {
      if (o.lane == "reverse") {
        if (dist(x, y, o.carX, o.carY1) < 40) {
          //carX = prevX + 20;
          carY = prevY + 20;
          carSpeed = 0;
          isGameOver(--life);
          println("collide()");
        }
      } 
      if (o.lane == "forward") {
        if (dist(x, y, o.carX, o.carY2) < 40) {
          //carX = prevX -20;
          carY = prevY - 20;
          carSpeed = 0;
          isGameOver(--life);
          println("collide()");
        }
      }
    }
  }
  void wallCollide(float x) {
    //left Wall Collision
    if (x < LEFT_WALL) {
      carX = LEFT_WALL;
    }
    //Right Wall Collision
    if (x > RIGHT_WALL) {
      carX = RIGHT_WALL;
    }
  }
  void carLoop(float y) {
    if (y < 0 ) {
      carY = height;
    }  
    if (y > height) {
      carY = 0;
    }
  }
}

class ObjectCar {
  private static final int carW = 40;
  private static final int carH = 60;
  private static final int LANE_1 = 195;
  private static final int LANE_2 = 300;
  private static final int LANE_3 = 415;
  private static final int LANE_4 = 530;

  float carSpeed = random(objMinSpeed, objMaxSpeed);
  float initCarSpeed = carSpeed;
  int[] reverseDesignList = {1, 2, 3, 4};
  int[] forwardDesignList = {1, 2, 3, 4};
  int[] laneList = {LANE_1, LANE_2, LANE_3, LANE_4};
  int carX = laneList[(int)random(0, laneList.length)];
  int reverseDesign;
  int forwardDesign;
  float carY1 = 0; // top of screen
  float carY2 = height; // bottom of screen
  String lane;

  public ObjectCar() {
    changeLane();
    changeDesign();
  }

  void load() {
    if (lane == "reverse") {
      move();
      switch(reverseDesign) {
      case 0:
        reverseDesign1();
        break;
      case 1:
        reverseDesign2();
        break;
      case 2:
        reverseDesign3();
        break;
      case 3:
        reverseDesign4();
        break;
      }
    }
    if (lane == "forward") {
      move();
      switch(forwardDesign) {
      case 0:
        forwardDesign1();
        break;
      case 1:
        forwardDesign2();
        break;
      case 2:
        forwardDesign3();
        break;
      case 3:
        forwardDesign4();
        break;
      }
    }
  }

  void move() {
    if (lane == "reverse") {
      carY1 += carSpeed;
    }
    if (lane == "forward") {
      carY2 -= carSpeed;
    }

    // infinity reverse lane
    if (carY1 - (carH/2) > height) {
      carY1 = 0 - (carH/2);
      changePos();
      changeDesign();
      changeLane();
    }
    // infinity forward lane
    if (carY2 + (carH/2) < 0) {
      carY2 = height + (carH/2);
      changePos();
      changeDesign();
      changeLane();
    }
  }
  void changePos() {
    carX = laneList[(int)random(0, laneList.length)];
  }
  void changeDesign() { 
    reverseDesign = (int)random(0, reverseDesignList.length);
    forwardDesign = (int)random(0, forwardDesignList.length);
  }
  void changeLane() {
    if (carX == LANE_1 || carX == LANE_2) {
      lane = "reverse";
    }
    if (carX == LANE_3 || carX == LANE_4) {
      lane = "forward";
    }
  }

  //white car
  void reverseDesign1() {
    pushMatrix();
    translate(carX, carY1);

    //bumper
    stroke(240, 240, 240);
    fill(240, 240, 240);
    ellipse(0, -28, 40, 15);
    ellipse(0, 28, 40, 15);
    noStroke();

    //body
    fill(240, 240, 240);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(255, 255, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    rect(-15, 25, 8, 5);
    rect(15, 25, 8, 5);
    noStroke();

    //window
    fill(90, 90, 90);
    ellipse(0, 15, 30, 7);

    //top
    fill(200, 200, 200);
    rect(0, 0, 30, 15);

    //backWindow
    fill(90, 90, 90);
    ellipse(0, -15, 28, 7);

    popMatrix();
  }

  //red car
  void reverseDesign2() {
    pushMatrix();
    translate(carX, carY1);

    //bumper
    stroke(255, 70, 70);
    fill(255, 70, 70);
    ellipse(0, -28, 40, 15);
    ellipse(0, 28, 40, 15);
    noStroke();

    //body
    fill(255, 70, 70);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(255, 255, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    rect(-15, 25, 8, 5);
    rect(15, 25, 8, 5);
    noStroke();

    //window
    fill(90, 90, 90);
    ellipse(0, 15, 30, 7);

    //top
    fill(200, 200, 200);
    rect(0, 0, 30, 15);

    //backWindow
    fill(90, 90, 90);
    ellipse(0, -15, 28, 7);

    popMatrix();
  }

  //yellow car
  void reverseDesign3() {
    pushMatrix();
    translate(carX, carY1);

    //bumper
    stroke(250, 213, 0);
    fill(250, 213, 0);
    ellipse(0, 28, 40, 15);
    stroke(20);
    fill(20);
    rect(0, -34, 46, 8);
    noStroke();

    //body
    fill(250, 213, 0);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(20, 20, 20);
    strokeWeight(1);
    fill(20, 20, 20);
    ellipse(-15, 25, 8, 5);
    ellipse(15, 25, 8, 5);
    noStroke();

    //window
    fill(50, 50, 50);
    ellipse(0, 15, 30, 7);

    //top
    fill(214, 184, 15);
    rect(0, 0, 30, 15);

    //backWindow
    fill(50, 50, 50);
    ellipse(0, -15, 28, 7);

    popMatrix();
  }

  //blue car
  void reverseDesign4() {
    pushMatrix();
    translate(carX, carY1);

    //bumper
    stroke(19, 102, 232);
    fill(19, 102, 232);
    ellipse(0, 28, 40, 15);
    noStroke();

    //body
    fill(19, 102, 232);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(200);
    strokeWeight(2);
    fill(255, 255, 255);
    rect(-15, 25, 8, 5);
    rect(15, 25, 8, 5);
    noStroke();

    //window
    fill(250, 250, 250);
    rect(0, 15, 30, 7);

    //top
    fill(24, 80, 167);
    rect(0, 0, 30, 15);

    //back
    fill(43, 43, 43);
    rect(0, -15, 35, 25);

    popMatrix();
  }

  //blue car
  void forwardDesign1() {
    pushMatrix();
    translate(carX, carY2);

    //bumper
    stroke(19, 102, 232);
    fill(19, 102, 232);
    ellipse(0, -28, 40, 15);
    noStroke();

    //body
    fill(19, 102, 232);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(200);
    strokeWeight(2);
    fill(255, 255, 255);
    rect(-15, -25, 8, 5);
    rect(15, -25, 8, 5);
    noStroke();

    //window
    fill(250, 250, 250);
    rect(0, -15, 30, 7);

    //top
    fill(24, 80, 167);
    rect(0, 0, 30, 15);

    //back
    fill(43, 43, 43);
    rect(0, 15, 35, 25);

    popMatrix();
  }

  //white car
  void forwardDesign2() {
    pushMatrix();
    translate(carX, carY2);

    //bumper
    stroke(240, 240, 240);
    fill(240, 240, 240);
    ellipse(0, -28, 40, 15);
    ellipse(0, 28, 40, 15);
    noStroke();

    //body
    fill(240, 240, 240);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(255, 255, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    rect(-15, -25, 8, 5);
    rect(15, -25, 8, 5);
    noStroke();

    //window
    fill(90, 90, 90);
    ellipse(0, -15, 30, 7);

    //top
    fill(200, 200, 200);
    rect(0, 0, 30, 15);

    //backWindow
    fill(90, 90, 90);
    ellipse(0, 15, 28, 7);

    popMatrix();
  }

  //red car
  void forwardDesign3() {
    pushMatrix();
    translate(carX, carY2);

    //bumper
    stroke(255, 70, 70);
    fill(255, 70, 70);
    ellipse(0, -28, 40, 15);
    ellipse(0, 28, 40, 15);
    noStroke();

    //body
    fill(255, 70, 70);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(255, 255, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    rect(-15, -25, 8, 5);
    rect(15, -25, 8, 5);
    noStroke();

    //window
    fill(90, 90, 90);
    ellipse(0, -15, 30, 7);

    //top
    fill(200, 200, 200);
    rect(0, 0, 30, 15);

    //backWindow
    fill(90, 90, 90);
    ellipse(0, 15, 28, 7);

    popMatrix();
  }

  //yellow car
  void forwardDesign4() {
    pushMatrix();
    translate(carX, carY2);

    //bumper
    stroke(250, 213, 0);
    fill(250, 213, 0);
    ellipse(0, -28, 40, 15);
    stroke(20);
    fill(20);
    rect(0, 34, 46, 8);
    noStroke();

    //body
    fill(250, 213, 0);
    rect(0, 0, carW, carH);

    //tire
    fill(0);
    ellipse(-22, -13, 6, 12);
    ellipse(22, -13, 6, 12);
    ellipse(-22, 20, 6, 12);
    ellipse(22, 20, 6, 12);

    // light
    stroke(20, 20, 20);
    strokeWeight(1);
    fill(20, 20, 20);
    ellipse(-15, -25, 8, 5);
    ellipse(15, -25, 8, 5);
    noStroke();

    //window
    fill(50, 50, 50);
    ellipse(0, -15, 30, 7);

    //top
    fill(214, 184, 15);
    rect(0, 0, 30, 15);

    //backWindow
    fill(50, 50, 50);
    ellipse(0, 15, 28, 7);

    popMatrix();
  }
}
