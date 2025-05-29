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
