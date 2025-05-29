class Fluid{

  private PImage image, image2, image3;
  private PImage actualImage;
  private PFont fluidFont;
  private int yFont;
  public int xImage, yImage;
  public String path;
  
  private int level;
  private int basicRegeneration;
  
  private int fluidHeight = int(((width/2.8) / 3.2 / 3) * 2.2);
  private int xFluid;
  private int yFluid;
  
  Fluid(String type){
    basicRegeneration = 100;
    level = 1;
    
    if(type == "HP"){
      path = "HUD/heroFluidIcon.png";
      image = loadImage("HUD/heroFluidIcon.png");
      image2 = loadImage("HUD/heroFluidIcon.png");
      image3 = loadImage("HUD/heroFluidIcon.png");
    }
    if(type == "EP"){
      image = loadImage("epFluid.png");
      image2 = loadImage("epFluid2.png");
      image3 = loadImage("epFluid3.png");
    }
    resizer();
    initFont();
    setActualImage();
  }
  
  public void showFluid(int x, int y, int quantity){
    xImage = x; yImage = y;
    image( actualImage , xFluid , yFluid );  //Wyświetla obraz fluida
    textFont(fluidFont);
    fill(255);
    text( quantity   ,   xFluid + image.width/2   ,   yFont + yFluid + image.height );  //Qyświetlanie tekstu z ilością fluidów
  }
  
  private void resizer(){
    image.resize(0 , fluidHeight);
    image2.resize(0 , fluidHeight);
    image3.resize(0 , fluidHeight);
    
    float circleHeight = (width/2.8) / 3.2;
    xFluid = (width/50) + int(circleHeight/2 - image.width/2);
    yFluid = int(((height - int(width/2.8) - (width/50)) + (int(width/2.8)/2) + ((int(width/2.8)/2)/4)) + (circleHeight/2 - image.height/2));
  }
  
  private void initFont(){
    fluidFont = createFont("Fonts/Kato.ttf",width/22);
  }
  
  /////////////////////////////////////////    GETTERY / SETTERY    ///////////////////////////
  
  public int getWidth(){
    return image.width;
  }
  
  public int getHeight(){
    return image.height;
  }
  
  public int getX(){
    return xFluid;
  }
  
  public int getY(){
    return yFluid;
  }
  
  public int getLevel(){
    return level;
  }
  
  public void setLevel(int value){
    level = value;
  }
  
  
  /////////////////////////////////////////    METODY OBLICZANIA    ///////////////////////////
  
  public int regenerationValue(){  //Zwraca wartość leczenia
    int value = Math.round((basicRegeneration + (level * 2)) * (level/10.0 + 1));  /// Oblicza ilość dodawanych punktów 
    return value;
  }
  
  public void setActualImage(){  //Ustawia aktualną ikonę
    if(level < 10) {actualImage = image;path = "HUD/heroFluidIcon.png";};
    if(level >= 10 && level<20) {actualImage = image2;path = "HUD/heroFluidIcon.png";};
    if(level >= 20) {actualImage = image3;path = "HUD/heroFluidIcon.png";};
  }
  
  public String getPath(){
    return path;
  }
  
  public void levelUp(){
    level++;
  }
  
}
