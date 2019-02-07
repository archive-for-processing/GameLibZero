int st = 0;
PImage img[];
MediaPlayer[] snd;
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
    img = loadImages("img");
    //snd = loadSounds("sounds");
}
//------------------------------------------------------------
void Draw() {
    switch(st) {
    case 0:
        
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