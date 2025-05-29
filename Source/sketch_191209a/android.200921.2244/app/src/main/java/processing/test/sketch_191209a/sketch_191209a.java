package processing.test.sketch_191209a;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import cassette.audiofiles.SoundFile; 
import java.util.Random; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_191209a extends PApplet {


State menu;
State charSelection;
State exp;
Saver saver;

MusicInterface test;

public void setup(){
  frameRate(60);
  
  noStroke();
  fill(0);
  orientation(PORTRAIT);
  
   MusicInterface.setSketch(this);  //Ustawia obiekt main w MusicInterface
  
  ///Klasy stanów
  menu = new Menu();
  charSelection = new CharSelection();
  exp = new Exp();
  
  
  //Klasa zapisu
  saver = new Saver();
  
  ///State init
  State.setState(menu);  ///Ustawienie stanu początkowego aplikacji (Domyślnie: MENU)
  
  test = new MusicInterface("bgmM1.mp3");
  
  test.play();
}


public void draw(){
  State.activeState.tick();    ///Tick i render aktualnego stanu gry
  State.activeState.render();
  
}
/*
  Klasa pomocnicza do tworzenia animacji.
  Zawiera ona tablice N elementową w obrazkami które są wyświetlane po kolei.

*/

class Animation {
  PImage[] frame; int animLength;
  int actualFrame, runner; //runner to zmianna która wyznacza czas (ilość cykli) do zmiany obrazu
  boolean play;
  
  Animation(PImage images[]){
    frame = images.clone();
    animLength = frame.length;
    actualFrame = 0;
    runner = 0;
    play = true;
  }
  
  public void playAnimation(int x, int y, int time, byte type){    ///Odtwarza animacje (  x/y - koordynaty  ,  time - ilość cykli między zmianą wyświetlanej klatki  ,  type:  0 - jeden cykl animacji  1 - animacja zapętlona)
    if(play){
      switch(type){
        case 0:
          if((runner + time)>animLength * time) play = false;
          image(frame[Math.round(runner/time)] , x, y);
        break;
        
        case 1:
          if((runner + 1)>animLength * time) restartRunner();
          image(frame[Math.round(runner/time)] , x, y);
        break;
        
        default:
          if((runner + 1)>animLength * time) play = false;
          image(frame[Math.round(runner/time)] , x, y);
        break;
      }
      runner++;
      System.out.println(runner);
    }
  
  }
  
  public void restartRunner(){  ///Ustawia runnera na pozycji 0
    runner = 0;
  }
  
  public void setDefaults(){
   runner = 0;
   play = true;
  }
  
  public void stopAnimation(){  ///Zatrzymuje animacje
    play = false;
  }
  
  public void resizeWidth(int w){
     for(int i = 0 ; i < frame.length ; i ++){
       frame[i].resize( w , 0 );
     }
  }
  
  public int getWidth(){
    return frame[0].width;
  }
  
  public int getHeight(){
    return frame[0].height;
  }

}

class Armor {
  
  public PImage image;
  public String name;  ///Nazwa przedmiotu
  private int level;  ///Poziom ulepszenia przedmiotu
  private int def[];  ///Wartości ataku (minimalnego i maksymalnego)
  
  private Animation[] stars;
  
  //Dzwięki
  MusicInterface upgradeSound = new MusicInterface("Sounds/upgradeSound.wav");
  
  Armor( String name , int def[] , String image_path){
    
    this.image = loadImage(image_path);
    this.name = name;
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
  
  public int calcDef(){ ///Metoda losująca i zwracająca atak
    return def[level];
  }
  
  private void resize(){
    image.resize(PApplet.parseInt(width/2.3f) , 0);
  }
  
  public void renderArmor(float x, float y){
    image(image, x, y);
    if(level == 7){
      stars[0].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
    }
    if(level == 8){
      stars[1].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
    }
    if(level == 9){
      stars[2].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
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
      stars[i].resizeWidth(PApplet.parseInt(width/2.3f));
    }
  }
  
  
  public boolean upgradeArmor(){
    if(level<9){
      level++;
      upgradeSound.play();
      return true;
    } else return false;
  }
  
  public int getArmorLevel(){
    return level;
  }
  
}
class CharSelection extends State{
    State exp;
  
    //Obiekty pomocnicze
    CollisionDetector CD;
  
    ///Grafiki
        ///Tło
    PImage iBackground= loadImage("charBg.png");
     
        ///Przyciski
    PImage iPrawo= loadImage("charPrawo.png");
    PImage iLewo= loadImage("charLewo.png");
    PImage iWybierz= loadImage("charWybierz.png");
    
        ///Postacie
            ///Ninja
            PImage iNinjaNapis= loadImage("charNinja.png");
            PImage iNinjaPostac= loadImage("charNinjaObr.png");
            
            ///Ninja
            PImage iWojownikNapis= loadImage("charWojownik.png");
            PImage iWojownikPostac= loadImage("charWojownikObr.png");
            
            ///Ninja
            PImage iSuraNapis= loadImage("charSura.png");
            PImage iSuraPostac= loadImage("charSuraObr.png");
            
            ///Ninja
            PImage iSzamanNapis= loadImage("charSzaman.png");
            PImage iSzamanPostac= loadImage("charSzamanObr.png");
            
    int[] xEkranPostaci; //Tablica zawiera współrzędne X grafik postaci (w celu ustalania która aktualnie jest wyświetlana)
    int yEkranPostaci;
    int aktualnaPostac; //Zmienna zawiera informacje o aktualnej klasie postaci
    /*
       1-wojownik
       2-ninja
       3-sura
       4-szaman
    */
    int yStrzalki; boolean boolPrawo; boolean boolLewo; int licznikPosowL, licznikPosowP; //licznik Posów to zmienna pomocnicza która mówi czy należy przesówać obraz
    int xPrawa, xLewa;
    int xWybierz, yWybierz;
    int predkoscZmianyPostaci=20;
    
    int xNapis, yNapis;
    
    ///Dzwięki wyboru postaci
    MusicInterface btnSound = new MusicInterface("Sounds/insertBtnSound.wav");
    
    
    CharSelection(){  ///Init menu
      init();
      exp = new Exp();
    }
    
    public  void tick(){
      rightArrowEvent();
      leftArrowEvent();
      actualCharacterTick();
      choiceButtonTick();
    };
    
    public void render(){   
      image(iBackground,0,0);
      image(iWojownikPostac,xEkranPostaci[0],yEkranPostaci);
      image(iNinjaPostac,xEkranPostaci[1],yEkranPostaci);
      image(iSuraPostac,xEkranPostaci[2],yEkranPostaci);
      image(iSzamanPostac,xEkranPostaci[3],yEkranPostaci);
      
      if(aktualnaPostac!=4)image(iPrawo, xPrawa,yStrzalki); //Strzałka w prawo działa jeśli aktualnie wyświetlana postać nie jest skrajną od prawej strony
      if(aktualnaPostac!=1)image(iLewo, xLewa,yStrzalki); //Strzałka w lewo działa jeśli aktualnie wyświetlana postać nie jest skrajną od lewej strony
      image(iWybierz, xWybierz, yWybierz);
      
      classNameRender();
    };
    
    public void init(){ ///Metoda init
      mobileResizer();
      CD = new CollisionDetector();
      boolPrawo = false; 
      ///Ustalanie koordynatów
      xEkranPostaci = new int[4];
      for(int i=0; i<4; i++) xEkranPostaci[i] = (width/2-iWojownikPostac.width/2)+(width*i); //Początkowe wypisanie współrzędnych X postaci 
      yEkranPostaci = PApplet.parseInt(height/10)*4;
      
      yStrzalki = height - iLewo.height;
      xLewa = 0 + iLewo.width*2;
      xPrawa = width - iPrawo.width*3;
      
      xWybierz =  width/2 - iWybierz.width/2;
      yWybierz = height-iWybierz.height;
      
      xNapis = width/2 - iWojownikNapis.width/2;
      yNapis = 0;
  }
    
    public void mobileResizer(){ ///Metoda do zmiany rozmiaru grafik w zależności od rozdzielczości ekranu
      iBackground.resize(width,height);
      iWybierz.resize(PApplet.parseInt(width/1.8f),0);
      iNinjaNapis.resize(PApplet.parseInt(width/1.3f),0);
      iWojownikNapis.resize(PApplet.parseInt(width/1.3f),0);
      iSzamanNapis.resize(PApplet.parseInt(width/1.3f),0);
      iSuraNapis.resize(PApplet.parseInt(width/1.3f),0);
      
      iWojownikPostac.resize(PApplet.parseInt(width/2),0);
      iNinjaPostac.resize(PApplet.parseInt(width/2),0);
      iSuraPostac.resize(PApplet.parseInt(width/2),0);
      iSzamanPostac.resize(PApplet.parseInt(width/2),0);
      
      iPrawo.resize(0,iWybierz.height);
      iLewo.resize(0,iWybierz.height);
    }
    
    public void rightArrowEvent(){  ///Obsługa prawej strzałki wyboru postaci
        if(mousePressed && CD.mouseCollision(xPrawa, yStrzalki, xPrawa+iPrawo.width, yStrzalki+iPrawo.height) && aktualnaPostac!=4){  //aktualna postac nie pozwala na wychodzenia poza skrajne postacie
          boolPrawo = true;
          btnSound.play();
        }
        if(licznikPosowP < width && boolPrawo && !boolLewo){ 
          for(int i=0; i<4; i++) {
            xEkranPostaci[i] -=predkoscZmianyPostaci;
          }
          licznikPosowP+=predkoscZmianyPostaci;
        }
        else {
          licznikPosowP =0;
          boolPrawo = false;  
        }
    }
    
    
    
    public void leftArrowEvent(){  ///Obsługa lewej strzałki wyboru postaci
        if(mousePressed && CD.mouseCollision(xLewa, yStrzalki, xLewa+iLewo.width, yStrzalki+iLewo.height) && aktualnaPostac!=1){  //aktualna postac nie pozwala na wychodzenia poza skrajne postacie
          boolLewo = true;
          btnSound.play();
        }
        if(licznikPosowL < width && boolLewo && !boolPrawo){ 
          for(int i=0; i<4; i++) {
            xEkranPostaci[i] +=predkoscZmianyPostaci;
          }
          licznikPosowL+=predkoscZmianyPostaci;
        }
        else {
          licznikPosowL =0;
          boolLewo = false;  
        }
    }
    
    public void actualCharacterTick(){
      for(int i=0; i<4; i++) if(xEkranPostaci[i]>0 && xEkranPostaci[i]<width) aktualnaPostac = i+1;
    }
    
    public void classNameRender(){
      switch(aktualnaPostac){
        case 1:
        image(iWojownikNapis, xNapis, yNapis);
          break;
          
        case 2:
        image(iNinjaNapis, xNapis, yNapis);
          break;
          
        case 3:
        image(iSuraNapis, xNapis, yNapis);
          break;
          
        case 4:
        image(iSzamanNapis, xNapis, yNapis);
          break;
          
        default:
          break;
      }
    }
    
    
    public void choiceButtonTick(){
      if(mousePressed && CD.mouseCollision(xWybierz , yWybierz , xWybierz+iWybierz.width , yWybierz+iWybierz.height)){
        if(aktualnaPostac == 1){ //Wojownik
          CharacterClass.setHero(new Wojownik());
          State.setState(exp);
        }
        if(aktualnaPostac == 2){ //Ninja
          
        }
        if(aktualnaPostac == 3){ //Sura
          CharacterClass.setHero(new Sura());
          State.setState(exp);
        }
        if(aktualnaPostac == 4){ //Szaman
          
        }
      }
    }
    
}


/*      TO DO LIST

Animowane tło               []
Animowane elementy (ognisko)[]
Grafiki przycisków          []
Muzyka                      []

*/
abstract static class CharacterClass{

  public static CharacterClass myHero; ///Metoda zawiera informacje na temat wybranego bohatera
  
  public static void setHero(CharacterClass hero){ ///Metoda pozwala na ustawienie bohatera
    myHero = hero;
  };
  
  
  //###################################################################################################################################//
  
  PImage image;  
  String name;    //Nazwa klasy postaci np. Wojownik
  int level;
  public int maxHealth; //Maksymalna ilość punktów zdrowia
  int standardHealth; float healthBooster; ///standardHealth to podstawowe punkty zdrowia                          healthBooster to mnożnik punktów zdrowia, który pozwala na obliczenie zdrowia w stosunku do aktualnego poziomu i statystyk
  public int maxEnergy; //Maksymalna ilość punktów many
  int standardEnergy; float energyBooster; ///standardEnegry to podstawowe punkty energii                          energyBooster to mnożnik punktów energii, który pozwala na obliczenie many w stosunku do aktualnego poziomu i statystyk
  int standardAttack; float attackBooster; ///standardAttack to obrażenia zadawane przez zwykły "surowy" atak      attackBooster to mnożnik ataku, który pozwala na silniejszy podstawowy atak w zaleqżności od klasy postaci
  int expiriencePoints;  //punkty doświadczenia
  int levelExpirience[];
  int sila,
      inteligencja,
      energia,
      zywotnosc,
      zrecznosc,
      freePoints;  //Punkty do rozdania
  Weapon weapon[];  int actualWeapon;  //weapon[] zawiera możliwą do posiadania broń (od najsłabszej do najsilniejszej)    actualWeapon to index posiadanej broni w tablicy
  Armor armor[];    int actualArmor;  //armor[] zawiera możliwe do posiadania pancerze (od najgorszego do najlepszego)     actualArmor to index posiadanego pancerza w tablicy
  Skill skillsList[];   //Tablica umiejętności postaci (ilośc: 5)
  
  int fluidRunner; //Oblicza czas do dropnięcia fluidów
  Fluid fluidHP , fluidEP;
  
  protected int yang; //Ilość posiadanych monet w grze
  protected int hpFluid, epFluid; //Ilość potków i manasów
  protected int fluidPower; //Określa siłę działąnia miksturek
  protected boolean fluidPressed; //Określa czy akrualnie mamy położony palec na użyciu fluida
  protected int criticalChance;  //procentowa szansa na krytyka
  
  HeroBar healthBar;
  public int actualHealth, healthRegeneration;  //Aktualna ilość punktów zdrowia      Regeneration - prędkość regeneracji jednego punktu zdrowia (ile cykli)
  public int actualEnergy, energyRegeneration;  //Aktualna ilość punktów enegrii
  
  protected int boostHpRegeneration, boostEpRegeneration, boostEp, boostHp;                    ///Zmienne do BOOSTów
  protected int boostHpRegenerationTime, boostEpRegenerationTime, boostEpTime, boostHpTime; //Timery odmierzają czas do zera
  
  protected int newLevelRunner;  //Runner wyświetlania informacji o nowym poziomie
  protected boolean newLevelScreen;  //Jest true jeśli ma wyświetlać informacje o nowym poziomie
  PImage iNewLevel;
  
  ///////////////////////////  Dzwięki  //////////////////////////////////////
  MusicInterface levelUpSound = new MusicInterface("Sounds/newLevelSound.wav");
  
  protected int healthRunner, energyRunner;  //Biegacze wyznaczający czas na regeneracje zdrowia i energii
  abstract protected void checkRegeneration();
  
  public abstract int attack();  //Metoda zwracająca wartość zwykłego ataku (wliczając bonusy , broń podręczną i statystyki )
  public abstract void getDamage(int damage);  //Metoda obliczająca otrzymane obrażenia (wliczając posiadaną obronę i statystyki)
  
  public void healthToMax(){
    actualHealth = maxHealth;
  }
  
  public void energyToMax(){
    actualEnergy = maxEnergy;
  }
  
  public void useHpFluid(){  ///Metoda użycai miksturek uleczających
    if(actualHealth + fluidHP.regenerationValue() >= maxHealth){  //Jeśli spełnia się warunek -> ulecz całkowicie (aby nie spowodować że actualHealth > maxHealth)
      healthToMax();
    }
    else {
      actualHealth += fluidHP.regenerationValue();
    }
    hpFluid--;
  }
  
  public void useEpFluid(){  ///Metoda użycia miksturek many
    if(actualEnergy + fluidEP.regenerationValue() >= maxEnergy){  //Jeśli spełnia się warunek -> odnów mane całkowicie (aby nie spowodować że actualEnergy > maxEnergy)
      energyToMax();
    }
    else {
      actualEnergy += fluidEP.regenerationValue();
    }
    epFluid--;
  }
  
  public void addFluidTick(){
    if(fluidRunner >= 1000){
      hpFluid ++;
      epFluid ++;
      fluidRunner = 0;
    }
    fluidRunner++;
  }
  
  public void addYang(int value){
    if((yang+value) <= MAX_INT) yang += value;
  }
  
  public void removeYang(int value){
    if(yang >= value) yang-=value;
  }
  
  abstract public void showSkillBar(Enemy enemy);
  
  abstract public void tick();
  abstract public void render();
  
  //abstract public void showBar();
  
  public boolean checkDie(){   //Metoda sprawdza czy postać żyje
    if(actualHealth <= 0) return true;
    return false;
    
  }
  
  ///////////////////////////////////////////////////  METODA INICJALIZACJI PUNKTÓW DOŚWIADCZENIA  //////////////////////////////////////////////////
  
  public void expInit(){
    levelExpirience = new int[100];  ///Dostępne 100 poziomów postaci
    
    for(int i = 0 ; i < levelExpirience.length ; i++){  //pętla wpisująca poziomy doświadczenia do następnego poziomu
      levelExpirience[i] = 500 * i;
    }
  }
  
  protected void checkLevel(){  //Metoda sprawdzająca i zwiększająca poziom postaci  
    if(expiriencePoints >= levelExpirience[level-1]){ // level-1 bo zaczynamy tablice od indexu 0 (a startujemy od poziomu 1)
      int surplus = expiriencePoints - levelExpirience[level-1]; //Nazwyżka punktów doświadczenia przechodząca na następny poziom
      levelUp();
      this.expiriencePoints = 0 + surplus;
      freePoints += 3;
      //healthBar.updateLenght();
      
      newLevelRunner = 0;
      newLevelScreen = true;
    }
  }
  
  public void levelUp(){  //Funkcja dodania poziomu
    this.level++;
    healthToMax();  //Regeneruje życie
    energyToMax();  //Regeneruje energie
    hpFluid+=5;    //nowy poziom zapewnia dodanie 5 miksturek życia i many
    epFluid+=5;
    
    levelUpSound.play();  //Dzwięk nowego poziomu
  }
  
  public boolean addPointTo(String attrib){  //Metoda służy do rozdawania wolnych punktów umiejętności
    if(freePoints>0){
      switch(attrib){
        case "sila":
          sila++;
          freePoints--;
          return true;
          
        case "inteligencja":
          inteligencja++;
          freePoints--;
          return true;
          
        case "energia":
          energia++;
          freePoints--;
          return true;
          
        case "zywotnosc":
          zywotnosc++;
          freePoints--;
          return true;
          
        case "zrecznosc":
          zrecznosc++;
          freePoints--;
          return true;
          
        default:
          return false;
      }
    } else return false;
  }
  
  //////////////////////////////////////////////// GETTERY i SETTERY /////////////////////////////////////////
  
  public int getExpToLevel(){
    return levelExpirience[level-1];
  }
  
  public int getExp(){
    return expiriencePoints;
  }
  
  public int getLevel(){
    return level;
  }
  
  public int getYang(){
    return yang;
  }
  
  public void addExp(int exp){
    expiriencePoints += exp;
  }
  
  public Weapon getActualWeapon(){
    return weapon[actualWeapon];
  }
  
  
  public Armor getActualArmor(){
    return armor[actualArmor];
  }
  
  /////////////////////////////////////////////  METODY WYŚWIETLANIA //////////////////////////////////////////

  abstract protected void resizer();

  abstract public void newLevelScreen();
  
  abstract public void renderImage(float x, float y);
  
  ////////////////////////////////////////////  METODY BOOST itp   ////////////////////////////////////////////
  
  protected void checkBoost(){  //Metoda sprawdzajaca czy aktualnie znajdujemy się pod stanem jakiegoś boost-u np. mikstury regeneracji zdrowia
    /*
       int boostHpRegeneration, boostEpRegeneration, boostEp, boostHp;                    ///Zmienne do BOOSTów
       int boostHpRegenerationTime, boostEpRegenerationTime, boostEpTime, boostHpTime;
    */
    
    if(boostHpRegenerationTime>0){  //Sprawdza czy przysługuje nam boost zdrowia
        if((actualHealth - boostHpRegeneration) < maxHealth){
          actualHealth += boostHpRegeneration;
        }
        else if((actualHealth - boostHpRegeneration) >= maxHealth){
          healthToMax();
        }
        boostHpRegenerationTime--;
    }
    
    if(boostEpRegenerationTime>0){  //Sprawdza czy przysługuje nam boost energii
        if((actualEnergy - boostEpRegeneration) < maxEnergy){
          actualEnergy += boostEpRegeneration;
        }
        else if((actualEnergy - boostEpRegeneration) >= maxEnergy){
          energyToMax();
        }
        boostEpRegenerationTime--;
    }
  }

}
/*
  Klasa pomocnicza do wykrywania kolizji:
* mouseCollision - Zwraca true jeśli wykrywa kolizje kursora myszki między podanymi punktami (lewy góry i prawy dolny róg (prostokąt))
*/


public class CollisionDetector{
  
  public boolean mouseCollision(int x_od, int y_od, int x_do, int y_do){
    
    if(  (mouseX>=x_od && mouseX<=x_do)  &&  (mouseY>=y_od && mouseY<=y_do)  )
      return true;
    else return false;
  }
  
  
  
  public boolean mouseCollision(float x_od, float y_od, float x_do, float y_do){
    
    if(  (mouseX>=x_od && mouseX<=x_do)  &&  (mouseY>=y_od && mouseY<=y_do)  )
      return true;
    else return false;
  }
  
}
public class Enemy{
  boolean alive;  ///Czy przeciwnik jest przy życiu?
  boolean dead; ///Czy przeciwnik został zabity?             ->      Różnica między tym a alive jest taka że gdy alive = false, dopóki nie przejdzie przez animację znikania dead = false
  boolean attacked; ///Czy przeciwnik jest atakowany (służy do ochrony przed "multi-hitem")
  
  public PImage image; //Grafika przeciwnika
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
  
  int opacity; //Przeźroczystość wyświetlaniej grafiki przeciwnika (przy śmierci opacity maleje)
  
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
    image.resize(PApplet.parseInt(width/1.4f),0);
    
    xEnemy = PApplet.parseInt(width/2 - image.width/2);
    yEnemy = PApplet.parseInt(height/1.4f - image.height/2);
    CD = new CollisionDetector();
    hitCounter = new HitCounter();
    
    healthBar = new HealthBar(hp, name, level);
    
    alive = true;
    attacked = false;
    
    PImage swoonImage[] = new PImage[]{loadImage("Animacje/Omdlenie/sprite_0.png"),loadImage("Animacje/Omdlenie/sprite_1.png"),loadImage("Animacje/Omdlenie/sprite_2.png"),loadImage("Animacje/Omdlenie/sprite_3.png")};
    swoonResize(swoonImage);
    swoonAnimation = new Animation(swoonImage);
    
    swoon = true;
    swoonTime = 600;
  }
  
  public void tick(CharacterClass hero){
    if(mousePressed && CD.mouseCollision( xEnemy , yEnemy , xEnemy+image.width , yEnemy+image.height ) && !attacked && stillAlive()) {
      getDamage(hero.attack()); 
      attacked=true;
    }
    if(!mousePressed) attacked = false;
    healthBar.tick(hp);    ///Tick paska zdrowia przeciwnika (pobiera punkty HP)
    
    if(stillAlive()) attackTick(hero);
    
    if(swoon && swoonTime>0){
       swoonTime --;
    } else {
      swoonTime=0;
      swoon = false;
    }
  }
  
  public void render(){
    if(!stillAlive())tint(255,opacity);
    image(image, xEnemy, yEnemy);
    noTint();
    healthBar.render();  ///Render paska zdrowia przeciwnika
    if(swoon) swoonAnimation.playAnimation(  width/2 - swoonAnimation.getWidth()/2  ,  yEnemy - swoonAnimation.getHeight()/2 ,  10  ,  PApplet.parseByte(1)  );
    if(stillAlive()){  //Aby nie wyświetlić po śmierci przeciwnika ani klatki zadanych obrażeń
      hitCounter.animateHitRender();
    } else opacity-=10;
    
    if(opacity <= 0 && !alive){
      dead = true;
    }
  }
  
  public void getDamage(int damageValue){ ///Funkcja odpowiada za przyjmowanie obrażeń
    hp -= damageValue;
    hitCounter.newValue(damageValue);
  }
  
  public int attack(){  ///Funkcja odpowiada za atakowanie
    return atk;
  }
  
  public void attackTick(CharacterClass hero){
    if(!swoon && attackRunner>=attackSpeed){
      hero.getDamage(attack());
      attackRunner=0;
    }
    attackRunner++;
  }
  
  public boolean stillAlive(){  ///sprawdza czy przeciwnik jest nadal żywy
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
  
  public void setDefault(){
    restoreHp();
    opacity = 255;
    dead = false;
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
  
  
}


/* TO DO LIST



*/

class Exp extends State{
  
  PImage iLewo= loadImage("charLewo.png"); 
  PImage iInv = loadImage("expStats.png");
  Random rand;
  private boolean backEnemy; int xLewo, yLewo;
  
  CollisionDetector CD;
  Map actualMap = null; //Aktualnie rozgrywana mapa
  int actualEnemy = 0;
  Map M1;  
  
  //MusicInterface MI;
  
  Exp(){
    init();
    CD = new CollisionDetector();
    rand = new Random();
    backEnemy = false;
    iLewo.resize(0 , height/13);   xLewo = 0;   yLewo = height / 2 - iLewo.height/2;
    iInv.resize(width/8 , 0);
    
    //MI = new MusicInterface("bgmM1.mp3");
    //MI.play();
  } 
  
  public void tick(){
    actualMap.tick(); 
    CharacterClass.myHero.tick();
    actualMap.getActualEnemy().tick(CharacterClass.myHero);
    backHero();
    
    if(actualMap.getEnemyNumber() > 0 && !backEnemy && mousePressed && CD.mouseCollision( xLewo , yLewo , xLewo + iLewo.width , yLewo + iLewo.height )){  //przycisk strzałki w lewo (cofania przeciwnika)
       actualMap.backEnemy(rand.nextInt(2)+1);
       backEnemy = true;
    }
    
    if(!mousePressed) backEnemy = false;
    if(mousePressed && CD.mouseCollision(width/30, height/22, width/30 + iInv.width , height/22 + iInv.height)){
      State inventory = new Inventory();
      State.setState(inventory);
    }
  }
  
  public void render(){
    actualMap.render();
    CharacterClass.myHero.showSkillBar(actualMap.getActualEnemy());
    for(int i = 0 ; i < 5 ; i++)CharacterClass.myHero.skillsList[i].render();
    CharacterClass.myHero.skillsList[3].levelUp();
    CharacterClass.myHero.healthBar.render();
    CharacterClass.myHero.render();
    
    if(actualMap.getEnemyNumber() > 0) image(iLewo, xLewo , yLewo); //Strzałka cofania przeciwnika o jeden lub dwa
    image(iInv , width/30 , height/22);
  }
  
  
  public void backHero(){  ///Metoda sprawdzająca i cofająca postać po śmierci o trzech przeciwników do tyłu
    if(CharacterClass.myHero.checkDie()){
      actualMap.backEnemy(3);
      CharacterClass.myHero.healthToMax();
      CharacterClass.myHero.energyToMax();
    }
  }
  
  public void init(){
    
    Enemy listaTest[] = new Enemy[50];
  listaTest[0] = new Enemy("Glodny_Zablakany_Pies.png", "Glodny Zablakany Pies", 1, 4, 100, 80, 10, 10);
  listaTest[1] = new Enemy("Dziki_Pies.png", "Dziki Pies", 1, 5, 90, 90, 10, 13);
  listaTest[2] = new Enemy("Glodny_Wilk.png", "Glodny Wilk", 2, 7, 100, 120, 10, 18);
  listaTest[3] = new Enemy("Wilk.png", "Wilk", 2, 11, 100, 70, 120, 21);
  listaTest[4] = new Enemy("Alfa_Wilk.png", "Alfa Wilk", 2, 13, 100, 90, 140, 21);
  listaTest[5] = new Enemy("Glodny_Alfa_Wilk.png", "Glodny Alfa Wilk", 2, 15, 100, 100, 140, 24);
  listaTest[6] = new Enemy("Nieb._Wilk.png", "Nieb. Wilk", 3, 18, 100, 150, 10, 26);
  listaTest[7] = new Enemy("Glodny_Nieb._Wilk.png", "Glodny Nieb. Wilk", 3, 20, 100, 160, 120, 26);
  listaTest[8] = new Enemy("Glodny_Dzik.png", "Glodny Dzik", 3, 21, 100, 180, 10, 31);
  listaTest[9] = new Enemy("Dzik.png", "Dzik", 4, 27, 100, 180, 10, 31);
  listaTest[10] = new Enemy("Przeklety_Wilk.png", "Przeklety Wilk", 4, 29, 100, 190, 10, 30);
  listaTest[11] = new Enemy("Nieb._Alfa_Wilk.png", "Nieb. Alfa Wilk", 4, 31, 100, 220, 10, 36);
  listaTest[12] = new Enemy("Glodny_Nieb._Alfa_Wilk.png", "Glodny Nieb. Alfa Wilk", 5, 33, 100, 240, 10, 38);
  listaTest[13] = new Enemy("Przeklety_Alfa_Wilk.png", "Przeklety Alfa Wilk", 5, 36, 100, 260, 10, 30);
  listaTest[14] = new Enemy("Glodny_Czerw._Dzik.png", "Glodny Czerw. Dzik", 5, 39, 100, 290, 10, 30);
  listaTest[15] = new Enemy("Czerw._Dzik.png", "Czerw. Dzik", 5, 40, 100, 310, 10, 30);
  listaTest[16] = new Enemy("Przeklety_Nieb._Wilk.png", "Przeklety Nieb. Wilk", 5, 41, 100, 310, 10, 35);
  listaTest[17] = new Enemy("Niedzwiedz.png", "Niedzwiedz", 6, 44, 100, 320, 10, 40);
  listaTest[18] = new Enemy("Glodny_Niedzw.png", "Glodny Niedzw.", 6, 47, 100, 340, 10, 42);
  listaTest[19] = new Enemy("Szary_Wilk.png", "Szary Wilk", 6, 50, 100, 350, 10, 44);
  listaTest[20] = new Enemy("Glodny_Szary_Wilk.png", "Glodny Szary Wilk", 6, 54, 100, 360, 10, 44);
  listaTest[21] = new Enemy("Przekl._Nieb._Alfa_Wilk.png", "Przekl. Nieb. Alfa Wilk", 6, 56, 100, 370, 10, 47);
  listaTest[22] = new Enemy("Niedzw._Grizzly.png", "Niedzw. Grizzly", 6, 60, 100, 370, 10, 47);
  listaTest[23] = new Enemy("Glodny_Niedzw._Grizzly.png", "Glodny Niedzw. Grizzly", 7, 64, 100, 380, 10, 49);
  listaTest[24] = new Enemy("Przeklety_Czerw._Dzik.png", "Przeklety Czerw. Dzik", 7, 66, 100, 390, 10, 50);
  listaTest[25] = new Enemy("Szary_Alfa_Wilk.png", "Szary Alfa Wilk", 7, 68, 100, 390, 10, 50);
  listaTest[26] = new Enemy("Glodny_Szary_Alfa_Wilk.png", "Glodny Szary Alfa Wilk", 7, 70, 100, 390, 10, 50);
  listaTest[27] = new Enemy("Przeklety_Niedzw.png", "Przeklety Niedzw.", 8, 71, 100, 410, 10, 50);
  listaTest[28] = new Enemy("Glodny_Tygrys.png", "Glodny Tygrys", 8, 74, 100, 440, 10, 50);
  listaTest[29] = new Enemy("Tygrys.png", "Tygrys", 8, 76, 100, 460, 10, 50);
  listaTest[30] = new Enemy("Glodny_Czar._Niedzw.png", "Glodny Czar. Niedzw.", 8, 78, 100, 460, 10, 60);
  listaTest[31] = new Enemy("Czar._Niedzw.png", "Czar. Niedzw.", 8, 80, 100, 460, 10, 60);
  listaTest[32] = new Enemy("Przekl._Niedzw._Grizzly.png", "Przekl. Niedzw. Grizzly", 9, 84, 100, 490, 10, 60);
  listaTest[33] = new Enemy("Braz._Niedzw.png", "Braz. Niedzw.", 9, 87, 100, 490, 10, 60);
  listaTest[34] = new Enemy("Glodny_Braz._Niedzw.png", "Glodny Braz. Niedzw.", 9, 89, 60, 530, 10, 50);
  listaTest[35] = new Enemy("Przeklety_Szary_Alfa_Wilk.png", "Przeklety Szary Alfa Wilk", 9, 93, 90, 570, 10, 60);
  listaTest[36] = new Enemy("Slaby_Malpi_Zolnierz.png", "Slaby Malpi Zolnierz", 10, 42, 35, 40, 570, 70);
  listaTest[37] = new Enemy("Bialy_Tygrys.png", "Bialy Tygrys", 10, 120, 100, 590, 10, 80);
  listaTest[38] = new Enemy("Glodny_Bialy_Tygrys.png", "Glodny Bialy Tygrys", 10, 146, 100, 610, 10, 90);
  listaTest[39] = new Enemy("Przeklety_Czar._Niedzw.png", "Przeklety Czar. Niedzw.", 10, 154, 100, 610, 10, 90);
  listaTest[40] = new Enemy("Przeklety_Tygrys.png", "Przeklety Tygrys", 11, 168, 100, 660, 10, 90);
  listaTest[41] = new Enemy("Slaby_Malpi_Miotacz.png", "Slaby Malpi Miotacz", 11, 113, 48, 640, 10, 100);
    for(int i=42; i<50; i++) listaTest[i] = new Enemy("Przeklety_Tygrys.png", "Przeklety Tygrys", 12, 180, 100, 710, 10, 120);
    M1 = new Map("expBg.png",1,listaTest);
    actualMap = M1;
  }
  
  
}
class Fluid{

  private PImage image, image2, image3;
  private PImage actualImage;
  private PFont font2;
  private int xFont, yFont;
  public int xImage, yImage;
  
  private int level;
  private int basicRegeneration;
  
  Fluid(String type){
    basicRegeneration = 100;
    level = 1;
    
    if(type == "HP"){
      image = loadImage("hpFluid.png");
      image2 = loadImage("hpFluid2.png");
      image3 = loadImage("hpFluid3.png");
    }
    if(type == "EP"){
      image = loadImage("epFluid.png");
      image2 = loadImage("epFluid2.png");
      image3 = loadImage("epFluid3.png");
    }
    resizer();
    initFont();
    setActualImage();
  }
  
  public void showFluid(int x, int y, int quantity){
    xImage = x; yImage = y;
    image( actualImage , x , y );  //Wyświetla obraz fluida
    textFont(font2);
    fill(255);
    text( quantity   ,   x + image.width/2   ,   yFont + y + image.height );  //Qyświetlanie tekstu z ilością fluidów
  }
  
  private void resizer(){
    image.resize(width/5 , 0);
    image2.resize(width/5 , 0);
    image3.resize(width/5 , 0);
  }
  
  private void initFont(){
    font2 = createFont("font.ttf",width/12);
  }
  
  /////////////////////////////////////////    GETTERY / SETTERY    ///////////////////////////
  
  public int getWidth(){
    return image.width;
  }
  
  public int getHeight(){
    return image.height;
  }
  
  public int getX(){
    return xImage;
  }
  
  public int getY(){
    return yImage;
  }
  
  public int getLevel(){
    return level;
  }
  
  
  /////////////////////////////////////////    METODY OBLICZANIA    ///////////////////////////
  
  public int regenerationValue(){
    int value = Math.round((basicRegeneration + (level * 2)) * (level/10.0f + 1));  /// Oblicza ilość dodawanych punktów 
    return value;
  }
  
  public void setActualImage(){
    if(level < 10) actualImage = image;
    if(level >= 10 && level<20) actualImage = image2;
    if(level >= 20) actualImage = image3;
  }
  
}
 class HealthBar {

  private int actualHealth, maxHealth;  ///actualHealth - aktualny stan zdrowia      maxHealth - maksymalna ilosc punktow zdrowia
  private String name; int level;  ///name - nazwa postaci    level - poziom postaci (wyswietlany obok nazwy)
  
  private float singleBarLenght, actualBarLenght, maxBarLenght = width/2.2f; int barHeight = PApplet.parseInt(height/60); ///Wymiary paska zdrowia
  private float singleCircleValue, actualCircleValue, maxCircleValue = 2*PI;
  private int xFrame = 0, yFrame = 0, widthFrame = width, heightFrame = PApplet.parseInt(height/23);
  private int xBar = PApplet.parseInt(width/2), yBar = PApplet.parseInt(heightFrame/2 - barHeight/2);
  private int xFont, yFont; PFont font;
  
  private PImage circle;
  private PGraphics maskaImage; private int maskaWymiar = width/5;
  
  HealthBar(int aH, int mH, String name, int lv){  ///Konstruktor 1
    actualHealth = aH;
    maxHealth = mH;
    this.name = name;
    level = lv;
    singleBarLenght = maxBarLenght / maxHealth;
    singleCircleValue = maxCircleValue / maxHealth;
    
    font = createFont("font.ttf", PApplet.parseInt(barHeight/1.7f));
    textFont(font); 
    xFont = PApplet.parseInt(width/20);
    yFont =  PApplet.parseInt(heightFrame/2);
    
    circle = loadImage("enemyHpCircle.png");
    maskaImage = createGraphics(maskaWymiar,maskaWymiar);
    maskaImage.beginDraw();
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0,  2*PI, PIE);
    maskaImage.endDraw();
    circle.resize(maskaWymiar,maskaWymiar);
  }
  
  HealthBar(int mH, String name, int lv){  ///Konstruktor 2
    maxHealth = mH;
    actualHealth = mH;
    this.name = name;
    level = lv;
    singleBarLenght = maxBarLenght / maxHealth;
    singleCircleValue = maxCircleValue / maxHealth;
    
    font = createFont("font.ttf", PApplet.parseInt(barHeight/1.7f)); 
    xFont = PApplet.parseInt(width/20);
    yFont = PApplet.parseInt(heightFrame/2);
    circle = loadImage("enemyHpCircle.png");
    maskaImage = createGraphics(maskaWymiar,maskaWymiar);
    
    maskaImage.beginDraw();
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0, 2*PI, PIE);
    maskaImage.endDraw();
    circle.resize(maskaWymiar,maskaWymiar);
  }
  
  public void tick(int HP){
    updateHP(HP);
    actualBarLenght = singleBarLenght * actualHealth;
    actualCircleValue = singleCircleValue * actualHealth;
    
    
    maskaImage.loadPixels(); 
    for(int i=0; i<maskaImage.pixels.length; i++) {
      maskaImage.pixels[i] = 0;
    }
    maskaImage.updatePixels();
    
    maskaImage.beginDraw();
    maskaImage.fill(255);
    maskaImage.arc(maskaWymiar/2, maskaWymiar/2, maskaWymiar, maskaWymiar, 0, actualCircleValue, PIE);
    maskaImage.endDraw();
  }
  
  
  public void render(){
    /*fill(66,64,64); ///KOLOR SZARY
    rect( 0 , 0 , widthFrame, heightFrame); ///Wymiary ramki HP
    fill(58,58,56); ///KOLOR PRAWIE CZARNY
    rect( xBar , yBar , maxBarLenght, barHeight); ///Wymiary ramki HP
    fill(213,8,32); ///KOLOR CZERWONY
    rect( xBar , yBar , actualBarLenght, barHeight); ///Wymiary aktualnego HP
    fill( 255 , 255 , 255 );
    textFont(font);
    text(name, xFont, yFont);*/
    
    circle.mask(minAlphas(circle,maskaImage));
    image(circle, width/2-maskaWymiar/2, height/2-maskaWymiar/2); 
    //image(maskaImage, width/2-maskaWymiar/2, height/2-maskaWymiar/2);
  }
  
  public void updateHP(int HP){
    if(HP>=0) actualHealth = HP;
    else actualHealth = 0;
  }
  
  
  
  
  
  
  
  
  public int[] minAlphas(PImage img, PImage img2) {
    img.loadPixels();
    img2.loadPixels();
    int[] a = new int[img.pixels.length];
    for (int i =0; i<img.pixels.length; i++) {
      a[i] = min(img.pixels[i] >> 24 & 0xFF, img2.pixels[i] >> 24 & 0xFF);
    }
    return a;
  }


}

/* TO DO
  wyświetlanie nazwy przeciwnika    []
*/
class HeroBar {

  private int actualHealth, maxHealth;  ///actualHealth - aktualny stan zdrowia      maxHealth - maksymalna ilosc punktow zdrowia
  private int actualEnergy, maxEnergy;  ///actualEnergy - aktualny stan energii      maxEnergy - maksymalna ilosc punktow many
  private int actualExp, maxExp;  ///actualExp - aktualny stan expa      maxExp - maksymalna ilosc punktow doswiadczenia
  
  
  private float singleHpLenght, actualHpLenght, maxHpLenght = width - (width/8.0f) * 5; int barHeight = PApplet.parseInt(width/8)/5; ///Wymiary paska zdrowia
  private float singleEpLenght, actualEpLenght, maxEpLenght = width - (width/8.0f) * 5; ///Wymiary paska energii
  private float singleExpLenght, actualExpLenght, maxExpLenght = width - (width/8.0f) * 5; ///Wymiary paska doświadczenia
  
  PGraphics maska, circleHp;
  private float singleHpHeight, maxHpHeight = width/2.8f;
  private float heroSkillWidth = (width/3)*2;
  
  //Grafiki HUD
  PImage heroExp, heroExpFrame, heroExpBg;
  PImage heroHp, heroHpFrame;              PImage heroHpBufor;
  PImage heroFluidCircle, heroFluidIcon;
  PImage heroSkillBar, heroHudThing;
  
  private void loadHudImage(){
    heroExp = loadImage("HUD/heroExp.png");
    heroExpFrame = new PImage();
    heroExpBg = loadImage("HUD/heroExpBg.png");
    heroHp = loadImage("HUD/heroHp.png");
    heroHpBufor = loadImage("HUD/heroHp.png");
    heroHpFrame = loadImage("HUD/heroHpFrame.png");
    heroFluidCircle = loadImage("HUD/heroFluidCircle.png");
    heroFluidIcon = loadImage("HUD/heroFluidIcon.png");
    heroSkillBar = loadImage("HUD/heroSkillBar.png");
    heroHudThing = loadImage("HUD/heroHudThing.png");
   
    
    heroHp.resize(PApplet.parseInt(maxHpHeight), PApplet.parseInt(maxHpHeight));
    heroHpBufor.resize(PApplet.parseInt(maxHpHeight), PApplet.parseInt(maxHpHeight));
    heroHpFrame.resize(PApplet.parseInt(maxHpHeight), PApplet.parseInt(maxHpHeight)); 
  }
  
  
  private int xHpBar = (width/8) * 5, 
              yHpBar = height-(width/8), 
              xEpBar = xHpBar,
              yEpBar = yHpBar + ((width/8)/5)*2,
              xExpBar = xHpBar,
              yExpBar = yHpBar + ((width/8)/5)*4;
  
  HeroBar(int mH, int mE, int mExp){  ///Konstruktor
    actualHealth = mH;    maxHealth = mH;
    actualEnergy = mE;    maxEnergy = mE;
    maxExp = mExp;
    
    singleHpLenght = maxHpLenght / maxHealth;
    singleEpLenght = maxEpLenght / maxEnergy;
    singleExpLenght = maxExpLenght / maxExp;
    
    circleHp = createGraphics(PApplet.parseInt(maxHpHeight), PApplet.parseInt(maxHpHeight));
    maska = createGraphics(PApplet.parseInt(maxHpHeight), PApplet.parseInt(maxHpHeight));
    
    circleHp.beginDraw();
    circleHp.fill(178, 34, 34);
    circleHp.circle((maxHpHeight)/2,(maxHpHeight)/2,maxHpHeight);
    circleHp.endDraw();
    
    maska.beginDraw();
    fill(255);
    maska.rect(0,0,maxHpHeight,maxHpHeight);
    maska.endDraw();
    singleHpHeight = maxHpHeight / maxHealth;
    
    loadHudImage();
  }
  
  
  ///////////////////////////////////////////    METODY    /////////////////////////////////////////////
  
  
  public void tick(){
    //updateLenght();
    updateHP();
    updateEP();
    updateEXP();
    actualHpLenght = singleHpLenght * actualHealth;
    actualEpLenght = singleEpLenght * actualEnergy;
    actualExpLenght = singleExpLenght * actualExp;
    
    /*System.out.println("maxPasek = "  +  maxHpLenght);
    System.out.println("pasekHP = "  +  singleHpLenght * maxHealth);
    System.out.println("pasekEP = "  +  singleEpLenght * maxEnergy);
    System.out.println("pasekEXP = " +  singleExpLenght * maxExp + "    |    actualExp = " + actualExpLenght);*/
    
    

    
    clearMask(); //Czyszczenie maski aby narysować nową
    maska.beginDraw();
    maska.rect(0,0,maxHpHeight,singleHpHeight*actualHealth);
    maska.endDraw();
    singleHpHeight = maxHpHeight / maxHealth;
    
    heroHpBufor = heroHp;
    
    heroHpBufor.mask(maska);  //Tak jak myślałem... "Maska zżera obrazek mimo że później sama się regeneruje"
  }
  
  
  public void render(){
    //fill(58,58,56); ///KOLOR PRAWIE CZARNY
    //rect( xHpBar , yHpBar , maxHpLenght, barHeight*5); ///Wymiary ramki pod ramką Hp i Ep
    //fill(213,8,32); ///KOLOR CZERWONY pod Hp
    //rect( xHpBar , yHpBar , actualHpLenght, barHeight*2); ///Wymiary aktualnego HP
    //fill( 49 , 81 , 199 ); ///KOLOR NIEBIESKI pod Ep
    //rect( xEpBar , yEpBar , actualEpLenght, barHeight*2); ///Wymiary aktualnego HP
    //fill( 237 , 204 , 24 ); ///KOLOR ZŁOTY pod Exp
    //rect( xExpBar , yExpBar , actualExpLenght, barHeight); ///Wymiary aktualnego HP
    
    
    image(heroHpBufor, 0, 0);
    image(heroHpFrame, 0, 0);
    //image(maska,0,0);
    //image(maska, 0, 0); 
  }
  
  public void updateHP(){  ///Metoda pobiera i aktualizuje wartość punktów życia z klasy aktualnego bohatera
    //maxHealth = CharacterClass.myHero.maxHealth;
    actualHealth = CharacterClass.myHero.actualHealth;
    if(actualHealth<0) actualHealth=0;
  }
  
  public void updateEP(){ ///Metoda pobiera i aktualizuje wartość punktów energii z klasy aktualnego bohatera
    //maxEnergy = CharacterClass.myHero.maxEnergy;
    actualEnergy = CharacterClass.myHero.actualEnergy;
    if(actualEnergy<0) actualEnergy=0;
  }
  
  public void updateEXP(){ ///Metoda pobiera i aktualizuje wartość punktów doświadczenia z klasy aktualnego bohatera
    //maxExp = CharacterClass.myHero.getExpToLevel();
    actualExp = CharacterClass.myHero.getExp();
    if(actualExp<0) actualExp=0;
    //System.out.println(actualExp);
  }
  
  public void updateLenght(){
    maxHealth = CharacterClass.myHero.maxHealth;
    maxEnergy = CharacterClass.myHero.maxEnergy;
    maxExp = CharacterClass.myHero.getExpToLevel();
    
    singleHpLenght = maxHpLenght / maxHealth;
    singleEpLenght = maxEpLenght / maxEnergy;
    singleExpLenght = maxExpLenght / maxExp;
  }
  
  
  
  
  
  
  public int[] minAlphas(PImage img, PImage img2) {
    img.loadPixels();
    img2.loadPixels();
    int[] a = new int[img.pixels.length];
    for (int i =0; i<img.pixels.length; i++) {
      a[i] = min(img.pixels[i] >> 24 & 0xFF, img2.pixels[i] >> 24 & 0xFF);
    }
    return a;
  }
  
  
  public void clearMask(){
    maska.loadPixels(); 
    for(int i=0; i<maska.pixels.length; i++) {
      maska.pixels[i] = 0;
    }
    maska.updatePixels();
  }
  
  
  

}
class HitCounter{
  
  float startowaWielkoscTekstu = width/20 ;  //wielkość czcionki wyśw. damage
  float finalowaWielkoscTekstu = width/15;  //wielkość czcionki wyśw. damage
  float aktualnaWielkoscTekstu;  //wielkość czcionki wyśw. damage
  PFont fontHit;
  
  private int hitValue;
  private boolean freshValue; //zawiera info na temat tego, czy nie padł nowy cios (jeśli tak to przybiera wartość true)
  private boolean endHit; //zawiera informacjeo tym, czy animacja ostatniego ciosu została zakończona
  
  private float actualX, actualY;
  private int actualRouteLocation;
  private int routeLength = PApplet.parseInt(height/4);
  
  private int tintValue;
  
  HitCounter(int hitValue){
    this.hitValue = hitValue;
    endHit = false;
    actualRouteLocation=0;
    tintValue = 255;
  }
  
  HitCounter(){
    endHit = true;
    actualRouteLocation=0;
    tintValue = 255;
  }
  
  
  //////////////////////////     METODA WYŚWIETLANIA WARTOŚCI CIOSU    ////////////////////////////////////
  
  public void animateHitRender(){  //Funkcja animuje zadane obrażernia i zwraca true jeśli animacja posiada następny krok  /  Zwraca false jeśli animacja została zakończona
    if(!endHit){
      //TUTAJ RYSUJ PUNKTY DAMAGE
      if(aktualnaWielkoscTekstu < finalowaWielkoscTekstu) aktualnaWielkoscTekstu+=10;
      if(routeLength - actualRouteLocation <= 100) tintValue -= 20;
      
      fontHit = createFont("font.ttf",aktualnaWielkoscTekstu);
      //tint(255,tintValue);
      textFont(fontHit);  //ustawiam czcionkę
      fill( 255 , 221 , 60 , tintValue );  //ustawiam kolor
      text( hitValue   ,   actualX   ,   actualY );  //Wyświetlam tekst z liczbą zadanych obrażeń
      //noTint();
      
      if(actualRouteLocation < routeLength){
         actualY -=15;
         if(routeLength % 2 == 0) actualX +=7;
         actualRouteLocation+=15; //Zwiększenie licznika actualRoute
      }
      else endHit = true;
    }
  }
  
  
  
  public void newValue(int value){
    hitValue = value;  //Przypisanie warości ciosu do zmiennej
    freshValue = true;  //Informacja o nowym ciosie
    endHit = false;
    
    actualX = width/2;  //Początkowe współrzędne tekstu
    actualY = height/2;
    
    actualRouteLocation = 0;
    tintValue = 255;
    aktualnaWielkoscTekstu = startowaWielkoscTekstu;
  }
  
  public void stop(){
    endHit = true;
  }
  
  
}
class Inventory extends State{

  PImage tlo = loadImage("invBg.png") , charSlot = loadImage("invCharSlot.png"); 
  PImage iUpgrade = loadImage("invUpgrade.png") , iArmor = loadImage("invArmor.png") , iWeapon = loadImage("invWeapon.png"); 
  PImage iPlus = loadImage("invPlus.png") , iExit = loadImage("invExit.png"); 
  
  float charSlotX, charSlotY;
  float iWeaponX, iWeaponY;
  float iArmorX, iArmorY;
  float iUpgradeArmorX, iUpgradeArmorY;
  float iUpgradeWeaponX, iUpgradeWeaponY;
  float characterX, characterY;
  float iExitX, iExitY;
  
  CollisionDetector CD;
  private boolean upgradeWeapon, upgradeArmor, addAtrib;  ///Metody sprawdzające i blokujące multi upgrade przedmiotów      addAtrib - blokada na dodawanie atrybutu
  
  PFont fontInv = createFont("font.ttf",width/24);
  
  float statsBtnX = width - width/8;
  float silaY = height/2,
        inteligencjaY = silaY + height/15,
        energiaY = inteligencjaY + height/15,
        zywotnoscY = energiaY + height/15,
        zrecznoscY = zywotnoscY + height/15,
        freePointsY = zrecznoscY + height/15,
        yangValueY = freePointsY + height/15 + height/15;
        
  float silaBtnY = silaY - iPlus.height*1.2f,
        inteligencjaBtnY = silaBtnY + height/15,
        energiaBtnY = inteligencjaBtnY + height/15,
        zywotnoscBtnY = energiaBtnY + height/15,
        zrecznoscBtnY = zywotnoscBtnY + height/15;
        
        //Dzwięki przycisków
    MusicInterface insertBtnSound = new MusicInterface("Sounds/insertBtnSound.wav"); 
    MusicInterface addBtnSound = new MusicInterface("Sounds/addBtnSound.wav"); 
    MusicInterface newWeaponSound = new MusicInterface("Sounds/newWeaponSound.wav"); 
    MusicInterface newArmorSound = new MusicInterface("Sounds/newArmorSound.wav"); 
    MusicInterface failSound = new MusicInterface("Sounds/upgradeFailSound.wav"); 
        
  Inventory(){
    resizer();
    setPosition();
    
    upgradeWeapon = false; upgradeArmor = false;
    CD = new CollisionDetector();
  }


  /////////////////////////////////////////////  TICK i RENDER  //////////////////////////////////////////
  
  public void tick(){
    if(!upgradeWeapon && mousePressed && CD.mouseCollision(iUpgradeWeaponX , iUpgradeWeaponY , iUpgradeWeaponX+iUpgrade.width , iUpgradeWeaponY+iUpgrade.height)){
      upgradeWeapon();
      upgradeWeapon = true;
    }
    
    if(!upgradeArmor && mousePressed && CD.mouseCollision(iUpgradeArmorX , iUpgradeArmorY , iUpgradeArmorX+iUpgrade.width , iUpgradeArmorY+iUpgrade.height)){
      upgradeArmor();
      upgradeArmor = true;
    }
    
    tickStats();
    
    if(!mousePressed){
      upgradeWeapon = false;
      upgradeArmor = false;
      addAtrib = false;
    }
    
    if(mousePressed && CD.mouseCollision(iExitX, iExitY, iExitX+iExit.width , iExitY+iExit.height)){
      State.setBeforeState();
      insertBtnSound.play();
    }
  }
  
  public void render(){
    image(tlo, 0, 0);
    renderCharacter();
    image(iArmor, iArmorX, iArmorY);
    image(iWeapon, iWeaponX, iWeaponY);
    
    image(iUpgrade, iUpgradeWeaponX, iUpgradeWeaponY);
    image(iUpgrade, iUpgradeArmorX, iUpgradeArmorY);
    
    image(iExit, iExitX, iExitY);
    
    renderStats();
  }
  
  
  ///////////////////////////////////////  METODY WYSWIETLANIA  //////////////////////////////////////////
  
  private void resizer(){
    int buttonWidth = width/10;
    tlo.resize(width , height);
    charSlot.resize(PApplet.parseInt(width/2) , 0);
    
    iUpgrade.resize(buttonWidth , 0);
    iArmor.resize(buttonWidth , 0);
    iWeapon.resize(buttonWidth , 0);
    iPlus.resize(width/20 , 0);
    iExit.resize(buttonWidth , 0);
  }
  
  private void setPosition(){
    charSlotX = width/2 - charSlot.width/2;
    charSlotY = height/6;
    
    iWeaponX = charSlotX - iWeapon.width;
    iWeaponY = charSlotY + iWeapon.width / 2;
    
    iArmorX = charSlotX + charSlot.width;
    iArmorY = iWeaponY;
    
    iUpgradeArmorX = iArmorX;
    iUpgradeArmorY = iArmorY + iArmor.height * 1.5f;
    
    iUpgradeWeaponX = iWeaponX;
    iUpgradeWeaponY = iWeaponY + iWeapon.height * 1.5f;
    
    characterX = width/2 - PApplet.parseInt(width/2.3f)/2;
    characterY = (charSlotY + charSlot.height/2) - PApplet.parseInt(width/2.3f)/2;
    
    iExitX = width - iExit.width;
    iExitY = 0;
  }
  
  private void renderCharacter(){
    image(charSlot, charSlotX, charSlotY);
    CharacterClass.myHero.renderImage(characterX, characterY );
    CharacterClass.myHero.getActualArmor().renderArmor(characterX, characterY);
    CharacterClass.myHero.getActualWeapon().renderWeapon(characterX, characterY);
  }
  
  private void renderStats(){
    textFont(fontInv);
    
    fill(255);
    text( "Yang:"   ,   width/10   ,   yangValueY );  //Nazwa Atrybutu
    text( CharacterClass.myHero.getYang()   ,   width - width/5   ,   yangValueY );  //Ilość Atrybutu
    
    fill(255);
    text( "SILA"   ,   width/9   ,   silaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.sila   ,   width/2   ,   silaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , silaBtnY);
    
    fill(255);
    text( "INTELIGENCJA"   ,   width/9   ,   inteligencjaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.inteligencja   ,   width/2   ,   inteligencjaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , inteligencjaBtnY);
    
    fill(255);
    text( "ENERGIA"   ,   width/9   ,   energiaY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.energia   ,   width/2   ,   energiaY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , energiaBtnY);
    
    fill(255);
    text( "ZYWOTNOSC"   ,   width/9   ,   zywotnoscY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.zywotnosc   ,   width/2   ,   zywotnoscY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , zywotnoscBtnY);
    
    fill(255);
    text( "ZRECZNOSC"   ,   width/9   ,   zrecznoscY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.zrecznosc   ,   width/2   ,   zrecznoscY );  //Ilość Atrybutu
    image(iPlus, statsBtnX , zrecznoscBtnY);
    
    fill(255);
    text( "PUNKTY DO ROZDANIA"   ,   width/8   ,   freePointsY );  //Nazwa Atrybutu
    fill( 49 , 81 , 199 );
    text( CharacterClass.myHero.freePoints   ,   width - width/4   ,   freePointsY );  //Ilość Atrybutu
  }
  
  private void tickStats(){
    if(!addAtrib && mousePressed && CD.mouseCollision(statsBtnX , silaBtnY , statsBtnX+iPlus.width , silaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("sila");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!addAtrib && mousePressed && CD.mouseCollision(statsBtnX , inteligencjaBtnY , statsBtnX+iPlus.width , inteligencjaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("inteligencja");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!addAtrib && mousePressed && CD.mouseCollision(statsBtnX , energiaBtnY , statsBtnX+iPlus.width , energiaBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("energia");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!addAtrib && mousePressed && CD.mouseCollision(statsBtnX , zywotnoscBtnY , statsBtnX+iPlus.width , zywotnoscBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("zywotnosc");
      addAtrib = true;
      addBtnSound.play();
    }
    if(!addAtrib && mousePressed && CD.mouseCollision(statsBtnX , zrecznoscBtnY , statsBtnX+iPlus.width , zrecznoscBtnY+iPlus.height)){
      CharacterClass.myHero.addPointTo("zrecznosc");
      addAtrib = true;
      addBtnSound.play();
    }
  }
  
  /////////////////////////////////////////////////////////  METODY ULEPSZANIA  /////////////////////////////////////////////////
  
  public void upgradeWeapon(){
    if(!CharacterClass.myHero.getActualWeapon().upgradeWeapon() && CharacterClass.myHero.actualWeapon < 11){
      CharacterClass.myHero.actualWeapon ++;
      newWeaponSound.play();
    }
  }
  
  public void upgradeArmor(){
    if(!CharacterClass.myHero.getActualArmor().upgradeArmor() && CharacterClass.myHero.actualArmor < 10){
      CharacterClass.myHero.actualArmor ++;
      newArmorSound.play();
    }
  }
  
}
class Map {
  public String name; ///Nazwa mapy: Np Miasto 1 lub Lodowa Kraina
  public PImage tlo; ///Tlo mapy wyświetlane po wejściu na jej teren
  private int poziom;  ///Poziom wymagany do wejścia na teren mapy (zabezpiecza przed walką z silnymi przeciwnikami)
  private Enemy enemyList[];
  private int actualEnemyNumber;
  
  Map(String BG, int poziom, Enemy enemyL[]){    ///Konstruktor pobiera (String z nazwą pliku tła,   Poziom potrzebny do wejścia na mape,    Tablice przeciwników na mapie)
    tlo = loadImage(BG);
    tlo.resize(width,height);  ///dostosowanie tła do ekrany telefonu
    this.poziom = poziom;
    //System.arraycopy( enemyL , 0 , this.enemyList , 0 , 50); //Zapis podanej w argumencie listy do enemyListy
    enemyList = enemyL.clone(); ///Utworzenie kopii listy enemyL do enemyList
    actualEnemyNumber = 0;
  }
  
  public void tick(){
    enemyDie();
    //enemyList[actualEnemyNumber].tick();
  };
  
  public void render() {
    image(tlo,0,0);
    enemyList[actualEnemyNumber].render();
  };
  
  public Enemy getActualEnemy(){
    return enemyList[actualEnemyNumber];
  }
  
  public int getEnemyNumber(){
    return actualEnemyNumber;
  }
  
  public void backEnemy(int count){
    int oldEnemy = actualEnemyNumber;
    if(actualEnemyNumber >= count){
      actualEnemyNumber -= count;
      enemyList[oldEnemy].setDefault();
      enemyList[oldEnemy].getHitCounter().stop(); //Zatrzymuje wyświetlanie informacji o uderzeniu, żeby nie wyświetlać jej przy ponownym przejściu do tego przeciwnika
      //enemyList[oldEnemy].hitCounter.stop();
    }
  }
  
  public void enemyDie(){  //Sprawdza czy przeciwnik żyje, a jeśli nie to dodaje nam punktów doświadczenia i zmienia przeciwnika na następnego
    if(!enemyList[actualEnemyNumber].stillAlive()){  //Jeśli postać przeciwnika ma 0 hp i zaczyna znikać
      //Tutaj dodać jakiś dzwięk i drop monet itp.
    }
    if(enemyList[actualEnemyNumber].isDead()){  //Jeśli postać przeciwnika zniknie
      CharacterClass.myHero.addExp(  Math.round(enemyList[actualEnemyNumber].getExp() * getExpFactor())  );    //Dodaje exp postaci
      System.out.println("Exp: " + enemyList[actualEnemyNumber].getExp() + "       |       Real Exp:" + Math.round(enemyList[actualEnemyNumber].getExp() * getExpFactor()) + "     |     Factor" + getExpFactor());
      int oldEnemy = actualEnemyNumber;
      actualEnemyNumber++;
      enemyList[oldEnemy].setDefault();
      enemyList[oldEnemy].getHitCounter().stop(); //Zatrzymuje wyświetlanie informacji o uderzeniu, żeby nie wyświetlać jej przy cofaniu przeciwników
      
      if(mousePressed) enemyList[actualEnemyNumber].attacked = true;  //Chroni przed natychmiastowym uderzeniem ze strony gracza
    }
  }
  
  private float getExpFactor(){ //Zwraca mnożlik expa w zależnbości od poziomów postaci
    if(enemyList[actualEnemyNumber].getLevel() > CharacterClass.myHero.getLevel()){
      System.out.println("Silniejszy : " + ((enemyList[actualEnemyNumber].getLevel() - CharacterClass.myHero.getLevel())/10.0f) );
      return ((enemyList[actualEnemyNumber].getLevel() - CharacterClass.myHero.getLevel())/10.0f) +1;
    }
    else if(enemyList[actualEnemyNumber].getLevel() < CharacterClass.myHero.getLevel()){
      System.out.println("Slabszy");
      return 1 - ((CharacterClass.myHero.getLevel() - enemyList[actualEnemyNumber].getLevel())/10.0f);
    }
    return 1;
  }
  
}
class Menu extends State{
    ///Grafiki
    PImage iBackground= loadImage("menuBg.png");
    PImage iLogo= loadImage("mePixLogo.png");
    
    ///Przyciski
    PImage iGrajBtn= loadImage("menuGraj.png");
    PImage iONasBtn= loadImage("menuONas.png");
    
    int iBtnX = PApplet.parseInt(width-(width/1.9f))/2;
    int iBtnY = height/6 + 550;
    int iONasBtnY = iBtnY+iGrajBtn.height+80;
    
    //Obiekty dodatkowe
    CollisionDetector CD;
    
    //Dzwięki przycisków
    MusicInterface btnSound = new MusicInterface("Sounds/insertBtnSound.wav"); 
    
    Menu(){  ///Init menu
      init();
    }
    
    public  void tick(){
      
      if(mousePressed && CD.mouseCollision(  iBtnX  ,  iBtnY  ,  iBtnX + iGrajBtn.width  ,  iBtnY+iGrajBtn.height  )){
        btnSound.play();
        State.setState(new CharSelection());
      }
      
      if(mousePressed && CD.mouseCollision(  iBtnX  ,  iONasBtnY  ,  iBtnX + iONasBtn.width  ,  iONasBtnY+iONasBtn.height  )){
        btnSound.play();
        State.setState(new ONas());
      }
    };
    
    public void render(){
      
      image(iBackground,0,0);
      int iLogoX = width/2 - iLogo.width/2;
      int iLogoY = height/6;
      image(iLogo,iLogoX,iLogoY); //Konstrukcja (width-(width/1.8))/2 pozwala na wyśrodkowanie obrazka na osi X
      image(iGrajBtn,iBtnX,iBtnY);
      image(iONasBtn,iBtnX, iONasBtnY);
    };
    
    public void init(){ ///Metoda init
      mobileResizer();
      CD = new CollisionDetector();
    }
    
    public void mobileResizer(){ ///Metoda do zmiany rozmiaru grafik w zależności od rozdzielczości ekranu
      iBackground.resize(width , height);
      iLogo.resize((int)(width/1.5f),0);
      iGrajBtn.resize((int)(width/1.9f),0);
      iONasBtn.resize((int)(width/1.9f),0);
    }
}


/*      TO DO LIST

Animowane tło               []
Grafika przycisków          []
Muzyka                      []

*/


static class MusicInterface{
  
    //Ustawianie PApplet
  static private sketch_191209a main;
  public static void setSketch(sketch_191209a m){main = m;}
  
  
    //Funkcjonalność klasy MusicInterface
  private SoundFile music;
  
  MusicInterface(String path){
    music = new SoundFile(main, path);
  }
  
  public void loop(){
    music.loop();
  }
  
  public void pause(){
    music.pause();
  }
  
  public void stop(){
    music.stop();
  }
  
  public void play(){
    music.play();
  }
  
  
  
}
class ONas extends State{
  
  PImage iBackground= loadImage("menuBg.png");
  PImage iExit = loadImage("invExit.png"); 
  PFont font = createFont("font.ttf",width/2);
  
  CollisionDetector CD = new CollisionDetector();
  
  
  ONas(){
    resizer();  
  }
  
  public void tick(){
    if(mousePressed && CD.mouseCollision(width - iExit.width , 0 , width , iExit.height)){
      State.setState(new Menu());
    }
  }
  
  public void render(){
    image( iBackground , 0 , 0 );
    fill(255);
    text( "Autor: Piotr Bobusia"   ,   0   ,   height/4 );
    text( "Studia: 3 rok, niestacjonarne"   , 0 ,    height/3 );
    text( "Index: 101272"     ,   0  ,   height/2);
    image(iExit , width - iExit.width , 0);
  }
  
  
  
  private void resizer(){
    iBackground.resize(width , height);
    iExit.resize(width/10 , 0);
  }
}
public class Saver{
  public void saveGame(){
    String[] zapis = {"To jest plik zapisu","Zapamietaj to sobie"};  //Treść pliku
    saveStrings("/storage/emulated/0/plikZapisu.txt",zapis);      //Funkcja zapisująca plik
  }
}
abstract class Skill {
  CollisionDetector CD;
  
  PImage icon[];  ///tablica ikon umiejętności (kolejno N M G P)
  Animation animationN; ///Animacja umiejętności na poziomie Normalnym
  Animation animationM; ///Animacja umiejętności na poziomie Mistrzowskim
  Animation animationG; ///Animacja umiejętności na poziomie Ponad Mistrzowskim
  Animation animationP; ///Animacja umiejętności na poziomie Perfekcyjnym
  
  PImage actualIcon; Animation actualAnimation;  //Zmienne zawierają aktualną ikonę i animacje (zależą one od stopinia wytrenowania umiejętności)
  
  public String name, description; ///Nazwa i opis umiejętności
  protected int level, manaCost; ///Poziom ulepszenia umiejętności     manaCost - koszt zużycia many
  
  protected int loadingTime; ///Czas ładowania umiejętności (podany w cyklach)
  protected int loadingRunner; //Runner czasowy ładowania skilla
  public boolean active;
  
  Skill(PImage icon[], String name, String desc, int mana, int time, PImage[] aN, PImage[] aM, PImage[] aG, PImage[] aP){
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
    for(int i=0 ; i<icon.length ; i++) icon[i].resize(PApplet.parseInt(width/7) , 0); //Ikony skilli
  }
  
  protected void resizeFullScreen(PImage ar[]){
    for(int i=0 ; i<ar.length ; i++) ar[i].resize(width , height); //Powiększa na pełny ekran wszystkie obrazy z tablicy
  }
  
  public void updateIcon(){
    if(level >0 && level <= 20){
      actualIcon = icon[0];
      actualAnimation = animationN;
    }
    if(level >20 && level <= 40){
      actualIcon = icon[1];
      actualAnimation = animationM;
    }
    if(level >40 && level <= 60){
      actualIcon = icon[2];
      actualAnimation = animationG;
    }
    if(level >60){
      actualIcon = icon[3];
      actualAnimation = animationP;
    }
  }
  
  abstract protected void useSkill(Enemy enemy);
  
  public int getY(){
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

  
}



/*
  Klase zmienić na abstrakcyjną z animacjami, kosztem many, poziomem, nazwą i opisem
  Ustawić konstruktor!
  
  Klasa musi być abstrakcyjna ponieważ niektóre umiejętności to umiejętności buffujące posiadające inne funkcjonalności niż atak.
*/
public static abstract class State{
  
  //ZMIENNE STATYCZNE
  private static State activeState = null;
  private static State beforeState = null;
  
  public static void setState(State state){
    beforeState = activeState;
    activeState = state;
  }
  
  public static void setBeforeState(){
    activeState = beforeState;
  }
  
  public static State getState(){
    return activeState;
  }
  
  
  //METODY ABSTRAKCYJNE
  public abstract void tick();
  public abstract void render();
  
}
class Sura extends CharacterClass{

  Fluid fluidHP , fluidEP;
  CollisionDetector CD;
  
  Sura(){
    name = "Sura"; level = 1;    image = loadImage("charSuraObr.png");
    initStats();
    initWeapons();
    initArmors();
    initEq();
    initSkills();
    healthBar = new HeroBar(this.maxHealth , this.maxEnergy, this.getExpToLevel());
    
    fluidHP = new Fluid("HP");
    fluidEP = new Fluid("EP");
    fluidPower=10; fluidPressed = false;
    CD = new CollisionDetector();
    expiriencePoints = 0;
    
    iNewLevel = loadImage("newLevel.png");
    newLevelScreen = false;
    
    resizer(); //Ustawia odpowiednie rozmiary grafik
  }
  
  
  public int attack(){   ///Metoda obliczająca wartość ataku (wliczając wszystkie czynniki takie jak Atak Podst. / Siła / Broń itp.)
    //System.out.println("attack: " + Math.round(standardAttack * (sila * attackBooster) + weapon[actualWeapon].calcAtk()) + " = " + standardAttack + " * ( "+sila +" * "+attackBooster+") * "+ weapon[actualWeapon].calcAtk());
    System.out.println("attack: "+Math.round(standardAttack * sila * attackBooster + weapon[actualWeapon].calcAtk()));
    return Math.round(standardAttack * sila * attackBooster + weapon[actualWeapon].calcAtk());
    //                    4          * (  5  *    1.2      )  +  3
  }
  
  public void getDamage(int damage){  ///Metoda przyjmuje wartość ataku przeciwnika i redukuje ją o wartość obrony (staty + zbroja) oraz odejmuje HP naszemu bohaterowi
    float zrecznoscDef = ( zrecznosc / 1000 ) + 1; ///Przy zrecznoci 5pkt. redukcja obrażeń to 1,005
    int realDamage = Math.round( damage * zrecznoscDef ) - armor[actualArmor].calcDef();
    
    if(realDamage<=0) actualHealth-=0;
    else actualHealth-=realDamage;
  }
  
  public void calcMaxHealth(){
    float zywotnoscHealth =  ( zywotnosc / 1000 ) + 1; ///Przy zywotnosci 5pkt. boost zycia to 1,005                [! Tutaj można byłoby dodać funkcję aby przy plusowaniu zywotnosci zwiekszało maxHealth w locie! NIE TYLKO PRZY LEVELOWANIU]
    maxHealth = Math.round(standardHealth * level * healthBooster * zywotnoscHealth);
  }
  
  public void calcMaxEnergy(){
    float energiaEnergy =  ( energia / 1000 ) + 1; ///Przy energii 5pkt. boost many to 1,005                [! Tutaj można byłoby dodać funkcję aby przy plusowaniu energii zwiekszało maxEnergy w locie! NIE TYLKO PRZY LEVELOWANIU]
    maxEnergy = Math.round(standardEnergy * level * energyBooster * energiaEnergy);
  }
  
  
  ////////////////////////////  INIT STATS  //  INIT SKILLS  //  INIT EQ  ////////////////////
  
  private void initStats(){
      standardAttack = 4;    attackBooster=1.2f;
      standardHealth = 300;  healthBooster=1.05f;  healthRegeneration = 60;
      standardEnergy = 70;   energyBooster=1.05f;  energyRegeneration = 85;
      sila = 5;
      inteligencja = 5;
      energia = 5;
      zywotnosc = 5;
      zrecznosc = 5;
      freePoints = 0;
      
      criticalChance = 0; //Promilowa szansa na cios krytyczny
      
      expiriencePoints = 0;
      int maxLevel = 99;
      levelExpirience = new int[maxLevel];  //definicja tablicy level Expirience
      levelExpirience[0] = 200; //Wymagane PD do uzyskania poziomu 2
      for(int i = 1; i<99; i++) levelExpirience[i] = levelExpirience[i-1] * 2;
      
      calcMaxHealth();
      calcMaxEnergy();
      healthToMax();  energyToMax();
  }
  
  
  private void initSkills(){
      skillsList = new Skill[5];
      PImage skillPlaceholder[] = new PImage[5]; PImage skillPhImage[] = new PImage[]{loadImage("skillPhIconN.png"),loadImage("skillPhIconM.png"),loadImage("skillPhIconG.png"),loadImage("skillPhIconP.png")};
      skillPlaceholder[0] = loadImage("skillPhN1.png");
      skillPlaceholder[1] = loadImage("skillPhN2.png");
      skillPlaceholder[2] = loadImage("skillPhN3.png");
      skillPlaceholder[3] = loadImage("skillPhN4.png");
      skillPlaceholder[4] = loadImage("skillPhN5.png");
      
      PImage skillPlaceholderM[] = new PImage[5];
      skillPlaceholderM[0] = loadImage("skillPhM1.png");
      skillPlaceholderM[1] = loadImage("skillPhM2.png");
      skillPlaceholderM[2] = loadImage("skillPhM3.png");
      skillPlaceholderM[3] = loadImage("skillPhM4.png");
      skillPlaceholderM[4] = loadImage("skillPhM5.png");
      
      PImage skillPlaceholderG[] = new PImage[5]; 
      skillPlaceholderG[0] = loadImage("skillPhG1.png");
      skillPlaceholderG[1] = loadImage("skillPhG2.png");
      skillPlaceholderG[2] = loadImage("skillPhG3.png");
      skillPlaceholderG[3] = loadImage("skillPhG4.png");
      skillPlaceholderG[4] = loadImage("skillPhG5.png");
      
      skillsList[0] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 500, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
      skillsList[1] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 230, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
      skillsList[2] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 115, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
      skillsList[3] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 5000, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
      skillsList[4] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 700, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
  }
  
  private void initEq(){
      yang = 100; //Ilość posiadanych monet w grze
      hpFluid = 5; 
      epFluid = 5; //Ilość potków i manasów
  }
  
  
  ////////////////////////////  INIT WEAPONS  //  INIT ARMORS  /////////////////////////////////
  
  private void initWeapons(){
    actualWeapon = 0;
    weapon = new Weapon[11];
    weapon[0] = new Weapon( "Miecz" , new int[]{0,1,2,3,4,5,6,7,8,9} , new int[]{3,4,5,6,7,8,9,10,11,12} , "miecz.png"); 
    weapon[1] = new Weapon( "Wielki Miecz" , new int[]{3,4,5,6,7,8,9,10,11,12} , new int[]{7,8,9,10,11,12,13,14,17,21} , "dlugiMiecz.png"); 
    weapon[2] = new Weapon( "Sejmitar" , new int[]{5,7,9,11,14,15,18,21,26,33} , new int[]{8,11,15,18,21,22,25,28,31,38} , "sejmitar.png"); 
    weapon[3] = new Weapon( "Stożkowy Miecz" , new int[]{11,12,13,14,15,16,17,18,19,20} , new int[]{20,21,22,23,24,25,30,35,38,41} , "stozkowyMiecz.png"); 
    weapon[4] = new Weapon( "Szeroki Miecz" , new int[]{15,16,17,18,19,20,21,22,23,24} , new int[]{25,26,27,28,29,30,35,37,42,48} , "szerokiMiecz.png"); 
    weapon[5] = new Weapon( "Srebrny Miecz" , new int[]{21,22,23,24,25,26,27,28,29,32} , new int[]{30,31,33,35,37,40,41,43,46,52} , "srebrnyMiecz.png"); 
    weapon[6] = new Weapon( "Miecz Pełni Księżyca" , new int[]{26,27,28,29,30,32,35,37,40,42} , new int[]{33,35,38,41,44,46,49,54,58,60} , "mieczPelniKsiezyca.png"); 
    weapon[7] = new Weapon( "Półtoraręczny Miecz" , new int[]{31,33,36,39,44,47,49,51,55,58} , new int[]{38,40,41,44,46,48,54,58,63,69} , "poltorarecznyMiecz.png"); 
    weapon[8] = new Weapon( "Miecz Barbarzyńcy" , new int[]{36,38,40,41,44,47,52,55,58,60} , new int[]{41,44,48,50,61,72,75,83,87,90} , "mieczBarbarzyncy.png"); 
    weapon[9] = new Weapon( "Miecz Egzorcysty" , new int[]{41,44,48,50,61,72,75,83,87,90} , new int[]{44,57,58,63,72,77,80,88,93,99} , "mieczEgzorcysty.png"); 
    weapon[10] = new Weapon( "Miecz Szponu Ducha" , new int[]{55,58,63,67,78,87,90,98,106,115} , new int[]{60,70,80,90,100,105,110,115,120,130} , "mieczSzponuDucha.png"); 
  }
  
  private void initArmors(){
    actualArmor = 0;
    armor = new Armor[10];
    armor[0] = new Armor( "Zbroja" , new int[]{5,7,9,12,15,17,19,22,25,30} , "suraArmor1.png");  
    armor[1] = new Armor( "Zbroja" , new int[]{7,9,12,15,18,23,36,40,45,50} , "suraArmor2.png");
    armor[2] = new Armor( "Zbroja" , new int[]{10,15,20,22,25,27,35,42,50,60} , "suraArmor3.png");
    armor[3] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor4.png");
    armor[4] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor5.png");
    armor[5] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor6.png");
    armor[6] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor7.png");
    armor[7] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor8.png");
    armor[8] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor9.png");
    armor[9] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "suraArmor10.png");
  }
  
  
  //////////////////////////////////////// METODY DODATKOWE   ////////////////////////////////////////////////////////
  
  public void showSkillBar(Enemy enemy){   
    for(int i = 0; i < 5 ; i ++){
      int x = (skillsList[i].actualIcon.width*i) , y=skillsList[i].getY();
      //image(skillsList[i].actualIcon, x , y);
      skillsList[i].renderIcon(x , y);
      skillsList[i].tick( x , y , enemy);
    }
  }
  
  public void showFluids(){   
    fluidHP.showFluid( 0 , height-(width/5)*2 , hpFluid);
    fluidEP.showFluid(width - width/5 , height-(width/5)*2 , epFluid);
    if(hpFluid>0 && !fluidPressed && mousePressed && CD.mouseCollision(fluidHP.getX() , fluidHP.getY() , fluidHP.getX() + fluidHP.getWidth() , fluidHP.getY()+fluidHP.getHeight())){  ///Jeśli ikona fluida została kliknięta
      useHpFluid();
      fluidPressed = true;
    }
    if(epFluid>0 && !fluidPressed && mousePressed && CD.mouseCollision(fluidEP.getX() , fluidEP.getY() , fluidEP.getX() + fluidEP.getWidth() , fluidEP.getY()+fluidEP.getHeight())){  ///Jeśli ikona fluida została kliknięta
      useEpFluid();
      fluidPressed = true;
    }
    if(!mousePressed && fluidPressed){
    fluidPressed = false ;
    }
  }
  
  public void checkRegeneration(){    ///Metoda sprawdzająca i wykonująca regeneracje HP i PE
    if(healthRunner>=healthRegeneration){  //Czy runner dobiegł już do mety
      if(actualHealth<maxHealth){  //Sprawdza aby nie dodać punktu do maksymalnego już HP
        actualHealth++;  //Dodaje punkt zdrowia
      }
      healthRunner=0; //"Życiowy biebacz" wraca na start
    } else healthRunner ++;  //Jeśli nie dobiegł, robi kolejny krok do mety
    
    if(energyRunner>=energyRegeneration){  //Czy runner dobiegł już do mety
      if(actualEnergy<maxEnergy){  //Sprawdza aby nie dodać punktu do maksymalnego już PE
        actualEnergy++;  //Dodaje punkt enegrii
      }
      energyRunner=0; //"Energiczny biebacz" wraca na start
    } else energyRunner ++;  //Jeśli nie dobiegł, robi kolejny krok do mety
  }
  
  
  
  //////////////////////////////////////// TICK / RENDER POSTACI   ////////////////////////////////////////////////////////

  public void tick(){
    healthBar.tick();
    checkRegeneration(); 
    checkLevel();
    addFluidTick();
  }
  
  public void render(){
    //healthBar.tick();
    showFluids();
    newLevelScreen();
  }
  
  ///////////////////////////////////////  METODY WYSWIETLANIA //////////////////////////////////////
  
  public void resizer(){
    iNewLevel.resize(PApplet.parseInt(width/1.5f) , 0);
    image.resize(PApplet.parseInt(width/2.3f) , 0);
  }
  
  public void newLevelScreen(){
    if(newLevelScreen){
      if(newLevelRunner <= 350){
        image(iNewLevel , width/2 - iNewLevel.width/2 , height/5);
        newLevelRunner ++;
      }
      else newLevelScreen = false;
    }
  }
  
  public void renderImage(float x, float y){
    image(image, x, y);
  }

}


/*   

  Uzupełnić wszystkie zmienne oraz metody tej klasy! 

*/
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
    description = "Trzy idealnie wykonane ciecia.";
    //wczytywanie ikon skilla
    icon = new PImage[4];
    icon[0] = loadImage("Wojownik/TrzystronneCiecie/iconN.png");
    icon[1] = loadImage("Wojownik/TrzystronneCiecie/iconM.png");
    icon[2] = loadImage("Wojownik/TrzystronneCiecie/iconG.png");
    icon[3] = loadImage("Wojownik/TrzystronneCiecie/iconP.png");
    
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
    manaCost = 20;
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
    actualEnemy.hp -= 5 * level * silaBoost * inteligencjaBoost;
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
        actualAnimation.playAnimation(0,0,3,PApplet.parseByte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}


/*    TO DO

  FUNKCJONALNOŚĆ METODY useSkill

*/
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
    description = "Energia miecza uderza we wroga.";
    //wczytywanie ikon skilla
    icon = new PImage[4];
    icon[0] = loadImage("Wojownik/UderzenieMiecza/iconN.png");
    icon[1] = loadImage("Wojownik/UderzenieMiecza/iconM.png");
    icon[2] = loadImage("Wojownik/UderzenieMiecza/iconG.png");
    icon[3] = loadImage("Wojownik/UderzenieMiecza/iconP.png");
    
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
    manaCost = 20;
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
    actualEnemy.hp -= 5 * level * silaBoost * inteligencjaBoost;
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
        actualAnimation.playAnimation(0,0,4,PApplet.parseByte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}


/*    TO DO

  FUNKCJONALNOŚĆ METODY useSkill

*/


class Weapon {
  Random rand;  //Obiekt losujący
  
  public PImage image;
  public String name;  ///Nazwa przedmiotu
  private int level;  ///Poziom ulepszenia przedmiotu
  private int atk_od[], atk_do[];  ///Wartości ataku (minimalnego i maksymalnego)
  
  private Animation[] stars;
  
  //Dzwięki
  MusicInterface upgradeSound = new MusicInterface("Sounds/upgradeSound.wav");
  
  Weapon( String name , int atk_od[] , int atk_do[] , String image_path){
    rand = new Random();
    
    this.image = loadImage(image_path);
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
    image.resize(PApplet.parseInt(width/2.3f) , 0);
  }
  
  public void renderWeapon(float x, float y){
    image(image, x, y);
    if(level == 7){
      stars[0].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
    }
    if(level == 8){
      stars[1].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
    }
    if(level == 9){
      stars[2].playAnimation(PApplet.parseInt(x), PApplet.parseInt(y), 50, PApplet.parseByte(1));
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
      stars[i].resizeWidth(PApplet.parseInt(width/2.3f));
    }
  }
  
  public boolean upgradeWeapon(){
    if(level<9){
      level++;
      upgradeSound.play();
      return true;
    } else return false;
  }
  
  public int getWeaponLevel(){
    return level;
  }
  
  
}
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
    description = "Wojownik zatacza ograg swoim mieczem.";
    //wczytywanie ikon skilla
    icon = new PImage[4];
    icon[0] = loadImage("Wojownik/WirMiecza/iconN.png");
    icon[1] = loadImage("Wojownik/WirMiecza/iconM.png");
    icon[2] = loadImage("Wojownik/WirMiecza/iconG.png");
    icon[3] = loadImage("Wojownik/WirMiecza/iconP.png");
    
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
    manaCost = 20;
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
        actualAnimation.playAnimation(0,0,3,PApplet.parseByte(0));  //Jeśli actualAnimation->play jest true
      }
    }
   }
   
   public void renderIcon(int x, int y){
    if(!active) tint(111, 111, 111);
    image(actualIcon, x , y);
    noTint();
   }
   
}


/*    TO DO

  FUNKCJONALNOŚĆ METODY useSkill

*/
class Wojownik extends CharacterClass{

  
  CollisionDetector CD;
  
  Wojownik(){
    name = "Wojownik"; level = 1;    image = loadImage("charWojownikObr.png");
    initStats();
    initWeapons();
    initArmors();
    initEq();
    initSkills();
    healthBar = new HeroBar(this.maxHealth , this.maxEnergy, this.getExpToLevel());
    
    fluidHP = new Fluid("HP");
    fluidEP = new Fluid("EP");
    fluidPower=10; fluidPressed = false;
    CD = new CollisionDetector();
    expiriencePoints = 0;
    
    iNewLevel = loadImage("newLevel.png");
    newLevelScreen = false;
    
    resizer(); //Ustawia odpowiednie rozmiary grafik
  }
  
  
  public int attack(){   ///Metoda obliczająca wartość ataku (wliczając wszystkie czynniki takie jak Atak Podst. / Siła / Broń itp.)
    //System.out.println("attack: " + Math.round(standardAttack * (sila * attackBooster) + weapon[actualWeapon].calcAtk()) + " = " + standardAttack + " * ( "+sila +" * "+attackBooster+") * "+ weapon[actualWeapon].calcAtk());
    System.out.println("attack: "+Math.round(standardAttack * sila * attackBooster + weapon[actualWeapon].calcAtk()));
    return Math.round(standardAttack * sila * attackBooster + weapon[actualWeapon].calcAtk());
    //                    4          * (  5  *    1.2      )  +  3
  }
  
  public void getDamage(int damage){  ///Metoda przyjmuje wartość ataku przeciwnika i redukuje ją o wartość obrony (staty + zbroja) oraz odejmuje HP naszemu bohaterowi
    float zrecznoscDef = ( zrecznosc / 1000 ) + 1; ///Przy zrecznoci 5pkt. redukcja obrażeń to 1,005
    int realDamage = Math.round( damage * zrecznoscDef ) - armor[actualArmor].calcDef();
    
    if(realDamage<=0) actualHealth-=0;
    else actualHealth-=realDamage;
  }
  
  public void calcMaxHealth(){
    float zywotnoscHealth =  ( zywotnosc / 1000 ) + 1; ///Przy zywotnosci 5pkt. boost zycia to 1,005                [! Tutaj można byłoby dodać funkcję aby przy plusowaniu zywotnosci zwiekszało maxHealth w locie! NIE TYLKO PRZY LEVELOWANIU]
    maxHealth = Math.round(standardHealth * level * healthBooster * zywotnoscHealth);
  }
  
  public void calcMaxEnergy(){
    float energiaEnergy =  ( energia / 1000 ) + 1; ///Przy energii 5pkt. boost many to 1,005                [! Tutaj można byłoby dodać funkcję aby przy plusowaniu energii zwiekszało maxEnergy w locie! NIE TYLKO PRZY LEVELOWANIU]
    maxEnergy = Math.round(standardEnergy * level * energyBooster * energiaEnergy);
  }
  
  
  ////////////////////////////  INIT STATS  //  INIT SKILLS  //  INIT EQ  ////////////////////
  
  private void initStats(){
      standardAttack = 5;    attackBooster=1.3f;
      standardHealth = 300;  healthBooster=1.06f;  healthRegeneration = 45;
      standardEnergy = 70;   energyBooster=1.03f;  energyRegeneration = 95;
      sila = 5;
      inteligencja = 5;
      energia = 5;
      zywotnosc = 5;
      zrecznosc = 5;
      freePoints = 0;
      
      criticalChance = 0; //Promilowa szansa na cios krytyczny
      
      expiriencePoints = 0;
      int maxLevel = 99;
      levelExpirience = new int[maxLevel];  //definicja tablicy level Expirience
      levelExpirience[0] = 200; //Wymagane PD do uzyskania poziomu 2
      for(int i = 1; i<99; i++) levelExpirience[i] = levelExpirience[i-1] * 2;
      
      calcMaxHealth();
      calcMaxEnergy();
      healthToMax();  energyToMax();
  }
  
  
  private void initSkills(){
      skillsList = new Skill[5];
      PImage skillPlaceholder[] = new PImage[5]; PImage skillPhImage[] = new PImage[]{loadImage("skillPhIconN.png"),loadImage("skillPhIconM.png"),loadImage("skillPhIconG.png"),loadImage("skillPhIconP.png")};
      skillPlaceholder[0] = loadImage("skillPhN1.png");
      skillPlaceholder[1] = loadImage("skillPhN2.png");
      skillPlaceholder[2] = loadImage("skillPhN3.png");
      skillPlaceholder[3] = loadImage("skillPhN4.png");
      skillPlaceholder[4] = loadImage("skillPhN5.png");
      
      PImage skillPlaceholderM[] = new PImage[5];
      skillPlaceholderM[0] = loadImage("skillPhM1.png");
      skillPlaceholderM[1] = loadImage("skillPhM2.png");
      skillPlaceholderM[2] = loadImage("skillPhM3.png");
      skillPlaceholderM[3] = loadImage("skillPhM4.png");
      skillPlaceholderM[4] = loadImage("skillPhM5.png");
      
      PImage skillPlaceholderG[] = new PImage[5]; 
      skillPlaceholderG[0] = loadImage("skillPhG1.png");
      skillPlaceholderG[1] = loadImage("skillPhG2.png");
      skillPlaceholderG[2] = loadImage("skillPhG3.png");
      skillPlaceholderG[3] = loadImage("skillPhG4.png");
      skillPlaceholderG[4] = loadImage("skillPhG5.png");
      
      skillsList[0] = new WirMiecza();
      skillsList[1] = new TrzystronneCiecie();
      skillsList[2] = new UderzenieMiecza();
      skillsList[3] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 5000, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
      skillsList[4] = new WirMiecza(skillPhImage, "MagiaTest", "Umiejetnosc testowa", 10, 700, skillPlaceholder, skillPlaceholderM, skillPlaceholderG, skillPlaceholderG, 15);
  }
  
  private void initEq(){
      yang = 100; //Ilość posiadanych monet w grze
      hpFluid = 5; 
      epFluid = 5; //Ilość potków i manasów
  }
  
  
  ////////////////////////////  INIT WEAPONS  //  INIT ARMORS  /////////////////////////////////
  
  private void initWeapons(){
    actualWeapon = 0;
    weapon = new Weapon[11];
    weapon[0] = new Weapon( "Miecz" , new int[]{0,1,2,3,4,5,6,7,8,9} , new int[]{3,4,5,6,7,8,9,10,11,12} , "miecz.png"); 
    weapon[1] = new Weapon( "Wielki Miecz" , new int[]{3,4,5,6,7,8,9,10,11,12} , new int[]{7,8,9,10,11,12,13,14,17,21} , "dlugiMiecz.png"); 
    weapon[2] = new Weapon( "Sejmitar" , new int[]{5,7,9,11,14,15,18,21,26,33} , new int[]{8,11,15,18,21,22,25,28,31,38} , "sejmitar.png"); 
    weapon[3] = new Weapon( "Stożkowy Miecz" , new int[]{11,12,13,14,15,16,17,18,19,20} , new int[]{20,21,22,23,24,25,30,35,38,41} , "stozkowyMiecz.png"); 
    weapon[4] = new Weapon( "Szeroki Miecz" , new int[]{15,16,17,18,19,20,21,22,23,24} , new int[]{25,26,27,28,29,30,35,37,42,48} , "szerokiMiecz.png"); 
    weapon[5] = new Weapon( "Srebrny Miecz" , new int[]{21,22,23,24,25,26,27,28,29,32} , new int[]{30,31,33,35,37,40,41,43,46,52} , "srebrnyMiecz.png"); 
    weapon[6] = new Weapon( "Miecz Pełni Księżyca" , new int[]{26,27,28,29,30,32,35,37,40,42} , new int[]{33,35,38,41,44,46,49,54,58,60} , "mieczPelniKsiezyca.png"); 
    weapon[7] = new Weapon( "Półtoraręczny Miecz" , new int[]{31,33,36,39,44,47,49,51,55,58} , new int[]{38,40,41,44,46,48,54,58,63,69} , "poltorarecznyMiecz.png"); 
    weapon[8] = new Weapon( "Miecz Barbarzyńcy" , new int[]{36,38,40,41,44,47,52,55,58,60} , new int[]{41,44,48,50,61,72,75,83,87,90} , "mieczBarbarzyncy.png"); 
    weapon[9] = new Weapon( "Zatruty Miecz" , new int[]{41,44,48,50,61,72,75,83,87,90} , new int[]{44,57,58,63,72,77,80,88,93,99} , "zatrutyMiecz.png"); 
    weapon[10] = new Weapon( "Miecz Trytona" , new int[]{55,58,63,67,78,87,90,98,106,115} , new int[]{60,70,80,90,100,105,110,115,120,130} , "mieczTrytona.png"); 
  }
  
  private void initArmors(){
    actualArmor = 0;
    armor = new Armor[10];
    armor[0] = new Armor( "Zbroja" , new int[]{5,7,9,12,15,17,19,22,25,30} , "wojoArmor1.png");  
    armor[1] = new Armor( "Zbroja" , new int[]{7,9,12,15,18,23,36,40,45,50} , "wojoArmor2.png");
    armor[2] = new Armor( "Zbroja" , new int[]{10,15,20,22,25,27,35,42,50,60} , "wojoArmor3.png");
    armor[3] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor4.png");
    armor[4] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor5.png");
    armor[5] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor6.png");
    armor[6] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor7.png");
    armor[7] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor8.png");
    armor[8] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor9.png");
    armor[9] = new Armor( "Zbroja" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor10.png");
  }
  
  
  //////////////////////////////////////// METODY DODATKOWE   ////////////////////////////////////////////////////////
  
  public void showSkillBar(Enemy enemy){   
    for(int i = 0; i < 5 ; i ++){
      int x = (skillsList[i].actualIcon.width*i) , y=skillsList[i].getY();
      //image(skillsList[i].actualIcon, x , y);
      skillsList[i].renderIcon(x , y);
      skillsList[i].tick( x , y , enemy);
    }
  }
  
  public void showFluids(){   
    fluidHP.showFluid( 0 , height-(width/5)*2 , hpFluid);
    fluidEP.showFluid(width - width/5 , height-(width/5)*2 , epFluid);
    if(hpFluid>0 && !fluidPressed && mousePressed && CD.mouseCollision(fluidHP.getX() , fluidHP.getY() , fluidHP.getX() + fluidHP.getWidth() , fluidHP.getY()+fluidHP.getHeight())){  ///Jeśli ikona fluida została kliknięta
      useHpFluid();
      fluidPressed = true;
    }
    if(epFluid>0 && !fluidPressed && mousePressed && CD.mouseCollision(fluidEP.getX() , fluidEP.getY() , fluidEP.getX() + fluidEP.getWidth() , fluidEP.getY()+fluidEP.getHeight())){  ///Jeśli ikona fluida została kliknięta
      useEpFluid();
      fluidPressed = true;
    }
    if(!mousePressed && fluidPressed){
    fluidPressed = false ;
    }
  }
  
  public void checkRegeneration(){    ///Metoda sprawdzająca i wykonująca regeneracje HP i PE
    if(healthRunner>=healthRegeneration){  //Czy runner dobiegł już do mety
      if(actualHealth<maxHealth){  //Sprawdza aby nie dodać punktu do maksymalnego już HP
        actualHealth++;  //Dodaje punkt zdrowia
      }
      healthRunner=0; //"Życiowy biebacz" wraca na start
    } else healthRunner ++;  //Jeśli nie dobiegł, robi kolejny krok do mety
    
    if(energyRunner>=energyRegeneration){  //Czy runner dobiegł już do mety
      if(actualEnergy<maxEnergy){  //Sprawdza aby nie dodać punktu do maksymalnego już PE
        actualEnergy++;  //Dodaje punkt enegrii
      }
      energyRunner=0; //"Energiczny biebacz" wraca na start
    } else energyRunner ++;  //Jeśli nie dobiegł, robi kolejny krok do mety
  }
  
  
  //////////////////////////////////////// TICK / RENDER POSTACI   ////////////////////////////////////////////////////////

  public void tick(){
    healthBar.tick();
    checkRegeneration(); 
    checkLevel();
    addFluidTick();
  }
  
  public void render(){
    //healthBar.tick();
    showFluids();
    newLevelScreen();
  }
  
  ///////////////////////////////////////  METODY WYSWIETLANIA //////////////////////////////////////
  
  public void resizer(){
    iNewLevel.resize(PApplet.parseInt(width/1.5f) , 0);
    image.resize(PApplet.parseInt(width/2.3f) , 0);
  }
  
  public void newLevelScreen(){
    if(newLevelScreen){
      if(newLevelRunner <= 350){
        image(iNewLevel , width/2 - iNewLevel.width/2 , height/5);
        newLevelRunner ++;
      }
      else newLevelScreen = false;
    }
  }
  
  public void renderImage(float x, float y){
    image(image, x, y);
  }

}


/*   

  Uzupełnić wszystkie zmienne oraz metody tej klasy! 

*/
  public void settings() {  fullScreen(); }
}
