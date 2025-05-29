class Wojownik extends CharacterClass{

  
  CollisionDetector CD;
  
  int skillX = width/50 + int(width/2.8) + int((width/2.8)/20);
  int skillY = (height - int(width/2.8) - width/50) +  int(((width/2.8)/2) + int((width/3.1)*1.65 / 18.5));
  
  Wojownik(){
    name = "Wojownik"; level = 1;    image = loadImage("charWojownikObr.png");
    initStats();  //funkcja odpowiedzialna za wczytanie statystyk
    initWeapons();  //funkcja odpowiedzialna za wczytanie broni dla klasy
    initArmors();  //funkcja odpowiedzialna za wczytanie pancerza dla klasy
    initEq();    //funkcja odpowiedzialna za wczytanie wywarów leczniczych
    initSkills();  //funkcja odpowiedzialna za wczytanie umiejętności klasy
    initItems();  //funkcja odpowiedzialna za wczytanie przedmiotów do plecaka
    healthBar = new HeroBar(this.maxHealth , this.maxEnergy, this.getExpToLevel());  //Utworzenie interfejsu z punktami zdrowia i dościadczenia
    
    fluidHP = new Fluid("HP");  //Utworzenie obiektu wywaru leczniczego
    fluidPower=10; fluidPressed = false;
    CD = new CollisionDetector();
    expiriencePoints = 0;  //posiadane na starcie punkty dośw.
    
    iNewLevel = loadImage("HUD/newLevel.png");
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
      standardAttack = 5;    attackBooster=1.3;                                      //STANDARD
      standardHealth = 300;  healthBooster=1.06;  healthRegeneration = 45;           //STANDARD
      standardEnergy = 70;   energyBooster=1.03;  energyRegeneration = 95;           //STANDARD
      sila = 5;
      inteligencja = 5;
      energia = 5;
      zywotnosc = 5;
      zrecznosc = 5;
      freePoints = 0;
      skillPoints = 0;
      
      criticalChance = 0; //Promilowa szansa na cios krytyczny                       //STANDARD
      
      expiriencePoints = 0;
      int maxLevel = 99;                                                             //STANDARD
      levelExpirience = new int[maxLevel];  //definicja tablicy level Expirience
      levelExpirience[0] = 200; //Wymagane PD do uzyskania poziomu 2
      for(int i = 1; i<99; i++) levelExpirience[i] = levelExpirience[i-1] * 2;
      
      calcMaxHealth();
      calcMaxEnergy();
      healthToMax();  energyToMax();
  }
  
  
  private void initSkills(){
      skillsList = new Skill[5];

      skillsList[0] = new WirMiecza();
      skillsList[1] = new TrzystronneCiecie();
      skillsList[2] = new UderzenieMiecza();
      skillsList[3] = new SzybkieCiecie();
      skillsList[4] = new WirMiecza();
  }
  
  private void initEq(){
      yang = 100; //Ilość posiadanych monet w grze
      hpFluid = 5; 
  }
  
  
  ////////////////////////////  INIT WEAPONS  //  INIT ARMORS  /////////////////////////////////
  
  private void initWeapons(){
    actualWeapon = 0;
    maxWeaponUpgrade = 11;
    System.out.println("START: initWeapons()");
    weapon = new Weapon[maxWeaponUpgrade];
    //weapon[0] = new Weapon( "Miecz" , new int[]{0,1,2,3,4,5,6,7,8,9} , new int[]{3,4,5,6,7,8,9,10,11,12} , "miecz.png"); 
    weapon[0] = new Weapon( "Miecz" , new int[]{0,1,2,3,4,5,6,7,8,9} , new int[]{3,4,5,6,7,8,9,10,11,12} , "Weapons/miecz.png" , new int[]{1,2,4,6,10,12,13,15,22,0} , new int[]{0,0,1,1,2,3,3,3,4,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,1,2,2,2,3,5,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,11,0,20,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0}); 
    weapon[1] = new Weapon( "Wielki Miecz" , new int[]{3,4,5,6,7,8,9,10,11,12} , new int[]{7,8,9,10,11,12,13,14,17,21} , "Weapons/dlugiMiecz.png", new int[]{3,5,8,9,10,12,14,25,28,0} , new int[]{0,1,2,3,4,5,5,5,7,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,1,2,2,4,4,6,7,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0}); 
    weapon[2] = new Weapon( "Sejmitar" , new int[]{5,7,9,11,14,15,18,21,26,33} , new int[]{8,11,15,18,21,22,25,28,31,38} , "Weapons/sejmitar.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,2,3,3,4,4,6,7,10} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[3] = new Weapon( "Utwardzany Miecz" , new int[]{11,12,13,14,15,16,17,18,19,20} , new int[]{20,21,22,23,24,25,30,35,38,41} , "Weapons/stozkowyMiecz.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,2,3,4,1,2,3,4,1,3} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{5,7,9,10,11,12,14,17,20,22} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[4] = new Weapon( "Szerszy Miecz" , new int[]{15,16,17,18,19,20,21,22,23,24} , new int[]{25,26,27,28,29,30,35,37,42,48} , "Weapons/szerokiMiecz.png", new int[]{0,0,0,0,0,0,0,0,0,2} , new int[]{0,5,5,6,7,8,9,10,0,4} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,2,3,4,1,2,3,4,1,3} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{5,7,9,10,11,12,14,17,20,22} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[5] = new Weapon( "Miecz ze Srebra" , new int[]{21,22,23,24,25,26,27,28,29,32} , new int[]{30,31,33,35,37,40,41,43,46,52} , "Weapons/srebrnyMiecz.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{2,4,7,8,11,14,14,16,17,19} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[6] = new Weapon( "Miecz Xin-Tao" , new int[]{26,27,28,29,30,32,35,37,40,42} , new int[]{33,35,38,41,44,46,49,54,58,60} , "Weapons/mieczPelniKsiezyca.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,1,1,1,1,1,1,1,1,1} , new int[]{2,2,2,3,4,5,6,0,0,0} , new int[]{0,0,0,0,0,0,0,2,2,4} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[7] = new Weapon( "Miecz Klanu Ziu" , new int[]{31,33,36,39,44,47,49,51,55,58} , new int[]{38,40,41,44,46,48,54,58,63,69} , "Weapons/poltorarecznyMiecz.png", new int[]{10,14,16,18,22,24,26,28,29,30} , new int[]{0,0,3,5,7,9,11,14,15,17} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,1,1,2,2,3,4,5,6} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    weapon[8] = new Weapon( "Miecz Barbarzyncow" , new int[]{36,38,40,41,44,47,52,55,58,60} , new int[]{41,44,48,50,61,72,75,83,87,90} , "Weapons/mieczBarbarzyncy.png", new int[]{10,14,16,18,22,24,26,28,29,30} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,1,2,2,2,2,3,4,4,0} , new int[]{0,0,0,0,0,0,0,0,1,2} , new int[]{0,0,0,0,0,0,0,0,0,10} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{2,3,5,7,9,10,11,13,15,17} , new int[]{0,0,0,0,0,0,0,0,0,0});
    weapon[9] = new Weapon( "Zatrute Ostrze" , new int[]{41,44,48,50,61,72,75,83,87,90} , new int[]{44,57,58,63,72,77,80,88,93,99} , "Weapons/zatrutyMiecz.png", new int[]{0,4,6,8,12,14,16,18,19,26} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{10,20,20,20,20,24,30,35,37,46} , new int[]{0,0,0,1,1,2,3,4,5,6} , new int[]{0,0,0,0,0,0,0,0,0,4} , new int[]{3,6,8,9,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});
    weapon[10] = new Weapon( "Miecz Tarona" , new int[]{55,58,63,67,78,87,90,98,106,115} , new int[]{60,70,80,90,100,105,110,115,120,130} , "Weapons/mieczTrytona.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,3,5,6,7,8,9,14,15,16} , new int[]{0,1,2,3,4,5,6,7,8,9} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0}); 
    System.out.println("FINISH: initWeapons()");
  }
  
  private void initArmors(){
    actualArmor = 0;
    maxArmorUpgrade = 10;
    armor = new Armor[maxArmorUpgrade];
    armor[0] = new Armor( "Szata Adepta" , new int[]{5,7,9,12,15,17,19,22,25,30} , "wojoArmor1.png", new int[]{1,2,4,6,13,14,15,17,28,0} , new int[]{0,0,1,1,2,3,3,3,4,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,1,2,2,2,3,5,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,11,0,20,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});  
    armor[1] = new Armor( "Szata Zlodzieja" , new int[]{7,9,12,15,18,23,36,40,45,50} , "wojoArmor2.png", new int[]{1,2,4,6,10,12,13,15,22,0} , new int[]{0,0,1,1,2,3,3,3,4,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,1,2,2,2,3,5,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,11,0,20,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});
    armor[2] = new Armor( "Szata Samurajska" , new int[]{10,15,20,22,25,27,35,42,50,60} , "wojoArmor3.png", new int[]{1,2,4,6,10,12,13,15,22,0} , new int[]{0,0,1,1,2,3,3,3,4,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,1,2,2,2,3,5,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,11,0,20,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});
    armor[3] = new Armor( "Zbroja Nocy" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor4.png", new int[]{1,2,4,6,10,12,13,15,22,0} , new int[]{0,0,1,1,2,3,3,3,4,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,1,2,2,2,3,5,0} , new int[]{0,0,0,0,0,0,0,0,0,1} , new int[]{0,0,3,4,8,0,11,0,20,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0});
    armor[4] = new Armor( "Szata Xio-Li" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor5.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,3,4,5,6,7,9,11,13} , new int[]{0,0,0,0,0,0,0,0,0,2} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{3,6,9,11,12,15,17,21,23,25} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,1});
    armor[5] = new Armor( "Zbroja Samurajska" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor6.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,3,4,5,6,7,9,11,13} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{6,6,7,7,8,8,9,9,11,0} , new int[]{0,0,0,0,0,0,4,6,9,13} , new int[]{0,0,0,0,0,0,0,0,2,3});
    armor[6] = new Armor( "Zbroja Xio-Li" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor7.png", new int[]{0,0,0,5,15,20,20,20,22,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,3,4,5,6,7,9,11,13} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{6,6,7,7,8,8,11,0,0,0} , new int[]{0,0,0,0,0,0,4,6,9,13} , new int[]{0,0,0,0,0,0,0,6,7,9});
    armor[7] = new Armor( "Zbroja Klanu Zin" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor8.png", new int[]{0,0,0,5,15,20,20,20,22,24} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,1,1,2,4,5,6,7,8,0} , new int[]{0,0,0,0,0,0,0,0,0,12} , new int[]{3,6,9,10,14,17,22,24,0,0} , new int[]{6,6,7,7,8,8,13,14,16,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,3,6,9,0});
    armor[8] = new Armor( "Zlota Szata" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor9.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{2,4,6,8,9,10,11,12,13,0} , new int[]{3,6,9,10,14,17,22,24,0,0} , new int[]{6,6,7,7,8,8,13,14,16,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,2,3,6,9,16});
    armor[9] = new Armor( "Zbroja Yami" , new int[]{15,17,23,26,35,47,59,62,65,70} , "wojoArmor10.png", new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{1,2,3,4,5,6,7,8,11,20} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{0,0,0,0,0,0,0,0,0,0} , new int[]{3,7,10,14,20,22,27,28,29,36});
  }
  
  
  protected void initItems(){
    bamboo = new Item("Bambus" , "Bambus wykorzystuje sie w celu ulepszania pancerza oraz broni dystansowej."  , 0);
    wood = new Item("Drewno" , "Wykorzystywane przez miecznika w celach wytwarzania broni." , 0);
    flowers = new Item("Kwiaty" , "Uzywane przez kupcow do produkcji barwnikow.", 0);
    iron = new Item("Zelazo" , "Material powszechnie uzywany do wytwarzania i ulepszania katan i tanto." , 0);
    gold = new Item("Zloto" , "Rzadki material do ulepszania pancerza oraz broni." , 0);
    supplies = new Item("Prowiant" , "Pomaga czasem w negocjacji podczas ulepszania ekwipunku." , 0);
    linen = new Item("Len" , "Tkaniny wykorzystywane sa przez platnerzy do ulepszania ubran i zbroi." , 0);
    lether = new Item("Skora" , "Stosowana w wytwarzaniu ubran i zbroi. Czasami uzywaja jej miecznicy." , 0);
    silk = new Item("Jedwab" , "Rzadko spotykany material stosowany w produkcji szat i zbroi" , 0);
  }
  
  
  //////////////////////////////////////// METODY DODATKOWE   ////////////////////////////////////////////////////////
  
  public void showSkillBar(Enemy enemy){ 
    for(int i = 0; i < 4 ; i ++){
      int x = skillX + (skillsList[i].actualIcon.width*i) , y = skillY; //y=skillsList[i].getY();
      //image(skillsList[i].actualIcon, x , y);
      skillsList[i].renderIcon(x , y);
      skillsList[i].tick( x , y , enemy);
    }
  }
  
  public void showFluids(){   
    fluidHP.showFluid( width/50 , (height - int(width/2.8) - (width/50)) + (int(width/2.8)/2) + ((int(width/2.8)/2)/4) , hpFluid);
    if(hpFluid>0 && !fluidPressed && mousePressed && CD.mouseCollision(fluidHP.getX() , fluidHP.getY() , fluidHP.getX() + fluidHP.getWidth() , fluidHP.getY()+fluidHP.getHeight())){  ///Jeśli ikona fluida została kliknięta
      useHpFluid();
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
    iNewLevel.resize(int(width/1.5) , 0);
    image.resize(int(width/2.3) , 0);
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
