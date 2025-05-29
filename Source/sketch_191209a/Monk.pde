class Monk extends State{
  
  PImage tlo_test;
  PImage testBtnON;
  PImage testBtnOFF;
  PImage upgradeSliderNow;
  PImage btnUpgradeON, btnUpgradeOFF;
  PImage btnMakeON, btnMakeOFF;
  
  PFont fontInv = createFont("Fonts/Ubuntu.ttf",width/23);  //Font do renderingu nazwy NPC  i renderingu nazwy naszej broni (nazwa broni na kolor złoty nad suwakiem)
  PFont fontInv2 = createFont("Fonts/Ubuntu.ttf",width/30);  //Font do renderingu tego co mówi
  PFont fontInv3 = createFont("Fonts/Ubuntu.ttf",width/35);  //Font do renderingu tego co mówi
  
  private int marginX, upgradeX, upgradeY;
  private int upgradeWidth, upgradeHeight;
  private int upgradeSliderNowX, upgradeSliderNowY;
  
  private int  upgradeButtonY;
  private int  makeButtonY;
  
  private int stuffX, stuffY;
  private int stuffWidth, stuffHeight;
  
  private boolean readyToUpgrade = true, readyToMake = true;
  
  private boolean checkUpgrade = false , checkMake = false;
  
  CollisionDetector CD = new CollisionDetector();
  
  //Przedmioty potrzebne do ulepszenia wywaru leczniczego 
  public Item    bamboo,
                 wood,
                 flowers,
                 iron,
                 gold,
                 supplies,
                 linen,
                 lether,
                 silk;
                 
   public Item makePrice = new Item("Kwiaty" , 10); ;
   
  
  //Koordynaty dialogowe
  private int dialogueX, dialogueY;
  private int dialogueWidth, dialogueHeight;
  
  //Interfejs muzyczny
  //Dzwięki przycisków
  MusicInterface upgradeFluidSound = new MusicInterface("Town/Sounds/FluidSound3.wav"); 
  MusicInterface makeFluidSound = new MusicInterface("Town/Sounds/FluidSound1.wav"); 
  
  MenuBar menuBar = new MenuBar();
  
  Monk(){
    loadImages();
    generateNeededStuff();
    checkAvailableItemsUpgrade();
    checkAvailableItemsMake();
    
    menuBar.setActiveMonk();
  }
  
  void tick(){
    menuBar.tick();
    
    buttonTick();
    if(!mousePressed){
      readyToUpgrade = true;
      readyToMake = true;
    }
  }
  
  void render(){
    image(tlo_test, 0, height - tlo_test.height);
    
    renderSpeech();
    renderUpgradeSection();
    renderStuffSection();
    
    //PRZYCISKI MENU MIASTA
    /*image(testBtnON , width/2-testBtnON.width/2-testBtnON.width*2 , height - testBtnOFF.height);
    image(testBtnOFF , width/2-testBtnON.width/2-testBtnON.width , height - testBtnOFF.height);
    image(testBtnOFF , width/2-testBtnON.width/2 , height - testBtnOFF.height);
    image(testBtnOFF , width/2+testBtnON.width/2 , height - testBtnOFF.height);
    image(testBtnOFF , width/2+testBtnON.width/2+testBtnON.width , height - testBtnOFF.height);*/
    menuBar.showMenuBar();
  }
  
  
  
  
  private void loadImages(){
    tlo_test = loadImage("Town/NPCmonk.png");
    testBtnON = loadImage("Town/btnPhON.png");
    testBtnOFF = loadImage("Town/btnPhOFF.png");
    upgradeSliderNow = loadImage("Town/Monk/upgradeSliderNow.png");
    btnUpgradeON = loadImage("Town/Monk/btnUpgradeON.png");
    btnUpgradeOFF = loadImage("Town/Monk/btnUpgradeOFF.png");
    btnMakeON = loadImage("Town/Monk/btnMakeON.png");
    btnMakeOFF = loadImage("Town/Monk/btnMakeOFF.png");
    
    resizer();
  }
  
  private void resizer(){
    tlo_test.resize(width , 0);
    testBtnON.resize(width/7 , 0);
    testBtnOFF.resize(width/7 , 0);
    
    
    marginX = width/10;
    upgradeX = marginX;        upgradeY = (height/10)*3;
    upgradeHeight = height/10*4;  upgradeWidth = int(width/1.6) - marginX;
    
    upgradeSliderNow.resize((upgradeWidth/8)*7/5,0);
    upgradeSliderNowX = upgradeX+upgradeWidth/2-upgradeSliderNow.width/2;
    upgradeSliderNowY = upgradeY + upgradeSliderNow.height/2;
    
    dialogueX = int(marginX*1.5); dialogueY = upgradeY/2;
    dialogueWidth = width-int(marginX*1.5)*2; dialogueHeight = upgradeY - dialogueY;
    
    upgradeButtonY = upgradeY + upgradeHeight - btnUpgradeON.height;

    btnUpgradeON.resize(upgradeWidth/5*3 , 0);
    btnUpgradeOFF.resize(upgradeWidth/5*3 , 0);
    btnMakeON.resize(upgradeWidth/5*3 , 0);
    btnMakeOFF.resize(upgradeWidth/5*3 , 0);
    
    PImage fluid = loadImage(CharacterClass.myHero.fluidHP.getPath());
    fluid.resize(int(upgradeSliderNow.width*2), 0);
    
    makeButtonY = int(upgradeSliderNowY+upgradeSliderNow.height*1.5+fluid.height*1.2);
    
    stuffHeight = upgradeHeight/10;       stuffWidth = int(width/2.5);  
    //stuffX = (width/3)*2 - stuffWidth/2;      stuffY = upgradeY + upgradeHeight/2 - stuffHeight*2;
    stuffX = upgradeX + upgradeWidth/2 - stuffWidth/2;      stuffY = makeButtonY+int(btnMakeON.height*2.5);
  }
  
  
  private void renderUpgradeSection(){    //Sekcja do wytwarzania wywarów leczniczych [WYTWÓRZ]
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(CENTER,BOTTOM);
    text( "Wywar Leczniczy" , upgradeX+upgradeWidth/2 ,   upgradeY );  //Ilość Atrybutu
    
    //Renderowanie paska postępu
    textFont(fontInv2);
    fill(0);
    textAlign(CENTER,CENTER);
    image(upgradeSliderNow , upgradeSliderNowX , upgradeSliderNowY);
    text( CharacterClass.myHero.fluidHP.getLevel() , upgradeSliderNowX+upgradeSliderNow.width/2 ,   upgradeSliderNowY + upgradeSliderNow.height/2);  //Ilość Atrybut
    
    PImage fluid = loadImage(CharacterClass.myHero.fluidHP.getPath());
    fluid.resize(int(upgradeSliderNow.width*2), 0);
    image(fluid, upgradeX + upgradeWidth/2 - fluid.width/2, upgradeSliderNowY+upgradeSliderNow.height*1.5);
    textFont(fontInv3);
    fill(255,255,255);
    text("x"+CharacterClass.myHero.hpFluid , upgradeX + upgradeWidth/2 + fluid.width/2.2 , upgradeSliderNowY+upgradeSliderNow.height*1.5+(fluid.height/10)*9);
    
    //Przycisk ulepszania przedmiotu
    makeButtonY = int(upgradeSliderNowY+upgradeSliderNow.height*1.5+fluid.height*1.2);
    if(checkMake) {image(btnMakeON , upgradeX+upgradeWidth/2-btnMakeON.width/2 , makeButtonY); /*readyToMake = true;*/}
    else image(btnMakeOFF , upgradeX+upgradeWidth/2-btnMakeON.width/2 , makeButtonY);
    makePrice.renderOnFluid(int(upgradeX+upgradeWidth/2.45), makeButtonY+btnMakeON.height, btnMakeON.height/2);
  }
  
  
  public void renderStuffSection(){   //Sekcja do ulepszania wywarów leczniczych [ULEPSZ]
    textFont(fontInv3);
    fill(255,255,255);
    textAlign(LEFT, BOTTOM);
    text("Koszt", stuffX , stuffY );
    fill(255 , 248 , 220);
    textAlign(RIGHT, BOTTOM);
    text("Posiadasz", stuffX+stuffWidth , stuffY );
    upgradeButtonY = renderUpgradeStuff(stuffX, stuffY, stuffWidth, stuffHeight);
    
    if(checkUpgrade) {image(btnUpgradeON , stuffX + stuffWidth/2 - btnUpgradeON.width/2 , upgradeButtonY); /*readyToUpgrade = true;*/}
    else image(btnUpgradeOFF , stuffX + stuffWidth/2 - btnUpgradeON.width/2 , upgradeButtonY);
  }
  
  
  private void renderSpeech(){
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(LEFT, BOTTOM);
    text("Mnich", dialogueX , dialogueY );
    
    textFont(fontInv2);
    fill(  251 , 251 , 251);
    textAlign(LEFT, TOP);
    text("Witaj przyjacielu! Niech twoja droga bedzie jasna, a twoje serce czyste i spokojne.", dialogueX , dialogueY , dialogueWidth , dialogueHeight );
  }
  
  
  private int[] generateNeededStuff(){  //Metoda generuje i zwraca tablice wymaganych przedmiotów do ulepszenia wywaru leczniczego
      int bam = 0 + floor(CharacterClass.myHero.fluidHP.getLevel()/5);
      int woo = 0 + floor(CharacterClass.myHero.fluidHP.getLevel()/12);
      int flo = 4 + CharacterClass.myHero.fluidHP.getLevel()*3;
      int iro = 0;
      int gol = 0 + floor(CharacterClass.myHero.fluidHP.getLevel()/15);
      int sup = 1 + floor(CharacterClass.myHero.fluidHP.getLevel()/2);
      int lin = 0;
      int let = 0;
      int sil = 0;
    
      bamboo   = new Item("Bambus" , bam);
      wood     = new Item("Drewno" , woo);
      flowers  = new Item("Kwiaty" , flo);
      iron     = new Item("Zelazo" ,iro);
      gold     = new Item("Zloto" , gol);
      supplies = new Item("Prowiant" , sup);
      linen    = new Item("Len" , lin);
      lether   = new Item("Skora" , let);
      silk     = new Item("Jedwab" , sil);
      
      return new int[]{bam,woo,flo,iro,gol,sup,lin,let,sil};  //Zwracam tablice wymaganych do ulepszenia przemiotów
  }
  
  
  public int renderUpgradeStuff(int x, int y, int w, int h){  ///Renderuje okno potrzebnych ulepszaczy do sekcji Upgrade  (Zwraca KOORDYNAT y NA KTÓRYM KOŃCZY RYSOWANIE)
    if(bamboo.getValue()>0) {bamboo.renderOnUpgrade(x, y, w, h); y+=h+h/20;}  //Sprawdzam czy potrzebuje tego przedmiotu i wywołuje funkcję rysowania do w sekcji Upgrade
    if(wood.getValue()>0) {wood.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(flowers.getValue()>0) {flowers.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(iron.getValue()>0) {iron.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(gold.getValue()>0) {gold.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(supplies.getValue()>0) {supplies.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(linen.getValue()>0) {linen.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(lether.getValue()>0) {lether.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(silk.getValue()>0) {silk.renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    
    return y+=h/20;
  }
  
  
  private void buttonTick(){  //Obsługa przycisków
    if(mousePressed && readyToMake && CD.mouseCollision(upgradeX+upgradeWidth/2-btnMakeON.width/2 , makeButtonY, upgradeX+upgradeWidth/2+btnMakeON.width/2 , makeButtonY+btnMakeON.height)){
      System.out.println("*klik*");
      if(checkMake){
        //Można kupić/wytworzyć wywar leczniczy:
        readyToMake = false;
        readyToUpgrade = false;
        removeItemsMake();
        CharacterClass.myHero.hpFluid++;
        makeFluidSound.play();
        checking();
      }
    }
    
    else if(mousePressed && readyToUpgrade && CD.mouseCollision(stuffX + stuffWidth/2 - btnUpgradeON.width/2 , upgradeButtonY , stuffX + stuffWidth/2 + btnUpgradeON.width/2 , upgradeButtonY+btnUpgradeON.height)){
      System.out.println("*klik2*");
      if(checkUpgrade){
        //Można kupić/wytworzyć wywar leczniczy:
        readyToMake = false;
        readyToUpgrade = false;
        removeItemsUpgrade();
        CharacterClass.myHero.fluidHP.levelUp();
        upgradeFluidSound.play();
        checking();
      }
    }
    
    else return;
  }
  
  
  
  private boolean checkAvailableItemsUpgrade(){  //Sprawdza czy posiadamy przedmioty potzrebne do ulepszenia i zwraca TRUE (jeśli tak) lub FALSE (jeśli nie)
    int[] tableStuff = CharacterClass.myHero.getTableStuff();
    int[] generateNeededStuff = generateNeededStuff();
    for(int i = 0 ; i < 9 ; i ++) if( generateNeededStuff[i] > tableStuff[i] ) {checkUpgrade = false; return false;}
    checkUpgrade = true;
    return true;
  }
  
  private boolean checkAvailableItemsMake(){  //Sprawdza czy posiadamy przedmioty potzrebne do ulepszenia i zwraca TRUE (jeśli tak) lub FALSE (jeśli nie)
    if( makePrice.getValue() > CharacterClass.myHero.getTableStuff()[2] ) {checkMake = false; return false;}
    System.out.println(makePrice.getValue() + ">" + CharacterClass.myHero.getTableStuff()[2]);
    checkMake = true;
    return true;
  }
  
  private void removeItemsUpgrade(){
    int[] newItemValue = new int[9]; 
    for(int i = 0 ; i < 9 ; i ++)  newItemValue[i] = CharacterClass.myHero.getTableStuff()[i] - generateNeededStuff()[i];
    CharacterClass.myHero.setTableStuff(newItemValue);
  }
  
  private void removeItemsMake(){
    int newValue = CharacterClass.myHero.flowers.getValue() - 10;
    CharacterClass.myHero.flowers.setValue(newValue);
  }
  
  private void checking(){
    checkAvailableItemsUpgrade();
    checkAvailableItemsMake();
  }
  
  
}
