class TrzystronneCiecie extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  TrzystronneCiecie(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  TrzystronneCiecie(){
    name = "Trzystronne Ciecie";
    description = "Zapewnie trzy idealnie wykonane ciecia mieczem.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Wojownik/Skill/S3/iconN.png";
    tabelaIkon[1] = "Wojownik/Skill/S3/iconM.png";
    tabelaIkon[2] = "Wojownik/Skill/S3/iconG.png";
    tabelaIkon[3] = "Wojownik/Skill/S3/iconP.png";
    iconPathLoader(tabelaIkon);
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Wojownik/TrzystronneCiecie/N/sprite_0.png"), loadImage("Wojownik/TrzystronneCiecie/N/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_3.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_4.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_5.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_6.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_7.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_0.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/N/sprite_3.png")};
    PImage[] animM = new PImage[]{loadImage("Wojownik/TrzystronneCiecie/M/sprite_0.png"), loadImage("Wojownik/TrzystronneCiecie/M/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_3.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_4.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_5.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_6.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_7.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_0.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/M/sprite_3.png")};
    PImage[] animG = new PImage[]{loadImage("Wojownik/TrzystronneCiecie/G/sprite_0.png"), loadImage("Wojownik/TrzystronneCiecie/G/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_3.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_4.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_5.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_6.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_7.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_0.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/G/sprite_3.png")};
    PImage[] animP = new PImage[]{loadImage("Wojownik/TrzystronneCiecie/P/sprite_0.png"), loadImage("Wojownik/TrzystronneCiecie/P/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_3.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_4.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_5.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_6.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_7.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_0.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_1.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_2.png"),loadImage("Wojownik/TrzystronneCiecie/P/sprite_3.png")};
    
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
    actualEnemy.hp -= 10 * level * silaBoost * zrecznoscBoost;
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
