class Armorer extends State{
  
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
  
  boolean upgradeArmor = false;
  
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
  MusicInterface newArmorSound = new MusicInterface("Sounds/newArmorSound.wav"); 
    
  CollisionDetector CD = new CollisionDetector();
  
  Armorer(){
    loadImages();
    generateSliderXtable();
    testBtnON.resize(width/7 , 0);
    testBtnOFF.resize(width/7 , 0);
    
    menuBar.setActiveArmorer();
  }
  
  void tick(){
    //Instruktaż TICK
    if(!Magazyn.popupUpgrade) {mouseBlocker = popupUpgrade.tick(); return;}
    if(!mouseBlocker) menuBar.tick();
    upgradeSliderNowIndex = CharacterClass.myHero.getActualArmor().level;
    
    if(CharacterClass.myHero.canUpgradeArmor() && !mouseBlocker && !upgradeArmor && mousePressed && CD.mouseCollision(upgradeButtonX , upgradeButtonY , upgradeButtonX+btnUpgradeON.width , upgradeButtonY+btnUpgradeON.height)){
      upgradeArmor();
      upgradeArmor = true;
    }
    
    if(!mousePressed) {upgradeArmor = false; mouseBlocker = false;}
    
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
    renderSpeech();   //Wyświetlanie wiadomości od NPC
    
    renderUpgradeSection(upgradeX, upgradeY);  //Wyświetlanie sekcji ulepszania
    renderStuffSection();  //Wyświetlanie tabeli potrzebnych ulepszaczy
    
    menuBar.showMenuBar();
    if(!Magazyn.popupUpgrade)popupUpgrade.render(); 
  }
  
  
  private void renderUpgradeSection(int x, int y){
    //Renderowanie nazwy broni
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(CENTER,BOTTOM);
    text( CharacterClass.myHero.getActualArmor().name , upgradeX+upgradeWidth/2 ,   upgradeY );  //Ilość Atrybutu
    
    //Renderowanie paska postępu
    textFont(fontInv2);
    fill(0);
    textAlign(CENTER,CENTER);
    
    tint(255,tintowy);
    image( upgradeSliderLine , upgradeSliderLineX , upgradeSliderLineY ); //Pasek poziomu
    
    
    if(upgradeSliderNowIndex<=8){  //Wyświetlanie rombu z poziomem
      image( upgradeSliderNow , upgradeSliderNowXtable[upgradeSliderNowIndex] , upgradeSliderLineY-upgradeSliderNow.height/2);
      text(CharacterClass.myHero.getActualArmor().level , upgradeSliderNowXtable[upgradeSliderNowIndex]+upgradeSliderNow.width/2 , upgradeSliderLineY);
      tint(255,255);
      image( upgradeSliderEnd , upgradeSliderLineX + (upgradeSliderWidth/9)*9 - upgradeSliderEnd.width/2, upgradeSliderLineY-upgradeSliderEnd.height/2);
    }
    else {
      image( upgradeSliderNowEnd , upgradeSliderLineX + (upgradeSliderWidth/9)*9 - upgradeSliderEnd.width/2, upgradeSliderLineY-upgradeSliderEnd.height/2);  
      text(CharacterClass.myHero.getActualArmor().level , upgradeSliderLineX + (upgradeSliderWidth/9)*9 , upgradeSliderLineY);
      tint(255,255);
    }
    
    
    //Renderowanie wyglądu posiadanej broni
    PImage armor = loadImage(CharacterClass.myHero.getActualArmor().getArmorPath());  //Zmienna z grafiką pancerza
    armor.resize(int(upgradeWidth/1.5), 0);  //Resize grafiki
    
    image(armor, upgradeX + upgradeWidth/2 - armor.width/2, upgradeY+upgradeHeight/4); //Wyśw. grafiki pancerza
    
    //Przycisk ulepszania przedmiotu
    if(CharacterClass.myHero.canUpgradeArmor()  && checkAvailableItems()) {image(btnUpgradeON , upgradeButtonX , upgradeButtonY); readyToUpgrade = true;}
    else image(btnUpgradeOFF , upgradeButtonX , upgradeButtonY);
  }
  
  
  public void renderStuffSection(){  //Wyświetlanie tabeli z wymaganymi przedmiotami
    textFont(fontInv3);
    fill(255,255,255);
    textAlign(LEFT, BOTTOM);
    text("Koszt", stuffX , stuffY );
    fill(255 , 248 , 220);
    textAlign(RIGHT, BOTTOM);
    text("Posiadasz", stuffX+stuffWidth , stuffY );
    CharacterClass.myHero.getActualArmor().renderUpgradeStuff(stuffX, stuffY, stuffWidth, stuffHeight);
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
    
    upgradeSliderWidth = (upgradeWidth/8)*7;     //((int(width/1.6) - marginX)/8)*7
    upgradeSliderLineX = upgradeX + upgradeWidth/2 - upgradeSliderWidth/2;
    upgradeSliderLineY = upgradeY + upgradeHeight/15;
    upgradeButtonX = upgradeX;
    upgradeButtonY = upgradeY + upgradeHeight - btnUpgradeON.height;
    
    dialogueX = int(marginX*1.5); dialogueY = upgradeY/2;
    dialogueWidth = width-int(marginX*1.5)*2; dialogueHeight = upgradeY - dialogueY;
    
    tlo_test = loadImage("Town/NPCarmorer.png");
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
  
  
  public void upgradeArmor(){
    if(checkAvailableItems()){  //Sprawdzam czy posiadam odpowiednie przemioty do ulepszania
      if( !CharacterClass.myHero.getActualArmor().upgradeArmor() && CharacterClass.myHero.actualArmor < 10){  //Jeśli Poziom broni jest == 9 i musi nastąpić upgrade na następną broń
        removeAvailableItems();
        CharacterClass.myHero.actualArmor ++;
        newArmorSound.play();
      } 
      else {  //Tutaj jeśli Poziom broni jest mniejszy od 9
        System.out.println("upgradeArmor ON");
        removeLastAvailableItems();
      }
    }
  }
  
  private boolean checkAvailableItems(){  //Sprawdza czy posiadamy przedmioty potzrebne do ulepszenia i zwraca TRUE (jeśli tak) lub FALSE (jeśli nie)
    for(int i = 0 ; i < 9 ; i ++) if( CharacterClass.myHero.getActualArmor().getUpgradeStuffIndex(i) > CharacterClass.myHero.getTableStuff()[i] ) return false;
    return true;
  }
  
  private void removeAvailableItems(){  //Odbieranie przedmiotów z ekwipunku naszego bohatera
    System.out.println("removeAvailableItems//removeAvailableItems//removeAvailableItems//removeAvailableItems");
    int[] newItemValue = new int[9]; 
    for(int i = 0 ; i < 9 ; i ++)  newItemValue[i] = CharacterClass.myHero.getTableStuff()[i] - CharacterClass.myHero.getActualArmor().getUpgradeStuffIndex(i) ;
    CharacterClass.myHero.setTableStuff(newItemValue);
  }
  
  private void removeLastAvailableItems(){  //Odbieranie przedmiotów z ekwipunku naszego bohatera
    System.out.println("removeAvailableItems//removeAvailableItems//removeAvailableItems//removeAvailableItems");
    int[] newItemValue = new int[9]; 
    for(int i = 0 ; i < 9 ; i ++)  newItemValue[i] = CharacterClass.myHero.getTableStuff()[i] - CharacterClass.myHero.getActualArmor().getLastUpgradeStuffIndex(i) ;
    CharacterClass.myHero.setTableStuff(newItemValue);
  }
  
  
  private void renderSpeech(){  //Wyświetlanie wiadomości od NPC
    textFont(fontInv);
    fill(255 , 248 , 220);
    textAlign(LEFT, BOTTOM);
    text("Platnerz", dialogueX , dialogueY );
    
    textFont(fontInv2);
    fill(  251 , 251 , 251);
    textAlign(LEFT, TOP);
    text("Zostaw mi swoje opancerzenie, a ja je ulepsze.", dialogueX , dialogueY , dialogueWidth , dialogueHeight );
  }
  
  
}
