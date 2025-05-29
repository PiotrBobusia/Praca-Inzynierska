
class Exp extends State{
  
  PImage iLewo= loadImage("charLewo.png");   //Grafika strzałki "ucieczki"
  Random rand;
  private boolean backEnemy; int xLewo, yLewo;  //Koordynaty przycisku "ucieczki"
  
  CollisionDetector CD;
  Map actualMap = null; //Aktualnie rozgrywana mapa
  int actualEnemy = 0; //Aktualny przeciwnik
  int actualMapIndex = 1; //Numer aktualnej mapy
  Map M1, M2, M3;  //Mapy
  
  //MusicInterface MI;
  
  private boolean mouseBlocker; //blokada kliknięć
  Popup popupHud = new Popup("STAN POSTACI","W dolnej czesci ekranu wyswietlane sa informacje o stanie zdrowia naszego bohatera.\nNiebieski pasek przedstawia zdobyte doswiadczenie, a pod min znajdziemy nasze umiejetnosci specjalne.\n\nUzywaj wywaru leczniczego do ulaczania postaci.","Popup/imgPopupHp.png");
  Popup popupEnemy = new Popup("PRZECIWNICY","Aby zaatakowac przeciwnika, kliknij w niego.\nCzerwony szlak nad nim wyznacza jego punkty zdrowia.","Popup/imgPopupEnemy.png");
  Popup popupKanji = new Popup("UNIKANIE","Podczas ataku przeciwnika mamy szanse wykonac unik, ktory uchroni nas przed otrzymaniem ciosu.\n\nKliknij w wyskakujacy przed ciosem przeciwnika znak Kanji, aby wykonac unik.","Popup/imgPopupKanji.png");
  
  MenuBar menuBar;  //Deklaracja górnego menu
  
  
  Exp(){    //Konstruktor
    init();  //Inicjalizacja Map i przeciwników
    CD = new CollisionDetector();  
    rand = new Random();
    backEnemy = false;
    iLewo.resize(0 , height/13);   xLewo = 0;   yLewo = height / 2 - iLewo.height/2;
    
    
    menuBar = new MenuBar(); //Stworzenie obiektu paska menu
    menuBar.setActivePodroz();  //Ustawienie stanu Podróży jako aktywny
    mouseBlocker = false;
  } 
  
  public void tick(){
    if(!Magazyn.popupHud) {mouseBlocker = popupHud.tick(); return;} //Ints. paska zdrowia
    if(!mouseBlocker && !Magazyn.popupEnemy) {mouseBlocker = popupEnemy.tick(); return;} //Ints. ataku
    if(!mouseBlocker && !Magazyn.popupKanji) {mouseBlocker = popupKanji.tick(); return;} //Ints. unikania
    if(actualMap.isLastEnemyDead()) goToNextMap();  //Zmiana mapy po pokonaniu ost. przeciwnika
    actualMap.tick();   //Tick aktualnej mapy
    CharacterClass.myHero.tick();  //Tick bohatera
    actualMap.getActualEnemy().tick(CharacterClass.myHero);  //Tick aktualnego przeciwnika
    backHero();  //cofanie bohatera po śmierci
    
    if(actualMap.getEnemyNumber() > 0 && !backEnemy && mousePressed && CD.mouseCollision( xLewo , yLewo , xLewo + iLewo.width , yLewo + iLewo.height )){  //przycisk strzałki w lewo (cofania przeciwnika)
       actualMap.backEnemy(rand.nextInt(2)+1);
       backEnemy = true;
    }
    
    if(!mousePressed) {backEnemy = false; mouseBlocker = false;}  //Zwolnienie przysicku palca
    
    menuBar.tick();  //Tick paska menu
  }
  
  public void render(){
    actualMap.render();  //Render mapy
    CharacterClass.myHero.showSkillBar(actualMap.getActualEnemy());  //Render IKON umiejętności
    for(int i = 0 ; i < 5 ; i++)CharacterClass.myHero.skillsList[i].render();  //metoda render umiejętności
    CharacterClass.myHero.healthBar.render();  //Render paska zdrowia bohatera
    CharacterClass.myHero.render();  //render klasy bohatera
    
    if(actualMap.getEnemyNumber() > 0) image(iLewo, xLewo , yLewo); //Strzałka cofania przeciwnika o jeden lub dwa
    
    menuBar.showMenuBar();  //Render paska menu
    if(!Magazyn.popupHud)popupHud.render();    //Renderowanie POPUPów
    else if (!Magazyn.popupEnemy)popupEnemy.render();
    else if (!Magazyn.popupKanji)popupKanji.render();
  }
  
  
  public void backHero(){  ///Metoda sprawdzająca i cofająca postać po śmierci o trzech przeciwników do tyłu
    if(CharacterClass.myHero.checkDie()){
      actualMap.backEnemy(3);
      CharacterClass.myHero.healthToMax();
      CharacterClass.myHero.energyToMax();
    }
  }
  
  public void init(){
    
    Enemy listaTest[] = new Enemy[50];                                         //Lv Atk AtkS HP                                //S W F I G S L L S
  listaTest[0] = new Enemy("Glodny_Zablakany_Pies.png", "Glodny Zablakany Pies", 1, 4, 100, 150, 10, 10,                new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      1);      
  listaTest[1] = new Enemy("Dziki_Pies.png", "Dziki Pies", 1, 5, 90, 200, 10, 13,                                       new int[]{1,0,0,0,0,0,0,0,0},new int[]{40,0,0,0,0,0,0,0,0},                     1);
  listaTest[2] = new Enemy("Glodny_Wilk.png", "Glodny Wilk", 2, 7, 100, 220, 10, 18,                                    new int[]{0,0,0,0,0,0,0,1,0},new int[]{0,0,0,0,0,0,0,50,0},                     1);
  listaTest[3] = new Enemy("Wilk.png", "Wilk", 2, 11, 100, 230, 120, 21,                                                new int[]{0,0,0,0,0,0,0,2,0},new int[]{0,0,0,0,0,0,0,50,0},                     1);
  listaTest[4] = new Enemy("Alfa_Wilk.png", "Alfa Wilk", 2, 13, 100, 250, 140, 21,                                      new int[]{0,0,0,0,0,0,0,2,0},new int[]{0,0,0,0,0,0,0,60,0},                     1);
  listaTest[5] = new Enemy("Glodny_Alfa_Wilk.png", "Glodny Alfa Wilk", 2, 15, 100, 250, 140, 24,                        new int[]{0,0,0,0,0,0,0,2,0},new int[]{0,0,0,0,0,0,0,60,0},                     1);
  listaTest[6] = new Enemy("Nieb._Wilk.png", "Nieb. Wilk", 3, 18, 100, 250, 10, 26,                                     new int[]{0,0,0,0,0,2,0,3,0},new int[]{0,0,0,0,0,60,0,60,0},                    1);
  listaTest[7] = new Enemy("Glodny_Nieb._Wilk.png", "Glodny Nieb. Wilk", 3, 20, 100, 260, 120, 26,                      new int[]{0,0,0,0,0,2,0,3,0},new int[]{0,0,0,0,0,60,0,60,0},                    1);
  listaTest[8] = new Enemy("Glodny_Dzik.png", "Glodny Dzik", 3, 21, 100, 340, 10, 31,                                   new int[]{0,0,5,0,0,0,0,1,0},new int[]{0,0,30,0,0,0,0,80,0},                    2); 
  listaTest[9] = new Enemy("Dzik.png", "Dzik", 4, 27, 100, 340, 10, 31,                                                 new int[]{0,0,5,0,0,0,0,1,0},new int[]{0,0,60,0,0,0,0,85,0},                    2);
  listaTest[10] = new Enemy("Przeklety_Wilk.png", "Przeklety Wilk", 4, 29, 100, 340, 10, 30,                            new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      1);
  listaTest[11] = new Enemy("Nieb._Alfa_Wilk.png", "Nieb. Alfa Wilk", 4, 31, 100, 380, 10, 36,                          new int[]{1,0,0,0,0,2,0,3,0},new int[]{10,0,0,0,0,70,0,90,0},                   1);
  listaTest[12] = new Enemy("Glodny_Nieb._Alfa_Wilk.png", "Glodny Nieb. Alfa Wilk", 5, 33, 100, 380, 10, 38,            new int[]{3,0,0,0,0,3,0,4,0},new int[]{20,0,0,0,0,70,0,90,0},                   1);
  listaTest[13] = new Enemy("Przeklety_Alfa_Wilk.png", "Przeklety Alfa Wilk", 5, 36, 100, 380, 10, 30,                  new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      1);        
  listaTest[14] = new Enemy("Glodny_Czerw._Dzik.png", "Glodny Czerw. Dzik", 5, 39, 100, 390, 10, 30,                    new int[]{0,0,3,0,1,0,0,1,0},new int[]{0,0,60,0,10,0,0,85,0},                   2);
  listaTest[15] = new Enemy("Czerw._Dzik.png", "Czerw. Dzik", 5, 40, 100, 410, 10, 30,                                  new int[]{0,1,3,0,1,0,0,1,0},new int[]{0,90,60,0,10,0,0,85,0},                  2);
  listaTest[16] = new Enemy("Przeklety_Nieb._Wilk.png", "Przeklety Nieb. Wilk", 5, 41, 100, 540, 10, 35,                new int[]{0,0,0,4,0,5,0,3,0},new int[]{0,0,0,67,0,60,0,60,0},                   1);
  listaTest[17] = new Enemy("Niedzwiedz.png", "Niedzwiedz", 6, 44, 100, 540, 10, 40,                                    new int[]{0,3,0,4,1,0,5,0,0},new int[]{0,80,0,55,10,0,10,0,0},                  2);
  listaTest[18] = new Enemy("Glodny_Niedzw.png", "Glodny Niedzw.", 6, 47, 100, 540, 10, 42,                             new int[]{0,3,0,4,1,0,5,0,0},new int[]{0,80,0,55,10,0,10,0,0},                  2);
  listaTest[19] = new Enemy("Szary_Wilk.png", "Szary Wilk", 6, 50, 100, 560, 10, 44,                                    new int[]{1,0,0,0,0,2,0,3,0},new int[]{10,0,0,0,0,70,0,90,0},                   1);
  listaTest[20] = new Enemy("Glodny_Szary_Wilk.png", "Glodny Szary Wilk", 6, 54, 100, 560, 10, 44,                      new int[]{1,0,0,0,0,2,0,3,0},new int[]{10,0,0,0,0,70,0,90,0},                   1);
  listaTest[21] = new Enemy("Przekl._Nieb._Alfa_Wilk.png", "Przekl. Nieb. Alfa Wilk", 6, 56, 100, 590, 10, 47,          new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      1);
  listaTest[22] = new Enemy("Niedzw._Grizzly.png", "Niedzw. Grizzly", 6, 60, 100, 590, 10, 47,                          new int[]{0,3,0,4,3,0,5,0,0},new int[]{0,80,0,55,20,0,40,0,0},                  2);
  listaTest[23] = new Enemy("Glodny_Niedzw._Grizzly.png", "Glodny Niedzw. Grizzly", 7, 64, 100, 590, 10, 49,            new int[]{0,0,0,8,3,0,0,0,5},new int[]{0,0,0,75,20,0,0,0,25},                   2);
  listaTest[24] = new Enemy("Przeklety_Czerw._Dzik.png", "Przeklety Czerw. Dzik", 7, 66, 100, 600, 10, 50,              new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaTest[25] = new Enemy("Szary_Alfa_Wilk.png", "Szary Alfa Wilk", 7, 68, 100, 600, 10, 50,                          new int[]{20,0,0,7,0,2,0,3,0},new int[]{35,0,0,50,0,70,0,90,0},                 2);
  listaTest[26] = new Enemy("Glodny_Szary_Alfa_Wilk.png", "Glodny Szary Alfa Wilk", 7, 70, 100, 600, 10, 50,            new int[]{0,0,0,0,0,10,3,0,1},new int[]{0,0,0,0,0,60,30,0,10},                  2);
  listaTest[27] = new Enemy("Przeklety_Niedzw.png", "Przeklety Niedzw.", 8, 71, 100, 650, 10, 50,                       new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaTest[28] = new Enemy("Glodny_Tygrys.png", "Glodny Tygrys", 8, 74, 100, 650, 10, 50,                              new int[]{0,0,0,0,0,0,10,10,10},new int[]{0,0,0,0,0,0,50,60,10},                3);
  listaTest[29] = new Enemy("Tygrys.png", "Tygrys", 8, 76, 100, 650, 10, 50,                                            new int[]{0,0,0,0,0,0,10,10,10},new int[]{0,0,0,0,0,0,60,70,20},                3);
  listaTest[30] = new Enemy("Glodny_Czar._Niedzw.png", "Glodny Czar. Niedzw.", 8, 78, 100, 730, 10, 60,                 new int[]{0,5,10,0,0,0,10,10,0},new int[]{0,60,10,0,0,0,50,60,0},               2);
  listaTest[31] = new Enemy("Czar._Niedzw.png", "Czar. Niedzw.", 8, 80, 100, 730, 10, 60,                               new int[]{0,0,10,15,0,0,10,10,0},new int[]{0,0,10,50,0,0,50,60,0},              2);
  listaTest[32] = new Enemy("Przekl._Niedzw._Grizzly.png", "Przekl. Niedzw. Grizzly", 9, 84, 100, 730, 10, 60,          new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaTest[33] = new Enemy("Braz._Niedzw.png", "Braz. Niedzw.", 9, 87, 100, 730, 10, 60,                               new int[]{0,0,10,15,0,0,10,13,1},new int[]{0,0,10,50,0,0,50,70,30},             2);
  listaTest[34] = new Enemy("Glodny_Braz._Niedzw.png", "Glodny Braz. Niedzw.", 9, 89, 60, 800, 10, 50,                  new int[]{30,0,30,0,0,0,0,0,0},new int[]{60,0,40,0,0,0,0,0,0},                  2);
  listaTest[35] = new Enemy("Przeklety_Szary_Alfa_Wilk.png", "Przeklety Szary Alfa Wilk", 9, 93, 90, 800, 10, 60,       new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaTest[36] = new Enemy("Slaby_Malpi_Zolnierz.png", "Slaby Malpi Zolnierz", 10, 42, 35, 800, 570, 70,               new int[]{50,50,0,0,0,0,0,0,0},new int[]{70,70,0,0,0,0,0,0,0},                  4);
  listaTest[37] = new Enemy("Bialy_Tygrys.png", "Bialy Tygrys", 10, 120, 100, 800, 10, 80,                              new int[]{0,0,0,20,10,0,0,0,0},new int[]{0,0,0,70,50,0,0,0,0},                  3);
  listaTest[38] = new Enemy("Glodny_Bialy_Tygrys.png", "Glodny Bialy Tygrys", 10, 146, 100, 850, 10, 90,                new int[]{0,0,0,22,13,52,0,0,0},new int[]{0,0,0,70,50,25,0,0,0},                3);
  listaTest[39] = new Enemy("Przeklety_Czar._Niedzw.png", "Przeklety Czar. Niedzw.", 10, 154, 100, 850, 10, 90,         new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      3);
  listaTest[40] = new Enemy("Przeklety_Tygrys.png", "Przeklety Tygrys", 11, 168, 100, 900, 10, 90,                      new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      3);
  listaTest[41] = new Enemy("Slaby_Malpi_Miotacz.png", "Slaby Malpi Miotacz", 11, 113, 48, 900, 10, 100,                new int[]{30,30,30,30,30,30,30,30,30},new int[]{30,20,10,20,10,50,30,20,10},    4);
    for(int i=42; i<50; i++) listaTest[i] = new Enemy("Przeklety_Tygrys.png", "Przeklety Tygrys", 12, 180, 100, 1010, 10, 120, new int[]{30,30,30,30,30,30,30,30,30},new int[]{30,20,10,20,10,50,30,20,10},3);
    M1 = new Map("Maps/expBg1.png",1,listaTest , 50);
    actualMap = M1;
    
    
   Enemy listaM2[] = new Enemy[40];                                           //Lv Atk AtkS HP                                //S W F I G S L L S
  listaM2[0] = new Enemy("Przeklety_Nieb._Wilk.png", "Przeklety Nieb. Wilk", 15, 181, 80, 1440, 10, 200,                new int[]{0,0,0,14,0,5,0,13,0},new int[]{0,0,0,67,0,60,0,60,0},                   1);
  listaM2[1] = new Enemy("Niedzwiedz.png", "Niedzwiedz", 16, 184, 80, 1450, 10, 220,                                    new int[]{0,3,0,4,11,0,15,0,0},new int[]{0,80,0,55,10,0,10,0,0},                  2);
  listaM2[2] = new Enemy("Glodny_Niedzw.png", "Glodny Niedzw.", 16, 187, 80, 1460, 10, 230,                             new int[]{0,3,0,4,11,0,15,0,0},new int[]{0,80,0,55,10,0,10,0,0},                  2);
  listaM2[3] = new Enemy("Szary_Wilk.png", "Szary Wilk", 16, 190, 80, 1450, 10, 240,                                    new int[]{21,0,0,0,0,2,0,3,0},new int[]{10,0,0,0,0,70,0,90,0},                   1);
  listaM2[4] = new Enemy("Glodny_Szary_Wilk.png", "Glodny Szary Wilk", 16, 199, 80, 1460, 10, 250,                      new int[]{21,0,0,0,0,2,0,3,0},new int[]{10,0,0,0,0,70,0,90,0},                   1);
  listaM2[5] = new Enemy("Przekl._Nieb._Alfa_Wilk.png", "Przekl. Nieb. Alfa Wilk", 16, 211, 80, 1470, 10, 300,          new int[]{0,0,0,8,8,8,0,0,0},new int[]{0,0,0,24,24,24,0,0,0},                      1);
  listaM2[6] = new Enemy("Niedzw._Grizzly.png", "Niedzw. Grizzly", 16, 222, 80, 1570, 10, 330,                          new int[]{0,3,0,14,3,0,5,0,0},new int[]{0,80,0,55,20,0,40,0,0},                  2);
  listaM2[7] = new Enemy("Glodny_Niedzw._Grizzly.png", "Glodny Niedzw. Grizzly", 17, 223, 80, 1680, 10, 340,            new int[]{0,0,0,28,3,0,0,0,5},new int[]{0,0,0,75,20,0,0,0,25},                   2);
  listaM2[8] = new Enemy("Przeklety_Czerw._Dzik.png", "Przeklety Czerw. Dzik", 17, 233, 80, 1690, 10, 350,              new int[]{58,0,0,0,0,0,0,0,0},new int[]{50,0,0,0,0,0,0,0,0},                      2);
  listaM2[9] = new Enemy("Szary_Alfa_Wilk.png", "Szary Alfa Wilk", 17, 233, 80, 1690, 10, 360,                          new int[]{20,0,0,17,0,2,0,13,0},new int[]{35,0,0,50,0,70,0,90,0},                 2);
  listaM2[10] = new Enemy("Glodny_Szary_Alfa_Wilk.png", "Glodny Szary Alfa Wilk", 17, 244, 80, 1700, 10, 370,            new int[]{0,0,0,0,0,10,3,0,11},new int[]{0,0,0,0,0,60,30,0,10},                  2);
  listaM2[11] = new Enemy("Przeklety_Niedzw.png", "Przeklety Niedzw.", 18, 255, 80, 1710, 10, 380,                       new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaM2[12] = new Enemy("Glodny_Tygrys.png", "Glodny Tygrys", 18, 255, 80, 1770, 10, 390,                              new int[]{0,0,0,0,0,0,20,15,15},new int[]{0,0,0,0,0,0,50,60,10},                3);
  listaM2[13] = new Enemy("Tygrys.png", "Tygrys", 18, 255, 80, 1782, 10, 400,                                            new int[]{0,0,0,0,0,0,10,20,27},new int[]{0,0,0,0,0,0,60,70,20},                3);
  listaM2[14] = new Enemy("Glodny_Czar._Niedzw.png", "Glodny Czar. Niedzw.", 18, 255, 80, 1830, 10, 410,                 new int[]{0,5,24,0,0,0,28,10,0},new int[]{0,60,10,0,0,0,50,60,0},               2);
  listaM2[15] = new Enemy("Czar._Niedzw.png", "Czar. Niedzw.", 18, 266, 80, 1940, 10, 420,                               new int[]{0,0,30,15,0,0,10,20,0},new int[]{0,0,10,50,0,0,50,60,0},              2);
  listaM2[16] = new Enemy("Przekl._Niedzw._Grizzly.png", "Przekl. Niedzw. Grizzly", 19, 266, 80, 2000, 10, 430,          new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaM2[17] = new Enemy("Braz._Niedzw.png", "Braz. Niedzw.", 19, 266, 80, 2100, 10, 440,                               new int[]{0,0,10,15,0,0,10,23,1},new int[]{0,0,10,50,0,0,50,70,30},             2);
  listaM2[18] = new Enemy("Glodny_Braz._Niedzw.png", "Glodny Braz. Niedzw.", 19, 277, 60, 2200, 10, 450,                  new int[]{30,0,30,0,0,0,0,0,0},new int[]{60,0,40,0,0,0,0,0,0},                  2);
  listaM2[19] = new Enemy("Przeklety_Szary_Alfa_Wilk.png", "Przeklety Szary Alfa Wilk", 19, 288, 80, 2370, 10, 450,       new int[]{0,0,0,0,0,0,0,0,0},new int[]{0,0,0,0,0,0,0,0,0},                      2);
  listaM2[20] = new Enemy("Slaby_Malpi_Zolnierz.png", "Slaby Malpi Zolnierz", 20, 300, 35, 2450, 570, 450,               new int[]{50,50,0,0,0,0,0,0,0},new int[]{80,80,0,0,0,0,0,0,0},                  4);
  listaM2[21] = new Enemy("Bialy_Tygrys.png", "Bialy Tygrys", 20, 322, 70, 2590, 10, 500,                              new int[]{0,0,0,40,20,0,0,0,0},new int[]{0,0,0,70,50,0,0,0,0},                  3);
  listaM2[22] = new Enemy("Glodny_Bialy_Tygrys.png", "Glodny Bialy Tygrys", 21, 333, 80, 2710, 10, 500,                new int[]{0,0,0,62,33,52,0,0,0},new int[]{0,0,0,70,50,25,0,0,0},                3);
  listaM2[23] = new Enemy("Przeklety_Czar._Niedzw.png", "Przeklety Czar. Niedzw.", 21, 355, 80, 2940, 10, 500,         new int[]{0,0,0,0,0,0,0,0,10},new int[]{0,0,0,0,0,0,0,0,10},                      3);
  listaM2[24] = new Enemy("Przeklety_Tygrys.png", "Przeklety Tygrys", 22, 377, 80, 3150, 10, 550,                      new int[]{11,0,0,0,0,0,0,0,0},new int[]{90,0,0,0,0,0,0,0,0},                      3);
  listaM2[25] = new Enemy("Slaby_Malpi_Miotacz.png", "Slaby Malpi Miotacz", 23, 233, 48, 3400, 10, 550,                new int[]{11,11,11,11,0,0,0,0,0},new int[]{90,56,75,46,0,0,0,0,0},               4);
  listaM2[26] = new Enemy("Maps/Enemy/M2/1.png", "Srebrny Wilk", 30, 250, 80, 3600, 10, 570,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               1);
  listaM2[27] = new Enemy("Maps/Enemy/M2/2.png", "Siwy Dzik", 32, 280, 80, 3800, 10, 600,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               2);
  listaM2[28] = new Enemy("Maps/Enemy/M2/3.png", "Genikulata", 33, 280, 80, 4000, 10, 640,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               8);
  listaM2[29] = new Enemy("Maps/Enemy/M2/4.png", "Skalny Golem", 34, 280, 80, 4100, 10, 680,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               7);
  listaM2[30] = new Enemy("Maps/Enemy/M2/5.png", "Wojownik Ognia", 35, 300, 80, 4300, 10, 700,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               6);
  listaM2[31] = new Enemy("Maps/Enemy/M2/6.png", "Lodowy Golem", 36, 310, 75, 4600, 10, 700,                                  new int[]{0,0,0,30,30,30,30,0,0},new int[]{0,0,0,60,70,60,70,0,0},                 7);
  listaM2[32] = new Enemy("Maps/Enemy/M2/7.png", "Lisica Tsudzurao", 37, 320, 75, 4800, 10, 700,                                  new int[]{0,0,0,30,30,30,30,0,0},new int[]{0,0,0,60,70,60,70,0,0},               5);
  listaM2[33] = new Enemy("Maps/Enemy/M2/8.png", "Wojownik Seikatsu", 38, 330, 75, 4900, 10, 700,                                  new int[]{0,0,0,30,30,30,30,0,0},new int[]{0,0,0,60,70,60,70,0,0},               9);
  listaM2[34] = new Enemy("Maps/Enemy/M2/9.png", "Lodowy Demon", 39, 350, 75, 5100, 10, 730,                                  new int[]{0,0,0,30,30,30,30,0,0},new int[]{0,0,0,60,70,60,70,0,0},               6);
  listaM2[35] = new Enemy("Maps/Enemy/M2/10.png", "Lodowy Szatan", 40, 350, 75, 5300, 10, 770,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},               10);
  listaM2[36] = new Enemy("Maps/Enemy/M2/11.png", "Zimowy Demon Hebi", 41, 350, 75, 5400, 10, 770,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},               8);
  listaM2[37] = new Enemy("Maps/Enemy/M2/12.png", "Czart", 42, 370, 70, 5500, 10, 770,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},               11);
  listaM2[38] = new Enemy("Maps/Enemy/M2/13.png", "Malthael", 43, 400, 70, 5800, 10, 810,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},               6);
  listaM2[39] = new Enemy("Maps/Enemy/M2/14.png", "Modeusz", 44, 420, 70, 6000, 10, 850,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},              12);
  M2 = new Map("Maps/expBg2.png",15,listaM2 , 40); 
  
  
   Enemy listaM3[] = new Enemy[13];                            //Lv Atk AtkS HP                                                       //S W F I G S L L S
  listaM3[0] = new Enemy("Maps/Enemy/M2/4.png", "Skalny Golem", 34, 280, 80, 3500, 10, 600,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               7);
  listaM3[1] = new Enemy("Maps/Enemy/M2/5.png", "Wojownik Ognia", 35, 300, 80, 3500, 10, 600,                                  new int[]{11,11,11,11,11,0,0,0,0},new int[]{90,56,75,46,64,0,0,0,0},               6);
  listaM3[2] = new Enemy("Maps/Enemy/M2/12.png", "Czart", 42, 370, 70, 5300, 10, 670,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,20},               11);
  listaM3[3] = new Enemy("Maps/Enemy/M3/1.png", "Demoniczny Wilk", 45, 350, 70, 5300, 10, 870,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,60,60,60,60,60},               5);
  listaM3[4] = new Enemy("Maps/Enemy/M3/2.png", "Drzewiec", 47, 370, 68, 5500, 10, 840,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,60,60,60,60,60},               7);
  listaM3[5] = new Enemy("Maps/Enemy/M3/3.png", "Stary Drzewiec", 49, 450, 67, 5600, 10, 900,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,60,60,60,60,60},               7);
  listaM3[6] = new Enemy("Maps/Enemy/M3/4.png", "Skorpion", 52, 480, 67, 5700, 10, 940,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,60,30,60,20,20},               12);
  listaM3[7] = new Enemy("Maps/Enemy/M3/5.png", "Skorpion Wylkaniczny", 54, 500, 64, 5800, 10, 990,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,60,60,30,60,20},               12);
  listaM3[8] = new Enemy("Maps/Enemy/M3/6.png", "Skorpion Demon", 55, 530, 64, 6000, 10, 1100,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,10,30,30,20,60},               6);
  listaM3[9] = new Enemy("Maps/Enemy/M3/7.png", "Demoniczny Dzikus", 57, 570, 64, 6300, 10, 1200,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,70,70,70,70,20},               10);
  listaM3[10] = new Enemy("Maps/Enemy/M3/8.png", "Legion", 59, 590, 63, 6900, 10, 1500,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,80,30,80,80,80},               5);
  listaM3[11] = new Enemy("Maps/Enemy/M3/9.png", "Kosiarz", 62, 620, 63, 7900, 10, 2000,                                  new int[]{0,0,0,0,10,30,30,20,20},new int[]{0,0,0,0,90,90,90,90,90},               9);
  listaM3[12] = new Enemy("Maps/Enemy/M3/10.png", "Jaakuna Keshin", 100, 750, 60, 9999, 10, 10000,                       new int[]{0,0,0,70,100,0,110,120,120},new int[]{0,0,0,70,80,0,90,90,90},           13);
  M3 = new Map("Maps/expBg3.png",40,listaM3 , 13); 
  }
  
  
  public void goToNextMap(){
    if(actualMapIndex == 1){
      actualMapIndex = 2;
      actualMap = M2;
      M1.setDefaultOption();
    }
    else if(actualMapIndex == 2){
      actualMapIndex = 3;
      actualMap = M3;
      M2.setDefaultOption();
    }
    else if(actualMapIndex == 3){
      actualMapIndex = 1;
      actualMap = M1;
      M3.setDefaultOption();
    }
  }
  
}
