class SkillTree extends State{

  PImage tlo = loadImage("invBg.png");  //Tło
  PImage checkBtn = loadImage("InvBtn/checkSkill.png");  //Przycisk "[?]"  
  
  PFont fontInv = createFont("font.ttf",width/24); //Fonty
  PFont fontInv2 = createFont("font.ttf",width/33);
  
  private int tintowy = 255;  //Tint do mrugania UI
  private boolean wGore =false, wDol=false;  //Boolean mrugania
  private boolean upgradeSkill = false;  //Boolean pilnujący przed multi ulepszaniem skilli
  
  int skillIconWidth;  //Wymiary ikon
  int skillIconHeight;
  
  //"Rozmycie" Drzewka umiejętności
  int[][] rozmycie = new int[4][4];
  
  CollisionDetector CD = new CollisionDetector();
  
  //Instruktaż i popup-y "[?]"
  Popup popupSkills = new Popup("UMIEJETNOSCI","Kazdy kolejny poziom umozliwia ulepszanie umiejetnosci specjalnych naszego bohatera.\nWydaj wolne punkty na ulepszenie umiejetnosci poprzez klikniecie w jej ikone.","Popup/imgPopupSkill.png");
  Popup popupSkill1 = new Popup(CharacterClass.myHero.skillsList[0].name,CharacterClass.myHero.skillsList[0].description,"Popup/imgPopupSkill2.png");
  Popup popupSkill2 = new Popup(CharacterClass.myHero.skillsList[1].name,CharacterClass.myHero.skillsList[1].description,"Popup/imgPopupSkill2.png");
  Popup popupSkill3 = new Popup(CharacterClass.myHero.skillsList[2].name,CharacterClass.myHero.skillsList[2].description,"Popup/imgPopupSkill2.png");
  Popup popupSkill4 = new Popup(CharacterClass.myHero.skillsList[3].name,CharacterClass.myHero.skillsList[3].description,"Popup/imgPopupSkill2.png");
    private boolean mouseBlocker = false;
  
  
  MenuBar menuBar = new MenuBar();
  
  SkillTree(){
    resizer();
    menuBar.setActiveDuch();
    genRozmycie(height/16);
  }

  void tick(){
    //Instruktaż TICK
    if(!Magazyn.popupSkills) {mouseBlocker = popupSkills.tick(); return;}
    if(!Magazyn.popupSkill[0]) {mouseBlocker = popupSkill1.tick(); return;}
    else if(!Magazyn.popupSkill[1]) {mouseBlocker = popupSkill2.tick(); return;}
    else if(!Magazyn.popupSkill[2]) {mouseBlocker = popupSkill3.tick(); return;}
    else if(!Magazyn.popupSkill[3]) {mouseBlocker = popupSkill4.tick(); return;}
    if(!mouseBlocker) menuBar.tick();
    if(!mousePressed) {upgradeSkill = false; mouseBlocker = false;}
  }

  void render(){
    image(tlo, 0, 0);
    renderFreePoints();
    renderSkill(0,height/6);    //Wyświetlanie gałęzi umiejętności
    renderSkill(1,height/6*2);
    renderSkill(2,height/6*3);
    renderSkill(3,height/6*4);
    menuBar.showMenuBar();   //Wyświetlanie paska menu
    //Instruktaż RENDER
    if(!Magazyn.popupSkills)popupSkills.render(); 
    if(!Magazyn.popupSkill[0])popupSkill1.render(); 
    else if(!Magazyn.popupSkill[1])popupSkill2.render(); 
    else if(!Magazyn.popupSkill[2])popupSkill3.render(); 
    else if(!Magazyn.popupSkill[3])popupSkill4.render(); 
  }
  
  
  
  private void renderSkill(int index, int y){  ///Funkcja renderowania drzewka dla poszczególnego skilla postaci
    int x0 = width/5 - skillIconWidth/2;
    int x1 = x0 + width/5;
    int x2 = x1 + width/5;
    int x3 = x2 + width/5;
    int y0 = y + rozmycie[index][0];
    int y1 = y + rozmycie[index][1];
    int y2 = y + rozmycie[index][2];
    int y3 = y + rozmycie[index][3];
    int btnX = x0 - int(skillIconWidth/1.2) , btnY = y0 + skillIconHeight/2 - checkBtn.height/2;
    PImage icon0 = loadImage(CharacterClass.myHero.skillsList[index].getIconPath(0));  ///Przerzucenie ikon umiejętności do zmiennych "buforowych" aby nadać im filtr GRAY
    PImage icon1 = loadImage(CharacterClass.myHero.skillsList[index].getIconPath(1));
    PImage icon2 = loadImage(CharacterClass.myHero.skillsList[index].getIconPath(2));
    PImage icon3 = loadImage(CharacterClass.myHero.skillsList[index].getIconPath(3));
    icon0.resize(skillIconWidth,skillIconHeight);
    icon1.resize(skillIconWidth,skillIconHeight);
    icon2.resize(skillIconWidth,skillIconHeight);
    icon3.resize(skillIconWidth,skillIconHeight);
    
    int actualIndex = CharacterClass.myHero.skillsList[index].actualIconIndex;
    int lvX, lvY;
    if(actualIndex == 0) {lvX = x0 + skillIconWidth/2; lvY = y0 + skillIconHeight + width/33;}
    else if(actualIndex == 1) {lvX = x1 + skillIconWidth/2; lvY = y1 + skillIconHeight + width/33;}
    else if(actualIndex == 2) {lvX = x2 + skillIconWidth/2; lvY = y2 + skillIconHeight + width/33;}
    else if(actualIndex == 3) {lvX = x3 + skillIconWidth/2; lvY = y3 + skillIconHeight + width/33;}
    else {lvX = x0 + skillIconWidth/2; lvY = y0 + skillIconHeight + width/33;}
    
    //OBLICZANIE TINTA
    if(CharacterClass.myHero.skillPoints>0){    //Obsługa mrugania skilla
        if(tintowy > 170 && wDol) tintowy--;
        else if(tintowy <= 170 && wDol) {wDol=false; wGore=true;}
        else if(tintowy < 255 && wGore) {tintowy++;}
        else if(tintowy >= 255 && wGore) {wGore = false; wDol=true;}
        else wDol = true;
    } else tintowy = 255;
    /////////
    
    textFont(fontInv2);
    fill( 250 , 250 , 210 );
    textAlign(CENTER);
    text( CharacterClass.myHero.skillsList[index].level   ,   lvX   ,   lvY );  //Ilość Atrybutu
    textAlign(LEFT);
    
    tint(255, tintowy);
    
    stroke(250, 250, 210,tintowy-50);
    line(  x0 + icon0.width/2  ,  y0 + icon0.height/2  ,  x1 + icon0.width/2  ,  y1 + icon0.height/2  );
    line(  x1 + icon0.width/2  ,  y1 + icon0.height/2  ,  x2 + icon0.width/2  ,  y2 + icon0.height/2  );
    line(  x2 + icon0.width/2  ,  y2 + icon0.height/2  ,  x3 + icon0.width/2  ,  y3 + icon0.height/2  );
    
    image(checkBtn , btnX , btnY);
    
    if(CharacterClass.myHero.skillsList[index].actualIconIndex!=0) icon0.filter(GRAY);
    image(icon0 , x0 , y0);
    
    if(CharacterClass.myHero.skillsList[index].actualIconIndex!=1) icon1.filter(GRAY);
    image(icon1 , x1 , y1);
    
    if(CharacterClass.myHero.skillsList[index].actualIconIndex!=2) icon2.filter(GRAY);
    image(icon2 , x2 , y2);
    
    if(CharacterClass.myHero.skillsList[index].actualIconIndex!=3) icon3.filter(GRAY);
    image(icon3 , x3 , y3);
    
    tint(255, 255);
    
    //Tick do obsługi dodawania poziomów umiejetności
    if(!mouseBlocker && !upgradeSkill && mousePressed && CharacterClass.myHero.skillPoints>0 && CD.mouseCollision(lvX-skillIconWidth/2 , lvY-(skillIconHeight + width/33) , lvX+skillIconWidth/2 , lvY- width/33)){
      CharacterClass.myHero.skillsList[index].levelUp();
      CharacterClass.myHero.skillPoints--;
      
      upgradeSkill = true;
    }
    
    //Tick do obsługi sprawdzania umiejętności
    if(!mouseBlocker && mousePressed && CD.mouseCollision(btnX , btnY , btnX+checkBtn.width , btnY+checkBtn.height)){
      if(index==0) Magazyn.popupSkill[index] = false;
      else if(index==1) Magazyn.popupSkill[index] = false;
      else if(index==2) Magazyn.popupSkill[index] = false;
      else if(index==3) Magazyn.popupSkill[index] = false;
    }
    
  }
  
  
  private void renderFreePoints(){
    textFont(fontInv);
    fill(255);
    text( "PUNKTY DO ROZDANIA"   ,   width/8   ,   height - menuBar.getHeight()-(menuBar.getInvBtnHeight()*2) );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.skillPoints   ,   width - width/4   ,   height - menuBar.getHeight()-(menuBar.getInvBtnHeight()*2) );  //Ilość Atrybutu
  }
  
  private void resizer(){
    tlo.resize(width,height);
    skillIconWidth = CharacterClass.myHero.skillsList[0].getIcon()[0].width;
    skillIconHeight = CharacterClass.myHero.skillsList[0].getIcon()[0].height;
    checkBtn.resize(int(skillIconWidth/1.7) , 0);
  }
  
  private void genRozmycie(int sila_rozmycia){
    for(int i = 0 ; i < 4 ; i ++)
      for(int j = 0 ; j < 4 ; j ++)
        rozmycie[i][j] = int(random(-sila_rozmycia, sila_rozmycia));
  }
  

}
