String PrefixPath = "D:/Processing_Data/ProcessingData_COM/";
//String PrefixPath = "";
String theFolderName = "1mondrian"+".txt";
String artPath = PrefixPath+theFolderName;

String iconPath = "";
PFont font; 

PVisualization AllArtworks;

void setup() {
  size(1800, 1200);

  font = loadFont("MicrosoftSansSerif-48.vlw");

  // giude box
  fill(255);
  rect(0, 0, 1000, 1000); // Left Box
  rect(1000, 0, 800, 1200); // Right Big Box
  rect(1050, 30, 350, 350); // Right 1st small box
  rect(1050, 30+350+40, 350, 350); // Right 2nd small box
  rect(1050, 30+(350+40)*2, 350, 350); // Right 3rd small boxes as below
  rect(1050, 30+(350+40)*2+87.5*1, 350, 87.5);
  rect(1050, 30+(350+40)*2+87.5*2, 350, 87.5);

  //AllArtworks = new PVisualization(artPath, iconPath);
  AllArtworks = new PVisualization(artPath, iconPath);
  
/*  for(int i=0; i< AllArtworks.artWorks[1].numOfSubset;i++) {
    println("x="+AllArtworks.artWorks[1].subBWNormDXY[i].x+" : y="+AllArtworks.artWorks[1].subBWNormDXY[i].y);
  } */
}

void draw() {
  background(255);
  //noLoop();
  AllArtworks.SubsetOfBrightnessAndSaturationStandardDivation();
  AllArtworks.snapLeftBigBox();
  AllArtworks.showSnapedArtworkInfo();
}

void keyReleased() {
 if(key==' ') {
  save(PrefixPath+"capture/"+theFolderName+hour()+minute()+second()+".jpg");
  println("image captured");
 }
}