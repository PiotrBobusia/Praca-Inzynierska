abstract class Skill {
  CollisionDetector CD;
  
  PImage icon[] = new PImage[4];  ///tablica ikon umiejętności (kolejno N M G P)
  protected String iconPath[];
  Animation animationN; ///Animacja umiejętności na poziomie Normalnym
  Animation animationM; ///Animacja umiejętności na poziomie Mistrzowskim
  Animation animationG; ///Animacja umiejętności na poziomie Ponad Mistrzowskim
  Animation animationP; ///Animacja umiejętności na poziomie Perfekcyjnym
  
  PImage actualIcon; Animation actualAnimation;  //Zmienne zawierają aktualną ikonę i animacje (zależą one od stopinia wytrenowania umiejętności)
  int actualIconIndex;
  
  public String name, description; ///Nazwa i opis umiejętności
  protected int level, manaCost; ///Poziom ulepszenia umiejętności     manaCost - koszt zużycia many
  
  protected int loadingTime; ///Czas ładowania umiejętności (podany w cyklach)
  protected int loadingRunner; //Runner czasowy ładowania skilla
  public boolean active;
  
  
  
  Skill(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP){   //Konstruktor pobierający tablice PImage z ikonamy
  
    this.icon = icon.clone();
    this.name = name;
    description = desc;
    resizeFullScreen(aN);
    resizeFullScreen(aM);
    resizeFullScreen(aG);
    resizeFullScreen(aP);
    animationN = new Animation(aN);
    animationM = new Animation(aM);
    animationG = new Animation(aG);
    animationP = new Animation(aP);
    
    manaCost = mana;
    loadingTime = time;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
 
  Skill(String icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP){   //Konstruktor pobierający tablice String z path do ikon
    iconPathLoader(icon);
    this.name = name;
    description = desc;
    resizeFullScreen(aN);
    resizeFullScreen(aM);
    resizeFullScreen(aG);
    resizeFullScreen(aP);
    animationN = new Animation(aN);
    animationM = new Animation(aM);
    animationG = new Animation(aG);
    animationP = new Animation(aP);
    
    manaCost = mana;
    loadingTime = time;
    level = 1;
    updateIcon();
    for(int i = 0; i < icon.length; i++)  this.icon[i].resize(width/8,0); ///Resizuje wszystkie ikony w tablicy
    
    loadingRunner = 0;
    active = true;
    
    CD = new CollisionDetector();
  }
  
  Skill(){
    loadingRunner = 0;
    active = true;
    CD = new CollisionDetector();
  }
  
  
  
  public void levelUp(){
    level++;
    updateIcon();
  };
  
  protected boolean checkMana(){
    if(manaCost > CharacterClass.myHero.actualEnergy) return false;
    else return true;
  }
  
  abstract public void tick(int x, int y, Enemy enemy);
  
  abstract public void render();
  
  
  /////////////////////////////// METODY RYSOWANIA //////////////////////////////////////
  
  protected void resizeIcon(){
    for(int i=0 ; i<icon.length ; i++) icon[i].resize(int(width/7) , 0); //Ikony skilli
  }
  
  protected void resizeFullScreen(PImage ar[]){
    for(int i=0 ; i<ar.length ; i++) ar[i].resize(width , height); //Powiększa na pełny ekran wszystkie obrazy z tablicy
  }
  
  public void updateIcon(){
    if(level >0 && level <= 20){
      actualIcon = icon[0];
      actualIconIndex = 0;
      actualAnimation = animationN;
    }
    if(level >20 && level <= 40){
      actualIcon = icon[1];
      actualIconIndex = 1;
      actualAnimation = animationM;
    }
    if(level >40 && level <= 60){
      actualIcon = icon[2];
      actualIconIndex = 2;
      actualAnimation = animationG;
    }
    if(level >60){
      actualIcon = icon[3];
      actualIconIndex = 3;
      actualAnimation = animationP;
    }
  }
  
  abstract protected void useSkill(Enemy enemy);
  
  public int getY(){ //stara funkcja ustalająca Y przy poprzednich wersjach gry
    return height - actualIcon.height;
  }
  
  public void checkBlock(){ ///Metoda sprawdzająca dostępność umiejętności
    if(!active){
      if(loadingRunner >= loadingTime) {
        active = true;
        loadingRunner = 0;
      }
      else loadingRunner ++;
    }
  }

  public void renderIcon(int x, int y){
    if(!active) tint(GRAY);
    image(actualIcon, x , y);
    noTint();
   }


  public PImage[] getIcon(){
    return icon;
  }
  
  public int getLevel(){
    return level;
  }
  
  public void setLevel(int value){
    level = value;
  }
  
  
  protected boolean iconPathLoader(String[] pathTable){    //Wczytuje tylko pierwsze cztery ikony
    iconPath = new String[4];
    for(int i = 0; i < 4; i++){
      System.out.println("Index iconPathLoader = "+i);
      icon[i] = loadImage(pathTable[i]);
      iconPath[i] = pathTable[i];
    }
    return true;
  }
  
  
  public String getIconPath(int index){
    if(index>3)System.out.println("Index getPathIcon przekroczył 3!");
    return iconPath[index];
  }
  
  
  
  
  
  
  
}
