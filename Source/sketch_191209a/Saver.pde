import android.app.Activity;
import android.content.Context;



public class Saver{
  
  public void saveGame(int slot){  //Metoda zapisująca gdzie slot oznacza numer slotu
    String[] zapis = {generateData(),""};  //Treść pliku
    saveStrings("/storage/emulated/0/plikZapisu"+slot+".txt",zapis);      //Funkcja zapisująca plik
  }
  
   private String generateData(){  //Generuje Stringa zawierającego niezbędne informacje na temat postaci
    String data = new String();
    /* 0  */    data = CharacterClass.myHero.name + "," ;
    /* 1  */    data += CharacterClass.myHero.getLevel() + "," ;
    /* 2  */    data += CharacterClass.myHero.sila + "," ;
    /* 3  */    data += CharacterClass.myHero.inteligencja + "," ;
    /* 4  */    data += CharacterClass.myHero.energia + "," ;
    /* 5  */    data += CharacterClass.myHero.zywotnosc + "," ;
    /* 6  */    data += CharacterClass.myHero.zrecznosc + "," ;
    /* 7  */    data += CharacterClass.myHero.freePoints + "," ;
    /* 8  */    data += CharacterClass.myHero.skillPoints + "," ;
    /* 9  */    data += CharacterClass.myHero.expiriencePoints + "," ;
    /* 10 */    data += CharacterClass.myHero.skillsList[0].level + "," ;
    /* 11 */    data += CharacterClass.myHero.skillsList[1].level + "," ;
    /* 12 */    data += CharacterClass.myHero.skillsList[2].level + "," ;
    /* 13 */    data += CharacterClass.myHero.skillsList[3].level + "," ;
    /* 14 */    data += CharacterClass.myHero.skillsList[4].level + "," ;
    /* 15 */    data += CharacterClass.myHero.hpFluid + "," ;
    /* 16 */    data += CharacterClass.myHero.fluidHP.getLevel() + "," ;
    /* 17 */    data += CharacterClass.myHero.actualWeapon + "," ;
    /* 18 */    data += CharacterClass.myHero.getActualWeapon().level + "," ;
    /* 19 */    data += CharacterClass.myHero.actualArmor + "," ;
    /* 20 */    data += CharacterClass.myHero.getActualArmor().level + "," ;
    /* 21 */    data += CharacterClass.myHero.bamboo.getValue() + "," ;
    /* 22 */    data += CharacterClass.myHero.wood.getValue() + "," ;
    /* 23 */    data += CharacterClass.myHero.flowers.getValue() + "," ;
    /* 24 */    data += CharacterClass.myHero.iron.getValue() + "," ;
    /* 25 */    data += CharacterClass.myHero.gold.getValue() + "," ;
    /* 26 */    data += CharacterClass.myHero.supplies.getValue() + "," ;
    /* 27 */    data += CharacterClass.myHero.linen.getValue() + "," ;
    /* 28 */    data += CharacterClass.myHero.lether.getValue() + "," ;
    /* 29 */    data += CharacterClass.myHero.silk.getValue() + "" ;
    
    return data;
  }
  
  
  
  public void loadGame(int slot){  //Metoda wczytująca gre gdzie slot to numer wczytywanego slotu
    uploadMagazine();  //Ładuje magazyn
    File file=new File("/storage/emulated/0/plikZapisu"+slot+".txt");
    String[] data = loadStrings(file);  //Wczytanie stringa z pliku
    String[] dataParts = data[0].split(",");  //Rozbicie stringa na dane
    
    System.out.println("Wczytano:"+data[0]);
    System.out.println("dataParts[0]:"+dataParts[0]);
    
    if(dataParts[0].equals("Wojownik")) CharacterClass.setHero(new Wojownik());
    else if (dataParts[0].equals("Inkwizytor")) CharacterClass.setHero(new Sura());
    else {System.out.println("Brak klasy ! -> Saver.loadGame"); return;}

    //Pora na wczytywanie danych dla postaci
    CharacterClass.myHero.level = parseInt(dataParts[1]);
    
    CharacterClass.myHero.sila = parseInt(dataParts[2]);
    CharacterClass.myHero.inteligencja = parseInt(dataParts[3]);
    CharacterClass.myHero.energia = parseInt(dataParts[4]);
    CharacterClass.myHero.zywotnosc = parseInt(dataParts[5]);
    CharacterClass.myHero.zrecznosc = parseInt(dataParts[6]);
    CharacterClass.myHero.freePoints = parseInt(dataParts[7]);
    CharacterClass.myHero.skillPoints = parseInt(dataParts[8]);
    CharacterClass.myHero.expiriencePoints = parseInt(dataParts[9]);
    
    
    CharacterClass.myHero.skillsList[0].setLevel(parseInt(dataParts[10]));
    CharacterClass.myHero.skillsList[1].setLevel(parseInt(dataParts[11]));
    CharacterClass.myHero.skillsList[2].setLevel(parseInt(dataParts[12]));
    CharacterClass.myHero.skillsList[3].setLevel(parseInt(dataParts[13]));
    CharacterClass.myHero.skillsList[4].setLevel(parseInt(dataParts[14]));
    
    CharacterClass.myHero.skillsList[0].updateIcon();
    CharacterClass.myHero.skillsList[1].updateIcon();
    CharacterClass.myHero.skillsList[2].updateIcon();
    CharacterClass.myHero.skillsList[3].updateIcon();
    CharacterClass.myHero.skillsList[4].updateIcon();
    
    CharacterClass.myHero.hpFluid = parseInt(dataParts[15]);
    CharacterClass.myHero.fluidHP.setLevel(parseInt(dataParts[16]));
    
    CharacterClass.myHero.actualWeapon = parseInt(dataParts[17]);
    CharacterClass.myHero.weapon[ parseInt(dataParts[17]) ].level = parseInt(dataParts[18]);
    
    CharacterClass.myHero.actualArmor = parseInt(dataParts[19]);
    CharacterClass.myHero.armor[ parseInt(dataParts[19]) ].level = parseInt(dataParts[20]);
    //CharacterClass.myHero.armor[CharacterClass.myHero.actualArmor].setArmorLevel(parseInt(dataParts[20]));
    
    CharacterClass.myHero.bamboo.setValue(parseInt(dataParts[21]));
    CharacterClass.myHero.wood.setValue(parseInt(dataParts[22]));
    CharacterClass.myHero.flowers.setValue(parseInt(dataParts[23]));
    CharacterClass.myHero.iron.setValue(parseInt(dataParts[24]));
    CharacterClass.myHero.gold.setValue(parseInt(dataParts[25]));
    CharacterClass.myHero.supplies.setValue(parseInt(dataParts[26]));
    CharacterClass.myHero.linen.setValue(parseInt(dataParts[27]));
    CharacterClass.myHero.lether.setValue(parseInt(dataParts[28]));
    CharacterClass.myHero.silk.setValue(parseInt(dataParts[29]));
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
