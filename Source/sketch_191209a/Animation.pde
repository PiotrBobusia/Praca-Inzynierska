/*
  Klasa pomocnicza do tworzenia animacji.
  Zawiera ona tablice N elementową w obrazkami które są wyświetlane po kolei.

*/

class Animation {
  PImage[] frame; int animLength;  //frame - przechowuje pojedyźcze klatki    animLength - ilość klatek w animacji
  int actualFrame, runner; //runner to zmianna która wyznacza czas (ilość cykli) do zmiany obrazu
  boolean play;
  
  Animation(PImage images[]){
    frame = images.clone();
    animLength = frame.length;
    actualFrame = 0;
    runner = 0;
    play = true;
  }
  
  void playAnimation(int x, int y, int time, byte type){    ///Odtwarza animacje (  x/y - koordynaty  ,  time - ilość cykli między zmianą wyświetlanej klatki  ,  type:  0 - jeden cykl animacji  1 - animacja zapętlona)
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
  
  void stopAnimation(){  ///Zatrzymuje animacje
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
