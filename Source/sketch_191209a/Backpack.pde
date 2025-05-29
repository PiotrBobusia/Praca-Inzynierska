class Backpack extends State{
  
  PImage tlo = loadImage("invBg.png");
  
  int xMargin = (width/7);  //Margines lewy/prawy dla wyświetlanych przedmiotów
  int xBlock = (width - xMargin *2) / 11;  //Szerokość pojedyńczego bloczna dla przemiotów (już po odjęciu marginesów) (okręgi z itemami mają szerokość 3 bloczków)
  int yBlock = int(xBlock * 1.2);
  int circleWidth = xBlock*3;
  
  MenuBar menuBar = new MenuBar();
  CollisionDetector CD = new CollisionDetector();
  
  
   Popup popupBackpack = new Popup("PLECAK","W plecaku zobaczysz ile posiadasz sztuk danego ulepszacza.\nKliknij na wybrany aby przeczytac jego opis.","Popup/imgPopupBackpack.png");
    private boolean mouseBlocker = false;
  
  
  Backpack(){
    loadImages();
    menuBar.setActivePlecak();
  }
  
  void tick(){
    if(!Magazyn.popupBackpack) {mouseBlocker = popupBackpack.tick(); return;}
    if(!mouseBlocker) menuBar.tick();
    
    if(!mousePressed) mouseBlocker = false;
  }

  void render(){
    image(tlo, 0, 0);
    if(CharacterClass.myHero.bamboo.renderItem(xMargin, height/10, CD)) /*  -->  */ CharacterClass.myHero.bamboo.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.wood.renderItem(xMargin + xBlock*4, height/10, CD)) /*  -->  */ CharacterClass.myHero.wood.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.flowers.renderItem(xMargin + xBlock*8, height/10, CD)) /*  -->  */ CharacterClass.myHero.flowers.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    
    if(CharacterClass.myHero.iron.renderItem(xMargin, height/10+yBlock*4, CD)) /*  -->  */ CharacterClass.myHero.iron.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.gold.renderItem(xMargin + xBlock*4, height/10+yBlock*4, CD)) /*  -->  */ CharacterClass.myHero.gold.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.supplies.renderItem(xMargin + xBlock*8, height/10+yBlock*4, CD)) /*  -->  */ CharacterClass.myHero.supplies.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    
    if(CharacterClass.myHero.linen.renderItem(xMargin, height/10+yBlock*8, CD)) /*  -->  */ CharacterClass.myHero.linen.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.lether.renderItem(xMargin + xBlock*4, height/10+yBlock*8, CD)) /*  -->  */ CharacterClass.myHero.lether.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    if(CharacterClass.myHero.silk.renderItem(xMargin + xBlock*8, height/10+yBlock*8, CD)) /*  -->  */ CharacterClass.myHero.silk.renderDescription((xMargin/3)*2, height/10+yBlock*12, xBlock*11 + xMargin/3, yBlock*2);
    menuBar.showMenuBar();
    if(!Magazyn.popupBackpack)popupBackpack.render(); 
  }
  
  private void loadImages(){
    tlo.resize(width , height);
    magazineResizer();
  }
  
  private void magazineResizer(){
    Magazyn.bambooIconON.resize(circleWidth , 0);
    Magazyn.woodIconON.resize(circleWidth , 0);
    Magazyn.flowersIconON.resize(circleWidth , 0);
    Magazyn.ironIconON.resize(circleWidth , 0);
    Magazyn.goldIconON.resize(circleWidth , 0);
    Magazyn.suppliesIconON.resize(circleWidth , 0);
    Magazyn.linenIconON.resize(circleWidth , 0);
    Magazyn.letherIconON.resize(circleWidth , 0);
    Magazyn.silkIconON.resize(circleWidth , 0);
      
    Magazyn.bambooIconOFF.resize(circleWidth , 0);
    Magazyn.woodIconOFF.resize(circleWidth , 0);
    Magazyn.flowersIconOFF.resize(circleWidth , 0);
    Magazyn.ironIconOFF.resize(circleWidth , 0);
    Magazyn.goldIconOFF.resize(circleWidth , 0);
    Magazyn.suppliesIconOFF.resize(circleWidth , 0);
    Magazyn.linenIconOFF.resize(circleWidth , 0);
    Magazyn.letherIconOFF.resize(circleWidth , 0);
    Magazyn.silkIconOFF.resize(circleWidth , 0);
  }

}
