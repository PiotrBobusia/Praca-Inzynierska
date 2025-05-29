public class Item {

  String name, description; //Nazwa i opis przemioty
  
  boolean iconResized = false;
  int value;  //Ilość posiadanych przedmiotów
  

  
  Item(String nazwa , String opis , int ilosc){    //Konstruktor do tworzenia przedmiotu - ikony pobierane z magazynu
    name = nazwa;
    description = opis;
    value = ilosc;
  }
  
  
  Item(String nazwa , int ilosc){    //Konstruktor do tworzenia przedmiotu z magazynu ( Przedmioty bez opisu )
    name = nazwa;
    this.value = ilosc;
  }
  
  Item(String nazwa){    //Konstruktor pobiera wszystkie informacje z magazynu ( Przedmioty bez opisu )
    name = nazwa;
  }
  

  
  public boolean renderItem(int x, int y, CollisionDetector CD){  //Służy do wyświetlania przemiotu w plecaku (boolean zwraca informacje czy przemiot w EQ jest aktualnie zaznaczony -> czy wyświetlać jego opis)
    textFont(Magazyn.fontInv2);  //ustawiam fonta
    textAlign(CENTER,TOP);
    if(CD.mouseCollision( x , y , x+magazineIconONWidth() , y+magazineIconONHeight() )){  //item oznaczony
          if(name == "Bambus")  image(Magazyn.bambooIconON, x, y);          //Rysuje przedmiot z magazynu !!!!!!!!!!!
          else if(name == "Drewno")  image(Magazyn.woodIconON, x, y);
          else if(name == "Kwiaty")  image(Magazyn.flowersIconON, x, y);
          else if(name == "Zelazo")  image(Magazyn.ironIconON, x, y);
          else if(name == "Zloto")  image(Magazyn.goldIconON, x, y);
          else if(name == "Prowiant")  image(Magazyn.suppliesIconON, x, y);
          else if(name == "Len")  image(Magazyn.linenIconON, x, y);
          else if(name == "Skora")  image(Magazyn.letherIconON, x, y);
          else if(name == "Jedwab")  image(Magazyn.silkIconON, x, y);
      fill( 255, 250, 250 );
      text( value , x+magazineIconONWidth()/2 ,   y+(magazineIconONWidth()/3)*2 );  //Ilość Atrybutu
      return true;
    } else {  //item nie jest oznaczony
          if(name == "Bambus")  image(Magazyn.bambooIconOFF, x, y);          //Rysuje przedmiot z magazynu !!!!!!!!!!!
          else if(name == "Drewno")  image(Magazyn.woodIconOFF, x, y);
          else if(name == "Kwiaty")  image(Magazyn.flowersIconOFF, x, y);
          else if(name == "Zelazo")  image(Magazyn.ironIconOFF, x, y);
          else if(name == "Zloto")  image(Magazyn.goldIconOFF, x, y);
          else if(name == "Prowiant")  image(Magazyn.suppliesIconOFF, x, y);
          else if(name == "Len")  image(Magazyn.linenIconOFF, x, y);
          else if(name == "Skora")  image(Magazyn.letherIconOFF, x, y);
          else if(name == "Jedwab")  image(Magazyn.silkIconOFF, x, y);
      fill( 0, 0, 0 );
      text( value , x+magazineIconONWidth()/2 ,   y+(magazineIconONWidth()/3)*2 );  //Ilość Atrybutu
      return false;
    }
  }
  
  public boolean renderDescription(int x, int y, float w, float h){ // w - szerokosc okna tekstowego    h - wysokosc okna tekstowego 
    fill( 255, 250, 250 );
    textAlign(LEFT,BOTTOM);
    textFont(Magazyn.fontInv);
    text( name  , x ,   y );
    textAlign(LEFT,TOP);
    textFont(Magazyn.fontInv2);
    text( description  , x ,   y + width/32 , x+w , h );
    return true;
  }
  
  
  public boolean renderOnUpgrade(int x, int y, float w, float h){ // w - szerokosc okna ulepszacza    h - wysokosc okna ulepszacza   (wymaga ikony przedmiotu)
    if(!iconResized) {magazineIconResizer(0 , int(h/4*3)); iconResized = true;}  //resize ikony przemiotu
    
    textFont(Magazyn.fontInv2);  //ustawiam fonta
    
    fill( 36, 36, 36 , 135 );
    rect(x-w/20 , y , w+w/10 , h , 2); //Rysujemy tło (prostokąt)
    
    fill( 255, 250, 250 );
    textAlign(LEFT,CENTER);  //Alignowanie tekstu
    text( value  , x ,   y+h/2 );  //Wyświetlam tekst ile potrzebujemy ulepszacza
    
    if(name == "Bambus")  image( Magazyn.bambooIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );               //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Drewno")  image( Magazyn.woodIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );            //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Kwiaty")  image( Magazyn.flowersIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );         //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Zelazo")  image( Magazyn.ironIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );            //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Zloto")  image( Magazyn.goldIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );             //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Prowiant")  image( Magazyn.suppliesIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );      //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Len")  image( Magazyn.linenIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );              //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Skora")  image( Magazyn.letherIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );           //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    else if(name == "Jedwab")  image( Magazyn.silkIcon , x + (w/11)*3 , y+h/2-magazineIconWidth()/2 );            //mniej więcej na środku wyświetlam ikone i nazwę wymaganego przemiotu
    text( name  , x + (w/11)*3 + magazineIconWidth() , y+h/2 );   //nazwa przedmiotu
    
    int ile = 0;
    
    if(name == "Bambus")  ile = CharacterClass.myHero.bamboo.value;
    else if(name == "Drewno")  ile = CharacterClass.myHero.wood.value;
    else if(name == "Kwiaty")  ile = CharacterClass.myHero.flowers.value;
    else if(name == "Zelazo")  ile = CharacterClass.myHero.iron.value;
    else if(name == "Zloto")  ile = CharacterClass.myHero.gold.value;
    else if(name == "Prowiant")  ile = CharacterClass.myHero.supplies.value;
    else if(name == "Len")  ile = CharacterClass.myHero.linen.value;
    else if(name == "Skora")  ile = CharacterClass.myHero.lether.value;
    else if(name == "Jedwab")  ile = CharacterClass.myHero.silk.value;
    
    
    textAlign(RIGHT,CENTER);  //Alignowanie tekstu
    text( ile  , x+w ,   y+h/2 );  //Wyświetlam tekst ile mamy ulepszacza
    return true;
  }
  
  
  public boolean renderOnFluid(int x, int y , int h){ // w - szerokosc okna ulepszacza    h - wysokosc okna ulepszacza         (wymaga ikony przedmiotu)
  
    if(!iconResized) {magazineIconResizer(0 , int(h/4*3)); iconResized = true;}  //resize ikony przemiotu
    
    textFont(Magazyn.fontInv2);  //ustawiam fonta
    
    
    if(name == "Bambus")  image(Magazyn.bambooIcon,  x  , y+h/2-magazineIconWidth()/2 );    //Rysuje przedmiot z magazynu !
          else if(name == "Drewno")  image(Magazyn.woodIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Kwiaty")  image(Magazyn.flowersIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Zelazo")  image(Magazyn.ironIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Zloto")  image(Magazyn.goldIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Prowiant")  image(Magazyn.suppliesIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Len")  image(Magazyn.linenIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Skora")  image(Magazyn.letherIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Jedwab")  image(Magazyn.silkIcon,  x  , y+h/2-magazineIconWidth()/2 );
    
    fill( 255, 250, 250 );
    textAlign(LEFT,CENTER);  //Alignowanie tekstu
    text( "x"+value  , x + magazineIconWidth() ,   y+h/2 );  //Wyświetlam tekst ile potrzebujemy ulepszacza
    
    return true;
  }
  
  public boolean renderOnDrop(int x, int y , int h, int value){ // w - szerokosc okna ulepszacza    h - wysokosc okna          (wymaga ikony przedmiotu)
  
    if(!iconResized) {magazineIconResizer(0 , int(h/4*3)); iconResized = true;}  //resize ikony przemiotu
    
    textFont(Magazyn.fontInv2);  //ustawiam fonta
    
    
    if(name == "Bambus")  image(Magazyn.bambooIcon, x  , y+h/2-magazineIconWidth()/2 );  //Rysuje przedmiot z magazynu !
          else if(name == "Drewno")  image(Magazyn.woodIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Kwiaty")  image(Magazyn.flowersIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Zelazo")  image(Magazyn.ironIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Zloto")  image(Magazyn.goldIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Prowiant")  image(Magazyn.suppliesIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Len")  image(Magazyn.linenIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Skora")  image(Magazyn.letherIcon,  x  , y+h/2-magazineIconWidth()/2 );
          else if(name == "Jedwab")  image(Magazyn.silkIcon,  x  , y+h/2-magazineIconWidth()/2 );
    
    fill( 255, 250, 250 );
    textAlign(LEFT,CENTER);  //Alignowanie tekstu
    text( "x"+value  , x + magazineIconWidth() ,   y+h/2 );  //Wyświetlam tekst ile potrzebujemy ulepszacza
    
    return true;
  }
  
  
  
  public String getName(){
    return name;
  }
  
  public int getValue(){
    return value;
  }
  
  public void setValue(int value){
    this.value = value;
  }

  public String getDescription(){
    return description;
  }
  
  //////////////////////////////////METODY MAGAZYNOWE
  
  public int magazineIconONWidth(){
    if(name == "Bambus")  return Magazyn.bambooIconON.width;
    else if(name == "Drewno")  return Magazyn.woodIconON.width;
    else if(name == "Kwiaty")  return Magazyn.flowersIconON.width;
    else if(name == "Zelazo")  return Magazyn.ironIconON.width;
    else if(name == "Zloto")  return Magazyn.goldIconON.width;
    else if(name == "Prowiant")  return Magazyn.suppliesIconON.width;
    else if(name == "Len")  return Magazyn.linenIconON.width;
    else if(name == "Skora")  return Magazyn.letherIconON.width;
    else if(name == "Jedwab")  return Magazyn.silkIconON.width;
    else return 0;
  }
  
  public int magazineIconWidth(){
    if(name == "Bambus")  return Magazyn.bambooIcon.width;
    else if(name == "Drewno")  return Magazyn.woodIcon.width;
    else if(name == "Kwiaty")  return Magazyn.flowersIcon.width;
    else if(name == "Zelazo")  return Magazyn.ironIcon.width;
    else if(name == "Zloto")  return Magazyn.goldIcon.width;
    else if(name == "Prowiant")  return Magazyn.suppliesIcon.width;
    else if(name == "Len")  return Magazyn.linenIcon.width;
    else if(name == "Skora")  return Magazyn.letherIcon.width;
    else if(name == "Jedwab")  return Magazyn.silkIcon.width;
    else return 0;
  }
  
  public int magazineIconONHeight(){
    if(name == "Bambus")  return Magazyn.bambooIconON.height;
    else if(name == "Drewno")  return Magazyn.woodIconON.height;
    else if(name == "Kwiaty")  return Magazyn.flowersIconON.height;
    else if(name == "Zelazo")  return Magazyn.ironIconON.height;
    else if(name == "Zloto")  return Magazyn.goldIconON.height;
    else if(name == "Prowiant")  return Magazyn.suppliesIconON.height;
    else if(name == "Len")  return Magazyn.linenIconON.height;
    else if(name == "Skora")  return Magazyn.letherIconON.height;
    else if(name == "Jedwab")  return Magazyn.silkIconON.height;
    else return 0;
  }
  
  public int magazineIconHeight(){
    if(name == "Bambus")  return Magazyn.bambooIcon.height;
    else if(name == "Drewno")  return Magazyn.woodIcon.height;
    else if(name == "Kwiaty")  return Magazyn.flowersIcon.height;
    else if(name == "Zelazo")  return Magazyn.ironIcon.height;
    else if(name == "Zloto")  return Magazyn.goldIcon.height;
    else if(name == "Prowiant")  return Magazyn.suppliesIcon.height;
    else if(name == "Len")  return Magazyn.linenIcon.height;
    else if(name == "Skora")  return Magazyn.letherIcon.height;
    else if(name == "Jedwab")  return Magazyn.silkIcon.height;
    else return 0;
  }
  
  public void magazineIconResizer(int w, int h){
    if(name == "Bambus")   Magazyn.bambooIcon.resize(w , h);
    else if(name == "Drewno")   Magazyn.woodIcon.resize(w , h);
    else if(name == "Kwiaty")   Magazyn.flowersIcon.resize(w , h);
    else if(name == "Zelazo")   Magazyn.ironIcon.resize(w , h);
    else if(name == "Zloto")   Magazyn.goldIcon.resize(w , h);
    else if(name == "Prowiant")   Magazyn.suppliesIcon.resize(w , h);
    else if(name == "Len")   Magazyn.linenIcon.resize(w , h);
    else if(name == "Skora")   Magazyn.letherIcon.resize(w , h);
    else if(name == "Jedwab")   Magazyn.silkIcon.resize(w , h);
  }
  

}










public static class Magazyn{
  public static PFont fontInv;
  public static PFont fontInv2;
  public static PFont fontPopup;
  public static PFont fontPopup2;
  
  public static PImage bambooIcon, bambooIconON, bambooIconOFF;
  public static PImage woodIcon, woodIconON, woodIconOFF;
  public static PImage flowersIcon, flowersIconON, flowersIconOFF;
  public static PImage ironIcon, ironIconON, ironIconOFF;
  public static PImage goldIcon, goldIconON, goldIconOFF;
  public static PImage suppliesIcon, suppliesIconON, suppliesIconOFF;
  public static PImage linenIcon, linenIconON, linenIconOFF;
  public static PImage letherIcon, letherIconON, letherIconOFF;
  public static PImage silkIcon, silkIconON, silkIconOFF;
  
  
  //Booleany do Popup
  public static boolean popupHud;
  public static boolean popupEnemy;
  public static boolean popupFluid;
  public static boolean popupStats;
  public static boolean popupSkills;
  public static boolean popupBackpack;
  public static boolean popupUpgrade;
  public static boolean popupTown;
  public static boolean popupKanji;
  public static boolean popupTest;
  public static boolean popupSkill[];
  
  
  //Dzwięki przeciwników
  public static MusicInterface bearSound;
  public static MusicInterface monkeySound;
  public static MusicInterface wolfSound;
  public static MusicInterface tigerSound;
  public static MusicInterface bossSound1;
  public static MusicInterface bossSound2;
  public static MusicInterface bossSound3;
  public static MusicInterface bossSound4;
  public static MusicInterface bossSound5;
  public static MusicInterface bearmanSound;
  public static MusicInterface demonSound;
  public static MusicInterface demonwolfSound;
  public static MusicInterface entSound;
  public static MusicInterface frogSound;
  public static MusicInterface ghulSound;
  public static MusicInterface orkSound;
  public static MusicInterface pigmanSound;
  
  //Dzwięki walki
  public static MusicInterface dodgeSound;
  public static MusicInterface cutSound1;
  public static MusicInterface cutSound2;
  public static MusicInterface cutSound3;
}




public class Popup{
  PImage image;  //obrazek wyświetlany przy opisie
  PImage exitBtn = loadImage("Popup/btnExit.png");
  boolean noImage;
  String name, description;  //Nazwa opisu np. "Uleczanie" i opis jak to zrobić
  
  int x = width/10, y = width/10;
  int popupWidth = width/10*8, popupHeight = height-width/10*2;
  int btnX, btnY;
  int imgX, imgY;
  int desX, desY;
  int desWidth, desHeight;
  int margin;
  
  
  //Collision Detector
  CollisionDetector CD = new CollisionDetector();
  
  Popup(String n, String d, String path){
    name = n;
    description = d;
    image = loadImage(path);
    noImage = false;
    resizer();
  }
  
  Popup(String n, String d){
    name = n;
    description = d;
    noImage = true;
    resizer();
  }
  
  
  public boolean tick(){  //Zwraca T/F dla mouseBlockera
    if(mousePressed && CD.mouseCollision( btnX , btnY , btnX+exitBtn.width , btnY+exitBtn.height )){
      if(name.equals("TEST")) Magazyn.popupTest=true;
      else if(name.equals("STAN POSTACI")) Magazyn.popupHud=true;
      else if(name.equals("PRZECIWNICY")) Magazyn.popupEnemy=true;
      else if(name.equals("STATYSTYKI")) Magazyn.popupStats=true;
      else if(name.equals("UMIEJETNOSCI")) Magazyn.popupSkills=true;
      else if(name.equals("PLECAK")) Magazyn.popupBackpack=true;
      else if(name.equals("ULEPSZANIE")) Magazyn.popupUpgrade=true;
      else if(name.equals("UNIKANIE")) Magazyn.popupKanji=true;
      else {
        Magazyn.popupSkill[0]=true;
        Magazyn.popupSkill[1]=true;
        Magazyn.popupSkill[2]=true;
        Magazyn.popupSkill[3]=true;
      }
      return true;
    } else return false;
  }
  
  public void render(){
    //Render tła
    fill(21, 21, 21,240);
    stroke(225,180);
    rect( x , y , popupWidth , popupHeight);
    image( exitBtn , btnX , btnY );
    
    //Render nazwy
    textFont(Magazyn.fontPopup);
    textAlign(CENTER,TOP);
    fill(97 , 146, 201);
    text(name , x + popupWidth/2 , y + popupWidth/20);
    
    //Render grafiki
    image(image , imgX , imgY);
    
    //Text area na treść
    textFont(Magazyn.fontPopup2);
    textAlign(LEFT , TOP);
    fill(255);
    text( description , desX , desY , desWidth , desHeight );
  }
  
  private void resizer(){
    exitBtn.resize(int(popupWidth/1.7) , 0);
    image.resize(width/4*3, 0);
    
    btnX = int( x+popupWidth/2-exitBtn.width/2 );
    btnY = int( y+popupHeight-exitBtn.height*1.5 );
    
    imgX = x + popupWidth/2 - image.width/2;
    imgY = y + popupWidth/20 + popupWidth/6;
    
    margin = popupWidth/18;
    desWidth = popupWidth - margin*2;
    desHeight = popupHeight - (imgY-y) - exitBtn.height - margin;
    desX = x+ margin;
    desY = imgY + image.height + margin*2;
  }
  
}







public class LoadingScreenState extends State{
  
  String loadingClass;
  PImage iLoading = loadImage("Menu/loading.png");
  boolean makeDraw = false; //Potrzebne opóźnienie do tworzenia postaci (aby rysowało napis wczytywania)
  
  LoadingScreenState(String loadingClass){
    this.loadingClass = loadingClass;
    iLoading.resize(int(width/1.2) , 0);
  }
  
  public void tick(){
  }
  
  public void render(){
    background(0);
    image(iLoading , width/2-iLoading.width/2 , height/2-iLoading.height/2);
    if(makeDraw){  //Jeśli makeDraw=true tworze postać i zmieniam State na EXP
      if(loadingClass.equals("Wojownik")){
        CharacterClass.setHero(new Wojownik());
        State.setState(exp);
      }
      else if(loadingClass.equals("Inkwizytor")){
        CharacterClass.setHero(new Sura());
        State.setState(exp);
      }
    }
    makeDraw = true;
  }
  
}
