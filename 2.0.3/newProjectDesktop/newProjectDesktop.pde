int st = 0;
AudioPlayer snd[];
PImage img[];
PFont fnt[];
//------------------------------------------------------------
void Settings() {
    setMode(640, 400, false);
    orientation(PORTRAIT);
    fps = 60;
    fadingColor = 255; // white screen fading..
    backgroundColor = 255;
}
//------------------------------------------------------------
void Setup() {
    img = loadImages("images");
    //snd = loadSounds("sounds");
}
//------------------------------------------------------------
void Draw() {
    switch(st) {
    case 0:
        world.setEdges();
        world.setGravity(0, 600);
        new personaje();
        st = 10;
        break;
        //++++++++++++++++++++++++++++++++
    case 10:
        if (key(_SPACE)) {
            new bola(320, 200);
        }
        break;
        //++++++++++++++++++++++++++++++++
        //++++++++++++++++++++++++++++++++
    }
}
//------------------------------------------------------------
class personaje extends sprite {
    int st = 0;
    //----------------------------------------
    //----------------------------------------
    void frame() {
        switch(st) {
            //++++++++++++++++++++++++++++++++
        case 0:
            setGraph(img[0]);
            sizeX = 20;
            sizeY = 20;
            x = 320;
            y = 200;
            createBody( TYPE_CIRCLE );
            setMaterial( RUBBER );
            st = 10;
            break;
            //++++++++++++++++++++++++++++++++
        case 10:
            if (key(_LEFT)) {
                addVx(-150);
            }
            if (key(_RIGHT)) {
                addVx(150);
            }
            if (key(_UP)) {
                addVy(-200);
            }
            if (key(_DOWN)) {
                addVy(200);
            }

            if (collisionType(1) != null) {
                exit();
            }

            if (collisionMouse(id)) {
                exit();
            }

            break;
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
        }
    }
}
//------------------------------------------------------------
//------------------------------------------------------------
class bola extends sprite {
    int st = 0;
    //----------------------------------------
    public bola(float x, float y) {
        this.x = x;
        this.y = y;
    }
    //----------------------------------------
    void frame() {
        switch(st) {
            //++++++++++++++++++++++++++++++++
        case 0:
            setGraph(img[1]);
            sizeX = sizeY = 20;
            createBody(TYPE_CIRCLE);
            setMaterial(RUBBER);
            type = 1;
            st = 10;
            break;
            //++++++++++++++++++++++++++++++++
        case 10:

            break;
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
        }
    }
}
//------------------------------------------------------------