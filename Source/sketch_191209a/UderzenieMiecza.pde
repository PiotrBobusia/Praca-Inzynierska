class UderzenieMiecza extends Skill{
   
  private int atk;  
  boolean activeAnimation;  //Mówi o tym czy animacja powinna być wyświetlana
  
  UderzenieMiecza(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP, int atk){  //Konstruktor w razie tworzenie podobnego skilla
    super( icon , name , desc , mana , time , aN , aM , aG , aP );
    this.atk = atk;
    activeAnimation = false;
  }
  
  UderzenieMiecza(){
    name = "Uderzenie Miecza";
    description = "Cala zgromadzona energia miecza uderza we wroga.\n Powoduje unieruchomienie przeciwnika.";
    //wczytywanie ikon skilla
    String[] tabelaIkon = new String[4];
    tabelaIkon[0] = "Wojownik/Skill/S1/iconN.png";
    tabelaIkon[1] = "Wojownik/Skill/S1/iconM.png";
    tabelaIkon[2] = "Wojownik/Skill/S1/iconG.png";
    tabelaIkon[3] = "Wojownik/Skill/S1/iconP.png";
    iconPathLoader(tabelaIkon);
    
    //tworzenie animacji skilla
    PImage[] animN = new PImage[]{loadImage("Wojownik/UderzenieMiecza/N/sprite_0.png"), loadImage("Wojownik/UderzenieMiecza/N/sprite_1.png"),loadImage("Wojownik/UderzenieMiecza/N/sprite_2.png"),loadImage("Wojownik/UderzenieMiecza/N/sprite_3.png"),loadImage("Wojownik/UderzenieMiecza/N/sprite_4.png"),loadImage("Wojownik/UderzenieMiecza/N/sprite_5.png"),loadImage("Wojownik/UderzenieMiecza/N/sprite_6.png")};
    PImage[] animM = new PImage[]{loadImage("Wojownik/UderzenieMiecza/M/sprite_0.png"), loadImage("Wojownik/UderzenieMiecza/M/sprite_1.png"),loadImage("Wojownik/UderzenieMiecza/M/sprite_2.png"),loadImage("Wojownik/UderzenieMiecza/M/sprite_3.png"),loadImage("Wojownik/UderzenieMiecza/M/sprite_4.png"),loadImage("Wojownik/UderzenieMiecza/M/sprite_5.png"),loadImage("Wojownik/UderzenieMiecza/M/sprite_6.png")};
    PImage[] animG = new PImage[]{loadImage("Wojownik/UderzenieMiecza/G/sprite_0.png"), loadImage("Wojownik/UderzenieMiecza/G/sprite_1.png"),loadImage("Wojownik/UderzenieMiecza/G/sprite_2.png"),loadImage("Wojownik/UderzenieMiecza/G/sprite_3.png"),loadImage("Wojownik/UderzenieMiecza/G/sprite_4.png"),loadImage("Wojownik/UderzenieMiecza/G/sprite_5.png"),loadImage("Wojownik/UderzenieMiecza/G/sprite_6.png")};
    PImage[] animP = new PImage[]{loadImage("Wojownik/UderzenieMiecza/P/sprite_0.png"), loadImage("Wojownik/UderzenieMiecza/P/sprite_1.png"),loadImage("Wojownik/UderzenieMiecza/P/sprite_2.png"),loadImage("Wojownik/UderzenieMiecza/P/sprite_3.png"),loadImage("Wojownik/UderzenieMiecza/P/sprite_4.png"),loadImage("Wojownik/UderzenieMiecza/P/sprite_5.png"),loadImage("Wojownik/UderzenieMiecza/P/sprite_6.png")};
    
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
    int inteligencjaBoost = (CharacterClass.myHero.inteligencja / 1500) + 1;
    actualEnemy.hp -= 10 * level * silaBoost * inteligencjaBoost;
    actualEnemy.setSwoon(50);
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
        actualAnimation.playAnimation(0,0,4,byte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}
