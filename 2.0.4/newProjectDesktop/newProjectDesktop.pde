int st = 0;
AudioPlayer snd[];
PImage img[];
PFont fnt[];
//------------------------------------------------------------
void Settings() {
    setMode(1024, 600, false);
    orientation(PORTRAIT);
    fps = 60;
    fadingColor = 255; // white screen fading..
    backgroundColor = 255;
}
//------------------------------------------------------------
void Setup() {
    //img = loadImages("images");
    //snd = loadSounds("sounds");
}
//------------------------------------------------------------
void Draw() {
    switch(st) {
    case 0:
        new touchMe(512, 200);
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