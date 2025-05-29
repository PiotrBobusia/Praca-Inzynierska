class HitCounter{
  
  float startowaWielkoscTekstu = width/20 ;  //wielkość czcionki wyśw. damage
  float finalowaWielkoscTekstu = width/15;  //wielkość czcionki wyśw. damage
  float aktualnaWielkoscTekstu;  //wielkość czcionki wyśw. damage
  PFont fontHit;
  
  private int hitValue;
  private boolean endHit; //zawiera informacjeo tym, czy animacja ostatniego ciosu została zakończona
  
  private float actualX, actualY;
  private int actualRouteLocation;
  private int routeLength = int(height/4);
  
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
