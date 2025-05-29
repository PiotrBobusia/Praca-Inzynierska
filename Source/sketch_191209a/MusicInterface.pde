import cassette.audiofiles.SoundFile;

static class MusicInterface{
    //Ustawianie PApplet
  static private sketch_191209a main;
  static void setSketch(sketch_191209a m){main = m;}
    //Funkcjonalność klasy MusicInterface
  private SoundFile music;
  
  MusicInterface(String path){  //Konstruktor pobierający ścieżkę do dźwięku
    music = new SoundFile(main, path);  //Tworzenie dźwięku
  }
  
  void loop(){ //Odtwarzanie zapętlonego dźwięku
    music.loop();
  }
  
  void pause(){ //Zapauzowanie odtwarzania dźwięku
    music.pause();
  }
  
  void stop(){  //Zatrzymanie odtwarzania dźwięku
    music.stop();
  }
  
  void play(){  //Jednorazowe odtworzenie dźwięku
    music.play();
  }
}
