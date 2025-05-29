class Zen extends State{
  
  PImage tlo;
  PImage buttonSaveSlot1ON, buttonSaveSlot1OFF;
  PImage buttonSaveSlot2ON, buttonSaveSlot2OFF;
  PImage buttonSaveSlot3ON, buttonSaveSlot3OFF;
  private boolean saved = false;
  
  private int btnS1X, btnS1Y;
  private int btnS2X, btnS2Y;
  private int btnS3X, btnS3Y;
  
  MenuBar menuBar = new MenuBar();
  CollisionDetector CD = new CollisionDetector();
  //Saver saver = new Saver();
  
  //Interfejs muzyczny
  //Dzwięki przycisków
  MusicInterface zenSound = new MusicInterface("Town/Sounds/ZenSave.wav"); 
  
  Zen(){
    loadImages();
    
    menuBar.setActiveZen();
  }
  
  void tick(){
    menuBar.tick();
    
    if(mousePressed && !saved && CD.mouseCollision(btnS1X , btnS1Y , btnS1X+buttonSaveSlot1ON.width , btnS1Y+buttonSaveSlot1ON.height)){
      saved = true;
      saver.saveGame(1);
      saver.saveGame(1);
      saver.saveGame(1);
      zenSound.play();
    }
    
    if(mousePressed && !saved && CD.mouseCollision(btnS2X , btnS2Y , btnS2X+buttonSaveSlot1ON.width , btnS2Y+buttonSaveSlot1ON.height)){
      saved = true;
      saver.saveGame(2);
      saver.saveGame(2);
      saver.saveGame(2);
      zenSound.play();
    }
    
    if(mousePressed && !saved && CD.mouseCollision(btnS3X , btnS3Y , btnS3X+buttonSaveSlot1ON.width , btnS3Y+buttonSaveSlot1ON.height)){
      saved = true;
      saver.saveGame(3);
      saver.saveGame(3);
      saver.saveGame(3);
      zenSound.play();
    }
    
  };
  
  void render(){
    image(tlo, 0, height - tlo.height); //TŁO
    menuBar.render();
    
    if(!saved) {image(buttonSaveSlot1ON , btnS1X , btnS1Y);}
    else image(buttonSaveSlot1OFF , btnS1X , btnS1Y);
    
    if(!saved) {image(buttonSaveSlot2ON , btnS2X , btnS2Y);}
    else image(buttonSaveSlot2OFF , btnS2X , btnS2Y);
    
    if(!saved) {image(buttonSaveSlot3ON , btnS3X , btnS3Y);}
    else image(buttonSaveSlot3OFF , btnS3X , btnS3Y);
  };
  
  
  
  private void loadImages(){
    tlo = loadImage("Town/NPCzen.png");
    
    buttonSaveSlot1ON = loadImage("Town/Zen/btnSaveSlot1ON.png");
    buttonSaveSlot1OFF = loadImage("Town/Zen/btnSaveSlot1OFF.png");
    
    buttonSaveSlot2ON = loadImage("Town/Zen/btnSaveSlot2ON.png");
    buttonSaveSlot2OFF = loadImage("Town/Zen/btnSaveSlot2OFF.png");
    
    buttonSaveSlot3ON = loadImage("Town/Zen/btnSaveSlot3ON.png");
    buttonSaveSlot3OFF = loadImage("Town/Zen/btnSaveSlot3OFF.png");
    
    resizer();
  }
  
  private void resizer(){
    tlo.resize(width , 0);
    
    buttonSaveSlot1ON.resize(int(width/2) , 0);
    buttonSaveSlot1OFF.resize(int(width/2) , 0);
    buttonSaveSlot2ON.resize(int(width/2) , 0);
    buttonSaveSlot2OFF.resize(int(width/2) , 0);
    buttonSaveSlot3ON.resize(int(width/2) , 0);
    buttonSaveSlot3OFF.resize(int(width/2) , 0);
    
    btnS1X = width/2 - buttonSaveSlot1ON.width/2;
    btnS1Y = height/4 - buttonSaveSlot1ON.height/2;
    
    btnS2X = width/2 - buttonSaveSlot1ON.width/2;
    btnS2Y = btnS1Y + buttonSaveSlot1ON.height*2;
    
    btnS3X = width/2 - buttonSaveSlot1ON.width/2;
    btnS3Y = btnS2Y + buttonSaveSlot1ON.height*2;
  };
  
  
 
  
  
  
  
}
