class CenterOfPainting
{
  // Data ----
  PImage img;
  float [] brightnessSumColum; // save colum b SUM
  float [] brightnessSumRow; // save row b SUM
  int brightnessCenterX;
  int brightnessCenterY;

  float [] saturationSumColum; // save colum b SUM
  float [] saturationSumRow; // save row b SUM
  int saturationCenterX;
  int saturationCenterY;

  int _x, _y, _w, _h;


  // Initialize ----
  CenterOfPainting(PImage img_in, int xin, int yin, int win, int hin) {
    img = img_in;
    int minArrayIndex = 0;
    int maxArrayIndex = 0;
    boolean foundCenter = false;
    _x=xin;
    _y=yin;
    _w=win;
    _h=hin;

    brightnessSumColum = new float[img.width];
    brightnessSumRow = new float[img.height];
    saturationSumColum = new float[img.width];
    saturationSumRow = new float[img.height];

    // Add x colum data into this array [x]
    for (int x=0; x<img.width; x++) {
      brightnessSumColum[x] = 0.0;
      for (int y=0; y<img.height; y++) {
        brightnessSumColum[x] += (256-1.0*(brightness(img.get(x, y))))/img.height; // black is heavy?
      } //for (int y=0; y<img.height; x++) {
    } //for (int x=0; x<img.width; x++) {
    // Add x colum data into this array [x]

    // Find Center of Colum X for brightness
    minArrayIndex = 0;
    maxArrayIndex = img.width;
    foundCenter = false;
    while (!foundCenter) {
      int TempCenterIndex = (maxArrayIndex+minArrayIndex)/2;
      float leftWeight = 0;
      for (int i=0; i<TempCenterIndex; i++) {
        leftWeight+=brightnessSumColum[i];
      }
      float RightWeight = 0;
      for (int i=TempCenterIndex; i<img.width; i++) {
        RightWeight+=brightnessSumColum[i];
      }
      if (leftWeight>RightWeight) {  
        maxArrayIndex = TempCenterIndex;
      } else {
        minArrayIndex = TempCenterIndex;
      }
      //print(TempCenterIndex+" ");
      if (TempCenterIndex==(maxArrayIndex+minArrayIndex)/2) {
        foundCenter=true;
       // println("Colum Center X is "+TempCenterIndex);
        brightnessCenterX=TempCenterIndex;
      }
    } //while(!foundCenter) {
    // Find Center of Colum X for brightness

    // Add y row data into this array [y]
    for (int y=0; y<img.height; y++) {
      brightnessSumRow[y] = 0.0;
      for (int x=0; x<img.width; x++) {
        brightnessSumRow[y] += (256-1.0*(brightness(img.get(x, y))))/img.width;  // black(0) is heavy?
      } //for (int y=0; y<img.height; x++) {
    } //for (int x=0; x<img.width; x++) {
    // Add x colum data into this array [x]

    // Find Center of Row Y for brightness
    minArrayIndex = 0;
    maxArrayIndex = img.height;
    foundCenter = false;
    while (!foundCenter) {
      int TempCenterIndex = (maxArrayIndex+minArrayIndex)/2;
      float TopWeight = 0;
      for (int i=0; i<TempCenterIndex; i++) {
        TopWeight+=brightnessSumRow[i];
      }
      float BottomWeight = 0;
      for (int i=TempCenterIndex; i<img.height; i++) {
        BottomWeight+=brightnessSumRow[i];
      }
      if (TopWeight>BottomWeight) {
        maxArrayIndex = TempCenterIndex;
      } else {
        minArrayIndex = TempCenterIndex;
      }
      //print(TempCenterIndex+" ");
      if (TempCenterIndex==(maxArrayIndex+minArrayIndex)/2) {
        foundCenter=true;
        //println("Colum Center Y is "+TempCenterIndex);
        brightnessCenterY=TempCenterIndex;
      }
    } //while(!foundCenter) {
    // Find Center of Row Y for brightness


    // SATURATION!!!!
    // Add x colum data into this array [x]
    for (int x=0; x<img.width; x++) {
      saturationSumColum[x] = 0.0;
      for (int y=0; y<img.height; y++) {
        saturationSumColum[x] += (256-1.0*(saturation(img.get(x, y))))/img.height; // dull(0) sat is heavy?
      } //for (int y=0; y<img.height; x++) {
    } //for (int x=0; x<img.width; x++) {
    // Add x colum data into this array [x]

    // Find Center of Colum X for saturation
    minArrayIndex = 0;
    maxArrayIndex = img.width;
    foundCenter = false;
    while (!foundCenter) {
      int TempCenterIndex = (maxArrayIndex+minArrayIndex)/2;
      float leftWeight = 0;
      for (int i=0; i<TempCenterIndex; i++) {
        leftWeight+=saturationSumColum[i];
      }
      float RightWeight = 0;
      for (int i=TempCenterIndex; i<img.width; i++) {
        RightWeight+=saturationSumColum[i];
      }
      if (leftWeight>RightWeight) {  
        maxArrayIndex = TempCenterIndex;
      } else {
        minArrayIndex = TempCenterIndex;
      }
      //print(TempCenterIndex+" ");
      if (TempCenterIndex==(maxArrayIndex+minArrayIndex)/2) {
        foundCenter=true;
        //println("Colum Center X is "+TempCenterIndex);
        saturationCenterX=TempCenterIndex;
      }
    } //while(!foundCenter) {
    // Find Center of Colum X for saturation

    // Add y row data into this array [y]
    for (int y=0; y<img.height; y++) {
      saturationSumRow[y] = 0.0;
      for (int x=0; x<img.width; x++) {
        saturationSumRow[y] += (256-1.0*(saturation(img.get(x, y))))/img.width;
      } //for (int y=0; y<img.height; x++) {
    } //for (int x=0; x<img.width; x++) {
    // Add x colum data into this array [x]

    // Find Center of Row Y for saturation
    minArrayIndex = 0;
    maxArrayIndex = img.height;
    foundCenter = false;
    while (!foundCenter) {
      int TempCenterIndex = (maxArrayIndex+minArrayIndex)/2;
      float TopWeight = 0;
      for (int i=0; i<TempCenterIndex; i++) {
        TopWeight+=saturationSumRow[i];
      }
      float BottomWeight = 0;
      for (int i=TempCenterIndex; i<img.height; i++) {
        BottomWeight+=saturationSumRow[i];
      }
      if (TopWeight>BottomWeight) {
        maxArrayIndex = TempCenterIndex;
      } else {
        minArrayIndex = TempCenterIndex;
      }
      //print(TempCenterIndex+" ");
      if (TempCenterIndex==(maxArrayIndex+minArrayIndex)/2) {
        foundCenter=true;
        //println("Colum Center Y is "+TempCenterIndex);
        saturationCenterY=TempCenterIndex;
      }
    } //while(!foundCenter) {
    // Find Center of Row Y for saturation
  } //CenterOfPainting(PImage img_in) {

  // Method ----

  float BrightCenterX() { // return brightness center value btw -1.0 to 1.0, same way belows...
    return ((1.0*brightnessCenterX/img.width)*2.0-1.0);
  }
  float BrightCenterY() {
    return ((1.0*brightnessCenterY/img.height)*2.0-1.0);
  }
  float SaturationCenterX() {
    return ((1.0*saturationCenterX/img.width)*2.0-1.0);
  }
  float SaturationCenterY() {
    return ((1.0*saturationCenterY/img.height)*2.0-1.0);
  }

  void showBrightnessCenter() {
    /*stroke(255, 200);
    strokeWeight(2);
    line(brightnessCenterX+_x, 0+_y, brightnessCenterX+_x, img.height+_y);
    line(0+_x, brightnessCenterY+_y, img.width+_x, brightnessCenterY+_y);
    noFill();
    ellipse(brightnessCenterX+_x, brightnessCenterY+_y, 15, 15);

    noFill();
    stroke(255,50);
    strokeWeight(3);
    rect(_x, _y, img.width, img.height);*/
    
    
  }

  void showSaturationCenter() {
    stroke(255, 0, 0, 200);
    strokeWeight(2);
    line(saturationCenterX+_x, 0+_y, saturationCenterX+_x, img.height+_y);
    line(0+_x, saturationCenterY+_y, img.width+_x, saturationCenterY+_y);
    noFill();
    ellipse(saturationCenterX+_x, saturationCenterY+_y, 15, 15);

    noFill();
    stroke(255,150);
    strokeWeight(3);
    rect(_x, _y, img.width, img.height);
  }

  //---------------------------
  // Tools, Not main Methods---
  //---------------------------




  //---------------------------
  // Tools, Not main Methods---
  //---------------------------


  //---------------------------
  // For Test------------------
  //---------------------------
  void testImg() {
    image(img, 0, 0);
  } //void testImg() {

  void testArray() {
    println("Testing arrays Colum & Row");
    for (int x=0; x<img.width; x++) {
      stroke(brightnessSumColum[x]);
      line(x, 0, x, x/2);
    }
    for (int y=0; y<img.height; y++) {
      stroke(brightnessSumRow[y]);
      line(0, y, y/2, y);
    }
  } //void testArray() {
  //---------------------------
  // For Test------------------
  //---------------------------
} //class CenterOfPainting