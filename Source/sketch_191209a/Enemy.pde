public class Enemy{
  boolean alive;  ///Czy przeciwnik jest przy życiu?
  boolean dead; ///Czy przeciwnik został zabity?             ->      Różnica między tym a alive jest taka że gdy alive = false, dopóki nie przejdzie przez animację znikania dead = false
  boolean attacked; ///Czy przeciwnik jest atakowany (służy do ochrony przed "multi-hitem")
  
  public PImage image;  private String imgPath; //Grafika przeciwnika
  private String name;  //Nazwa przeciwnika np. dziki dzik
  private int level, atk, hp, hpMax, yangDrop; //poziom przeciwnika, punkty_ataku, punkty_zycia, drop_yangów
  HealthBar healthBar;
  int attackSpeed, attackRunner; //Ilość cykli pomiędzy następnymi atakami przeciwnika    attackRunner - określa ile cykli minęło od ostatniego ataku
  int expiriencePoints; //Punkty dościawczenia zdobyte po pokonaniu przeciwnika
  
  private int xEnemy, yEnemy; //koordynaty grafiki przeciwnika 
  CollisionDetector CD;
  private HitCounter hitCounter; //obiekt wyświetlający uderzenia
  
  public boolean swoon; ///Omdlenie
  public int swoonTime; //Jeśli 0 to nie ma omdlenia   /    Jeśli więcej to odlicza ten czas do zera
  Animation swoonAnimation;
  
  private int[] drop; int[] podob; //drop - lista ilości temów    pobod - lista prawdopodobienstwa dropu
  private int[] generatedLoot; //Wygenerowany loot
  private boolean generateLoot = false;  //Informacja o tym czy loot został wygenerowany
  private boolean itemAdded = false;  //Zapewnie blokade przed podwójnym dodaniem przedmiotów dla gracza
  
  int opacity; //Przeźroczystość wyświetlaniej grafiki przeciwnika (przy śmierci opacity maleje)
  
  
  //Dzwięki ataku przeciwnika
  int breed = 0;
  
  //Animacja ataku przeciwnika
  int attackSizeMax = 7;
  int attackSize = 0;
  boolean goUp = false, goDown = false;  //zwiększanie/zmniejszanie obrazka
  
  boolean dodgeTime; //Jest true jeśli w tym momencie możliwe jest wykonanie uniku
  boolean dodged; //Jest true jeśli unik został wykonany poprawinie
  PImage dodgeImage = loadImage("HUD/kanjiUnik.png");
  int dodgeX, dodgeY;
  boolean randDodge; //Blokada losowania zmiennych uniku dodgeX i dodgeY
  boolean dodgeCheck = false;
  int defaultDodgeTime = 18;
    
  //ITEMY MOZLIWE DO LOOTU
  private Item bamboo, wood, flowers, iron, gold, supplies, linen, lether, silk;
    
  Enemy(String Img, String name, int level, int atk, int atkSpeed, int hp, int yang, int PD){
    image = loadImage(Img); opacity = 255;
    this.name = name;
    this.level = level;
    this.atk = atk;
    attackSpeed = atkSpeed;
    this.hp = hp;
    this.hpMax = hp;
    this.yangDrop = yang;
    this.expiriencePoints = PD;
    image.resize(int(width/1.4),0);
    
    xEnemy = int(width/2 - image.width/2);
    yEnemy = int(height/1.4 - image.height/2);
    CD = new CollisionDetector();
    hitCounter = new HitCounter();
    
    healthBar = new HealthBar(hp, name, level);
    
    alive = true;
    attacked = false;
    
    PImage swoonImage[] = new PImage[]{loadImage("Animacje/Omdlenie/sprite_0.png"),loadImage("Animacje/Omdlenie/sprite_1.png"),loadImage("Animacje/Omdlenie/sprite_2.png"),loadImage("Animacje/Omdlenie/sprite_3.png")};
    swoonResize(swoonImage);
    swoonAnimation = new Animation(swoonImage);
    
    swoon = false;  //Omdlenieeee
    swoonTime = 0;
    
    ///Potrzebne zmienne do dropu
    loadItems();
    drop = new int[]{0,0,0,0,0,0,0,0,0};
    podob = new int[]{0,0,0,0,0,0,0,0,0};
    generateLoot();
  }
  
  
  Enemy(String Img, String name, int level, int atk, int atkSpeed, int hp, int yang, int PD, int[] item, int[] podobienstwo){ //int[] item zawiera ilosc przedmiotow [index 0 - 8]     int[] podobienstwo zawiera szanse na wypadniecie przedmiotu 
    image = loadImage(Img); opacity = 255;
    this.name = name;
    this.level = level;
    this.atk = atk;
    attackSpeed = atkSpeed;
    this.hp = hp;
    this.hpMax = hp;
    this.yangDrop = yang;
    this.expiriencePoints = PD;
    image.resize(int(width/1.4),0);
    
    xEnemy = int(width/2 - image.width/2);
    yEnemy = int(height/1.4 - image.height/2);
    CD = new CollisionDetector();
    hitCounter = new HitCounter();
    
    healthBar = new HealthBar(hp, name, level);
    
    alive = true;
    attacked = false;
    
    PImage swoonImage[] = new PImage[]{loadImage("Animacje/Omdlenie/sprite_0.png"),loadImage("Animacje/Omdlenie/sprite_1.png"),loadImage("Animacje/Omdlenie/sprite_2.png"),loadImage("Animacje/Omdlenie/sprite_3.png")};
    swoonResize(swoonImage);
    swoonAnimation = new Animation(swoonImage);
    
    swoon = false;
    swoonTime = 0;
    
    ///Potrzebne zmienne do dropu
    loadItems();
    drop = new int[9];
    podob = new int[9];
    for(int i = 0; i < 9; i ++){
      drop[i] = item[i];
      podob[i] = podobienstwo[i];
    }
    generateLoot();
  }
  
  
  
  Enemy(String Img, String name, int level, int atk, int atkSpeed, int hp, int yang, int PD, int[] item, int[] podobienstwo, int rasa){ //int[] item zawiera ilosc przedmiotow [index 0 - 8]     int[] podobienstwo zawiera szanse na wypadniecie przedmiotu     int rasa - zawiera informacje o rasie w celu dodania dzwięku ataku
    image = loadImage(Img); opacity = 255;
    imgPath = Img;
    this.name = name;
    this.level = level;
    this.atk = atk;
    attackSpeed = atkSpeed;
    this.hp = hp;
    this.hpMax = hp;
    this.yangDrop = yang;
    this.expiriencePoints = PD;
    image.resize(int(width/1.4),0);
    
    xEnemy = int(width/2 - image.width/2);
    yEnemy = int(height/1.4 - image.height/2);
    CD = new CollisionDetector();
    hitCounter = new HitCounter();
    
    healthBar = new HealthBar(hp, name, level);
    
    alive = true;
    attacked = false;
    
    PImage swoonImage[] = new PImage[]{loadImage("Animacje/Omdlenie/sprite_0.png"),loadImage("Animacje/Omdlenie/sprite_1.png"),loadImage("Animacje/Omdlenie/sprite_2.png"),loadImage("Animacje/Omdlenie/sprite_3.png")};
    swoonResize(swoonImage);
    swoonAnimation = new Animation(swoonImage);
    
    swoon = false;
    swoonTime = 0;
    
    ///Potrzebne zmienne do dropu
    loadItems();
    drop = new int[9];
    podob = new int[9];
    for(int i = 0; i < 9; i ++){
      drop[i] = item[i];
      podob[i] = podobienstwo[i];
    }
    generateLoot();
    
    breed = rasa;
    dodgeImage.resize(width/6 , 0);
  }
  
  
  
  
  
  void tick(CharacterClass hero){
    //Kliknięcie w ikone przeciwnika -> zaatakowanie go
    if(mousePressed && CD.mouseCollision( xEnemy , yEnemy , xEnemy+image.width , yEnemy+image.height ) && !attacked && stillAlive()) {
      getDamage(hero.attack()); 
      attacked=true;
    }
    if(!mousePressed) attacked = false;
    healthBar.tick(hp);    ///Tick paska zdrowia przeciwnika (pobiera punkty HP)
    
    if(stillAlive()) attackTick(hero);  //Tick atakujący bohatera
    if(!swoon) attackAnimationTick();  //Omdlenie przeciwnika
    
    if(swoon && swoonTime>0){  //Licznik czasu omdlenia
       swoonTime --;
    } else {
      swoonTime=0;
      swoon = false;
    }
  }
  
  void render(){
    if(!stillAlive())tint(255,opacity);
    image(image, xEnemy, yEnemy);  //Grafika przeciwnika
    noTint();
    healthBar.render();  ///Render paska zdrowia przeciwnika
    if(swoon) swoonAnimation.playAnimation(  width/2 - swoonAnimation.getWidth()/2  ,  yEnemy - swoonAnimation.getHeight()/2 ,  10  ,  byte(1)  );
    if(stillAlive()){  //Aby nie wyświetlić po śmierci przeciwnika ani klatki zadanych obrażeń
      hitCounter.animateHitRender();
      dodgeTick(); //Tick unikania ciosów przeciwnika
    } else { 
      opacity-=10;
      lootRender(int(width/2.3), height/3*2, width/11);
    }
    
    if(opacity <= 0 && !alive){
      dead = true;
      if(!itemAdded) addItemToHero();
      itemAdded = true;
    }
  }
  
  void getDamage(int damageValue){ ///Funkcja odpowiada za przyjmowanie obrażeń
    hp -= damageValue;
    hitCounter.newValue(damageValue);
    int rand = int(random(3));
    if(rand == 1) Magazyn.cutSound1.play();
    else if(rand == 2) Magazyn.cutSound2.play();
    else if(rand == 3) Magazyn.cutSound3.play();
  }
  
  int attack(){  ///Funkcja odpowiada za atakowanie
    return atk;
  }
  
  void attackTick(CharacterClass hero){
    if(!swoon && attackRunner>=attackSpeed){
      if(!dodged) hero.getDamage(attack());
      attackRunner=0; dodged = false; dodgeCheck=false;
    }
    attackRunner++;
    
    if(!dodgeCheck && (attackSpeed - attackRunner)<defaultDodgeTime) {
      dodgeX = int(random(width-dodgeImage.width));
      dodgeY = int(random(height/5,height/7*5));
      dodgeTime = true;
      dodgeCheck=true;
    } 
  }
  
  boolean stillAlive(){  ///sprawdza czy przeciwnik jest nadal żywy
    if(hp<=0){
      alive = false;
      return false;
    } else {
      alive = true;
      return true;
    }
  }
  
  public boolean isDead(){  ///sprawdza czy przeciwnik jest nadal żywy
    if(dead) return true;
    else return false;
  }
  
  public int getExp(){
    return expiriencePoints;
  }
  
  public int getLevel(){
    return level;
  }
  
  public void restoreHp(){
    hp = hpMax;
  }
  
  public void setDefault(){  //powrót do ustawień podstawowych
    restoreHp();
    opacity = 255;
    dead = false;
    generateLoot(); 
    itemAdded = false; 
    dodged = false;
    swoon = false;
    swoonTime = 0;
  }
  
  public void setSwoon(int time){
    swoon = true;
    swoonTime = time;
  }
  
  public HitCounter getHitCounter(){
    return hitCounter;
  }
  
  
  ////////////////////////////////////// METODY POMOCNICZE   /////////////////////////////
  
  private void swoonResize(PImage[] swoonImage){
    for(int i = 0; i < swoonImage.length ; i++){
      swoonImage[i].resize(width/4 , 0);
    }
  };
  
  
  
  
  ////////////////////////////////// METODY LOOT  /////////////////////////////////////
  
  private void lootRender(int x , int y, int h){  //Metoda do wyświetlania lootu     //Randomowe tworzy rozsyp wypadających przedmiotów po ekranie
    if(generatedLoot[0]>0) {bamboo.renderOnDrop(x , y , h , generatedLoot[0]); y+=h;}
    if(generatedLoot[1]>0) {wood.renderOnDrop(x , y , h , generatedLoot[1]); y+=h;}
    if(generatedLoot[2]>0) {flowers.renderOnDrop(x , y , h , generatedLoot[2]); y+=h;}
    if(generatedLoot[3]>0) {iron.renderOnDrop(x , y , h , generatedLoot[3]); y+=h;}
    if(generatedLoot[4]>0) {gold.renderOnDrop(x , y , h , generatedLoot[4]); y+=h;}
    if(generatedLoot[5]>0) {supplies.renderOnDrop(x , y , h , generatedLoot[5]); y+=h;}
    if(generatedLoot[6]>0) {linen.renderOnDrop(x , y , h , generatedLoot[6]); y+=h;}
    if(generatedLoot[7]>0) {lether.renderOnDrop(x , y , h , generatedLoot[7]); y+=h;}
    if(generatedLoot[8]>0) {silk.renderOnDrop(x , y , h , generatedLoot[8]); y+=h;}
  }
  
  private int[] generateLoot(){  //Metoda do generowania lootu
   int[] loot = new int[9];
   
   for(int i = 0 ; i < 9 ; i++){
     if(drop[i]!=0 && random(100) < podob[i]){
       loot[i] = int(random(1 , drop[i]));
     } else loot[i]=0;
     
     generatedLoot[i]=loot[i];
   }
   generateLoot = true;
   return loot;
  }
  
  private void addItemToHero(){
    if(generateLoot) {CharacterClass.myHero.addTableStuff(generatedLoot); itemAdded = true;}
    else System.out.println("Enemy->addItemToHero: Loot nie zostal wygenerowany");
  }
  
  
  private void loadItems(){
      generatedLoot = new int[9];
      bamboo   = new Item("Bambus" , 0);
      wood     = new Item("Drewno" , 0);
      flowers  = new Item("Kwiaty" , 0);
      iron     = new Item("Zelazo" ,0);
      gold     = new Item("Zloto" , 0);
      supplies = new Item("Prowiant" , 0);
      linen    = new Item("Len" , 0);
      lether   = new Item("Skora" , 0);
      silk     = new Item("Jedwab" , 0);
  }
  
  
  //system unikania ciosów przeciwnika
  private void dodgeTick(){ //Zawiera Render przycisku uniku, a także jego Tick obsługujący wciśnięcie go
    if(dodgeTime){
      //Wyświetlanie ikony uniku
      image(dodgeImage , dodgeX , dodgeY);
      //Obsługa przycisku unikania ciosu
      if(mousePressed && CD.mouseCollision( dodgeX , dodgeY , dodgeX+dodgeImage.width , dodgeY+dodgeImage.height )){
        dodged = true;
        Magazyn.dodgeSound.play();
        dodgeTime = false;
      }
    }
  }
  
  //Metody dźwięków
  private void playAttackSound(){
    if(breed == 1) Magazyn.wolfSound.play();              //  1 - Wilk
    else if(breed == 2) Magazyn.bearSound.play();         // 2 - Niedźwiedź
    else if(breed == 3) Magazyn.tigerSound.play();        // 3 - Tygrys
    else if(breed == 4) Magazyn.monkeySound.play();       // 4 - Małpa
    else if(breed == 5) Magazyn.demonwolfSound.play();    // 5 - Demoniczny Wilk
    else if(breed == 6) Magazyn.demonSound.play();        // 6 - Demon
    else if(breed == 7) Magazyn.entSound.play();          // 7 - Drzewiec
    else if(breed == 8) Magazyn.frogSound.play();         // 8 - Żabiec
    else if(breed == 9) Magazyn.ghulSound.play();         // 9 - Ghul
    else if(breed == 10) Magazyn.orkSound.play();         // 10 - Ork
    else if(breed == 11) Magazyn.pigmanSound.play();      // 11 - Świniowaty
    else if(breed == 12) Magazyn.bearmanSound.play();      // 12 - Niedźwiedziowaty
    else if(breed == 13){      // 13 - BOSS
      int rand = int(random(1,5));
      switch(rand){
        case 1: Magazyn.bossSound1.play();
          break;
        case 2: Magazyn.bossSound2.play();
          break;
        case 3: Magazyn.bossSound3.play();
          break;
        case 4: Magazyn.bossSound4.play();
          break;
        case 5: Magazyn.bossSound5.play();
          break;
      }
    }
    else Magazyn.wolfSound.play();                    // Default - Wilk
  }
  
  
  //Metoda do animacji ataku przeciwnika
  private void attackAnimationTick(){
    if(!goUp && !goDown && attackSizeMax>=(attackSpeed-attackRunner) && attackSize==0){  //Jeśli liczba klatek do ataku jest taka sama lub mniejsza od animacji
      goUp = true;
      playAttackSound();
    }
    
    if(goUp){  //rośnie!
      attackSize++;
      image.resize(int(width/1.4)+attackSize*15 , 0);
      if(attackSize>=attackSizeMax) {dodgeTime = false; goUp = false; goDown = true;};
    }
    else if(goDown){
      if(attackSize>0) attackSize--;
      else {goUp = false; goDown = false;};
      image.resize(int(width/1.4)+attackSize*15 , 0);
    }
    else{
      System.out.println("Wczytuje grafike przecinika");
      image = loadImage(imgPath);
      image.resize(int(width/1.4) , 0);
    }
  }
  
  
}


/* TO DO LIST



*/
