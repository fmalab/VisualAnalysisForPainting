# VisualAnalysisForPainting
Jin Wan Park
School of Computer Science and Engineering, Chung-Ang University, Seoul, South Korea
jinpark@cau.ac.kr 

This painting analysys tools use the image subset barycenter pattern 
to reveal genre and artist characteristics

The suggested visualization and analysis tool is inspired by 
Gombrich's theory of a painter’s window and 
Locher’s psychological research on computational balance. 

Explain

Data Files:
Each Artist's Painting group of Propotionally Cropped Image's Barycenter information
incluiding

BrCtrX = brightness center x
BrCtrY = brightness center y
SatCtrX, SatCtrY = Saturation center x, y
SD_MeanBX, SD_MeanBY = standard dv. mean of group for brightness barycenter x, y
SD_StdDvBX, SD_StdDvBY = standard dv. brightness barycenter x, y
SD_MeanSX, SD_MeanSY, SD_StdDvSX, SD_StdDvSY = saturation

SubCtrBX, SubCtrBY, SubCtrBNDX, SubCtrBNDY, SubCtrSX, SubCtrSY, SubCtrSNDX, SubCtrSNDY
= subset image member's barycenter x, y, standar dv x, y
I set member size as 300

Source code uses absolute path, so you have to fix it for your computer env.
This is written in Processing, which is basically 'Java'.

2018.07.11
