class CharSelection extends State{
    State exp;
  
    //Obiekty pomocnicze
    CollisionDetector CD;
  
    ///Grafiki
        ///Tło
    PImage iBackground= loadImage("charBg2.png");
    PImage iLoading= loadImage("Menu/loading.png");
    int loadingX, loadingY;
    boolean isLoading = false;
     
        ///Przyciski
    PImage iWybierz= loadImage("charWybierz.png");
    
        ///Postacie
            
            ///Wojownik
            PImage iWojownikNapis= loadImage("Character/napisWojownik.png");
            PImage iWojownikPostacON= loadImage("Character/charWojownikON.png");
            PImage iWojownikPostacOFF= loadImage("Character/charWojownikOFF.png");
            int wojownikX, wojownikY;
            
            ///Inkwizytor
            PImage iSuraNapis= loadImage("Character/napisInkwizytor.png");
            PImage iSuraPostacON= loadImage("Character/charSuraON.png");
            PImage iSuraPostacOFF= loadImage("Character/charSuraOFF.png");
            int suraX, suraY;
            
            PImage iWybierzNapis= loadImage("Character/wybierzPostac.png");
            
    //wskaźniki zaznaczonej postaci
    boolean isWojownik = false, isSura = false;
    boolean loadCharacter = false; //Jeśli jest true to mam wczytać wybraną postać
            
    int yEkranPostaci;
    int xWybierz, yWybierz;
    
    int xNapis, yNapis;
    
    ///Dzwięki wyboru postaci
    MusicInterface btnSound = new MusicInterface("Sounds/insertBtnSound.wav");
    MusicInterface loadSound = new MusicInterface("Sounds/gameLoad.wav");
    
    
    CharSelection(){  ///Init menu
      init();
      exp = new Exp();
      uploadMagazine();
    }
    
    public  void tick(){
      //Obsługa zaznaczenia postawi Wojownika
      if(!isWojownik && mousePressed && CD.mouseCollision(wojownikX , wojownikY , wojownikX + iWojownikPostacON.width , wojownikY + iWojownikPostacON.height)){      //Obsługa zaznaczenia postawi Wojownika
        System.out.println("KLIK NA WOJOWNIKA");
        isSura = false;
        isWojownik = true;
      }
      
      //Obsługa zaznaczenia postaci Inkwizytor
      if(!isSura && mousePressed && CD.mouseCollision(suraX , suraY , suraX + iSuraPostacON.width , suraY + iSuraPostacON.height)){                                  //Obsługa zaznaczenia postaci Inkwizytor
        System.out.println("KLIK NA SURE");
        isWojownik = false;
        isSura = true;
      }
      
      //Kliknięcie przycisku [Wybierz]
      if((isWojownik || isSura)  && mousePressed && CD.mouseCollision(xWybierz , yWybierz , xWybierz + iWybierz.width , yWybierz + iWybierz.height)){                 //Kliknięcie przycisku [Wybierz]
        loadSound.play();
        if(isWojownik){
          State.setState(new LoadingScreenState("Wojownik"));
        }
        else if(isSura){
          State.setState(new LoadingScreenState("Inkwizytor"));
        }
      }
      
    };
    
    public void render(){  
      image(iBackground,0,0);
      if(isWojownik)image(iWojownikPostacON,wojownikX,wojownikY);
        else image(iWojownikPostacOFF,wojownikX,wojownikY);
      if(isSura)image(iSuraPostacON,suraX,suraY);
        else image(iSuraPostacOFF,suraX,suraY);
      
      image(iWybierz, xWybierz, yWybierz);
      
      classNameRender();
    };
    
    public void init(){ ///Metoda init
      mobileResizer();
      CD = new CollisionDetector();
      ///Ustalanie koordynatów
      yEkranPostaci = int(height/10)*4;
      
      xWybierz =  width/2 - iWybierz.width/2;
      yWybierz = height-iWybierz.height;
      
      xNapis = width/2 - iWojownikNapis.width/2;
      yNapis = 0;
      
      //koordynaty wyświetlanych postaci
      wojownikX = width/2 - iWojownikPostacON.width; wojownikY = yEkranPostaci;
      suraX = width/2; suraY = yEkranPostaci;
  }
    
    public void mobileResizer(){ ///Metoda do zmiany rozmiaru grafik w zależności od rozdzielczości ekranu
      iBackground.resize(width,height);
      iWybierz.resize(int(width/1.8),0);
      iWybierzNapis.resize(int(width/1.3),0);
      iWojownikNapis.resize(int(width/1.3),0);
      iSuraNapis.resize(int(width/1.3),0);
      
      iWojownikPostacON.resize(int(width/2),0);
      iWojownikPostacOFF.resize(int(width/2),0);
      iSuraPostacON.resize(int(width/2),0);
      iSuraPostacOFF.resize(int(width/2),0);

      
      iLoading.resize(int(width/1.2) , 0);
      loadingX = width/2 - iLoading.width/2 ; loadingY = height/2 - iLoading.height/2;
    }
    
    
    public void classNameRender(){
      if(isWojownik) image(iWojownikNapis , xNapis , yNapis);
      else if(isSura) image(iSuraNapis , xNapis , yNapis);
      else image(iWybierzNapis , xNapis , yNapis);
    }
    
    
    private void uploadMagazine(){
      Magazyn.fontInv = createFont("Fonts/Ubuntu.ttf",width/28);  //Fonty do renderingu nazw przdmiotów
      Magazyn.fontInv2 = createFont("Fonts/Ubuntu.ttf",width/34);
      
      Magazyn.fontPopup = createFont("Fonts/Ubuntu.ttf",width/16);  //Fonty do renderingu nazw przdmiotów
      Magazyn.fontPopup2 = createFont("Fonts/Ubuntu.ttf",width/23);
      
      Magazyn.bambooIcon = loadImage("InvBtn/bag/Upgrades/iconBamboo.png");
      Magazyn.woodIcon = loadImage("InvBtn/bag/Upgrades/iconWood.png");
      Magazyn.flowersIcon = loadImage("InvBtn/bag/Upgrades/iconFlowers.png");
      Magazyn.ironIcon = loadImage("InvBtn/bag/Upgrades/iconIron.png");
      Magazyn.goldIcon = loadImage("InvBtn/bag/Upgrades/iconGold.png");
      Magazyn.suppliesIcon = loadImage("InvBtn/bag/Upgrades/iconSupplies.png");
      Magazyn.linenIcon = loadImage("InvBtn/bag/Upgrades/iconLinen.png");
      Magazyn.letherIcon = loadImage("InvBtn/bag/Upgrades/iconLether.png");
      Magazyn.silkIcon = loadImage("InvBtn/bag/Upgrades/iconSilk.png");
      
      Magazyn.bambooIconON = loadImage("InvBtn/bag/imgBambooON.png");
      Magazyn.woodIconON = loadImage("InvBtn/bag/imgWoodON.png");
      Magazyn.flowersIconON = loadImage("InvBtn/bag/imgFlowersON.png");
      Magazyn.ironIconON = loadImage("InvBtn/bag/imgIronON.png");
      Magazyn.goldIconON = loadImage("InvBtn/bag/imgGoldON.png");
      Magazyn.suppliesIconON = loadImage("InvBtn/bag/imgSuppliesON.png");
      Magazyn.linenIconON = loadImage("InvBtn/bag/imgLinenON.png");
      Magazyn.letherIconON = loadImage("InvBtn/bag/imgLetherON.png");
      Magazyn.silkIconON = loadImage("InvBtn/bag/imgSilkON.png");
      
      Magazyn.bambooIconOFF = loadImage("InvBtn/bag/imgBambooOFF.png");
      Magazyn.woodIconOFF = loadImage("InvBtn/bag/imgWoodOFF.png");
      Magazyn.flowersIconOFF = loadImage("InvBtn/bag/imgFlowersOFF.png");
      Magazyn.ironIconOFF = loadImage("InvBtn/bag/imgIronOFF.png");
      Magazyn.goldIconOFF = loadImage("InvBtn/bag/imgGoldOFF.png");
      Magazyn.suppliesIconOFF = loadImage("InvBtn/bag/imgSuppliesOFF.png");
      Magazyn.linenIconOFF = loadImage("InvBtn/bag/imgLinenOFF.png");
      Magazyn.letherIconOFF = loadImage("InvBtn/bag/imgLetherOFF.png");
      Magazyn.silkIconOFF = loadImage("InvBtn/bag/imgSilkOFF.png");
      
      System.out.println("Magazyn zostal utworzony");
    }
    
    
}
