class Map {
  public String name; ///Nazwa mapy: Np Miasto 1 lub Lodowa Kraina
  public PImage tlo; ///Tlo mapy wyświetlane po wejściu na jej teren
  private Enemy enemyList[];
  private int actualEnemyNumber;
  private int enemyOnMap;
  
  Map(String BG, int poziom, Enemy enemyL[], int enemyOnMap){    ///Konstruktor pobiera (String z nazwą pliku tła,   Poziom potrzebny do wejścia na mape,    Tablice przeciwników na mapie)
    tlo = loadImage(BG);
    tlo.resize(width,height);  ///dostosowanie tła do ekrany telefonu
    //System.arraycopy( enemyL , 0 , this.enemyList , 0 , 50); //Zapis podanej w argumencie listy do enemyListy
    enemyList = enemyL.clone(); ///Utworzenie kopii listy enemyL do enemyList
    actualEnemyNumber = 0;
    this.enemyOnMap = enemyOnMap - 1;  //Ilość przeciwników na mapie (odejmuje -1 aby wskazywać index w tabeli)
  }
  
  void tick(){
    enemyDie();  //Sprawdza czy przeciwnik żyje
  };
  
  void render() {
    image(tlo,0,0);
    enemyList[actualEnemyNumber].render();  //Wyświetla aktualnego przeciwnika
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
  
  void enemyDie(){  //Sprawdza czy przeciwnik żyje, a jeśli nie to dodaje nam punktów doświadczenia i zmienia przeciwnika na następnego
    if(enemyList[actualEnemyNumber].isDead()){  //Jeśli postać przeciwnika zniknie
      CharacterClass.myHero.addExp(  Math.round(enemyList[actualEnemyNumber].getExp() * getExpFactor())  );    //Dodaje exp postaci
      System.out.println("Exp: " + enemyList[actualEnemyNumber].getExp() + "       |       Real Exp:" + Math.round(enemyList[actualEnemyNumber].getExp() * getExpFactor()) + "     |     Factor" + getExpFactor());
      int oldEnemy = actualEnemyNumber;
      if(!(actualEnemyNumber == enemyOnMap)){
      actualEnemyNumber++;
      enemyList[oldEnemy].setDefault();
      enemyList[oldEnemy].getHitCounter().stop(); //Zatrzymuje wyświetlanie informacji o uderzeniu, żeby nie wyświetlać jej przy cofaniu przeciwników
      }
      
      if(mousePressed) enemyList[actualEnemyNumber].attacked = true;  //Chroni przed natychmiastowym uderzeniem ze strony gracza
    }
  }
  
  private float getExpFactor(){ //Zwraca mnożlik expa w zależnbości od poziomów postaci
    if(enemyList[actualEnemyNumber].getLevel() > CharacterClass.myHero.getLevel()){
      System.out.println("Silniejszy : " + ((enemyList[actualEnemyNumber].getLevel() - CharacterClass.myHero.getLevel())/10.0) );
      return ((enemyList[actualEnemyNumber].getLevel() - CharacterClass.myHero.getLevel())/10.0) +1;
    }
    else if(enemyList[actualEnemyNumber].getLevel() < CharacterClass.myHero.getLevel()){
      System.out.println("Slabszy");
      return 1 - ((CharacterClass.myHero.getLevel() - enemyList[actualEnemyNumber].getLevel())/10.0);
    }
    return 1;
  }
  
  public boolean isLastEnemyDead(){  //Sprawdza i zwraca informacje czy ostatni przeciwnik na mapie został pokonany
    if(actualEnemyNumber == enemyOnMap && getActualEnemy().isDead()){  //Jeśli ostatni przeciwnik zostanie pokonany -> Zwracam true
      return true;
    } else return false;
  }
  
  public void setDefaultOption(){  //Ustawia zmienne tak aby powrót na tą mapę był możliwy przy pętli
    actualEnemyNumber = 0;
    enemyList[enemyOnMap].setDefault();
  }
  
}
