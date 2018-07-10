class PVisualization
{
  //PImage icons;
  //PImage singleIcon;
  PImage singleBigIcon;
  PaintingData artWorks[];
  int numOfPaintings = 0;
  String artPath_on;
  String iconPath_on;
  float dotSize;
  float dotSizeFirst;
  int firstBoxOpacity;
  int elapsedTime;
  int oldTIme;
  boolean shown;

  // My Menu for each Drawing On and Off
  boolean drawYisXLine = true;  //t
  boolean slopeLine = true;  //t
  boolean drawDots = true;  //t
  boolean drawDotsWithCross = false; //f

  // Left Big Box Screen
  int selectedID = 0;
  int oldID = 0;
  PVector LTofLeftBigBox = new PVector(0, 0); // Left Top Point
  PVector WHofLeftBigBox = new PVector(1000, 1000); // Width Height size
  // --------- standard Diviation Black and White ---------------// 
  PVector maxSubStandardDivXY; // place to store max BW and Sat .... anything bigger
  PVector arraySubBWStandardDivXY [];
  PVector meanSubBWStandardDivXY;
  PVector arrayPysicalSubBWStandardDivXY []; // physical point location
  // --------- standard Diviation Black and White ---------------//
  // --------- standard Diviation Black and White ---------------// 
  PVector arraySubSatStandardDivXY [];
  PVector meanSubSatStandardDivXY;
  PVector arrayPysicalSubSatStandardDivXY []; // physical point location
  // --------- standard Diviation Black and White ---------------//

  PVisualization (String artPath_in, String iconPath_in) {
    artPath_on = artPath_in;
    iconPath_on = iconPath_in;

    // load icon image
    //icons = loadImage(iconPath);
    // sample image
    //singleIcon = get(0, 0, 10, 10);
    // load artwork data
    String [] lines;
    lines = loadStrings(artPath);
    numOfPaintings = lines.length-1;
    artWorks = new PaintingData [numOfPaintings];

    dotSize = 5.0; // more painting = smaill dots
    dotSizeFirst =  constrain(10000.0/numOfPaintings, 3, 10);
    firstBoxOpacity = 150;
    elapsedTime = oldTIme = 0;
    shown = false;

    maxSubStandardDivXY = new PVector(0.0, 0.0); // share two belows
    arraySubBWStandardDivXY = new PVector [numOfPaintings];
    arrayPysicalSubBWStandardDivXY = new PVector [numOfPaintings]; // physical point location
    arraySubSatStandardDivXY = new PVector [numOfPaintings];
    arrayPysicalSubSatStandardDivXY = new PVector [numOfPaintings]; // physical point location

    maxSubStandardDivXY.x = maxSubStandardDivXY.y = 0.5;

    for (int i=1; i<numOfPaintings+1; i++) {
      if (i%10==0) { // progress
        println("Loading ... "+i*100.0/numOfPaintings+" %");
      }
      // create paintingData Class
      artWorks[i-1] = new PaintingData(lines[i]);
      // put all Sub Standard Diviation of Brightness and saturation x and y into array 
      arraySubBWStandardDivXY[i-1] = new PVector(artWorks[i-1].SubBWStandardDivXY.x, artWorks[i-1].SubBWStandardDivXY.y);
      arraySubSatStandardDivXY[i-1] = new PVector(artWorks[i-1].SubSatStandardDivXY.x, artWorks[i-1].SubSatStandardDivXY.y);
      // --------- standard Diviation Black and White & Saturation---------------//
    }

    // calculate brightness & saturation xy skew - mean of them - for arc put them into Variable
    meanSubBWStandardDivXY = new PVector (0, 0);
    meanSubSatStandardDivXY = new PVector (0, 0);
    for (int i=0; i<numOfPaintings; i++) {
      meanSubBWStandardDivXY.x = meanSubBWStandardDivXY.x+arraySubBWStandardDivXY[i].x;
      meanSubBWStandardDivXY.y = meanSubBWStandardDivXY.y+arraySubBWStandardDivXY[i].y;
      meanSubSatStandardDivXY.x = meanSubSatStandardDivXY.x+arraySubSatStandardDivXY[i].x;
      meanSubSatStandardDivXY.y = meanSubSatStandardDivXY.y+arraySubSatStandardDivXY[i].y;
    }
    meanSubBWStandardDivXY.x = meanSubBWStandardDivXY.x/numOfPaintings;
    meanSubBWStandardDivXY.y = meanSubBWStandardDivXY.y/numOfPaintings;
    meanSubSatStandardDivXY.x = meanSubSatStandardDivXY.x/numOfPaintings;
    meanSubSatStandardDivXY.y = meanSubSatStandardDivXY.y/numOfPaintings;

    println(artPath+" "+numOfPaintings+" paintings");
    println("sbBWDvmX = "+meanSubBWStandardDivXY.x+" sbBWDvmY = "+meanSubBWStandardDivXY.y+" x:y ratio = 1:"+meanSubBWStandardDivXY.y/meanSubBWStandardDivXY.x);
    println("sbSatDvmX = "+meanSubSatStandardDivXY.x+" sbSatDvmY = "+meanSubSatStandardDivXY.y+" x:y ratio = 1:"+meanSubSatStandardDivXY.y/meanSubSatStandardDivXY.x);
    println("bw:sat ratio x = 1:"+meanSubSatStandardDivXY.x/meanSubBWStandardDivXY.x+" bw:sat ratio y = 1:"+meanSubSatStandardDivXY.y/meanSubBWStandardDivXY.y);
    println("Loading Finished");

    initializePysicalSubStandardDivXY(LTofLeftBigBox, WHofLeftBigBox, 0.05, maxSubStandardDivXY, arraySubBWStandardDivXY, arraySubSatStandardDivXY);
  }

  // main left drawings
  void SubsetOfBrightnessAndSaturationStandardDivation() {
    axisDrawing (LTofLeftBigBox, WHofLeftBigBox, 0.05, maxSubStandardDivXY, "Subset of Brightness & Saturation Standard Divation");
    graphDotDrawing (LTofLeftBigBox, WHofLeftBigBox, 0.05, maxSubStandardDivXY, arraySubBWStandardDivXY, color(0, 50));
    graphDotDrawing (LTofLeftBigBox, WHofLeftBigBox, 0.05, maxSubStandardDivXY, arraySubSatStandardDivXY, color(255, 0, 0, 50));
  }
  void axisDrawing (PVector LT, PVector WH, float marginPercent, PVector maxXY, String title) {
    PVector margin = new PVector(WH.x*marginPercent, WH.y*marginPercent); // calculate margin
    PVector trueLT = new PVector(LT.x+margin.x, LT.y+margin.y); // Left top with margin
    PVector trueWH = new PVector(WH.x-margin.x*2, WH.y-margin.y*2); // width height adjust with margin
    Boolean hundredInt = false;

    if (maxXY.x==100&&maxXY.y==100) {
      hundredInt = true;
    }

    noFill();
    stroke(0);
    rect(LT.x, LT.y, WH.x, WH.y); // big left box
    rect(trueLT.x, trueLT.y, trueWH.x, trueWH.y); // big left box

    stroke(0);
    line(trueLT.x, trueLT.y, trueLT.x, trueLT.y+trueWH.y); // y line
    line(trueLT.x, trueLT.y+trueWH.y, trueLT.x+trueWH.x, trueLT.y+trueWH.y); // x line
    fill(0);
    float normalSize = max(trueWH.x/60.0, 15.0);

    // x axis numbers
    float count =0.0; 
    textFont(font, normalSize);
    text(title, trueLT.x, trueLT.y-normalSize);
    for (float x = trueLT.x; x<=trueLT.x+trueWH.x; x+=(trueWH.x)/10.0) {
      if (hundredInt) {
        text(int(count), x, trueLT.y+trueWH.y+normalSize);
      } else {
        text(count, x, trueLT.y+trueWH.y+normalSize);
      }
      line(x, trueLT.y+trueWH.y, x, trueLT.y+trueWH.y-10);
      count+=(maxXY.x/10.0);
    }
    // y axis numbers
    count =0.0; 
    textFont(font, normalSize);
    for (float y = trueLT.y; y<=trueLT.y+trueWH.y; y+=(trueWH.y)/10.0) {
      if (hundredInt) {
        text(int(maxXY.y-count), trueLT.x-normalSize*3, y);
      } else {
        text(maxXY.y-count, trueLT.x-normalSize*3, y);
      }
      line(trueLT.x, y, trueLT.x+10, y);
      count+=(maxXY.y/10.0);
    }

    // draw line for the skew BW
    float ext = 3.0; // tring to extend line
    // strokeWeight(4);

    if (drawYisXLine) {
      stroke(0, 0, 255, 50);
      line(
        map(0, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(0, 0, maxXY.y, trueWH.y, 0)+trueLT.y, 
        map(maxXY.x, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(maxXY.y, 0, maxXY.y, trueWH.y, 0)+trueLT.y
        );
    }

    if (slopeLine) {
      stroke(0, 100);
      line(
        map(0, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(0, 0, maxXY.y, trueWH.y, 0)+trueLT.y, 
        map(meanSubBWStandardDivXY.x*ext, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(meanSubBWStandardDivXY.y*ext, 0, maxXY.y, trueWH.y, 0)+trueLT.y
        );
    }

    noFill();
    stroke(0, 100);
    arc(
      map(0, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
      map(0, 0, maxXY.y, trueWH.y, 0)+trueLT.y, 
      map(meanSubBWStandardDivXY.x, 0, maxXY.x, 0, trueWH.x)*2, 
      map(meanSubBWStandardDivXY.y, 0, maxXY.y, 0, trueWH.y)*2, 
      2*0.75*PI, 
      2*PI);

    textFont(font, normalSize);
    fill(0, 150);
    text("sbBWDvXm = "+meanSubBWStandardDivXY.x+
      "\nsbBWDvYm = "+meanSubBWStandardDivXY.y+
      "\nx:y ratio = 1:"+meanSubBWStandardDivXY.y/meanSubBWStandardDivXY.x, 
      map(maxXY.x*0.8, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
      map(maxXY.y*0.80, 0, maxXY.y, 0, trueWH.y)+trueLT.y
      );


    // draw line for the skew Sat
    if (slopeLine) {
      stroke(255, 0, 0, 100);
      line(
        map(0, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(0, 0, maxXY.y, trueWH.y, 0)+trueLT.y, 
        map(meanSubSatStandardDivXY.x*ext*1.3, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
        map(meanSubSatStandardDivXY.y*ext*1.3, 0, maxXY.y, trueWH.y, 0)+trueLT.y
        );
    }

    noFill();
    stroke(255, 0, 0, 100);
    arc(
      map(0, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
      map(0, 0, maxXY.y, trueWH.y, 0)+trueLT.y, 
      map(meanSubSatStandardDivXY.x, 0, maxXY.x, 0, trueWH.x)*2, 
      map(meanSubSatStandardDivXY.y, 0, maxXY.y, 0, trueWH.y)*2, 
      2*0.75*PI, 
      2*PI);

    textFont(font, normalSize);
    fill(255, 0, 0, 150);
    text("sbSatDvXm = "+meanSubSatStandardDivXY.x+
      "\nsbSatDvYm = "+meanSubSatStandardDivXY.y+
      "\nx:y ratio = 1:"+meanSubSatStandardDivXY.y/meanSubSatStandardDivXY.x, 
      map(maxXY.x*0.8, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
      map(maxXY.y*0.86, 0, maxXY.y, 0, trueWH.y)+trueLT.y
      );

    // ratio of bw sat     
    fill(0, 105, 150, 150);
    text("bw:sat ratio x = 1:"+meanSubSatStandardDivXY.x/meanSubBWStandardDivXY.x+
      "\nbw:sat ratio y = 1:"+meanSubSatStandardDivXY.y/meanSubBWStandardDivXY.y, 
      map(maxXY.x*0.79, 0, maxXY.x, 0, trueWH.x)+trueLT.x, 
      map(maxXY.y*0.93, 0, maxXY.y, 0, trueWH.y)+trueLT.y
      );
  }

  // little dots in Left Big Box
  void graphDotDrawing (PVector LT, PVector WH, float marginPercent, PVector maxXY, PVector p[], color dotColor) {

    PVector margin = new PVector(WH.x*marginPercent, WH.y*marginPercent); // calculate margin
    PVector trueLT = new PVector(LT.x+margin.x, LT.y+margin.y); // Left top with margin
    PVector trueWH = new PVector(WH.x-margin.x*2, WH.y-margin.y*2); // width height adjust with margin
    Boolean hundredInt = false;

    if (maxXY.x==100&&maxXY.y==100) {
      hundredInt = true;
    }

    // draw Dots
    noStroke();
    fill(dotColor);
    for (int i=0; i<numOfPaintings; i++) {
      float adjustedX = map(p[i].x, 0, maxXY.x, 0, trueWH.x)+trueLT.x;
      float adjustedY = map(p[i].y, 0, maxXY.y, trueWH.y, 0)+trueLT.y;
      // dots... if you want to change them, change this code

      if (drawDotsWithCross) { 
        stroke(dotColor);
        strokeWeight(2);
        line(adjustedX-dotSizeFirst, adjustedY, adjustedX+dotSizeFirst, adjustedY);
        line(adjustedX, adjustedY-dotSizeFirst, adjustedX, adjustedY+dotSizeFirst);
        strokeWeight(1);
        noStroke();
      }
      //
      // or you can delete whole dots like this
      if (drawDots) {
        ellipse(adjustedX, adjustedY, dotSizeFirst, dotSizeFirst);
      }
    }
  }

  void snapLeftBigBox() {
    float distanceOfPoints = 100000;
    float newDistBW = 100000;
    float newDistSat = 100000;
    int id = -1;
    if (mouseX>LTofLeftBigBox.x&&mouseX<LTofLeftBigBox.x+WHofLeftBigBox.x&&mouseY>LTofLeftBigBox.y&&mouseY<LTofLeftBigBox.y+WHofLeftBigBox.y) {
      for (int i=0; i<numOfPaintings; i++) {
        newDistBW = dist(mouseX, mouseY, arrayPysicalSubBWStandardDivXY[i].x, arrayPysicalSubBWStandardDivXY[i].y);
        newDistSat = dist(mouseX, mouseY, arrayPysicalSubSatStandardDivXY[i].x, arrayPysicalSubSatStandardDivXY[i].y);

        if (distanceOfPoints>newDistBW) {
          distanceOfPoints =newDistBW;
          id = i;
        }
        if (distanceOfPoints>newDistSat) {
          distanceOfPoints = newDistSat;
          id = i;
        }
      }

      fill(0, 50);
      stroke(0);
      ellipse(arrayPysicalSubBWStandardDivXY[id].x, arrayPysicalSubBWStandardDivXY[id].y, 10, 10);

      fill(255, 0, 0, 50);
      stroke(255, 0, 0);
      ellipse(arrayPysicalSubSatStandardDivXY[id].x, arrayPysicalSubSatStandardDivXY[id].y, 10, 10);

      stroke(0, 255, 0, 150);
      line(arrayPysicalSubBWStandardDivXY[id].x, arrayPysicalSubBWStandardDivXY[id].y, arrayPysicalSubSatStandardDivXY[id].x, arrayPysicalSubSatStandardDivXY[id].y);

      if (oldID == selectedID&& !shown) {
        // check elapsed time add to elapsedTImeOfSelection
        elapsedTime = elapsedTime+ millis() - oldTIme;
        oldTIme = millis();
        if (elapsedTime>100) {
          singleBigIcon = loadImage(artWorks[selectedID].imagePath); // just change this line to loadimage....
          shown = true;
        }
      } else if (oldID != selectedID) {
        // reset elapsedTImeOfSelection
        oldTIme = millis();
        elapsedTime = 0;
        shown = false;
      }

      if (shown) {
        image(singleBigIcon, 1420, 65, 325, 325);
      } else {
        noFill();
        fill(0);
        rect(1420, 65, 325, 325);
      }

      oldID = selectedID; 
      selectedID = id;
      displayInformationLeftBigBox();
    }
  }

  void showSnapedArtworkInfo() {
    // Right 1st box - brightness and saturation center
    graphDrawingRight1stBox (new PVector (1010, 30), new PVector (400, 400), 0.1, "Original Artwork GeoCenter");
    graphDrawingRight2ndBox (new PVector (1010, 440), new PVector (400, 400), 0.1, "Sub-set images GeoCenter", true);
    graphDrawingRight2ndBox (new PVector (1380, 440), new PVector (400, 400), 0.1, "Sub-set images GeoCenter: distribution", false);
    graphDrawingRight3rdBox ();
  }

  void graphDrawingRight3rdBox() {
    // normDistribution subset brightness X
    normalDistributionCountDrawing(new PVector (1050, 900), new PVector (300, 100), "Normal Distribution Subset Image: Brightness X", artWorks[selectedID].subBWNormCountX, color(0));
    normalDistributionCountDrawing(new PVector (1400, 900), new PVector (300, 100), "Normal Distribution Subset Image: Brightness Y", artWorks[selectedID].subBWNormCountY, color(0));
    normalDistributionCountDrawing(new PVector (1050, 1050), new PVector (300, 100), "Normal Distribution Subset Image: Saturation X", artWorks[selectedID].subSatNormCountX, color(255, 0, 0));
    normalDistributionCountDrawing(new PVector (1400, 1050), new PVector (300, 100), "Normal Distribution Subset Image: Saturation Y", artWorks[selectedID].subSatNormCountY, color(255, 0, 0));
  }

  void normalDistributionCountDrawing (PVector LT, PVector WH, String title, int countArray[], color c) {
    // 20 is the array size
    float realStep = WH.x/countArray.length;

    noFill();
    stroke(0);
    line(LT.x, LT.y, LT.x, LT.y+WH.y); // y line
    line(LT.x, LT.y+WH.y, LT.x+WH.x, LT.y+WH.y); // x line

    float normalSize = max(WH.x/100.0, 10.0);
    // x axis numbers
    float count =0.0; 

    textFont(font, normalSize);
    fill(0);
    text(title, LT.x, LT.y-normalSize);
    for (float x = LT.x; x<=LT.x+WH.x; x+=realStep) {
      text(nf(count, 1, 1), x, LT.y+WH.y+normalSize);
      //line(x, LT.y+WH.y, x, LT.y+WH.y+10);
      count+=(1.0/countArray.length);
    }

    fill(c);
    for (int i=0; i<countArray.length; i++) {
      rect(LT.x+i*realStep, LT.y+WH.y, realStep, -1*countArray[i]);
    }
  }


  // draw right 1st box brightness saturation center information
  void graphDrawingRight1stBox (PVector LT, PVector WH, float marginPercent, String title) {

    PVector margin = new PVector(WH.x*marginPercent, WH.y*marginPercent); // calculate margin
    PVector trueLT = new PVector(LT.x+margin.x, LT.y+margin.y); // Left top with margin
    PVector trueWH = new PVector(WH.x-margin.x*2, WH.y-margin.y*2); // width height adjust with margin
    PVector p = new PVector(artWorks[selectedID].BWCenterXY.x, artWorks[selectedID].BWCenterXY.y);

    noFill();
    stroke(0);
    rect(trueLT.x, trueLT.y, trueWH.x, trueWH.y); // in box

    stroke(0);
    line(trueLT.x, trueLT.y, trueLT.x, trueLT.y+trueWH.y); // y line
    line(trueLT.x, trueLT.y+trueWH.y, trueLT.x+trueWH.x, trueLT.y+trueWH.y); // x line
    fill(0);
    float normalSize = max(trueWH.x/100.0, 10.0);
    // x axis numbers
    float count =-1.0; 
    textFont(font, normalSize);
    text(title, trueLT.x, trueLT.y-normalSize);
    for (float x = trueLT.x; x<=trueLT.x+trueWH.x; x+=(trueWH.x)/10.0) {
      text(nf(count, 1, 1), x, trueLT.y+trueWH.y+normalSize);
      line(x, trueLT.y+trueWH.y, x, trueLT.y+trueWH.y-10);
      count+=(2.0/10.0);
    }
    // y axis numbers
    count =1.0; 
    textFont(font, normalSize);
    for (float y = trueLT.y; y<=trueLT.y+trueWH.y; y+=(trueWH.y)/10.0) {
      text(nf(count, 1, 1), trueLT.x-normalSize*2.0, y);
      line(trueLT.x, y, trueLT.x+10, y);
      count-=(2.0/10.0);
    }

    // brightness center drawing
    color dotColor = color(0, firstBoxOpacity);
    normalSize = normalSize*1.3;

    noStroke();
    fill(dotColor);
    float adjustedX = map(p.x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
    float adjustedY = map(p.y, 1.0, -1.0, trueWH.y, 0)+trueLT.y; // i don't know but the numbers has to be changed opp
    ellipse(adjustedX, adjustedY, dotSize, dotSize);
    textFont(font, normalSize);
    text("x: "+nf(p.x, 1, 3), adjustedX+normalSize, adjustedY);
    text("y: "+nf(-1*p.y, 1, 3), adjustedX+normalSize, adjustedY+normalSize*1.2); // here also
    stroke(dotColor);
    line(adjustedX, trueLT.y, adjustedX, trueLT.y+trueWH.y);
    line(trueLT.x, adjustedY, trueLT.x+trueWH.x, adjustedY);

    // saturation center drawing

    p = new PVector(artWorks[selectedID].SatCenterXY.x, artWorks[selectedID].SatCenterXY.y);

    dotColor = color(255, 0, 0, firstBoxOpacity);
    noStroke();
    fill(dotColor);
    adjustedX = map(p.x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
    adjustedY = map(p.y, 1.0, -1.0, trueWH.y, 0)+trueLT.y;
    ellipse(adjustedX, adjustedY, dotSize, dotSize);
    textFont(font, normalSize);
    text("x: "+nf(p.x, 1, 3), adjustedX-normalSize*4, adjustedY);
    text("y: "+nf(-1*p.y, 1, 3), adjustedX-normalSize*4, adjustedY+normalSize*1.2);
    stroke(dotColor);
    line(adjustedX, trueLT.y, adjustedX, trueLT.y+trueWH.y);
    line(trueLT.x, adjustedY, trueLT.x+trueWH.x, adjustedY);
  }

  void graphDrawingRight2ndBox (PVector LT, PVector WH, float marginPercent, String title, boolean drawingMode) {

    PVector margin = new PVector(WH.x*marginPercent, WH.y*marginPercent); // calculate margin
    PVector trueLT = new PVector(LT.x+margin.x, LT.y+margin.y); // Left top with margin
    PVector trueWH = new PVector(WH.x-margin.x*2, WH.y-margin.y*2); // width height adjust with margin

    PVector p [] = new PVector [artWorks[selectedID].numOfSubset];
    p = artWorks[selectedID].subBWCenterXY;

    noFill();
    stroke(0);
    rect(trueLT.x, trueLT.y, trueWH.x, trueWH.y); // in box

    stroke(0);
    line(trueLT.x, trueLT.y, trueLT.x, trueLT.y+trueWH.y); // y line
    line(trueLT.x, trueLT.y+trueWH.y, trueLT.x+trueWH.x, trueLT.y+trueWH.y); // x line
    fill(0);
    float normalSize = max(trueWH.x/100.0, 10.0);
    // x axis numbers
    float count =-1.0; 
    textFont(font, normalSize);
    text(title, trueLT.x, trueLT.y-normalSize);
    for (float x = trueLT.x; x<=trueLT.x+trueWH.x; x+=(trueWH.x)/10.0) {
      text(nf(count, 1, 1), x, trueLT.y+trueWH.y+normalSize);
      line(x, trueLT.y+trueWH.y, x, trueLT.y+trueWH.y-10);
      count+=(2.0/10.0);
    }
    // y axis numbers
    count =1.0; 
    textFont(font, normalSize);
    for (float y = trueLT.y; y<=trueLT.y+trueWH.y; y+=(trueWH.y)/10.0) {
      text(nf(count, 1, 1), trueLT.x-normalSize*2.0, y);
      line(trueLT.x, y, trueLT.x+10, y);
      count-=(2.0/10.0);
    }

    float adjustedX = 0;
    float adjustedY = 0;

    // draw brightness center subset images Dots
    noStroke();
    color dotColor = color(0, 100);
    fill(dotColor);

    if (drawingMode) {
      for (int i=0; i<artWorks[selectedID].numOfSubset; i++) {
        adjustedX = map(p[i].x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
        adjustedY = map(p[i].y, 1.0, -1.0, trueWH.y, 0)+trueLT.y;
        ellipse(adjustedX, adjustedY, dotSize, dotSize);
      }
    }

    if (!drawingMode) {
      adjustedX = map(artWorks[selectedID].SubBWMeanXY.x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
      adjustedY = map(artWorks[selectedID].SubBWMeanXY.y, 1.0, -1.0, trueWH.y, 0)+trueLT.y;
      stroke(dotColor);
      line(adjustedX, trueLT.y, adjustedX, trueLT.y+trueWH.y);
      line(trueLT.x, adjustedY, trueLT.x+trueWH.x, adjustedY);
      fill(0, 50);
      ellipse(adjustedX, adjustedY, artWorks[selectedID].SubBWStandardDivXY.x*trueWH.x, artWorks[selectedID].SubBWStandardDivXY.y*trueWH.y);
    }

    // draw saturation center subset images
    noStroke();
    p = artWorks[selectedID].subSatCenterXY;

    dotColor = color(255, 0, 0, 100);
    fill(dotColor);

    if (drawingMode) {
      for (int i=0; i<artWorks[selectedID].numOfSubset; i++) {
        adjustedX = map(p[i].x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
        adjustedY = map(p[i].y, 1.0, -1.0, trueWH.y, 0)+trueLT.y;
        ellipse(adjustedX, adjustedY, dotSize, dotSize);
      }
    }
    if (!drawingMode) {
      adjustedX = map(artWorks[selectedID].SubSatMeanXY.x, -1.0, 1.0, 0, trueWH.x)+trueLT.x;
      adjustedY = map(artWorks[selectedID].SubSatMeanXY.y, 1.0, -1.0, trueWH.y, 0)+trueLT.y;
      stroke(dotColor);
      line(adjustedX, trueLT.y, adjustedX, trueLT.y+trueWH.y);
      line(trueLT.x, adjustedY, trueLT.x+trueWH.x, adjustedY);
      fill(255, 0, 0, 50);
      ellipse(adjustedX, adjustedY, artWorks[selectedID].SubSatStandardDivXY.x*trueWH.x, artWorks[selectedID].SubSatStandardDivXY.y*trueWH.y);
    }
  }


  void displayInformationLeftBigBox() {
    // 여기 지운 부분은 아이콘 파일 로드인데, 사실 안쓰는게 나은 듯해서 지움.
    // diplay information
    //int blockNum = ceil(sqrt(numOfPaintings));
    //int xTh = selectedID%blockNum;
    //int yTh = selectedID/blockNum;
    // int blockSize = icons.width/blockNum;
    // int imageDisplaySize = 200;
    /*
    if (selectedID!=oldID) {
     singleIcon = icons.get(xTh*blockSize, yTh*blockSize, blockSize, blockSize);
     println(artWorks[selectedID].imagePath);
     }
     */
    /*   if(keyPressed&&(singleIcon.width==blockSize)) {
     singleIcon = loadImage(artWorks[selectedID].imagePath);
     } */
    // blockSize = min(200, blockSize);
    //image(singleIcon, LTofLeftBigBox.x+WHofLeftBigBox.x-imageDisplaySize, LTofLeftBigBox.y+WHofLeftBigBox.y+2, imageDisplaySize, imageDisplaySize-4);

    textFont(font, 16);
    fill(0);
    text(artWorks[selectedID].imagePath, 50, height-160);
    textFont(font, 20);
    fill(0);
    text("Subset image Brightness Standard Div : x = "+artWorks[selectedID].SubBWStandardDivXY.x+" : y = "+artWorks[selectedID].SubBWStandardDivXY.y, 50, height-130);
    text("Subset image Saturation Standard Div : x = "+artWorks[selectedID].SubSatStandardDivXY.x+" : y = "+artWorks[selectedID].SubSatStandardDivXY.y, 50, height-105);
    textFont(font, 16);
    fill(0);
    text("Subset image Brightness Mean : x = "+artWorks[selectedID].SubBWMeanXY.x+" : y = "+artWorks[selectedID].SubBWMeanXY.y, 50, height-80);
    text("Subset image Saturation Mean : x = "+artWorks[selectedID].SubSatMeanXY.x+" : y = "+artWorks[selectedID].SubSatMeanXY.y, 50, height-60);

    text("Original Image Brightness Center : x = "+artWorks[selectedID].BWCenterXY.x+" : y = "+artWorks[selectedID].BWCenterXY.y, 50, height-40);
    text("Original Image Saturation Center : x = "+artWorks[selectedID].SatCenterXY.x+" : y = "+artWorks[selectedID].SatCenterXY.y, 50, height-20);
  }

  void initializePysicalSubStandardDivXY (PVector LT, PVector WH, float marginPercent, PVector maxXY, PVector BW[], PVector Sat[]) {

    PVector margin = new PVector(WH.x*marginPercent, WH.y*marginPercent); // calculate margin
    PVector trueLT = new PVector(LT.x+margin.x, LT.y+margin.y); // Left top with margin
    PVector trueWH = new PVector(WH.x-margin.x*2, WH.y-margin.y*2); // width height adjust with margin

    for (int i=0; i<numOfPaintings; i++) {
      float adjustedX = map(BW[i].x, 0, maxXY.x, 0, trueWH.x)+trueLT.x;
      float adjustedY = map(BW[i].y, 0, maxXY.y, trueWH.y, 0)+trueLT.y;

      arrayPysicalSubBWStandardDivXY[i] = new PVector(adjustedX, adjustedY);

      adjustedX = map(Sat[i].x, 0, maxXY.x, 0, trueWH.x)+trueLT.x;
      adjustedY = map(Sat[i].y, 0, maxXY.y, trueWH.y, 0)+trueLT.y;

      arrayPysicalSubSatStandardDivXY[i] = new PVector(adjustedX, adjustedY);
    }
  }
}