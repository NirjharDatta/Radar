import processing.serial.*;
Serial myPort; 
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;
String alertMessage = "";
boolean showAlert = false;
void setup() {
    size(1200, 700); 
    smooth();
    myPort = new Serial(this, "COM9", 9600); 
    myPort.bufferUntil('.'); 
}
void draw() {
    fill(98, 245, 31);
    noStroke();
    fill(0, 4); 
    rect(0, 0, width, height - height * 0.065); 
    fill(98, 245, 31); 
    drawRadar(); 
    drawLine();
    drawObject();
    drawText();    
    if (showAlert) {
        drawAlert();
    }
}
void serialEvent(Serial myPort) { 
    data = myPort.readStringUntil('.');
    data = data.substring(0, data.length() - 1);  
    index1 = data.indexOf(","); 
    angle = data.substring(0, index1); 
    distance = data.substring(index1 + 1, data.length());   
    iAngle = int(angle);
    iDistance = int(distance);  
    println("Received: " + angle + ", " + distance);      
    if (iDistance < 20) {
        alertMessage = "Alert! Object very close!";
        showAlert = true;
    } else if (iDistance < 40) {
        alertMessage = "Caution! Object nearby.";
        showAlert = true;
    } else {
        showAlert = false; 
    }
}
void drawRadar() {
    pushMatrix();
    translate(width / 2, height - height * 0.1);
    noFill();
    strokeWeight(2);
    stroke(98, 245, 31);    
    arc(0, 0, (width - width * 0.01), (width - width * 0.01), PI, TWO_PI);
    arc(0, 0, (width - width * 0.1), (width - width * 0.1), PI, TWO_PI);
    arc(0, 0, (width - width * 0.4), (width - width * 0.4), PI, TWO_PI);
    arc(0, 0, (width - width * 0.7), (width - width * 0.7), PI, TWO_PI);
    // Draw angle lines
    line(-width / 2, 0, width / 2, 0);
    for (int angle = 30; angle <= 150; angle += 30) {
        line(0, 0, (-width / 2) * cos(radians(angle)), (-width / 2) * sin(radians(angle)));
    }
    popMatrix();
}
void drawObject() {
    pushMatrix();
    translate(width / 2, height - height * 0.1);
    strokeWeight(9);
    stroke(255, 10, 10); 
    pixsDistance = iDistance * 5; 
    if (iDistance < 40) {
        float startX = pixsDistance * cos(radians(iAngle));
        float startY = -pixsDistance * sin(radians(iAngle));
        line(startX, startY, (width - width * 0.5) * cos(radians(iAngle)), -(width - width * 0.5) * sin(radians(iAngle)));
    }
    popMatrix();
}
void drawLine() {
    pushMatrix();
    strokeWeight(9);
    stroke(30, 250, 60);
    translate(width / 2, height - height * 0.1); 
    line(0, 0, pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle))); 
    popMatrix();
}
void drawText() {
    pushMatrix();
    noObject = (iDistance > 40) ? "Out of Range" : "In Range";
    fill(0, 0, 0);
    noStroke();
    rect(0, height - height * 0.07, width, height);
    fill(98, 245, 31);
    textSize(20);  
    text("10cm", width - width * 0.3854, height - height * 0.0833);
    text("20cm", width - width * 0.281, height - height * 0.0833);
    text("30cm", width - width * 0.177, height - height * 0.0833);
    text("40cm", width - width * 0.0729, height - height * 0.0833);
    textSize(30);
    text("Ultrasonic Radar", width - width * 0.875, height - height * 0.0277);
    text("Angle: " + iAngle + " °", width - width * 0.1, height - height * 0.0277);
    text("Distance: ", width - width * 0.3, height - height * 0.0277);
    if (iDistance < 40) {
        text("        " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);
    }  
    popMatrix(); 
}
void drawAlert() {
    fill(255, 0, 0, 150); 
    rect(0, height / 2 - 30, width, 60);
    fill(255);
    textSize(24);
    textAlign(CENTER);
    text(alertMessage, width / 2, height / 2);
}
