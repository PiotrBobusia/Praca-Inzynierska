class Armor {
  
  public PImage image;  ///Grafika przemiotu
  public String name;  ///Nazwa przedmiotu
  private int level;  ///Poziom ulepszenia przedmiotu
  private int def[];  ///Wartości ataku (minimalnego i maksymalnego)
  private String path;  //Ścieżka grafiki przedmiotu
  
  private Animation[] stars;  //Animacja lśnienia
  
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
  
  //Dzwięki ulpeszenia
  MusicInterface upgradeSound = new MusicInterface("Sounds/upgradeSound.wav");
  
  
  Armor( String name , int def[] , String image_path, int bam[] , int woo[] , int flo[] , int iro[] , int gol[] , int sup[] , int lin[] , int let[] , int sil[] ){  //Konstruktor zawierający potrzebne przedmioty do ulepszania pancerza
    this.image = loadImage(image_path);
    this.name = name;
    this.path = image_path;
    this.def = def.clone();
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
      wood[i]     = new Item("Drewno" , woo[i]);
      flowers[i]  = new Item("Kwiaty" , flo[i]);
      iron[i]     = new Item("Zelazo"  ,iro[i]);
      gold[i]     = new Item("Zloto"  , gol[i]);
      supplies[i] = new Item("Prowiant"  , sup[i]);
      linen[i]    = new Item("Len"  , lin[i]);
      lether[i]   = new Item("Skora"  , let[i]);
      silk[i]     = new Item("Jedwab" , sil[i]);
    }
    initAnimation();
  }
  
  
  Armor( String name , int def[] , String image_path){
    
    this.image = loadImage(image_path);
    this.name = name;
    this.path = image_path;
    this.def = def.clone();
    level = 0;              ///Konstruktor ustawia podstawowo poziom ulepszenia przedmiotu na ZERO
    resize();
    
    initAnimation();
  }
  
  Armor( String name , int def[]){
    
    this.image = null;
    this.name = name;
    this.def = def.clone();
    level = 0;              ///Konstruktor ustawia podstawowo poziom ulepszenia przedmiotu na ZERO
    
    initAnimation();
  }
  
  public int calcDef(){ ///Metoda zwracająca wartość obrony
    return def[level];
  }
  
  private void resize(){  ///Skalowanie obrau pancerza
    image.resize(int(width/2.3) , 0);
  }
  
  public void renderArmor(float x, float y){  ///Wyświetlanie pancerza
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
  
  private void initAnimation(){
    PImage ArmorUpdate1 = loadImage("armorUpdate1.png");
    PImage ArmorUpdate2 = loadImage("armorUpdate2.png");
    PImage ArmorUpdate3 = loadImage("armorUpdate3.png");
    
    stars = new Animation[3];
    stars[0] = new Animation(new PImage[]{ArmorUpdate1, ArmorUpdate2, ArmorUpdate3, ArmorUpdate2});
    stars[1] = new Animation(new PImage[]{ArmorUpdate1, ArmorUpdate2, ArmorUpdate3, ArmorUpdate2});
    stars[2] = new Animation(new PImage[]{ArmorUpdate1, ArmorUpdate2, ArmorUpdate3, ArmorUpdate2});
    
    for(int i = 0; i < stars.length ; i++){
      stars[i].resizeWidth(int(width/2.3));
    }
  }
  
  
  public boolean upgradeArmor(){ //Metoda służąca do ulepszania pancerza
    if(level<9){
      level++;
      upgradeSound.play();
      return true;
    } else return false;
  }
  
  public int getArmorLevel(){  //Zwraca poziom pancerza
    return level;
  }
  
  public void setArmorLevel(int value){  //Ustawia poziom pancerza
    level = value;
  }
  
  
  //////////////////////////////METODY ZWIĄZANE Z PŁATNERZEM
  
  public String getArmorPath(){
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
    if(getUpgradeStuff()[0]>0) {bamboo[level].renderOnUpgrade(x, y, w, h); y+=h+h/20;}                                    //Sprawdzam czy potrzebuje tego przedmiotu i wywołuje funkcję rysowania do w sekcji Upgrade
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
