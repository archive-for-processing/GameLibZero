int st = 0;
AudioPlayer snd[];
PImage img[];
PFont fnt[];
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