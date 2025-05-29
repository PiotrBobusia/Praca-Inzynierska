 class HealthBar {

  private int actualHealth, maxHealth;  ///actualHealth - aktualny stan zdrowia      maxHealth - maksymalna ilosc punktow zdrowia
  int level;  ///name - nazwa postaci    level - poziom postaci (wyswietlany obok nazwy)
  
  int barHeight = int(height/60); ///Wymiary paska zdrowia
  private float singleCircleValue, actualCircleValue, maxCircleValue = 2*PI;
  PFont font;
  
  private PImage circle;
  private PGraphics maskaImage; private int maskaWymiar = width/5;
  
  HealthBar(int aH, int mH, String name, int lv){  ///Konstruktor 1
    actualHealth = aH;
    maxHealth = mH;
    level = lv;
    singleCircleValue = maxCircleValue / maxHealth;
    
    font = createFont("font.ttf", int(barHeight/1.7));
    textFont(font); 
    
    circle = loadImage("enemyHpCircle.png");
    maskaImage = createGraphics(maskaWymiar,maskaWymiar);
    maskaImage.beginDraw();
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0,  2*PI, PIE);
    maskaImage.endDraw();
    circle.resize(maskaWymiar,maskaWymiar);
  }
  
  HealthBar(int mH, String name, int lv){  ///Konstruktor 2
    maxHealth = mH;
    actualHealth = mH;
    level = lv;
    singleCircleValue = maxCircleValue / maxHealth;
    
    font = createFont("font.ttf", int(barHeight/1.7)); 
    circle = loadImage("enemyHpCircle.png");
    maskaImage = createGraphics(maskaWymiar,maskaWymiar);
    
    maskaImage.beginDraw();
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0, 2*PI, PIE);
    maskaImage.endDraw();
    //!!!circle.resize(maskaWymiar,maskaWymiar);
  }
  
  void tick(int HP){
    updateHP(HP);  //Aktualizacja punktów zdrowia przeciwnika
    actualCircleValue = singleCircleValue * actualHealth;
    
    
    maskaImage.loadPixels(); //Czyszczenie maski
    for(int i=0; i<maskaImage.pixels.length; i++) {
      maskaImage.pixels[i] = 0;
    }
    maskaImage.updatePixels();
    
    maskaImage.beginDraw();  //Rozpoczęcie rysowania nowej maski
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0, actualCircleValue, PIE);
    maskaImage.endDraw();
  }
  
  
  void render(){
    PImage circle2 = loadImage("enemyHpCircle.png");
    circle2.resize(maskaWymiar,maskaWymiar);
    circle2.mask(minAlphas(circle2,maskaImage));  //Nakładanie "paska" zdrowia na maskę
    image(circle2, width/2-maskaWymiar/2, height/2-maskaWymiar/2); 
    //image(maskaImage, width/2-maskaWymiar/2, height/2-maskaWymiar/2);
  }
  
  void updateHP(int HP){ //Aktualizacja punktów zdrowia przeciwnika
    if(HP>=0) actualHealth = HP;
    else actualHealth = 0;
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


}
