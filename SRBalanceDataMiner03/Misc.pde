File[] listFiles(String dir) 
{
  // file loader... 
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

PImage lazyResizeImage(PImage img, int wh) { 
  // return image with new box size... it will not work if the wh is bigger than width or height
    if(wh>width||wh>height) {
     println("Warning lazyResizeImage... bigger than screen image redered"); 
    }
    image(img, 0, 0, wh, wh);
    img = get(0, 0, wh, wh);
    return img;
}