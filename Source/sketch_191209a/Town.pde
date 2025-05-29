class Town extends State{
  
  MenuBar menuBar = new MenuBar();
  PImage tlo1 = loadImage("Town/NPC_town1.png");
  PImage tlo2 = loadImage("Town/NPC_town2.png");
  private int timer = 0;  //Licznik do rysowania i wskazyswania gdzie jest menu miasta
  
  Town(){
    menuBar.setActiveMiasto();
    resizer();
  }
  
  void tick(){
    menuBar.tick();
    if(timer<120)timer ++;
  }
  
  void render(){
    image(tlo1, 0, height - tlo1.height);
    menuBar.showMenuBar();
    if(timer<30) menuBar.setActiveSwordsmith();
    else if(timer>=30 && timer<60) menuBar.setActiveArmorer();
    else if(timer>=60 && timer<90) menuBar.setActiveMonk();
    else if(timer>=90 && timer<120) menuBar.setActiveZen();
    else menuBar.setActiveMiasto();
  }
  
  private void resizer(){
    tlo1.resize(width , 0);
    tlo2.resize(width , 0);
  }
  
}
