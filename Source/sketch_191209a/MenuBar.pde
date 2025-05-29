public class MenuBar{
  //Deklaracja grafik przycisków Menu
  PImage menuBg;
  PImage imgMiastoOFF, imgMiastoON;
  PImage imgPostacOFF, imgPostacON;
  PImage imgPodrozOFF, imgPodrozON;
  
  PImage imgCialoOFF = loadImage("InvBtn/imgCialoOFF.png");    PImage imgCialoON = loadImage("InvBtn/imgCialoON.png");
  PImage imgDuchOFF = loadImage("InvBtn/imgDuchOFF.png");    PImage imgDuchON = loadImage("InvBtn/imgDuchON.png");
  PImage imgPlecakOFF = loadImage("InvBtn/imgPlecakOFF.png");    PImage imgPlecakON = loadImage("InvBtn/imgPlecakON.png");
  
  PImage imgSwordsmithON = loadImage("Town/btnSwordsmithON.png");           PImage imgSwordsmithOFF = loadImage("Town/btnSwordsmithOFF.png");
  PImage imgArmorerON = loadImage("Town/btnArmorerON.png");                 PImage imgArmorerOFF = loadImage("Town/btnArmorerOFF.png");
  PImage imgMonkON = loadImage("Town/btnMonkON.png");                       PImage imgMonkOFF = loadImage("Town/btnMonkOFF.png");
  PImage imgZenON = loadImage("Town/btnZenON.png");                         PImage imgZenOFF = loadImage("Town/btnZenOFF.png");
  
  //Deklaracja koordynatów przycisków
  float xMiasto, yMiasto;
  float xPodroz, yPodroz;
  float xPostac, yPostac;
  
  float xCialo, yCialo;
  float xDuch, yDuch;
  float xPlecak, yPlecak;
  
  float xSwordsmith, ySwordsmith;
  float xArmorer, yArmorer;
  float xMonk, yMonk;
  float xZen, yZen;
  
  
  private boolean activeMiasto;
  private boolean activePodroz;
  private boolean activePostac;
  private boolean activeDuch;
  private boolean activePlecak;
  private boolean activeCialo;
  
  
  private boolean activeSwordsmith;
  private boolean activeArmorer;
  private boolean activeMonk;
  private boolean activeZen;

  
  //Obiekty dodatkowe
    CollisionDetector CD;
  
  
  MenuBar(){
    loadImages();
    
    unactiveAll();
    
    CD = new CollisionDetector();
  }
  
  public void showMenuBar(){
    image(menuBg, 0, 0);
    render();
  }
  
  
  
  private void loadImages(){
    menuBg = loadImage("MenuBtn/menuBar.png");
    imgMiastoOFF = loadImage("MenuBtn/miastoOFF.png");           imgMiastoON = loadImage("MenuBtn/miastoON.png");

    imgPostacOFF = loadImage("MenuBtn/postacOFF.png");           imgPostacON = loadImage("MenuBtn/postacON.png");

    imgPodrozOFF = loadImage("MenuBtn/podrozOFF.png");           imgPodrozON = loadImage("MenuBtn/podrozON.png");

    
    imgSwordsmithON.resize(width/8,0);
    imgSwordsmithOFF.resize(width/8,0);
    imgArmorerON.resize(width/8,0);
    imgArmorerOFF.resize(width/8,0);
    imgMonkON.resize(width/8,0);
    imgMonkOFF.resize(width/8,0);
    imgZenON.resize(width/8,0);
    imgZenOFF.resize(width/8,0);
    
    
    menuBg.resize(width, height/24);
    imgMiastoOFF.resize(0, height/33);           imgMiastoON.resize(0, height/33);
    imgPostacOFF.resize(0, height/33);           imgPostacON.resize(0, height/33);
    imgPodrozOFF.resize(0, height/33);           imgPodrozON.resize(0, height/33);
    imgCialoOFF.resize(0, height/19);            imgCialoON.resize(0, height/19);
    imgDuchOFF.resize(0, height/19);             imgDuchON.resize(0, height/19);
    imgPlecakOFF.resize(0, height/19);           imgPlecakON.resize(0, height/19);
    
    
    
    xMiasto = 0;                                    yMiasto = menuBg.height/2 - imgMiastoOFF.height/2;
    xPodroz = width/2 - imgPodrozOFF.width/2;       yPodroz = menuBg.height/2 - imgPodrozOFF.height/2;
    xPostac = width-imgPostacOFF.width;             yPostac = menuBg.height/2 - imgPostacOFF.height/2;
    
    
    xDuch = width/2 - imgDuchOFF.width/2;                                             yDuch = height - imgCialoOFF.height - menuBg.height;
    xCialo = xDuch - imgCialoOFF.width - menuBg.height;                               yCialo = yDuch;
    xPlecak = xDuch + imgDuchOFF.width + menuBg.height;                               yPlecak = yDuch;
    
    
     xArmorer = width/2-imgMonkON.width;         yArmorer = height-imgMonkON.height*1.1;
     xMonk = width/2;                            yMonk = yArmorer;
     xSwordsmith = xArmorer - imgMonkON.width;   ySwordsmith = yArmorer;
     xZen = xMonk+imgMonkON.width;               yZen = yArmorer;
  }
  
  
  public void tick(){
    if(!activePodroz && CD.mouseCollision(xPodroz, yPodroz, xPodroz+imgPodrozOFF.width, yPodroz+imgPodrozOFF.height)){  //przycisk Podrozy - możliwość wciśnięcia
      //tutaj wykonuje skrypt po kliknięciu przycisku podróży  
      setActivePodroz();
      State exp = new Exp();
      State.setState(exp);
    }
    if(!activePostac && CD.mouseCollision(xPostac, yPostac, xPostac+imgPostacOFF.width, yPostac+imgPostacOFF.height)){  //przycisk Postaci - możliwość wciśnięcia
      //tutaj wykonuje skrypt po kliknięciu przycisku postaci  
      setActivePostac();
      State inventory = new Inventory();
      State.setState(inventory);
    }
    if(!activeMiasto && CD.mouseCollision(xMiasto, yMiasto, xMiasto+imgMiastoOFF.width, yMiasto+imgMiastoOFF.height)){  //przycisk Miasta - możliwość wciśnięcia
      //tutaj wykonuje skrypt po kliknięciu przycisku miasto  
      setActiveMiasto();
      State town = new Town();
      State.setState(town);
    }
    
    if(activePostac){  //Obsługa ticku meny Inventory
        if(!activeCialo && CD.mouseCollision(xCialo , yCialo , xCialo+imgCialoOFF.width , yCialo+imgCialoOFF.height) ) {  //Przycisk Postac -> Cialo
          setActiveCialo();
          State inventory = new Inventory();
          State.setState(inventory);
        }
        
        if(!activeDuch && CD.mouseCollision(xDuch , yDuch , xDuch+imgDuchOFF.width , yDuch+imgDuchOFF.height) ) {  //Przycisk Postac -> Duch
          setActiveDuch();
          State skillTree = new SkillTree();
          State.setState(skillTree);
        }
        
        if(!activePlecak && CD.mouseCollision(xPlecak , yPlecak , xPlecak+imgPlecakOFF.width , yPlecak+imgPlecakOFF.height) ) {  //Przycisk Postac -> Plecak
          setActivePlecak();
          State backpack = new Backpack();
          State.setState(backpack);
        }
    }
    
    if(activeMiasto){  //Obsługa ticku meny Miasto
        if(!activeSwordsmith && CD.mouseCollision(xSwordsmith , ySwordsmith , xSwordsmith+imgSwordsmithOFF.width , ySwordsmith+imgSwordsmithOFF.height) ) {  //Przycisk Miasto -> Kowal
          setActiveSwordsmith();
          State swordsmith = new Swordsmith();
          State.setState(swordsmith);
        }
        
        if(!activeArmorer && CD.mouseCollision(xArmorer , yArmorer , xArmorer+imgArmorerOFF.width , yArmorer+imgArmorerOFF.height) ) {  //Przycisk Miasto -> Płatnierz
          setActiveArmorer();
          State armorer = new Armorer();
          State.setState(armorer);
        }
        
        if(!activeMonk && CD.mouseCollision(xMonk , yMonk , xMonk+imgMonkOFF.width , yMonk+imgMonkOFF.height) ) {  //Przycisk Miasto -> Monk
          setActiveMonk();
          State monk = new Monk();
          State.setState(monk);
        }
        
        if(!activeZen && CD.mouseCollision(xZen , yZen , xZen+imgZenOFF.width , yZen+imgZenOFF.height) ) {  //Przycisk Miasto -> Zen
          setActiveZen();
          State zen = new Zen();
          State.setState(zen);
        }
    }
  }
  
  public void render(){
    if(activeMiasto) image(imgMiastoON , xMiasto , yMiasto); else image(imgMiastoOFF , xMiasto , yMiasto);
    if(activePodroz) image(imgPodrozON , xPodroz , yPodroz); else image(imgPodrozOFF , xPodroz , yPodroz);
    if(activePostac) image(imgPostacON , xPostac , yPostac); else image(imgPostacOFF , xPostac , yPostac);
    
    if(activePostac && ( activeDuch || activeCialo || activePlecak )){  //Wyświetlanie dodatkowego menu w Inventory
      if(activeCialo) image(imgCialoON , xCialo , yCialo); else image(imgCialoOFF , xCialo , yCialo);
      if(activeDuch) image(imgDuchON , xDuch , yDuch); else image(imgDuchOFF , xDuch , yDuch);
      if(activePlecak) image(imgPlecakON , xPlecak , yPlecak); else image(imgPlecakOFF , xPlecak , yPlecak);
    }
    
    if(activeMiasto){
        if(activeSwordsmith) image(imgSwordsmithON , xSwordsmith , ySwordsmith); else image(imgSwordsmithOFF , xSwordsmith , ySwordsmith);
        if(activeArmorer) image(imgArmorerON , xArmorer , yArmorer); else image(imgArmorerOFF , xArmorer , yArmorer);
        if(activeMonk) image(imgMonkON , xMonk , yMonk); else image(imgMonkOFF , xMonk , yMonk);
        if(activeZen) image(imgZenON , xZen , yZen); else image(imgZenOFF , xZen , yZen);
     }
  }
  
  
  
  public void setActiveMiasto() {unactiveAll(); activeMiasto = true;}
  public void setActivePodroz() {unactiveAll(); activePodroz = true;}
  public void setActivePostac() {unactiveAll(); activePostac = true;}
  public void setActiveDuch() {unactiveAll(); activeDuch = true; activePostac = true;}
  public void setActiveCialo() {unactiveAll(); activeCialo = true; activePostac = true;}
  public void setActivePlecak() {unactiveAll(); activePlecak = true; activePostac = true;}
  
  public void setActiveSwordsmith() {unactiveAll(); activeSwordsmith = true; activeMiasto = true;}
  public void setActiveArmorer() {unactiveAll(); activeArmorer = true; activeMiasto = true;}
  public void setActiveMonk() {unactiveAll(); activeMonk = true; activeMiasto = true;}
  public void setActiveZen() {unactiveAll(); activeZen = true; activeMiasto = true;}
  
  
  private void unactiveAll(){
    activeMiasto = false;
    activePodroz = false;
    activePostac = false;
    activeDuch = false;
    activePlecak = false;
    activeCialo = false;
    
    activeSwordsmith = false;
    activeArmorer = false;
    activeMonk = false;
    activeZen = false;
  }
  
  public int getHeight(){
    return menuBg.height;
  }
  
  public int getInvBtnHeight(){
    return imgCialoOFF.height;
  }
  
}
