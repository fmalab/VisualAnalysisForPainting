class PaintingData
{
  // image path
  String imagePath; // A(0) in Excel
  // ---------------------------------------------------
  // brigtness & saturation center position of original image
  PVector BWCenterXY; // B(1), C(2)
  PVector SatCenterXY; // D(3), E(4)
  // ---------------------------------------------------
  // brightness & saturation mean of subset images  
  PVector SubBWMeanXY; // F(5), G(6)
  PVector SubSatMeanXY; // J(9), K(10)
  // brughtness & saturation Standard Diviasion of subset images 
  PVector SubBWStandardDivXY; // H(7), I(8)
  PVector SubSatStandardDivXY; // L(11), M(12)
  // ---------------------------------------------------
  // -------- subset images ----------------------------
  // how many sub images
  int numOfSubset;
  // sub image brightness center array -> id+8*n rotation from data
  PVector subBWCenterXY []; // N(13), O(14)
  // sub image brightness Normal Distribution position
  PVector subBWNormDXY []; // P(15), Q(16)
  // sub image saturation center array
  PVector subSatCenterXY []; // R(17), S(18)
  // sub image saturation Normal Distribution position
  PVector subSatNormDXY []; // T(19), U(20)
  
  // sub image brightness Normal Distribution Cumulative BWCenterXY with 20? sections
  int subNormGraphDensity = 10;
  int subBWNormCountX [] = new int [subNormGraphDensity]; // every 0.05?
  int subBWNormCountY [] = new int [subNormGraphDensity]; // every 0.05?
  int subSatNormCountX [] = new int [subNormGraphDensity];
  int subSatNormCountY [] = new int [subNormGraphDensity];
  
  PaintingData(String s) {
    String [] t = splitTokens(s,"\t\n\r");
    numOfSubset = (t.length-12)/8;
    // println("total subset = "+numOfSubset+" data = "+t[0]+" : "+t[1]);
    
    imagePath = t[0];
    BWCenterXY = new PVector(float(t[1]),float(t[2]));
    SatCenterXY = new PVector(float(t[3]),float(t[4]));
    SubBWMeanXY = new PVector(float(t[5]),float(t[6]));
    SubSatMeanXY = new PVector(float(t[9]),float(t[10]));
    SubBWStandardDivXY = new PVector(float(t[7]),float(t[8]));
    SubSatStandardDivXY = new PVector(float(t[11]),float(t[12]));
    
    subBWCenterXY =  new PVector [numOfSubset];
    subBWNormDXY  =  new PVector [numOfSubset];
    subSatCenterXY  =  new PVector [numOfSubset];
    subSatNormDXY  =  new PVector [numOfSubset];
    
    // initialize subBWNormCountXY, subSatNormCountXY
    for(int i=0; i<subNormGraphDensity;i++) {
      subBWNormCountX[i] = 0;
      subSatNormCountX[i] = 0;
      subBWNormCountY[i] = 0;
      subSatNormCountY[i] = 0;
    }
    
    // put numbers into arrays - sub image set
    for(int i=0; i<numOfSubset;i++) {
      subBWCenterXY[i] = new PVector(float(t[13+i*8]),float(t[14+i*8]));
      subBWNormDXY[i] =  new PVector(float(t[15+i*8]),float(t[16+i*8]));
      
      // count subBWNormCountXY
      subBWNormCountX[constrain(int(subBWNormDXY[i].x*subNormGraphDensity),0,subNormGraphDensity-1)]++;
      subBWNormCountY[constrain(int(subBWNormDXY[i].y*subNormGraphDensity),0,subNormGraphDensity-1)]++;
      
      subSatCenterXY[i] =  new PVector(float(t[17+i*8]),float(t[18+i*8]));
      //println(numOfSubset);
      //println("subSatNormDXY["+i+"] = new PVector(float(t["+(19+i*8)+"]),float(t["+(20+i*8)+"]));");
      subSatNormDXY[i] =   new PVector(float(t[19+i*8]),float(t[20+i*8]));
      
      // count subSatNormDXY 0<=x<0.05 -> * 20 -> 0<=x*20<1.0 -> [0]
      subSatNormCountX[constrain(int(subSatNormDXY[i].x*subNormGraphDensity),0,subNormGraphDensity-1)]++;
      subSatNormCountY[constrain(int(subSatNormDXY[i].y*subNormGraphDensity),0,subNormGraphDensity-1)]++;
    }
  }
 
}