abstract static class CharacterClass{

  public static CharacterClass myHero; ///Metoda zawiera informacje na temat wybranego bohatera
  
  public static void setHero(CharacterClass hero){ ///Metoda pozwala na ustawienie bohatera
    myHero = hero;
  };
  
  
  //###################################################################################################################################
  
  PImage image;   //Grafika postaci
  String name;    //Nazwa klasy postaci np. Wojownik
  int level;      //Poziom postaci
  public int maxHealth; //Maksymalna ilość punktów zdrowia
  int standardHealth; float healthBooster; ///standardHealth to podstawowe punkty zdrowia                          healthBooster to mnożnik punktów zdrowia, który pozwala na obliczenie zdrowia w stosunku do aktualnego poziomu i statystyk
  public int maxEnergy; //Maksymalna ilość punktów many
  int standardEnergy; float energyBooster; ///standardEnegry to podstawowe punkty energii                          energyBooster to mnożnik punktów energii, który pozwala na obliczenie many w stosunku do aktualnego poziomu i statystyk
  int standardAttack; float attackBooster; ///standardAttack to obrażenia zadawane przez zwykły "surowy" atak      attackBooster to mnożnik ataku, który pozwala na silniejszy podstawowy atak w zaleqżności od klasy postaci
  int expiriencePoints;  //punkty doświadczenia
  int levelExpirience[];  //Tablica wymaganych punktów doświadczenia do osiągnięcia poziomu
  int sila,        //Zmienne statystyk postaci
      inteligencja,
      energia,
      zywotnosc,
      zrecznosc,
      freePoints,
      skillPoints;  //Punkty do rozdania
  Weapon weapon[];  int actualWeapon, maxWeaponUpgrade;  //weapon[] zawiera możliwą do posiadania broń (od najsłabszej do najsilniejszej)    actualWeapon to index posiadanej broni w tablicy         maxWeaponUpgrade to maksymalny poziom ulepszenia broni 
  Armor armor[];    int actualArmor, maxArmorUpgrade;  //armor[] zawiera możliwe do posiadania pancerze (od najgorszego do najlepszego)     actualArmor to index posiadanego pancerza w tablicy       maxArmorUpgrade to maksymalny poziom ulepszenia zbroi 
  public Skill skillsList[];   //Tablica umiejętności postaci (ilośc: 4)
  
  int fluidRunner; //Oblicza czas do dropnięcia fluidów
  Fluid fluidHP; //Klasa wywaru leczniczego
  
  protected int yang; //Ilość posiadanych monet w grze
  protected int hpFluid; //Ilość potków i manasów
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
  
  
  PImage iLoading;
  
  //Music Interface
  MusicInterface useFluidSound = new MusicInterface("Town/Sounds/FluidSound1.wav"); 
  
  /////////////////////////// PLECAK /////////////////////////////////////////
  public Item    bamboo,
                 wood,
                 flowers,
                 iron,
                 gold,
                 supplies,
                 linen,
                 lether,
                 silk;
  
  
  ///////////////////////////  Dzwięki  //////////////////////////////////////
  MusicInterface levelUpSound = new MusicInterface("Sounds/newLevelSound.wav");
  
  protected int healthRunner, energyRunner;  //Biegacze wyznaczający czas na regeneracje zdrowia i energii
  abstract protected void checkRegeneration();
  
  abstract int attack();  //Metoda zwracająca wartość zwykłego ataku (wliczając bonusy , broń podręczną i statystyki )
  abstract void getDamage(int damage);  //Metoda obliczająca otrzymane obrażenia (wliczając posiadaną obronę i statystyki)
  
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
    useFluidSound.play();
  }
  
  
  public void addFluidTick(){ //Tick czasowego dodawania wywarów leczniczych
    if(fluidRunner >= 1000){
      hpFluid ++;
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
  
  abstract public void tick();  //Tick postaci
  abstract public void render();  //Render postaci
  
  //abstract public void showBar();
  
  public boolean checkDie(){   //Metoda sprawdza czy postać żyje
    if(actualHealth <= 0) return true;
    return false;
    
  }
  
  ///////////////////////////////////////////////////  METODA INICJALIZACJI PUNKTÓW DOŚWIADCZENIA  //////////////////////////////////////////////////
  
  public void expInit(){  //Oblicza potrzebne doświadczenie na poziom
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
      skillPoints++;
      //healthBar.updateLenght();
      
      newLevelRunner = 0;
      newLevelScreen = true;
    }
  }
  
  public void levelUp(){  //Funkcja dodania poziomu (Nagradza nas wywarami leczniczymy)
    this.level++;
    healthToMax();  //Regeneruje życie
    energyToMax();  //Regeneruje energie
    hpFluid+=5;    //nowy poziom zapewnia dodanie 5 miksturek życia i many
    
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
  
  public boolean addPointToSkill(int index){  //Metoda służy do rozdawania wolnych punktów duchowych
    if(skillPoints>0){
      skillsList[index].levelUp();
      return true;
    }
    else return false;
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
  
  
  
  public int[] getTableStuff(){  //funkcja zwraca tablice wszystkich posiadanych przedmiotów do ulepszania
    int[] stuff = new int[9];
    stuff[0] = bamboo.getValue();
    stuff[1] = wood.getValue();
    stuff[2] = flowers.getValue();
    stuff[3] = iron.getValue();
    stuff[4] = gold.getValue();
    stuff[5] = supplies.getValue();
    stuff[6] = linen.getValue();
    stuff[7] = lether.getValue();
    stuff[8] = silk.getValue();
    
    return stuff;
  }
  
  
  public void setTableStuff(int[] tableValueSet){  //funkcja zwraca tablice wszystkich posiadanych przedmiotów do ulepszania
    System.out.println("//setTableStuff//setTableStuff//setTableStuff//setTableStuff//setTableStuff");
    bamboo.value =   tableValueSet[0];
    wood.value =     tableValueSet[1];
    flowers.value =  tableValueSet[2];
    iron.value =     tableValueSet[3];
    gold.value =     tableValueSet[4];
    supplies.value = tableValueSet[5];
    linen.value =    tableValueSet[6];
    lether.value =   tableValueSet[7];
    silk.value =     tableValueSet[8];
  }
  
  public void addTableStuff(int[] tableValueSet){  //funkcja zwraca tablice wszystkich posiadanych przedmiotów do ulepszania
    System.out.println("//addTableStuff//addTableStuff//addTableStuff//addTableStuff//addTableStuff");
    bamboo.value +=   tableValueSet[0];
    wood.value +=     tableValueSet[1];
    flowers.value +=  tableValueSet[2];
    iron.value +=     tableValueSet[3];
    gold.value +=     tableValueSet[4];
    supplies.value += tableValueSet[5];
    linen.value +=    tableValueSet[6];
    lether.value +=   tableValueSet[7];
    silk.value +=     tableValueSet[8];
  }
  
  
  /////////////////////////////////////////////  METODY WYŚWIETLANIA //////////////////////////////////////////

  abstract protected void resizer();

  abstract public void newLevelScreen();
  
  abstract public void renderImage(float x, float y);
  
  ////////////////////////////////////////////  METODY BOOST itp   ////////////////////////////////////////////
  
  protected void checkBoost(){  //Metoda sprawdzajaca czy aktualnie znajdujemy się pod stanem jakiegoś boost-u np. mikstury regeneracji zdrowia
    
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
  
  ////////////////////////////////////// METODY SPRAWDZANIA UPGRADE //////////////////////////////////
  
  public boolean canUpgradeWeapon(){  //Zwraca czy można zrobić upgrade broni z +9 -> +0
    if(actualWeapon == (maxWeaponUpgrade-1)) return false;
    return true;
  }
  
  public boolean canUpgradeArmor(){  //Zwraca czy można zrobić upgrade zbroi z +9 -> +0
    if(actualArmor == (maxArmorUpgrade-1)) return false;
    return true;
  }

}
