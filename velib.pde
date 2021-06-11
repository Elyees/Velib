String lien = "https://opendata.paris.fr/api/records/1.0/search/?dataset=velib-disponibilite-en-temps-reel&q=&facet=name&refine.name=H%C3%B4tel+de+Ville+de+Chaville";
String nom_station ;
String localisation ;
int capacite ;
int velo_dispo ;
int place_dispo ;
int velo_mecha ;
int velo_elec ;
float lat,lon,latst,lonst;
float latbl,latbr,lontl,lonbl;
float abs,ord;
float x,y;
int r;
PFont font;
PImage map ;
PImage elec;
PImage meca;
PImage park;

void setup() 
{
  size(700,800); 
  background(255);
  
  font = createFont ("arial.ttf" , 25);
  textFont(font);
  
  elec = loadImage("elec.jpg");
  meca = loadImage("meca.png");
  park = loadImage("parking.png");
  map = loadImage("paris.PNG");
}

//fonctions de conversion
float conversionabs(float lat,float lon)
{
  abs = r*cos(lat)*cos(lon);
  return(abs);
}

float conversionord(float lat,float lon)
{
  ord = r*cos(lat)*sin(lon);
  return(ord);
}

void draw() 
{
  //importer les données
  JSONObject fichier = loadJSONObject(lien); 
  nom_station = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getString("name");
  localisation = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getString("nom_arrondissement_communes");
  capacite = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getInt("capacity");
  place_dispo = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getInt("numdocksavailable");
  velo_dispo = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getInt("numbikesavailable");
  velo_mecha = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getInt("mechanical");
  velo_elec = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getInt("ebike");
  latst = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getJSONArray("coordonnees_geo").getFloat(0);
  lonst = fichier.getJSONArray("records").getJSONObject(0).getJSONObject("fields").getJSONArray("coordonnees_geo").getFloat(1);
  
  //station et capacité
  fill(0, 102, 153);
  text("Station: ",100,80);
  fill(0,0,0);
  text(nom_station +" - "+ localisation,190,80);
  fill(0, 102, 153);
  text("Capacité: ",100,125);
  fill(0,0,0);
  text( capacite +" vélos",210,125);
  
  //places parking
  if(place_dispo>1){
    image(park,100,137,50,50);
    fill(0,0,0);
    text(place_dispo+" places parking disponibles",150,175);
  }
  else if(place_dispo==1){
    image(park,100,137,50,50);
    fill(0,0,0);
    text(place_dispo+" place parking disponible",150,175);
  }  
  else {
    fill(0,0,0);
    text("Pas de places disponibles",100,175);
  }  
  
  //vélos
  if(velo_dispo>0){ 
    image(meca,110,200,30,30);
    fill(0,0,0);
    text(velo_mecha+ " vélos méchaniques",150,225);
    image(elec,105,250,40,40);
    fill(0,0,0);
    text(velo_elec+ " vélos électriques",150,275); 
  }
  else{
    fill(0,0,0);
    text("Pas de vélos disponibles",100,225);
  }
  
  //coordonnées géographiques
  image(map,100,325,500,300);
  
  lontl = 2.187094;
  latbl = 48.779966;
  lonbl = 2.185750;
  latbr = 48.782755;
  float[] latitudes = {latst,latbr,latbl};
  float[] longitudes = {lonst,lontl,lonbl};
  float[] abscisses = new float[3];
  float[] ordonnees = new float[3];
  
  for (int i=0;i<3;i=i+1){
     abscisses[i]=conversionabs(latitudes[i],longitudes[i]);
     ordonnees[i]=conversionord(latitudes[i],longitudes[i]);
  }
  
  x = (500*(abscisses[0]-abscisses[2])/(abscisses[1]-abscisses[2]))+100;
  y = (300*(ordonnees[0]-ordonnees[2])/(ordonnees[1]-ordonnees[2]))+325;
  fill(0,0,0);
  ellipse(x,y,10,10);
}
