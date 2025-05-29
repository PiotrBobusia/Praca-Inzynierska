class ONas extends State{
  
  PImage iBackground= loadImage("menuBg.png");
  PImage iExit = loadImage("invExit.png"); 
  PFont font = createFont("Fonts/Ubuntu.ttf",width/20);
  
  CollisionDetector CD = new CollisionDetector();
  
  
  ONas(){
    resizer();  
  }
  
  void tick(){
    if(mousePressed && CD.mouseCollision(width - iExit.width , 0 , width , iExit.height)){
      State.setState(new Menu());
    }
  }
  
  void render(){
    image( iBackground , 0 , 0 );
    textFont(font);
    fill(255);
    textAlign(CENTER);
    text( "Autor: Piotr Bobusia"   ,   width/2   ,   height/4 );
    text( "Studia: 4 rok, niestacjonarne"   , width/2 ,    height/3 );
    text( "Index: 101272"     ,   width/2  ,   height/2);
    image(iExit , width - iExit.width , 0);
  }
  
  
  
  private void resizer(){
    iBackground.resize(width , height);
    iExit.resize(width/10 , 0);
  }
}
