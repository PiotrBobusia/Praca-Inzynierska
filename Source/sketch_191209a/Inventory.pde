class Inventory extends State{  ///Inventory to tak na prawdę State Postać->Ciało

  PImage tlo = loadImage("invBg.png") , charSlot = loadImage("invCharSlot.png"); 
  PImage iPlus = loadImage("invPlus.png") , iExit = loadImage("invExit.png"); 
  
  
  float charSlotX, charSlotY;
  float iWeaponX, iWeaponY;
  float iArmorX, iArmorY;
  float iUpgradeArmorX, iUpgradeArmorY;
  float iUpgradeWeaponX, iUpgradeWeaponY;
  float characterX, characterY;
  float iExitX, iExitY;
  
  CollisionDetector CD;
  MenuBar menuBar = new MenuBar(); //Stworzenie obiektu paska menu
  private boolean addAtrib;  ///Metody sprawdzające i blokujące multi upgrade przedmiotów      addAtrib - blokada na dodawanie atrybutu
  
  PFont fontInv = createFont("font.ttf",width/24);
  
  float statsBtnX = width - width/8;
  float silaY = menuBar.getHeight()*3,
        inteligencjaY = silaY + height/15,
        energiaY = inteligencjaY + height/15,
        zywotnoscY = energiaY + height/15,
        zrecznoscY = zywotnoscY + height/15,
        freePointsY = zrecznoscY + height/15,
        yangValueY = freePointsY + height/15;
        
  float silaBtnY = silaY - iPlus.height*1.2,
        inteligencjaBtnY = silaBtnY + height/15,
        energiaBtnY = inteligencjaBtnY + height/15,
        zywotnoscBtnY = energiaBtnY + height/15,
        zrecznoscBtnY = zywotnoscBtnY + height/15;
        
        //Dzwięki przycisków
    MusicInterface insertBtnSound = new MusicInterface("Sounds/insertBtnSound.wav"); 
    MusicInterface addBtnSound = new MusicInterface("Sounds/addBtnSound.wav"); 

    Popup popupStats = new Popup("STATYSTYKI","Dzieki zdobywaniu nowych poziomow, nasza postac moze sie rozwijac poprzez polepszanie swoich statystyk.\nRozdaj wolne punkty statystyk, aby byc coraz lepszym.","Popup/imgPopupStats.png");
    private boolean mouseBlocker = false;
        
  Inventory(){
    menuBar.setActiveCialo();
    
    resizer();
    setPosition();
    
    CD = new CollisionDetector();
    
    
  }


  /////////////////////////////////////////////  TICK i RENDER  //////////////////////////////////////////
  
  public void tick(){
    if(!Magazyn.popupStats) {mouseBlocker = popupStats.tick(); return;} //Instruktaż
    
    tickStats();  //Tick statystyk
    
    if(!mousePressed){  //Zwolnienie blokady kliku
      addAtrib = false;
      mouseBlocker = false;
    }
    
   if(!mouseBlocker) menuBar.tick();  //Tick paska menu
  }
  
  public void render(){
    image(tlo, 0, 0);  //Wyświetlanie tła
    renderCharacter();  //Wyświetlanie wyglądu postaci
    
    renderStats();  //Wyświetlanie statystyk
    menuBar.showMenuBar();  //Wyświetlanie menu
    if(!Magazyn.popupStats)popupStats.render();  //Wyświetlanie instruktażu 
  }
  
  
  ///////////////////////////////////////  METODY WYSWIETLANIA  //////////////////////////////////////////
  
  private void resizer(){
    int buttonWidth = width/10;
    tlo.resize(width , height);
    charSlot.resize(int(width/2) , 0);
    
    iPlus.resize(width/20 , 0);
    iExit.resize(buttonWidth , 0);
  }
  
  private void setPosition(){
    charSlotX = width/2 - charSlot.width/2;
    charSlotY = height/2+height/15;
    
    iArmorX = charSlotX + charSlot.width;
    iArmorY = iWeaponY;
    
    characterX = width/2 - int(width/2.3)/2;
    characterY = (charSlotY + charSlot.height/2) - int(width/2.3)/2;
    
    iExitX = width - iExit.width;
    iExitY = 0;
  }
  
  private void renderCharacter(){
    image(charSlot, charSlotX, charSlotY);
    CharacterClass.myHero.renderImage(characterX, characterY );
    CharacterClass.myHero.getActualArmor().renderArmor(characterX, characterY);
    CharacterClass.myHero.getActualWeapon().renderWeapon(characterX + charSlot.width/5.9 , characterY  + charSlot.height/2 , charSlot.width/100*52);
    CharacterClass.myHero.getActualWeapon().renderAnimation(characterX, characterY);
  }
  
  private void renderStats(){
    textFont(fontInv);
    textAlign(LEFT,BOTTOM);
    
    fill(255);
    text( "SILA"   ,   width/9   ,   silaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.sila   ,   width/2   ,   silaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , silaBtnY);
    
    fill(255);
    text( "INTELIGENCJA"   ,   width/9   ,   inteligencjaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.inteligencja   ,   width/2   ,   inteligencjaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , inteligencjaBtnY);
    
    fill(255);
    text( "ENERGIA"   ,   width/9   ,   energiaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.energia   ,   width/2   ,   energiaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , energiaBtnY);
    
    fill(255);
    text( "ZYWOTNOSC"   ,   width/9   ,   zywotnoscY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.zywotnosc   ,   width/2   ,   zywotnoscY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , zywotnoscBtnY);
    
    fill(255);
    text( "ZRECZNOSC"   ,   width/9   ,   zrecznoscY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.zrecznosc   ,   width/2   ,   zrecznoscY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , zrecznoscBtnY);
    
    fill(255);
    text( "PUNKTY DO ROZDANIA"   ,   width/8   ,   freePointsY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.freePoints   ,   width - width/4   ,   freePointsY );  //Ilość Atrybutu
  }
  
  private void tickStats(){
    if(!mouseBlocker && !addAtrib && mousePressed && CD.mouseCollision(statsBtnX , silaBtnY , statsBtnX+iPlus.width , silaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("sila");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!mouseBlocker && !addAtrib && mousePressed && CD.mouseCollision(statsBtnX , inteligencjaBtnY , statsBtnX+iPlus.width , inteligencjaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("inteligencja");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!mouseBlocker && !addAtrib && mousePressed && CD.mouseCollision(statsBtnX , energiaBtnY , statsBtnX+iPlus.width , energiaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("energia");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!mouseBlocker && !addAtrib && mousePressed && CD.mouseCollision(statsBtnX , zywotnoscBtnY , statsBtnX+iPlus.width , zywotnoscBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("zywotnosc");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!mouseBlocker && !addAtrib && mousePressed && CD.mouseCollision(statsBtnX , zrecznoscBtnY , statsBtnX+iPlus.width , zrecznoscBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("zrecznosc");
      addAtrib = true;
      addBtnSound.play();
    }
  }
  
  /////////////////////////////////////////////////////////  METODY ULEPSZANIA  /////////////////////////////////////////////////
  
  public void upgradeWeapon(){
    if(!CharacterClass.myHero.getActualWeapon().upgradeWeapon() && CharacterClass.myHero.actualWeapon < 11){
      CharacterClass.myHero.actualWeapon ++;
      //newWeaponSound.play();
    }
  }
  
  public void upgradeArmor(){
    if(!CharacterClass.myHero.getActualArmor().upgradeArmor() && CharacterClass.myHero.actualArmor < 10){
      CharacterClass.myHero.actualArmor ++;
      //newArmorSound.play();
    }
  }
  
}
