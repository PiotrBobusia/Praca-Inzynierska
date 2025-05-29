class Swordsmith extends State{
  
  PImage tlo_test;
  PImage testBtnON;
  PImage testBtnOFF;
  PImage btnUpgradeON;
  PImage btnUpgradeOFF;
  PImage upgradeSliderLine;
  PImage upgradeSliderEnd;
  PImage upgradeSliderNow;
  PImage upgradeSliderNowEnd;
  
  MenuBar menuBar = new MenuBar();
  
  //Zmienne do tekstu
  int fontX = width/2;      int fontY = menuBar.getHeight()*2;
  PFont fontInv = createFont("Fonts/Ubuntu.ttf",width/23);  //Font do renderingu nazwy NPC  i renderingu nazwy naszej broni (nazwa broni na kolor złoty nad suwakiem)
  PFont fontInv2 = createFont("Fonts/Ubuntu.ttf",width/30);  //Font do renderingu tego co mówi
  PFont fontInv3 = createFont("Fonts/Ubuntu.ttf",width/35);  //Font do renderingu tego co mówi
  
  //Zmienne do tabeli ulepszania
  int marginX;
  int upgradeX, upgradeY;
  int upgradeHeight, upgradeWidth;
  int upgradeButtonWidth, upgradeButtonX, upgradeButtonY;
  int upgradeSliderWidth;
  int upgradeSliderNowIndex;  //Index poziomu przedmiotu potrzebny do tabeli upgradeSliderNowXtable[] do wyznaczania X rombu
  int upgradeSliderLineX;
  int upgradeSliderLineY;
  int[] upgradeSliderNowXtable = new int[9];  //Tabela przechowuje Koordynaty rombów na dany level przedmiotu
  
  boolean upgradeWeapon = false;
  
  //Tabela ulepszaczy zmienne
  int stuffHeight,  stuffWidth;
  int stuffX, stuffY;
  
  
  //Koordynaty dialogowe
  private int dialogueX, dialogueY;
  private int dialogueWidth, dialogueHeight;
  
  
  //Obsługa mrugania rombów z poziomem
  private boolean readyToUpgrade = false;
  private boolean alphaUp = false, alphaDown = false;
  private int tintowy = 255; //poziom przeźroczystości
  
  
  Popup popupUpgrade = new Popup("ULEPSZANIE","Pancerz i Bron mozna ulepszac aby zadawala wieksze obrazenia.\nW tym celu musisz posiadac odpowiednie przedmioty w swoim ekwipunku.","Popup/imgPopupArmorer.png");
    private boolean mouseBlocker = false;
  
  //Interfejs muzyczny
  //Dzwięki przycisków
  MusicInterface newWeaponSound = new MusicInterface("Sounds/newWeaponSound.wav"); 
    
  CollisionDetector CD = new CollisionDetector();
  
  Swordsmith(){
    loadImages();
    generateSliderXtable();
    testBtnON.resize(width/7 , 0);
    testBtnOFF.resize(width/7 , 0);
    
    menuBar.setActiveSwordsmith();
  }
  
  void tick(){
    if(!Magazyn.popupUpgrade) {mouseBlocker = popupUpgrade.tick(); return;}
    if(!mouseBlocker) menuBar.tick();
    upgradeSliderNowIndex = CharacterClass.myHero.getActualWeapon().level;
    
    if(CharacterClass.myHero.canUpgradeWeapon() && !mouseBlocker && !upgradeWeapon && mousePressed && CD.mouseCollision(upgradeButtonX , upgradeButtonY , upgradeButtonX+btnUpgradeON.width , upgradeButtonY+btnUpgradeON.height)){
      upgradeWeapon();
      upgradeWeapon = true;
    }
    
    if(!mousePressed) {upgradeWeapon = false; mouseBlocker = false;}
    
    //OBLICZANIE TINTA
    if(readyToUpgrade){    //Obsługa mrugania rombu | Jeśli gotowy do Update
        if(tintowy > 200 && alphaDown) tintowy--;
        else if(tintowy <= 200 && alphaDown) {alphaDown=false; alphaUp=true;}
        else if(tintowy < 255 && alphaUp) {tintowy++;}
        else if(tintowy >= 255 && alphaUp) {alphaUp = false; alphaDown=true;}
        else alphaDown = true;
    } else tintowy = 255;
    /////////
  }
  
  void render(){
    image(tlo_test, 0, height - tlo_test.height); //TŁO
    renderSpeech();

    renderUpgradeSection(upgradeX, upgradeY);
    renderStuffSection();
    
    menuBar.showMenuBar();
    if(!Magazyn.popupUpgrade)popupUpgrade.render(); 
  }
  
  
  private void renderUpgradeSection(int x, int y){
    //Renderowanie nazwy broni
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(CENTER,BOTTOM);
    text( CharacterClass.myHero.getActualWeapon().name , upgradeX+upgradeWidth/2 ,   upgradeY );  //Ilość Atrybutu
    
    //Renderowanie paska postępu
    textFont(fontInv2);
    fill(0);
    textAlign(CENTER,CENTER);
    
    tint(255,tintowy);
    image( upgradeSliderLine , upgradeSliderLineX , upgradeSliderLineY );
    
    
    if(upgradeSliderNowIndex<=8){
      image( upgradeSliderNow , upgradeSliderNowXtable[upgradeSliderNowIndex] , upgradeSliderLineY-upgradeSliderNow.height/2);
      text(CharacterClass.myHero.getActualWeapon().level , upgradeSliderNowXtable[upgradeSliderNowIndex]+upgradeSliderNow.width/2 , upgradeSliderLineY);
      tint(255,255);
      image( upgradeSliderEnd , upgradeSliderLineX + (upgradeSliderWidth/9)*9 - upgradeSliderEnd.width/2, upgradeSliderLineY-upgradeSliderEnd.height/2);
    }
    else {
      image( upgradeSliderNowEnd , upgradeSliderLineX + (upgradeSliderWidth/9)*9 - upgradeSliderEnd.width/2, upgradeSliderLineY-upgradeSliderEnd.height/2);  
      text(CharacterClass.myHero.getActualWeapon().level , upgradeSliderLineX + (upgradeSliderWidth/9)*9 , upgradeSliderLineY);
      tint(255,255);
    }
    
    
    //Renderowanie wyglądu posiadanej broni
    PImage weapon = loadImage(CharacterClass.myHero.getActualWeapon().getWeaponPath());
    weapon.resize(upgradeWidth, 0);
    
    pushMatrix();  //Matrix do rysowania zrotowanej broni
    translate(upgradeX, upgradeY+upgradeHeight/1.6);
    rotate(-radians(29));
    image(weapon, 0, 0);
    popMatrix();
    
    //Przycisk ulepszania przedmiotu
    if(CharacterClass.myHero.canUpgradeWeapon()  && checkAvailableItems()) {image(btnUpgradeON , upgradeButtonX , upgradeButtonY); readyToUpgrade = true;}
    else image(btnUpgradeOFF , upgradeButtonX , upgradeButtonY);
  }
  
  
  public void renderStuffSection(){
    textFont(fontInv3);
    fill(255,255,255);
    textAlign(LEFT, BOTTOM);
    text("Koszt", stuffX , stuffY );
    fill(255 , 248 , 220);
    textAlign(RIGHT, BOTTOM);
    text("Posiadasz", stuffX+stuffWidth , stuffY );
    CharacterClass.myHero.getActualWeapon().renderUpgradeStuff(stuffX, stuffY, stuffWidth, stuffHeight);
  }
  
  
  private void loadImages(){
    btnUpgradeON = loadImage("Town/Upgrader/btnUpgradeON.png");
    btnUpgradeOFF = loadImage("Town/Upgrader/btnUpgradeOFF.png");
    
    //Zmienne do tabeli ulepszania
    marginX = width/10;
    upgradeX = marginX;        upgradeY = (height/10)*3;
    upgradeHeight = height/10*4;  upgradeWidth = int(width/1.6) - marginX;
    upgradeButtonWidth = upgradeWidth;
    
    btnUpgradeON.resize(upgradeButtonWidth , 0);
    btnUpgradeOFF.resize(upgradeButtonWidth , 0);
    
    upgradeSliderWidth = (upgradeWidth/8)*7;
    upgradeSliderLineX = upgradeX + upgradeWidth/2 - upgradeSliderWidth/2;
    upgradeSliderLineY = upgradeY + upgradeHeight/15;
    upgradeButtonX = upgradeX;
    upgradeButtonY = upgradeY + upgradeHeight - btnUpgradeON.height;
    
    dialogueX = int(marginX*1.5); dialogueY = upgradeY/2;
    dialogueWidth = width-int(marginX*1.5)*2; dialogueHeight = upgradeY - dialogueY;
    
    tlo_test = loadImage("Town/NPCswordsmith.png");
    testBtnON = loadImage("Town/btnPhON.png");
    testBtnOFF = loadImage("Town/btnPhOFF.png");
    upgradeSliderLine = loadImage("Town/Upgrader/upgradeSliderLine.png");
    upgradeSliderEnd = loadImage("Town/Upgrader/upgradeSliderEnd.png");
    upgradeSliderNow = loadImage("Town/Upgrader/upgradeSliderNow.png");
    upgradeSliderNowEnd = loadImage("Town/Upgrader/upgradeSliderNowEnd.png");
    
    
    tlo_test.resize(width , 0);
    upgradeSliderLine.resize( upgradeSliderWidth , 0 );
    upgradeSliderEnd.resize( upgradeSliderWidth/5 , 0 );
    upgradeSliderNow.resize( upgradeSliderWidth/7 , 0 );
    upgradeSliderNowEnd.resize( upgradeSliderWidth/5 , 0 );
    
    
    stuffHeight = upgradeHeight/10;       stuffWidth = int(width/2.5);
    stuffX = (width/3)*2 - stuffWidth/2;      stuffY = upgradeY + upgradeHeight/2 - stuffHeight*2;
  }
  
  private void generateSliderXtable(){
    for(int i = 0; i<9; i++) upgradeSliderNowXtable[i] = upgradeSliderLineX + ((upgradeSliderWidth/9)*i)  - upgradeSliderNow.width/2;
  }
  
  
  public void upgradeWeapon(){
    if(checkAvailableItems()){  //Sprawdzam czy posiadam odpowiednie przemioty do ulepszania
      if( !CharacterClass.myHero.getActualWeapon().upgradeWeapon() && CharacterClass.myHero.actualWeapon < 11){  //Jeśli Poziom broni jest == 9 i musi nastąpić upgrade na następną broń
        removeAvailableItems();
        CharacterClass.myHero.actualWeapon ++;
        newWeaponSound.play();
      } 
      else {  //Tutaj jeśli Poziom broni jest mniejszy od 9
        System.out.println("upgradeWeapon ON");
        removeLastAvailableItems();
      }
    }
  }
  
  private boolean checkAvailableItems(){  //Sprawdza czy posiadamy przedmioty potzrebne do ulepszenia i zwraca TRUE (jeśli tak) lub FALSE (jeśli nie)
    for(int i = 0 ; i < 9 ; i ++) if( CharacterClass.myHero.getActualWeapon().getUpgradeStuffIndex(i) > CharacterClass.myHero.getTableStuff()[i] ) return false;
    return true;
  }
  
  private void removeAvailableItems(){  //Odbieranie przedmiotów z ekwipunku naszego bohatera
    System.out.println("removeAvailableItems//removeAvailableItems//removeAvailableItems//removeAvailableItems");
    int[] newItemValue = new int[9]; 
    for(int i = 0 ; i < 9 ; i ++)  newItemValue[i] = CharacterClass.myHero.getTableStuff()[i] - CharacterClass.myHero.getActualWeapon().getUpgradeStuffIndex(i) ;
    CharacterClass.myHero.setTableStuff(newItemValue);
  }
  
  private void removeLastAvailableItems(){  //Odbieranie przedmiotów z ekwipunku naszego bohatera
    System.out.println("removeAvailableItems//removeAvailableItems//removeAvailableItems//removeAvailableItems");
    int[] newItemValue = new int[9]; 
    for(int i = 0 ; i < 9 ; i ++)  newItemValue[i] = CharacterClass.myHero.getTableStuff()[i] - CharacterClass.myHero.getActualWeapon().getLastUpgradeStuffIndex(i) ;
    CharacterClass.myHero.setTableStuff(newItemValue);
  }
  
  
  private void renderSpeech(){
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(LEFT, BOTTOM);
    text("Miecznik", dialogueX , dialogueY );
    
    textFont(fontInv2);
    fill(  251 , 251 , 251);
    textAlign(LEFT, TOP);
    text("Witaj! Zostaw mi swoje ostrze, a ja je ulepsze po uczciewej cenie.", dialogueX , dialogueY , dialogueWidth , dialogueHeight );
  }
  
  
}
