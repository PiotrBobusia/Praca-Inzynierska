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
