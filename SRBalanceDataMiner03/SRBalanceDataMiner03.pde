import java.io.File;

String PrefixPath = "D:/Processing_Data/ProcessingData_COM/";
String mainName = "chagallMore";

// Setting -----------------------
String FolderPath = "E:/imageDataSub/"+mainName; // folder
String outName = PrefixPath+mainName+".txt";
int MaxSubDiv = 300; // number of sub-picture

float minSize = 0.25; //25% of image
float maxSize = 0.5; // 50% of image
// Setting -----------------------

PImage IconImg;
PrintWriter output;

void setup()
{
  PImage tempImg; // load each image
  PVector subBPoints[] = new PVector [MaxSubDiv];
  PVector subSPoints[] = new PVector [MaxSubDiv];
  PVector subBND[] = new PVector [MaxSubDiv];
  PVector subSND[] = new PVector [MaxSubDiv];

  size(800, 800); // width = height, same size
  IconImg = get(0, 0, width, height); // base image to store icon images
  output = createWriter(outName);

  File [] fl = listFiles(FolderPath);
  // println("how many files = "+fl.length);

  int blockSize = width/(int(ceil(sqrt(fl.length))));
  int nextLine = width/blockSize; 


  background(0);

  // print Menus
  output.print("path"+"\t"+"BrCtrX"+"\t"+"BrCtrY"+"\t"+"SatCtrX"+"\t"+"SatCtrY"+"\t"+
    "SD_MeanBX"+"\t"+"SD_MeanBY"+"\t"+"SD_StdDvBX"+"\t"+"SD_StdDvBY"+"\t"+
    "SD_MeanSX"+"\t"+"SD_MeanSY"+"\t"+"SD_StdDvSX"+"\t"+"SD_StdDvSY"+"\t");
  for (int i=0; i<MaxSubDiv; i++) {
    output.print(i+"SubCtrBX"+"\t"+i+"SubCtrBY"+"\t"+i+"SubCtrBNDX"+"\t"+i+"SubCtrBNDY"+"\t"+
      i+"SubCtrSX"+"\t"+i+"SubCtrSY"+"\t"+i+"SubCtrSNDX"+"\t"+i+"SubCtrSNDY"+"\t");
  }
  output.print("\n");
  //  output.println("");

  // Load each Files
  for (int i = 0; i < fl.length; ++i) {
    println(i*100.0/fl.length+"% : Estimated Time Left "+(fl.length*millis()/(i+1) - millis())/1000+" second");
    background(0);
    tempImg = loadImage(fl[i].toString());
    //println(fl[i].toString()+" is loaded");
    int sX = (i%nextLine)*blockSize;
    int sY = (i/nextLine)*blockSize;

    CenterOfPainting thePainting = new CenterOfPainting(tempImg, 0, 0, tempImg.width, tempImg.height);

    // write as below format
    // (0)path, (1)BrightnessCenter X, (2)Y, (3)Saturation Center X, (4)y, 
    // (5)Bright-Sub-Center-Mean X, (6)Y, (7)Standard Div_B X, (8)Y, (9)Saturation-Sub-Center-Mean X, (10)Y, (11)Standard Div_S X, (12)Y
    // repeat MaxSubDivnumber of SubBrightnessCenter array (11+)X, (12+)Y, (13+)Normal Distribution_B X, (14+)Y, SubSaturationCenter array (15+)X, (16+)Y, (17+)Normal Distribution_S X, (18+)Y
    // Write File Path ----------------------------------------------------------------- (0)path,
    output.print(fl[i].toString()+"\t");
    // Write Brightness Center X, Y ---------------------------------------------------- (1)BrightnessCenter X, (2)Y
    output.print(thePainting.BrightCenterX()+"\t");
    output.print(thePainting.BrightCenterY()+"\t");
    // Write Saturation Center X, Y ---------------------------------------------------- (2)Y, (3)Saturation Center X, (4)y, 
    output.print(thePainting.SaturationCenterX()+"\t");
    output.print(thePainting.SaturationCenterY()+"\t");
    //----------------------------------------------------------------------------------
    // make array for image parts 

    for (int j=0; j<MaxSubDiv; j++) { // self divide random...
      int x, y, w, h;

      if (tempImg.width==tempImg.height) {
        w = int(random(tempImg.width*minSize, tempImg.width*maxSize));
        //h = int(random(tempImg.height*minSize, tempImg.height*maxSize));
        h = w;
      } else if (tempImg.width>tempImg.height) {
        w = int(random(tempImg.width*minSize, tempImg.width*maxSize));
        h = int(1.0*w*tempImg.height/tempImg.width);
      } else {
        h = int(random(tempImg.height*minSize, tempImg.height*maxSize));
        w = int(1.0*h*tempImg.width/tempImg.height);
      }
      x = int(random(tempImg.width-w));
      y = int(random(tempImg.height-h));
      // rect(x, y, w, h);
      PImage _img = tempImg.get(x, y, w, h);
      CenterOfPainting subPainting = new CenterOfPainting(_img, x, y, w, h);
      subBPoints[j] = new PVector(subPainting.BrightCenterX(), subPainting.BrightCenterY());
      subSPoints[j] = new PVector(subPainting.SaturationCenterX(), subPainting.SaturationCenterY());
    }
    // calculate mean standard divation & each point's Normal Distribution of image parts - brightness
    double centerBX[] = new double [MaxSubDiv];
    double centerBY[] = new double [MaxSubDiv];
    double centerSX[] = new double [MaxSubDiv];
    double centerSY[] = new double [MaxSubDiv];
    for (int j=0; j<MaxSubDiv; j++) {
      centerBX[j] = subBPoints[j].x;
      centerBY[j] = subBPoints[j].y;
      centerSX[j] = subSPoints[j].x;
      centerSY[j] = subSPoints[j].y;
    }
    double meanBX = Mean(centerBX); // calculate mean of all the x positions
    double stDivBX = StandardDiv(meanBX, centerBX);  // calculate standard deviation of x
    double meanBY = Mean(centerBY); // same way mean y
    double stDivBY = StandardDiv(meanBY, centerBY); // same way standard deviation y
    double meanSX = Mean(centerSX); // calculate mean of all the x positions
    double stDivSX = StandardDiv(meanSX, centerSX);  // calculate standard deviation of x
    double meanSY = Mean(centerSY); // same way mean y
    double stDivSY = StandardDiv(meanSY, centerSY); // same way standard deviation y
    for (int j=0; j<MaxSubDiv; j++) {
      subBND[j] = new PVector((float)Normal_Distribution(centerBX[j], meanBX, stDivBX), (float)Normal_Distribution(centerBY[j], meanBY, stDivBY));
      subSND[j] = new PVector((float)Normal_Distribution(centerSX[j], meanSX, stDivSX), (float)Normal_Distribution(centerSY[j], meanSY, stDivSY));
    }
    // Write ------------------------------(5)Bright-Sub-Center-Mean X, (6)Y, (7)Standard Div_B X, (8)Y,
    output.print(meanBX+"\t"+meanBY+"\t"+stDivBX+"\t"+stDivBY+"\t");
    output.print(meanSX+"\t"+meanSY+"\t"+stDivSX+"\t"+stDivSY+"\t");
    // Write ---- repeat MaxSubDivnumber
    for (int j=0; j<MaxSubDiv; j++) {
      // Write ---------- MaxSubDivnumber of SubBrightnessCenter array (11+)X, (12+)Y, (13+)Normal Distribution_B
      output.print(subBPoints[j].x+"\t"+subBPoints[j].y+"\t"+subBND[j].x+"\t"+subBND[j].y+"\t");
      // Write ---------- SubSaturationCenter array (15+)X, (16+)Y, (17+)Normal Distribution_S X, (18+)Y
      output.print(subSPoints[j].x+"\t"+subSPoints[j].y+"\t"+subSND[j].x+"\t"+subSND[j].y+"\t");
    }
    // End Witing
    output.print("\n");
    // output.println("");

    // make icon
    tempImg = lazyResizeImage(tempImg, blockSize);
    IconImg.set(sX, sY, tempImg);
  }
  output.close();
  image(IconImg, 0, 0);
  save(outName+"icons.jpg");

  println("Mining Fisnished");

  exit();
}