class Menu extends State{
    ///Grafiki
    PImage iBackground= loadImage("menuBg.png");
    PImage iLogo= loadImage("Logo/logo.png");
    
    ///Przyciski
    PImage iKontynuacjaBtn= loadImage("Menu/btnKontynuacja.png");
    PImage iKontynuacjaBtnOFF= loadImage("Menu/btnKontynuacjaOFF.png");
    PImage iGrajBtn= loadImage("Menu/btnNowaGra.png");
    PImage iONasBtn= loadImage("Menu/btnONas.png");
    
    int iBtnX;
    int iBtnY;
    int iONasBtnY;
    int iLogoX, iLogoY;
    
    int iKontBtnX = iBtnX;
    int iKontBtnY;
    boolean kontynuator = false;
    
    boolean mouseBlocker = false;
    
    //Przyciski wczytywania gry
    PImage loadSlot1BtnON= loadImage("Menu/btnSlot1ON.png");
    PImage loadSlot1BtnOFF= loadImage("Menu/btnSlot1OFF.png");
    private boolean slot1Exist = false;
    private int slot1X, slot1Y;
    
    PImage loadSlot2BtnON= loadImage("Menu/btnSlot2ON.png");
    PImage loadSlot2BtnOFF= loadImage("Menu/btnSlot2OFF.png");
    private boolean slot2Exist = false;
    private int slot2X, slot2Y;
    
    PImage loadSlot3BtnON= loadImage("Menu/btnSlot2ON.png");
    PImage loadSlot3BtnOFF= loadImage("Menu/btnSlot2OFF.png");
    private boolean slot3Exist = false;
    private int slot3X, slot3Y;
    
    //Obiekty dodatkowe
    CollisionDetector CD;
    
    //Dzwięki przycisków
    MusicInterface btnSound = new MusicInterface("Sounds/insertBtnSound.wav"); 
    
    //Testowy popup
    Popup popupTest = new Popup("TEST","W dolnej czesci ekranu wyswietlane sa informacje o stanie zdrowia naszego bohatera.\nNiebieski pasek przedstawia zdobyte doswiadczenie, a pod min znajdziemy nasze umiejetnosci specjalne.\n\nUzywaj wywaru leczniczego do ulaczania postaci.","Popup/imgPopupHp.png");
    
    Menu(){  ///Init menu
      init();
    }
    
    public  void tick(){
      if(!Magazyn.popupTest) {mouseBlocker = popupTest.tick(); return;}
      if(!mouseBlocker && mousePressed && CD.mouseCollision(  iBtnX  ,  iBtnY  ,  iBtnX + iGrajBtn.width  ,  iBtnY+iGrajBtn.height  )){
        btnSound.play();
        State.setState(new CharSelection());
      }
      
      if(!mouseBlocker && mousePressed && CD.mouseCollision(  iBtnX  ,  iONasBtnY  ,  iBtnX + iONasBtn.width  ,  iONasBtnY+iONasBtn.height  )){
        btnSound.play();
        State.setState(new ONas());
      }
      /////Poniżej obsługa przycisków wczytywania gry :
      if(slot1Exist && !mouseBlocker &&  mousePressed && CD.mouseCollision(  slot1X  ,  slot1Y  ,  slot1X + loadSlot1BtnON.width  ,  slot1Y+loadSlot1BtnON.height  )){  //Wczytywanie kontynacji
        btnSound.play();
        saver.loadGame(1);
        State.setState(new Inventory());
      }
      
      if(slot2Exist && !mouseBlocker &&  mousePressed && CD.mouseCollision(  slot2X  ,  slot2Y  ,  slot2X + loadSlot2BtnON.width  ,  slot2Y+loadSlot2BtnON.height  )){  //Wczytywanie kontynacji
        btnSound.play();
        saver.loadGame(2);
        State.setState(new Inventory());
      }
      
      if(slot3Exist && !mouseBlocker &&  mousePressed && CD.mouseCollision(  slot3X  ,  slot3Y  ,  slot3X + loadSlot3BtnON.width  ,  slot3Y+loadSlot3BtnON.height  )){  //Wczytywanie kontynacji
        btnSound.play();
        saver.loadGame(3);
        State.setState(new Inventory());
      }
      
      if(!mousePressed) mouseBlocker = false;
      
    };
    
    public void render(){
      
      image(iBackground,0,0);
      
      image(iLogo,iLogoX,iLogoY);                                                       //Konstrukcja (width-(width/1.8))/2 pozwala na wyśrodkowanie obrazka na osi X
      image(iGrajBtn,iBtnX,iBtnY);
      image(iONasBtn,iBtnX, iONasBtnY);
      
      
      if(slot1Exist) image(loadSlot1BtnON,slot1X,slot1Y);
      else image(loadSlot1BtnOFF,slot1X,slot1Y);
      
      if(slot2Exist) image(loadSlot2BtnON,slot2X,slot2Y);
      else image(loadSlot2BtnOFF,slot2X,slot2Y);
      
      if(slot3Exist) image(loadSlot3BtnON,slot3X,slot3Y);
      else image(loadSlot3BtnOFF,slot3X,slot3Y);
      
      if(!Magazyn.popupTest)popupTest.render();
    };
    
    public void init(){ ///Metoda init
      mobileResizer();
      loadMagazinePopup();
      checkLoadingSlot();
      CD = new CollisionDetector();
    }
    
    public void mobileResizer(){ ///Metoda do zmiany rozmiaru grafik w zależności od rozdzielczości ekranu
      iBackground.resize(width , height);
      iLogo.resize((int)(width/1.2),0);
      iGrajBtn.resize((int)(width/1.9),0);
      iONasBtn.resize((int)(width/1.9),0);
      iKontynuacjaBtn.resize((int)(width/1.9),0);
      iKontynuacjaBtnOFF.resize((int)(width/1.9),0);
      iKontBtnY = height - iKontynuacjaBtn.height*2;
      
      loadSlot1BtnON.resize(width/4 , 0);
      loadSlot1BtnOFF.resize(width/4 , 0);
      
      loadSlot2BtnON.resize(width/4 , 0);
      loadSlot2BtnOFF.resize(width/4 , 0);
      
      loadSlot3BtnON.resize(width/4 , 0);
      loadSlot3BtnOFF.resize(width/4 , 0);
      
      slot1X = 0;     slot1Y = height - loadSlot1BtnON.height;
      slot2X = width/2 - loadSlot2BtnON.width/2;     slot2Y = slot1Y;
      slot3X = width - loadSlot3BtnON.width;     slot3Y = slot1Y;
      
      iLogoX = width/2 - iLogo.width/2;
      iLogoY = height/6;
      
      iBtnX = int(width-(width/1.9))/2;
      iBtnY = int(height/6 + iLogo.height * 1.5);
      iONasBtnY = iBtnY+int(iGrajBtn.height*1.5);
      
    }
    
    
    private boolean saveExist(int slot){ //sprawdza czy slot posiada jakiś zapis
      File file=new File("/storage/emulated/0/plikZapisu"+slot+".txt");
      boolean exists = file.exists();
      if (exists) {
        println("true");
        return true;
      }
      else {
        println("false");
        return false;
      }     
    }
    
    
    private void checkLoadingSlot(){ ///Metoda do sprawdzania dostępności slotów zapisu
        slot1Exist = saveExist(1);    
        slot2Exist = saveExist(2);   
        slot3Exist = saveExist(3);   
    }
    
    
    
    
    
    
    private void loadMagazinePopup(){
      Magazyn.popupHud = false;
      Magazyn.popupEnemy = false;
      Magazyn.popupFluid = false;
      Magazyn.popupStats = false;
      Magazyn.popupSkills = false;
      Magazyn.popupBackpack = false;
      Magazyn.popupTown = false;
      Magazyn.popupUpgrade = false;
      Magazyn.popupTest = true;
      Magazyn.popupKanji = false;
      
      Magazyn.popupSkill = new boolean[4];
      Magazyn.popupSkill[0] = true;
      Magazyn.popupSkill[1] = true;
      Magazyn.popupSkill[2] = true;
      Magazyn.popupSkill[3] = true;
      
      Magazyn.bearSound = new MusicInterface("Sounds/enemySound/bearSound.wav");
      Magazyn.monkeySound = new MusicInterface("Sounds/enemySound/monkeySound.wav");
      Magazyn.wolfSound = new MusicInterface("Sounds/enemySound/wolfSound.wav");
      Magazyn.tigerSound = new MusicInterface("Sounds/enemySound/tigerSound.wav");
      
      Magazyn.bossSound1 = new MusicInterface("Sounds/enemySound/bossSound1.wav");
      Magazyn.bossSound2 = new MusicInterface("Sounds/enemySound/bossSound2.wav");
      Magazyn.bossSound3 = new MusicInterface("Sounds/enemySound/bossSound3.wav");
      Magazyn.bossSound4 = new MusicInterface("Sounds/enemySound/bossSound4.wav");
      Magazyn.bossSound5 = new MusicInterface("Sounds/enemySound/bossSound5.wav");
      Magazyn.bearmanSound = new MusicInterface("Sounds/enemySound/bearmanSound.wav");
      Magazyn.demonSound = new MusicInterface("Sounds/enemySound/demonSound.wav");
      Magazyn.demonwolfSound = new MusicInterface("Sounds/enemySound/demonwolfSound.wav");
      Magazyn.entSound = new MusicInterface("Sounds/enemySound/entSound.wav");
      Magazyn.frogSound = new MusicInterface("Sounds/enemySound/frogSound.wav");
      Magazyn.ghulSound = new MusicInterface("Sounds/enemySound/ghulSound.wav");
      Magazyn.orkSound = new MusicInterface("Sounds/enemySound/orkSound.wav");
      Magazyn.pigmanSound = new MusicInterface("Sounds/enemySound/pigmanSound.wav");
      
      
      Magazyn.dodgeSound = new MusicInterface("Sounds/enemySound/dodgeSound.wav");
      Magazyn.cutSound1 = new MusicInterface("Sounds/enemySound/cutSound1.wav");
      Magazyn.cutSound2 = new MusicInterface("Sounds/enemySound/cutSound2.wav");
      Magazyn.cutSound3 = new MusicInterface("Sounds/enemySound/cutSound3.wav");
    }
    
}
