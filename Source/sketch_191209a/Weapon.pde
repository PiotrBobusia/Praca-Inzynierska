import java.util.Random;

class Weapon {
  Random rand;  //Obiekt losujący
  
  public PImage image;
  public String name;  ///Nazwa przedmiotu
  private int level;  ///Poziom ulepszenia przedmiotu
  private int atk_od[], atk_do[];  ///Wartości ataku (minimalnego i maksymalnego)
  private String path;
  
  private Animation[] stars;
  
  //Przedmioty potrzebne do ulepszenia przemiotu
  public Item    bamboo[],
                 wood[],
                 flowers[],
                 iron[],
                 gold[],
                 supplies[],
                 linen[],
                 lether[],
                 silk[];
  
  
  //Dzwięki
  MusicInterface upgradeSound = new MusicInterface("Sounds/upgradeSound.wav");
  
  
  Weapon( String name , int atk_od[] , int atk_do[] , String image_path, int bam[] , int woo[] , int flo[] , int iro[] , int gol[] , int sup[] , int lin[] , int let[] , int sil[] ){  //Konstruktor zawierający przedmioty potrzebne do ulepszenia przedmiotu
    rand = new Random();
    
    this.image = loadImage(image_path);
    this.path = image_path;
    this.name = name;
    this.atk_od = atk_od.clone();
    this.atk_do = atk_do.clone();   
    level = 0;              ///Konstruktor ustawia podstawowo poziom ulepszenia przedmiotu na ZERO
    resize();
    
    bamboo = new Item[10];
    wood = new Item[10];
    flowers = new Item[10];
    iron = new Item[10];
    gold = new Item[10];
    supplies = new Item[10];
    linen = new Item[10];
    lether = new Item[10];
    silk = new Item[10];
    
    for(int i = 0; i < 10; i ++){   
      bamboo[i]   = new Item("Bambus" , bam[i]);
      wood[i]     = new Item("Drewno"  , woo[i]);
      flowers[i]  = new Item("Kwiaty"  , flo[i]);
      iron[i]     = new Item("Zelazo"  ,iro[i]);
      gold[i]     = new Item("Zloto"  , gol[i]);
      supplies[i] = new Item("Prowiant"  , sup[i]);
      linen[i]    = new Item("Len" , lin[i]);
      lether[i]   = new Item("Skora"  , let[i]);
      silk[i]     = new Item("Jedwab" , sil[i]);
    }
    
    initAnimation();
  }
  
  
  Weapon( String name , int atk_od[] , int atk_do[] , String image_path){
    rand = new Random();
    
    this.image = loadImage(image_path);
    this.path = image_path;
    this.name = name;
    this.atk_od = atk_od.clone();
    this.atk_do = atk_do.clone();   
    level = 0;              ///Konstruktor ustawia podstawowo poziom ulepszenia przedmiotu na ZERO
    resize();
    
    initAnimation();
  }
  
  
  Weapon( String name , int atk_od[] , int atk_do[]){
    rand = new Random();
    
    this.image = null;
    this.name = name;
    this.atk_od = atk_od.clone();
    this.atk_do = atk_do.clone();   
    level = 0;              ///Konstruktor ustawia podstawowo poziom ulepszenia przedmiotu na ZERO
    resize();
    
    initAnimation();
  }
  
  
  public int calcAtk(){ ///Metoda losująca i zwracająca atak
    //int wynik = rand.nextInt(atk_do);      [  0  -  (atk_do-1)  ]
    return rand.nextInt(atk_do[level]-atk_od[level]+1) + atk_od[level];   //   [  0  -  ( (atk_do-atk_od + 1) - 1 )  ]     dodając do wyniku atak_od wynik  [  atak_od  -  atk_do  ]
  }
  
  private void resize(){
    image.resize(int(width/2.3) , 0);
  }
  
  public void renderWeapon(float x, float y){  //Rysowanie broni w jej podstawych wymiarach
    image(image, x, y);
    if(level == 7){
      stars[0].playAnimation(int(x), int(y), 50, byte(1));
    }
    if(level == 8){
      stars[1].playAnimation(int(x), int(y), 50, byte(1));
    }
    if(level == 9){
      stars[2].playAnimation(int(x), int(y), 50, byte(1));
    }
  }
  
  public void renderWeapon(float x, float y, int szerokosc){    //Rysowanie broni z dodatkiem skalowania obrazka   (Tutaj oś Y wyznacza Środek obrazka, a nie górny róg jak zwykle)
    image.resize(szerokosc , 0);
    image(image, x, y - image.height/2);
  }
  
  public void renderAnimation(float x, float y){    //Rysowanie broni z dodatkiem skalowania obrazka   (Tutaj oś Y wyznacza Środek obrazka, a nie górny róg jak zwykle)
    if(level == 7){
      stars[0].playAnimation(int(x), int(y), 50, byte(1));
    }
    if(level == 8){
      stars[1].playAnimation(int(x), int(y), 50, byte(1));
    }
    if(level == 9){
      stars[2].playAnimation(int(x), int(y), 50, byte(1));
    }
  }
  
  private void initAnimation(){
    PImage WeaponUpdate1 = loadImage("weaponUpdate1.png");
    PImage WeaponUpdate2 = loadImage("weaponUpdate2.png");
    PImage WeaponUpdate3 = loadImage("weaponUpdate3.png");
    
    stars = new Animation[3];
    stars[0] = new Animation(new PImage[]{WeaponUpdate1, WeaponUpdate2, WeaponUpdate3, WeaponUpdate2});
    stars[1] = new Animation(new PImage[]{WeaponUpdate1, WeaponUpdate2, WeaponUpdate3, WeaponUpdate2});
    stars[2] = new Animation(new PImage[]{WeaponUpdate1, WeaponUpdate2, WeaponUpdate3, WeaponUpdate2});
    
    for(int i = 0; i < stars.length ; i++){
      stars[i].resizeWidth(int(width/2.3));
    }
  }
  
  public boolean upgradeWeapon(){  //służy do ulpeszania przedmiotu do +9 wyżej należy zwiększyć licznik broni (CharacterClass.myHero.actualWeapon ++)
    if(level<9){
      level++;
      upgradeSound.play();
      return true;
    } else return false;
  }
  
  public int getWeaponLevel(){
    return level;
  }
  
  public String getWeaponPath(){
    return path;
  }
  
  public int[] getUpgradeStuff(){  //funkcja zwraca tablice wszystkich przedmiotów potrzebnych do ulepszania
    int[] stuff = new int[]{
      bamboo[level].getValue(),
      wood[level].getValue(),
      flowers[level].getValue(),
      iron[level].getValue(),
      gold[level].getValue(),
      supplies[level].getValue(),
      linen[level].getValue(),
      lether[level].getValue(),
      silk[level].getValue()
    };
    return stuff;
  }
  
  public int getUpgradeStuffIndex(int index){
    switch(index){
      case 0: System.out.println("bamboo::"+bamboo[level].getValue()); return bamboo[level].getValue(); 
      case 1: System.out.println("wood::"+wood[level].getValue()); return wood[level].getValue();
      case 2: System.out.println("flowers::"+flowers[level].getValue()); return flowers[level].getValue();
      case 3: System.out.println("iron::"+iron[level].getValue()); return iron[level].getValue();
      case 4: System.out.println("gold::"+gold[level].getValue()); return gold[level].getValue();
      case 5: System.out.println("supplies::"+supplies[level].getValue()); return supplies[level].getValue();
      case 6: System.out.println("linen::"+linen[level].getValue()); return linen[level].getValue();
      case 7: System.out.println("lether::"+lether[level].getValue()); return lether[level].getValue();
      case 8: System.out.println("silk::"+silk[level].getValue()); return silk[level].getValue();
      default: return 0;
    }
  }
  
  public int getLastUpgradeStuffIndex(int index){
    switch(index){
      case 0: System.out.println("bamboo::"+bamboo[level].getValue()); return bamboo[level-1].getValue(); 
      case 1: System.out.println("wood::"+wood[level].getValue()); return wood[level-1].getValue();
      case 2: System.out.println("flowers::"+flowers[level].getValue()); return flowers[level-1].getValue();
      case 3: System.out.println("iron::"+iron[level].getValue()); return iron[level-1].getValue();
      case 4: System.out.println("gold::"+gold[level].getValue()); return gold[level-1].getValue();
      case 5: System.out.println("supplies::"+supplies[level].getValue()); return supplies[level-1].getValue();
      case 6: System.out.println("linen::"+linen[level].getValue()); return linen[level-1].getValue();
      case 7: System.out.println("lether::"+lether[level].getValue()); return lether[level-1].getValue();
      case 8: System.out.println("silk::"+silk[level].getValue()); return silk[level-1].getValue();
      default: return 0;
    }
  }
  
  public void renderUpgradeStuff(int x, int y, int w, int h){  ///Renderuje okno potrzebnych ulepszaczy do sekcji Upgrade
    if(getUpgradeStuff()[0]>0) {bamboo[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}  //Sprawdzam czy potrzebuje tego przedmiotu i wywołuje funkcję rysowania do w sekcji Upgrade
    if(getUpgradeStuff()[1]>0) {wood[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[2]>0) {flowers[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[3]>0) {iron[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[4]>0) {gold[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[5]>0) {supplies[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[6]>0) {linen[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[7]>0) {lether[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
    if(getUpgradeStuff()[8]>0) {silk[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}
  }
  
  
}
