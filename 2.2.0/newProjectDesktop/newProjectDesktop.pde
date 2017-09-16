int st = 0;
AudioPlayer snd[];
PImage img[];
PFont fnt[];
scene escena;
sprite idPerso;
//------------------------------------------------------------
void Settings() {
    setMode(640, 400, false);
    fps = 60;
    fadingColor = 255; // white screen fading..
    backgroundColor = 255;
}
//------------------------------------------------------------
void Setup() {
    //orientation(PORTRAIT);
    img = loadImages("images");
    //snd = loadSounds("sounds");
}
//------------------------------------------------------------
void Draw() {
    switch(st) {
    case 0:
        escena = new scene(img[1], 0,0,640,400);
        idPerso = new personaje();
        escena.setCamera(idPerso);
        new thing();
        st = 10;
        break;
        //++++++++++++++++++++++++++++++++
    case 10:
        
        break;
        //++++++++++++++++++++++++++++++++
        //++++++++++++++++++++++++++++++++
    }
}
//------------------------------------------------------------
class personaje extends sprite{
    int st = 0;
    int velocidad = 3;
    void frame(){
        switch(st){
            //++++++++++++++++++++++++++++++++
            case 0:
                setGraph(img[0]);
                setScene(escena);
                x = 100;
                y = 100;
                sizeX = 10;
                st = 10;
                break;
            //++++++++++++++++++++++++++++++++
            case 10:
                if(key( _A ))  {x-=velocidad;}
                if(key( _D ))  {x+=velocidad;}
                if(key( _W ))  {y-=velocidad;}
                if(key( _S ))  {y+=velocidad;}
                break;
            //++++++++++++++++++++++++++++++++
        }
    }
}
//------------------------------------------------------------
class thing extends sprite{
    int st = 0;
    void frame(){
        switch(st){
            //++++++++++++++++++++++++++++++++
            case 0:
                setGraph(img[2]);
                setScene(escena);
                x = 800;
                y = 200;
                break;
            //++++++++++++++++++++++++++++++++
            case 10:
                
                break;
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
        }
    }
}
//------------------------------------------------------------