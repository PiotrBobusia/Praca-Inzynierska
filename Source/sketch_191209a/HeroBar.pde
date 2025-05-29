class HeroBar {

  private int actualHealth, maxHealth;  ///actualHealth - aktualny stan zdrowia      maxHealth - maksymalna ilosc punktow zdrowia
  private int actualEnergy;  ///actualEnergy - aktualny stan energii      maxEnergy - maksymalna ilosc punktow many
  private int actualExp, maxExp;  ///actualExp - aktualny stan expa      maxExp - maksymalna ilosc punktow doswiadczenia
  
  
  int barHeight = int(width/8)/5; ///Wymiary paska zdrowia

  
  PGraphics maska, circleHp;
  PGraphics maskaExp;
  private float singleHpHeight, maxHpHeight = width/2.8;
  private float fluidCircleHeight = maxHpHeight / 3.2;            //((width/2.8) / 3.2 / 3) * 2       <- formuła do fluida na Height
  private float heroExpWidth = (width/3.1)*1.65;
  private float heroExpHeight = heroExpWidth / 19;
  
  private float singleExpLenght; ///Wymiary paska doświadczenia
  
  //Grafiki HUD
  PImage heroExp, heroExpFrame, heroExpBg;
  PImage heroHp, heroHpFrame;             // PImage heroHpBufor;
  PImage heroFluidCircle, heroFluidIcon;
  PImage heroSkillBar, heroHudThing;
  
  
  
  private void loadHudImage(){
    heroExp = loadImage("HUD/heroExp.png");
    heroExpFrame = loadImage("HUD/heroExpFrame.png");
    heroExpBg = loadImage("HUD/heroExpBg.png");
    heroHp = loadImage("HUD/heroHp.png");
    //heroHpBufor = loadImage("HUD/heroHp.png");
    heroHpFrame = loadImage("HUD/heroHpFrame.png");
    heroFluidCircle = loadImage("HUD/heroFluidCircle.png");
    heroFluidIcon = loadImage("HUD/heroFluidIcon.png");
    heroSkillBar = loadImage("HUD/heroSkillBar.png");
    heroHudThing = loadImage("HUD/heroHudThing.png");
   
    
    heroHp.resize(int(maxHpHeight), int(maxHpHeight));
    //heroHpBufor.resize(int(maxHpHeight), int(maxHpHeight));
    heroHpFrame.resize(int(maxHpHeight), int(maxHpHeight)); 
    heroFluidCircle.resize(int(fluidCircleHeight), int(fluidCircleHeight));
    
    heroExp.resize(int(heroExpWidth), int(heroExpHeight)); 
    heroExpFrame.resize(int(heroExpWidth), int(heroExpHeight)); 
    heroExpBg.resize(int(heroExpWidth), int(heroExpHeight)); 
  }
  
  
  /*private int xHpBar = (width/8) * 5,            //koordynaty na HUD paskowy
              yHpBar = height-(width/8), 
              xEpBar = xHpBar,
              yEpBar = yHpBar + ((width/8)/5)*2,
              xExpBar = xHpBar,
              yExpBar = yHpBar + ((width/8)/5)*4;
  */
  
  
  private int xHUD = width/50,                      //koordynaty na HUD kołowy
              yHUD = height - int(maxHpHeight) - xHUD,
              xHpCircle = xHUD,                      
              yHpCircle = yHUD,
              xFluidCircle = xHUD,                                                                //Formuła fluidowska: width/50 + 
              yFluidCircle = yHpCircle + (int(maxHpHeight)/2) + ((int(maxHpHeight)/2)/4),         //Formuła fluidowska: (height - int(width/2.8) - (width/50)) + (int(width/2.8)/2) + ((int(width/2.8)/2)/4)
              xExpBar = xHpCircle + int(maxHpHeight) + int(maxHpHeight/20),                       //Formuła skillowa: width/50 + int(width/2.8) + int((width/2.8)/20)
              yExpBar = yHpCircle + int(maxHpHeight/2);                                           //Formuła skillowa: (height - int(width/2.8) - width/50) +  int(((width/2.8)/2) + int((width/3.1)*1.65 / 18.5))
  
  HeroBar(int mH, int mE, int mExp){  ///Konstruktor
    actualHealth = mH;    maxHealth = mH;
    actualEnergy = mE;
    maxExp = mExp;
    
    singleExpLenght = heroExpWidth / maxExp;
    
    
        loadHudImage();    //załadowanie grafik wraz z ich przeskalowaniem
    
    maska = createGraphics(int(maxHpHeight), int(maxHpHeight));
    maskaExp = createGraphics(int(heroExpWidth), int(heroExpHeight));
    
    
    maska.beginDraw();
    fill(255);
    maska.rect(0,0,maxHpHeight,maxHpHeight);
    maska.endDraw();
    singleHpHeight = maxHpHeight / maxHealth;
    
    maskaExp.beginDraw();
    fill(255);
    maskaExp.rect(0,0,singleExpLenght * actualExp, heroExpHeight);
    maskaExp.endDraw();
    

  }
  
  
  ///////////////////////////////////////////    METODY    /////////////////////////////////////////////
  
  
  void tick(){
    updateHP();  //Aktualizacja stanu zdrowia postaci
    updateEP();
    updateEXP();  //Aktualizacja punktów doświadczenia

    singleHpHeight = maxHpHeight / maxHealth;  //Obliczanie pojedyńczego segmentu HP
    clearMask(); //Czyszczenie maski aby narysować nową
    maska.beginDraw();
    //maska.rect(0,0,maxHpHeight,singleHpHeight*actualHealth);
    maska.rect(0,0 + (singleHpHeight * (maxHealth - actualHealth)),maxHpHeight,maxHpHeight);
    maska.endDraw();
    
    
    singleExpLenght = heroExpWidth / maxExp; //Obliczanie pojedyńczego segmentu EXP
    System.out.println("SingleExp = "  +  singleExpLenght + "     MaxWidth = " + heroExpWidth);
    maskaExp.beginDraw(); //Rozpoczęcie rysowania na masce
    fill(255);
    maskaExp.rect(0, 0,singleExpLenght * actualExp, heroExpHeight);  //Rysowanie paska dośw. na masce
    maskaExp.endDraw(); //Zakończenie rysowania na masce
    
  }
  
  
  void render(){
    PImage heroHpBufor;
    heroHpBufor = loadImage("HUD/heroHp.png");
    heroHpBufor.resize(int(maxHpHeight), int(maxHpHeight));
    heroHpBufor.mask(minAlphas(heroHpBufor,maska));
    
    image(heroHpBufor, xHpCircle, yHpCircle);
    image(heroHpFrame, xHpCircle, yHpCircle);
    
    image(heroFluidCircle, xFluidCircle, yFluidCircle);


    PImage heroExpBufor;
    heroExpBufor = loadImage("HUD/heroExp.png");
    heroExpBufor.resize(int(heroExpWidth), int(heroExpHeight));
    heroExpBufor.mask(maskaExp);
    
    image(heroExpBg, xExpBar, yExpBar);
    image(heroExpBufor, xExpBar, yExpBar);
    image(heroExpFrame, xExpBar, yExpBar);
  }
  
  void updateHP(){  ///Metoda pobiera i aktualizuje wartość punktów życia z klasy aktualnego bohatera
    actualHealth = CharacterClass.myHero.actualHealth;
    if(actualHealth<0) actualHealth=0;
  }

  void updateEXP(){ ///Metoda pobiera i aktualizuje wartość punktów doświadczenia z klasy aktualnego bohatera
    maxExp = CharacterClass.myHero.getExpToLevel();
    actualExp = CharacterClass.myHero.getExp();
    if(actualExp<0) actualExp=0;
  }
  
  
  void updateEP(){ ///Metoda pobiera i aktualizuje wartość punktów energii z klasy aktualnego bohatera
    actualEnergy = CharacterClass.myHero.actualEnergy;
    if(actualEnergy<0) actualEnergy=0;
  }
  
  
  public void updateLenght(){
    maxHealth = CharacterClass.myHero.maxHealth;
    maxExp = CharacterClass.myHero.getExpToLevel();
    
    singleExpLenght = heroExpWidth / maxExp;
  }
  
  
  
  
  
  
  int[] minAlphas(PImage img, PImage img2) {
    img.loadPixels();
    img2.loadPixels();
    int[] a = new int[img.pixels.length];
    for (int i =0; i<img.pixels.length; i++) {
      a[i] = min(img.pixels[i] >> 24 & 0xFF, img2.pixels[i] >> 24 & 0xFF);
    }
    return a;
  }
  
  
  void clearMask(){
    maska.loadPixels(); 
    for(int i=0; i<maska.pixels.length; i++) {
      maska.pixels[i] = 0;
    }
    maska.updatePixels();
    
    
    maskaExp.loadPixels(); 
    for(int i=0; i<maskaExp.pixels.length; i++) {
      maskaExp.pixels[i] = 0;
    }
    maskaExp.updatePixels();
    
  }
  
  
  

}
