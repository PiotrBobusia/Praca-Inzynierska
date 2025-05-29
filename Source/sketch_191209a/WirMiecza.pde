class WirMiecza extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  WirMiecza(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  WirMiecza(){
    name = "Wir Miecza";
    description = "Wojownik zatacza okrag swoim mieczem, tworzac smiercionosny atak.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Wojownik/Skill/S4/iconN.png";
    tabelaIkon[1] = "Wojownik/Skill/S4/iconM.png";
    tabelaIkon[2] = "Wojownik/Skill/S4/iconG.png";
    tabelaIkon[3] = "Wojownik/Skill/S4/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png")};
    PImage[] animM = new PImage[]{loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png")};
    PImage[] animG = new PImage[]{loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png")};
    PImage[] animP = new PImage[]{loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png")};
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 400;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    int silaBoost = (CharacterClass.myHero.sila / 950) + 1;
    int zrecznoscBoost = (CharacterClass.myHero.zrecznosc / 1500) + 1;
    actualEnemy.hp -= 5 * level * silaBoost * zrecznoscBoost;
    CharacterClass.myHero.actualEnergy -= manaCost;
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}






////////////// Na dole klasa skilla Szybkie Cięcie wojownika !!!!!!!!!









class SzybkieCiecie extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  SzybkieCiecie(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  SzybkieCiecie(){
    name = "Szybkie ciecie";
    description = "Bardzo szybkie ciecie mieczem.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Wojownik/Skill/S2/iconN.png";
    tabelaIkon[1] = "Wojownik/Skill/S2/iconM.png";
    tabelaIkon[2] = "Wojownik/Skill/S2/iconG.png";
    tabelaIkon[3] = "Wojownik/Skill/S2/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/N/sprite_0.png"), loadImage("Wojownik/WirMiecza/N/sprite_1.png"),loadImage("Wojownik/WirMiecza/N/sprite_2.png"),loadImage("Wojownik/WirMiecza/N/sprite_3.png"),loadImage("Wojownik/WirMiecza/N/sprite_4.png"),loadImage("Wojownik/WirMiecza/N/sprite_5.png")};
    PImage[] animM = new PImage[]{loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/M/sprite_0.png"), loadImage("Wojownik/WirMiecza/M/sprite_1.png"),loadImage("Wojownik/WirMiecza/M/sprite_2.png"),loadImage("Wojownik/WirMiecza/M/sprite_3.png"),loadImage("Wojownik/WirMiecza/M/sprite_4.png"),loadImage("Wojownik/WirMiecza/M/sprite_5.png")};
    PImage[] animG = new PImage[]{loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/G/sprite_0.png"), loadImage("Wojownik/WirMiecza/G/sprite_1.png"),loadImage("Wojownik/WirMiecza/G/sprite_2.png"),loadImage("Wojownik/WirMiecza/G/sprite_3.png"),loadImage("Wojownik/WirMiecza/G/sprite_4.png"),loadImage("Wojownik/WirMiecza/G/sprite_5.png")};
    PImage[] animP = new PImage[]{loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png"),
                                  loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png"),
                                loadImage("Wojownik/WirMiecza/P/sprite_0.png"), loadImage("Wojownik/WirMiecza/P/sprite_1.png"),loadImage("Wojownik/WirMiecza/P/sprite_2.png"),loadImage("Wojownik/WirMiecza/P/sprite_3.png"),loadImage("Wojownik/WirMiecza/P/sprite_4.png"),loadImage("Wojownik/WirMiecza/P/sprite_5.png")};
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 400;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    int silaBoost = (CharacterClass.myHero.sila / 950) + 1;
    int zrecznoscBoost = (CharacterClass.myHero.zrecznosc / 1300) + 1;
    actualEnemy.hp -= 16 * level * silaBoost * zrecznoscBoost;
    CharacterClass.myHero.actualEnergy -= manaCost;
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}































////////////// Na dole klasa skilla OGNISTE UDERZENIE INKWIZYTORA !!!!!!!!!









class OgnisteUderzenie extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  OgnisteUderzenie(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  OgnisteUderzenie(){
    name = "Ogniste Uderzenie";
    description = "Uderzenie ostrzem spowitym przez ogien.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Sura/Skill/S2/iconN.png";
    tabelaIkon[1] = "Sura/Skill/S2/iconM.png";
    tabelaIkon[2] = "Sura/Skill/S2/iconG.png";
    tabelaIkon[3] = "Sura/Skill/S2/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Sura/Skill/S2/animation/N/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S2/animation/N/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S2/animation/N/sprite_0/sprite_2.png")};
    PImage[] animM = new PImage[]{loadImage("Sura/Skill/S2/animation/M/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S2/animation/M/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S2/animation/M/sprite_0/sprite_2.png")};
    PImage[] animG = new PImage[]{loadImage("Sura/Skill/S2/animation/G/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S2/animation/G/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S2/animation/G/sprite_0/sprite_2.png")};
    PImage[] animP = new PImage[]{loadImage("Sura/Skill/S2/animation/P/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S2/animation/P/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S2/animation/P/sprite_0/sprite_2.png")};
    
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 400;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    int silaBoost = (CharacterClass.myHero.sila / 950) + 1;
    int inteligencjaBoost = (CharacterClass.myHero.inteligencja / 1000) + 1;
    actualEnemy.hp -= 15 * level * silaBoost * inteligencjaBoost;
    CharacterClass.myHero.actualEnergy -= manaCost;
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}























////////////// Na dole klasa skilla OGNISTE UDERZENIE INKWIZYTORA !!!!!!!!!









class DuchoweUderzenie extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  DuchoweUderzenie(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  DuchoweUderzenie(){
    name = "Duchowe Uderzenie";
    description = "Przelanie duchowej mocy na miecz pozwala wykonac bardzo silne uderzenie.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Sura/Skill/S1/iconN.png";
    tabelaIkon[1] = "Sura/Skill/S1/iconM.png";
    tabelaIkon[2] = "Sura/Skill/S1/iconG.png";
    tabelaIkon[3] = "Sura/Skill/S1/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_4.png"),loadImage("Sura/Skill/S1/animation/N/sprite_0/sprite_5.png")};
    PImage[] animM = new PImage[]{loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_4.png"),loadImage("Sura/Skill/S1/animation/M/sprite_0/sprite_5.png")};
    PImage[] animG = new PImage[]{loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_4.png"),loadImage("Sura/Skill/S1/animation/G/sprite_0/sprite_5.png")};
    PImage[] animP = new PImage[]{loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_4.png"),loadImage("Sura/Skill/S1/animation/P/sprite_0/sprite_5.png")};
    
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 430;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    int zywotnoscBoost = (CharacterClass.myHero.zywotnosc / 1650) + 1;
    int inteligencjaBoost = (CharacterClass.myHero.inteligencja / 900) + 1;
    actualEnemy.hp -= 17 * level * zywotnoscBoost * inteligencjaBoost;
    CharacterClass.myHero.actualEnergy -= manaCost;
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}




















////////////// Na dole klasa skilla SPOPIELENIE INKWIZYTORA !!!!!!!!!









class Spopielenie extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  Spopielenie(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  Spopielenie(){
    name = "Spopielenie";
    description = "Inkwizytor wypala wszystko co stanie mu na drodze.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Sura/Skill/S4/iconN.png";
    tabelaIkon[1] = "Sura/Skill/S4/iconM.png";
    tabelaIkon[2] = "Sura/Skill/S4/iconG.png";
    tabelaIkon[3] = "Sura/Skill/S4/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Sura/Skill/S4/animation/N/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S4/animation/N/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S4/animation/N/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S4/animation/N/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S4/animation/N/sprite_0/sprite_4.png")};
    PImage[] animM = new PImage[]{loadImage("Sura/Skill/S4/animation/M/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S4/animation/M/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S4/animation/M/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S4/animation/M/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S4/animation/M/sprite_0/sprite_4.png")};
    PImage[] animG = new PImage[]{loadImage("Sura/Skill/S4/animation/G/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S4/animation/G/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S4/animation/G/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S4/animation/G/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S4/animation/G/sprite_0/sprite_4.png")};
    PImage[] animP = new PImage[]{loadImage("Sura/Skill/S4/animation/P/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S4/animation/P/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S4/animation/P/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S4/animation/P/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S4/animation/P/sprite_0/sprite_4.png")};
    
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 510;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    int energiaBoost = (CharacterClass.myHero.energia / 1150) + 1;
    int inteligencjaBoost = (CharacterClass.myHero.inteligencja / 900) + 1;
    actualEnemy.hp -= 23 * level * energiaBoost * inteligencjaBoost;
    CharacterClass.myHero.actualEnergy -= manaCost;
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}















////////////// Na dole klasa skilla STRACH INKWIZYTORA !!!!!!!!!









class Strach extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  Strach(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  Strach(){
    name = "Strach";
    description = "Przez olbrzymi strach przeciwnik nie ma sily aby sie poruszyc.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Sura/Skill/S3/iconN.png";
    tabelaIkon[1] = "Sura/Skill/S3/iconM.png";
    tabelaIkon[2] = "Sura/Skill/S3/iconG.png";
    tabelaIkon[3] = "Sura/Skill/S3/iconP.png";
    iconPathLoader(tabelaIkon);
    
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Sura/Skill/S3/animation/N/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S3/animation/N/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S3/animation/N/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S3/animation/N/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S3/animation/N/sprite_0/sprite_4.png")};
    PImage[] animM = new PImage[]{loadImage("Sura/Skill/S3/animation/M/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S3/animation/M/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S3/animation/M/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S3/animation/M/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S3/animation/M/sprite_0/sprite_4.png")};
    PImage[] animG = new PImage[]{loadImage("Sura/Skill/S3/animation/G/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S3/animation/G/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S3/animation/G/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S3/animation/G/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S3/animation/G/sprite_0/sprite_4.png")};
    PImage[] animP = new PImage[]{loadImage("Sura/Skill/S3/animation/P/sprite_0/sprite_0.png"), loadImage("Sura/Skill/S3/animation/P/sprite_0/sprite_1.png"),loadImage("Sura/Skill/S3/animation/P/sprite_0/sprite_2.png"), loadImage("Sura/Skill/S3/animation/P/sprite_0/sprite_3.png"), loadImage("Sura/Skill/S3/animation/P/sprite_0/sprite_4.png")};
    
    resizeFullScreen(animN);
    resizeFullScreen(animM);
    resizeFullScreen(animG);
    resizeFullScreen(animP);
    animationN = new Animation(animN);
    animationM = new Animation(animM);
    animationG = new Animation(animG);
    animationP = new Animation(animP);
    
    //kolejne dane
    manaCost = 0;
    loadingTime = 600;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  
  public void useSkill(Enemy actualEnemy){ ///Użycie skila wymaga podania jako parametry:     postaci, którą gramy    oraz    przeciwnika
    actualEnemy.setSwoon(100+(level*5));
    active = false;
  }
  
  
  public void tick(int x , int y , Enemy enemy){
    checkBlock();
    if(active && mousePressed && CD.mouseCollision(x , y , x+actualIcon.width , y+actualIcon.height) && !activeAnimation && checkMana()){
      activeAnimation = true;
      useSkill(enemy);
    }
    
  }
  
  public void render(){
    if(activeAnimation){
      if(!actualAnimation.play){ //Jeśli animacja się zakończyła
        activeAnimation = false;
        actualAnimation.setDefaults(); //restartuje animacje
      }
      else {
        actualAnimation.playAnimation(0,0,3,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}
