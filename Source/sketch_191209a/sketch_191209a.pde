State menu;
State exp;
Saver saver;

void setup(){
  frameRate(60);  //Ustawienie ilości klatek na sekunde
  fullScreen();
  noStroke();
  fill(0);
  orientation(PORTRAIT);  //orientacja ekranu (uniemożliwia obrót)
  MusicInterface.setSketch(this);  //Ustawia obiekt main w MusicInterface
  
  ///Klasy stanów
  menu = new Menu();
  exp = new Exp();
  
  //Klasa zapisu
  saver = new Saver();
  
  ///State init
  State.setState(menu);  ///Ustawienie stanu początkowego aplikacji (Domyślnie: MENU)
  
}

void draw(){
  State.activeState.tick();    ///Tick i render aktualnego stanu gry
  State.activeState.render();
}
