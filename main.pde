int canvasWidth = 800;
int canvasHeight = 600;

// Plane variables
float planeX, planeY;
float PLANE_SPEED = 4;

// Food variables
boolean foodInMotion = false;
float foodX, foodY, foodInitX, foodInitY, foodTimeDropped;
float FOOD_SPEED = 3;
float GRAVITY = 0.2;

// Target variables
float targetX, targetY, targetSize;
int score = 0;
int level = 1;
int targetHits = 0;
int messageTimer = 0;
String message = "";

void setup() {
  size(1000, 1000);
  planeX = -50;
  planeY = height / 6;
  resetTarget();
}

void draw() {
  background(135, 206, 250); // Sky color
  drawBackground();
  
  movePlane();
  drawPlane();
  
  if (foodInMotion) {
    float elapsedTime = calcTimeSinceDropped(foodTimeDropped);
    foodX = calcFoodX(elapsedTime, foodInitX, FOOD_SPEED);
    foodY = calcFoodY(elapsedTime, foodInitY);
    
    fill(255, 204, 0);
    ellipse(foodX, foodY, 20, 20);
    
    fill(0);
    text("Food: (" + int(foodX) + ", " + int(foodY) + ")", 20, 20);
    
    if (foodInObject(targetX, targetY, targetSize, foodX, foodY)) {
      score++;
      targetHits++;
      foodInMotion = false;
      message = "TARGET HIT!";
      messageTimer = 60;
      resetTarget();
    }
    
    if (belowGround(foodY) || outOfView(foodX)) {
      foodInMotion = false;
      message = "MISS!";
      messageTimer = 60;
    }
  }
  
  drawTarget();
  drawScore();
  displayMessage();
  
  if (targetHits == 3) {
    level++;
    targetHits = 0;
    if (targetSize > 20) {
      targetSize -= 5;
    }
  }
}

void drawBackground() {
  fill(50, 205, 50);
  rect(0, height / 2, width, height / 2);
  
  for (int i = 0; i < width; i += 100) {
    drawTree(i, height / 2);
  }
}

void drawTree(float x, float y) {
  fill(139, 69, 19);
  rect(x + 30, y - 60, 20, 60);
  
  fill(34, 139, 34);
  triangle(x, y - 40, x + 50, y - 100, x + 100, y - 40);
}

void movePlane() {
  planeX += PLANE_SPEED;
  if (planeX > width + 50) {
    planeX = -50;
  }
}

void drawPlane() {
  fill(255, 0, 0);
  rect(planeX, planeY, 50, 20);
  
  fill(0);
  triangle(planeX, planeY, planeX + 10, planeY - 10, planeX + 10, planeY + 10);
  triangle(planeX + 50, planeY, planeX + 40, planeY - 10, planeX + 40, planeY + 10);
}

void drawTarget() {
  fill(255, 0, 0);
  ellipse(targetX, targetY, targetSize, targetSize);
}

void drawScore() {
  fill(0);
  textSize(20);
  text("Score: " + score, width - 100, 30);
  text("Level: " + level, width - 100, 60);
}

void displayMessage() {
  if (messageTimer > 0) {
    fill(0);
    textSize(25);
    textAlign(CENTER);
    text(message, width / 2, height / 2);
    messageTimer--;
  }
}

float calcTimeSinceDropped(float time) {
  return (frameCount - time);
}

float calcFoodX(float flightTime, float initX, float initV) {
  return initX + initV * flightTime;
}

float calcFoodY(float flightTime, float initY) {
  return initY + 0.5 * GRAVITY * flightTime * flightTime;
}

boolean foodInObject(float objectX, float objectY, float objectDiameter, float foodX, float foodY) {
  float d = dist(foodX, foodY, objectX, objectY);
  return d < objectDiameter / 2;
}

boolean belowGround(float y) {
  return y > height;
}

boolean outOfView(float x) {
  return x > width;
}

void keyPressed() {
  if (key == ENTER && !foodInMotion) {
    foodInMotion = true;
    foodInitX = planeX + 25;
    foodInitY = planeY + 10;
    foodTimeDropped = frameCount;
    message = "FOOD RELEASED";
    messageTimer = 60;
  }
}

void resetTarget() {
  targetX = random(100, width - 100);
  targetY = random(height / 2 + 50, height - 50);
  targetSize = 50;
}
