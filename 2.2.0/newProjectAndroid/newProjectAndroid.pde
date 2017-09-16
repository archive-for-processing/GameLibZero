int st = 0;
PImage img[];
MediaPlayer[] snd;
scene escena;
sprite idPerso;
//------------------------------------------------------------
void Settings() {
    setMode(640, 400, true);
    fps = 60;
    fadingColor = 255; // white screen fading..
    backgroundColor = 255;
}
//------------------------------------------------------------
void Setup() {
    orientation(LANDSCAPE);
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
                priority = 0;
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