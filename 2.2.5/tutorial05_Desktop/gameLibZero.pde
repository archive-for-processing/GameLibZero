////////////////////////////////////////////////////////////////////////
//
//            GameLibZero 2.2.0 by Luis Lopez Martinez
//                16/09/2017 - Barcelona SPAIN.
//                        OPEN SOURCE  
// - Dependences: 'minim Sound Library' - Import it from Sketch menu.
// - Dependences: 'Fisica library'      - Import it from Sketch menu.
//
////////////////////////////////////////////////////////////////////////


import fisica.*;
FWorld world;
final int TYPE_BOX = -1;
final int TYPE_CIRCLE = -2;

// materiales disponibles para la simulación física..
final int WOOD    = 1;
final int METAL   = 2;
final int STONE   = 3;
final int PLASTIC = 4;
final int RUBBER  = 5;
final int HUMAN   = 6;

import java.util.*;
int resolutionWidth;
int resolutionHeight;
int virtualResolutionWidth;
int virtualResolutionHeight;
boolean fullscreen_ = false;
ArrayList<sprite> sprites;
sprite _id_;
PGraphics blitter;
int fps = 60;
boolean fading = false;
float deltaFading = 0;
float alphaFading = 0;
int fadingType = 0;
color fadingColor = 1;
Mouse mouse;
color backgroundColor = 0;
//------------------------------------------------------------
void settings() {
    size(320, 200, P3D);
    noSmooth();
    Settings();
    if (fullscreen_) {
        fullScreen();
    }
}
//------------------------------------------------------------
void setup() {
    sprites = new ArrayList<sprite>();
    Setup();
    setModeSecondSteep();
    frameRate(fps);
    blitter = createGraphics(virtualResolutionWidth, virtualResolutionHeight, P3D);
    blitter.noSmooth();

    Fisica.init(this);
    world = new FWorld();

    mouse = new Mouse();
    mouse.b = new FCircle(1);
    mouse.b.setSensor(true);
    world.add(mouse.b);
}
//------------------------------------------------------------
void draw() {
    // mouse operations..
    mouse.oldX = mouse.x;
    mouse.oldY = mouse.y;
    mouse.x = (mouseX * virtualResolutionWidth ) / resolutionWidth; 
    mouse.y = (mouseY * virtualResolutionHeight) / resolutionHeight;
    mouse.updateSensorPosition();

    // Sort sprites..
    Collections.sort(sprites, new spriteComparator());

    // clean background and draw sprite collection..
    blitter.beginDraw();
    blitter.background(backgroundColor);
    blitter.shapeMode(CENTER);
    blitter.noStroke();
    // draw sprites..
    for (int i = sprites.size()-1; i >= 0; i--) {
        _id_ = sprites.get(i);
        // first steep.. execute sprite code..
        _id_.draw();
        // second steep.. 
        // check if this sprite needs dead..
        if (_id_.statusKill) {
            world.remove(_id_.b);        // elimino el shape del mundo..
            sprites.remove(_id_);        // elimino el sprite de la lista..
            _id_.deleteFromMemory();     // operaciones internas de la clase sprite antes de expirar..
        }
        if (!_id_.live) {
            _id_.statusKill = true;
        }
    }

    // screen fading..
    if (fading) {
        if (fadingType == 1) {
            if (alphaFading < 255) {
                alphaFading += deltaFading;
            } else {
                deltaFading = 0;
                alphaFading = 255;
                fading = false;
            }
        } else if (fadingType == -1) {
            if (alphaFading > 0) {
                alphaFading -= deltaFading;
            } else {
                deltaFading = 0;
                alphaFading = 0;
                fading = false;
            }
        }
    }

    Draw();
    world.step();
    if (alphaFading > 0) {
        blitter.fill(fadingColor, alphaFading);
        blitter.rect(0, 0, virtualResolutionWidth+1, virtualResolutionHeight+1);
    }

    blitter.endDraw();
    image(blitter, 0, 0, width, height);
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
class region{
    float x;
    float y;
    float w;
    float h;
    public region(float x, float y, float w, float h){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
}
//------------------------------------------------------------
//------------------------------------------------------------
class sprite {
    int priority = 512;                    // priority execution..
    boolean live = true;                   // if false this sprite has prepared ti killed by the core in the next frame..
    boolean statusKill = false;            // if true.. core kills this sprite inmediatly..
    boolean visible = false;               // show/hide sprite..
    PImage graph;                          // texture of sprite..
    float x = 0;                           // x position..
    float y = 0;                           // y position..
    float z = 0;                           // profundidad..
    float angle = 0;                       // angle of rotation in degrees..
    float sizeX = 100.0;                   // size widtt for scale sprite..
    float sizeY = 100.0;                   // size height for scale sprite..
    float alpha = 255;                     // transparency of sprite..
    PShape s;                              // quad shape of sprite..
    sprite id;                             // identifier of sprite..
    float x0;                              // offsetX texture..
    float y0;                              // offsetY texture..
    float radius;                          // radius of this sprite for simple collision check..
    float type = -1;                       // type of sprite.. for collisionType() check..
    sprite idTempForCheckCollision;
    FBody b = null;                        // physic shape of this sprite..
    region r = new region(0,0,virtualResolutionWidth,virtualResolutionHeight);
    boolean onScene = false;
    scene sceneId = null;
    float oldX;
    float oldY;
    float SX, SY;                          // screen X cord, screen Y cord..
    //......................................
    // constructor..
    sprite() {
        id = this;
        sprites.add(id);
    }
    //......................................
    // functions..
    void draw() {
        if (b != null) {
            x = b.getX();
            y = b.getY();
            angle = -degrees(b.getRotation());
        }
        if (visible) {
            s.setTexture(graph);
            blitter.pushMatrix();
            if(onScene){
                SX = x - sceneId.x + sceneId.xInicial;
                SY = y - sceneId.y + sceneId.yInicial;
                blitter.translate(SX, SY);
            } else{
                blitter.translate(x, y);
            }
            blitter.scale(sizeX/100.0, sizeY/100.0);
            blitter.rotate(radians(-angle));
            blitter.tint(255, alpha);
            //blitter.clip(0,0,mouse.x,mouse.y);
            blitter.shape(s);
            blitter.popMatrix();
        }
        oldX = x;
        oldY = y;
        frame();
    }
    //......................................
    void createBody( int TYPE_BODY) {
        switch(TYPE_BODY) {
        case TYPE_BOX:
            b = new FBox( (graph.width*sizeX)/100, (graph.height*sizeY)/100 );
            b.setPosition( x, y );
            world.add( b );
            break;
        case TYPE_CIRCLE:
            b = new FCircle( ((graph.width*sizeX)/100 + (graph.height*sizeY)/100) / 2.0 );
            b.setPosition( x, y );
            world.add( b );
            break;
        }
        b.setGrabbable(false);
        b.setRotation(radians(angle));
        //b.setGroupIndex(-1);
    }
    //......................................
    void setMaterial( int material ) {
        switch(material) {
        case WOOD:
            b.setFriction(0.50);
            b.setRestitution(0.17);
            b.setDensity(0.57);
            break;
        case METAL:
            b.setFriction(0.13);
            b.setRestitution(0.17);
            b.setDensity(7-80);
            break;
        case STONE:
            b.setFriction(0.75);
            b.setRestitution(0.05);
            b.setDensity(2.40);
            break;
        case PLASTIC:
            b.setFriction(0.38);
            b.setRestitution(0.09);
            b.setDensity(0.95);
            break;
        case RUBBER:
            b.setFriction(0.75);
            b.setRestitution(0.95);
            b.setDensity(1.70);
            break;
        case HUMAN:
            b.setFriction(1.00);
            b.setRestitution(0.00);
            b.setDensity(0.95);
            break;
        }
    }
    //......................................
    //..............................
    void setDamping(float damping) {
        b.setDamping(damping);
    }
    //..............................
    void setDrag(boolean drag_) {
        b.setGrabbable(drag_);
    }
    //..............................
    void addImpulse(float angle, float impulse) {
        float fx = impulse*cos(radians(angle));
        float fy = -impulse*sin(radians(angle));
        b.addImpulse(fx, fy);
    }
    //..............................
    void addImpulse(float angle, float impulse, int offsetX, int offsetY) {
        float fx = impulse*cos(radians(angle));
        float fy = -impulse*sin(radians(angle));
        b.addImpulse(fx, fy, -offsetX, -offsetY);
    }
    //..............................
    void addVx(float vx) {
        b.addImpulse(vx, 0);
    }
    //..............................
    void addVy(float vy) {
        b.addImpulse(0, vy);
    }
    //..............................
    void setPosition(float x, float y) {
        b.setPosition(x, y);
    }
    //..............................
    //..............................
    void setVx(float vx) {
        b.setVelocity(vx, getVy());
    }
    //..............................
    //..............................
    void setVy(float vy) {
        b.setVelocity(getVx(), vy);
    }
    //..............................
    void addPosition(float x_, float y_) {
        b.adjustPosition(x_, y_);
    }
    //..............................
    float getVx() {
        return b.getVelocityX();
    }
    //..............................
    float getVy() {
        return b.getVelocityY();
    }
    //..............................
    void setGroup(int group_) {
        b.setGroupIndex(group_);
    }
    //..............................
    void setAngle(float ang_) {
        
        b.setRotation(radians(ang_-270));
    }
    //..............................
    void setStatic(boolean static_) {
        b.setStatic(static_);
    }
    //..............................
    void setSensor(boolean sensor_){
        b.setSensor(sensor_);
    }
    //..............................
    void frame() {
    }
    //......................................
    void setGraph(PImage graph_) {
        graph = graph_;
        s = createShape();
        s.setTexture(graph);
        s.beginShape();
        s.tint(255, alpha);
        s.vertex(0, 0, x0, y0);
        s.vertex(graph.width, 0, graph.width+x0, 0);
        s.vertex(graph.width, graph.height, graph.width+x0, graph.height+y0);
        s.vertex(0, graph.height, x0, graph.height+y0);
        s.endShape(CLOSE);
        s.disableStyle();
        visible = true;
    }
    //......................................
    void deleteFromMemory() {
        id = null;
    }
    //......................................
    //protected void finalize() throws Throwable{
    //  super.finalize();
    //}
    //......................................
    void advance(float dist_, float angle_) {
        x = x + dist_*sin(radians(90.0 + -angle_));
        y = y - dist_*cos(radians(90.0 + -angle_));
    }
    //......................................
    void advance(float dist_) {
        x = x + dist_*sin(radians(90.0 + -angle));
        y = y - dist_*cos(radians(90.0 + -angle));
    }
    //......................................
    float getAngle(float Bx, float By) {
        float ang = degrees(atan2( By-y, Bx-x ));
        if (ang < 0) {
            ang = 360.0 + ang;
        }
        if (ang >= 360.0) {
            ang = 0;
        }  
        return 360 - ang;
    }
    //......................................
    float getDist(float x2, float y2) {
        return(sqrt((x-x2)*(x-x2) + (y-y2)*(y-y2)));
    }
    //......................................
    boolean collision(sprite id_) {
        return b.isTouchingBody(id_.b);
    }
    //......................................
    sprite collisionType(int type_) {
        // recorrer la colección de sprites..
        for (int i = sprites.size()-1; i >= 0; i--) {
            // buscar los que son del tipo indicado..
            idTempForCheckCollision = sprites.get(i);
            if (idTempForCheckCollision.type == type_) {
                // comprobar si hay colision..
                if (collision(idTempForCheckCollision)) {
                    // retorno el id del sprite que colisiona..
                    return idTempForCheckCollision;
                }
            }
        }
        return null;
    }
    //......................................
    void setScene(scene sceneId){
        onScene = true;
        this.sceneId = sceneId;
        r = sceneId.r;
        priority = sceneId.priority-1;
    }
    //......................................
    boolean isContact(float angA, float angB){
        // angulo del vector entre el cuerpo del sprite y el punto de contacto..
        float ang = 0;
        
        // lista de contactos..
        ArrayList contacts = b.getContacts();
        
        // recorrer lista de contactos..
        for (int i=0; i<contacts.size(); i++) {
            // recojo el contacto actual..
            FContact c = (FContact)contacts.get(i);
            
            // si el cuerpo 1 soy yo..
            if(c.getBody1() == b){
                ang = getAngle(c.getX(), c.getY());
                //println(ang);
            } else{    // si el cuerpo 2 soy yo..
                ang = getAngle(c.getX(), c.getY());
                //println(frameCount, ang);
                
            }
            
            // si el angulo que formo con el contacto esta entre los margenes pasados como parametros..
            if( ang > angA && ang < angB ){
                return true;
            }
        }
        return false;
    }
    //......................................
}
//------------------------------------------------------------
class spriteComparator implements Comparator {
    int compare(Object o1, Object o2) {
        int z1 = ((sprite) o1).priority;
        int z2 = ((sprite) o2).priority;
        return z1 - z2;
    }
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
final void screenDrawText(PFont fnt_, int size, String text, int cod, float x, float y, color col, float alpha) {  
    blitter.pushMatrix();
    if (fnt_ != null) {
        blitter.textFont(fnt_);
    }
    blitter.textSize(size);
    if (cod==4) {
        blitter.textAlign(CENTER, CENTER);
    }
    if (cod==3) {
        blitter.textAlign(LEFT, CENTER);
    }
    if (cod==5) {
        blitter.textAlign(RIGHT, CENTER);
    }
    blitter.fill(col, alpha);
    blitter.text(text, x, y);
    blitter.popMatrix();
}
//------------------------------------------------------------
// pintar un grafico de manera sencilla en pantalla con size_x e size_y y alpha..
final void screenDrawGraphic(PImage img_, float x, float y, float angle, float sizeX, float sizeY, float alpha) {
    blitter.pushMatrix();
    blitter.imageMode(CENTER);
    blitter.tint(255, alpha);
    blitter.translate(x, y, 0);
    blitter.rotate(radians(angle));
    blitter.scale(sizeX/100.0, sizeY/100.0);
    blitter.image(img_, 0, 0);
    blitter.popMatrix();
}
//------------------------------------------------------------
final PImage writeInMap(PFont fnt, int size, String texto) {
    PGraphics buffer = null;
    buffer = createGraphics(virtualResolutionWidth, virtualResolutionHeight, P2D);
    buffer.beginDraw();
    buffer.textAlign(LEFT, TOP);
    buffer.textFont(fnt);
    buffer.textSize(size);
    buffer.fill(#FFFFFF);
    PImage dst = createImage((int)buffer.textWidth(texto), (int)(buffer.textAscent()+buffer.textDescent()+size), ARGB);
    buffer.text(texto, 0, 0);
    buffer.endDraw();
    dst.blend( buffer, 0, 0, dst.width, dst.height, 0, 0, dst.width, dst.height, BLEND );
    buffer = null;
    return dst;
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
PImage[] loadImages(String nameFolder) {
    java.io.File folder = new java.io.File(dataPath("")+"/"+nameFolder);
    String[] filenames = folder.list();
    //println(filenames.length);
    //println(dataPath("")+"/"+nameFolder);
    PImage[] img = new PImage[filenames.length];
    for (int i = 0; i < filenames.length; i++) {
        //println("Loading: "+filenames[i]);
        img[i] = loadImage(dataPath("") + "/" + nameFolder + "/" + filenames[i]);
    }
    return img;
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
final void setMode(int w, int h, boolean modeWindow_) {
    virtualResolutionWidth = w;
    virtualResolutionHeight = h;
    fullscreen_ = modeWindow_;
}
//------------------------------------------------------------
final void setModeSecondSteep() {
    if (fullscreen_) {
        surface.setSize(resolutionWidth = int(displayWidth), resolutionHeight = int(displayHeight));
    } else {
        surface.setSize(resolutionWidth = virtualResolutionWidth, resolutionHeight = virtualResolutionHeight);
    }
    int x = (displayWidth/2) - (virtualResolutionWidth/2);
    int y = (displayHeight/2) - (virtualResolutionHeight/2);
    if (!fullscreen_) {
        surface.setLocation(x-3, y);
    }
}
//------------------------------------------------------------
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
// lista de constantes para las teclas..
// -------------------------------------
final int _UP =     38;
final int _DOWN =   40;
final int _LEFT =   37;
final int _RIGHT =  39;
final int _SPACE =  32;
final int _ESC =    27;
final int _ENTER =  10;
final int _F1 =     112;
final int _F2 =     113;
final int _F3 =     114;
final int _F4 =     115;
final int _F5 =     116;
final int _F6 =     117;
final int _F7 =     118;
final int _F8 =     119;
final int _F9 =     120;
final int _F10 =    121;
final int _PRINT =  154;
final int _BLOQ =   145;
final int _PAUSE =  19;
final int _PLUS  =  139;
final int _MINUS =  140;
final int _DEL   =  147;
final int _A =      65;
final int _B =      66;
final int _C =      67;
final int _D =      68;
final int _E =      69;
final int _F =      70;
final int _G =      71;
final int _H =      72;
final int _I =      73;
final int _J =      74;
final int _K =      75;
final int _L =      76;
final int _M =      77;
final int _N =      78;
final int _O =      79;
final int _P =      80;
final int _Q =      81;
final int _R =      82;
final int _S =      83;
final int _T =      84;
final int _U =      85;
final int _V =      86;
final int _W =      87;
final int _X =      88;
final int _Y =      89;
final int _Z =      90;
final int _a =      65 + 32;
final int _b =      66 + 32;
final int _c =      67 + 32;
final int _d =      68 + 32;
final int _e =      69 + 32;
final int _f =      70 + 32;
final int _g =      71 + 32;
final int _h =      72 + 32;
final int _i =      73 + 32;
final int _j =      74 + 32;
final int _k =      75 + 32;
final int _l =      76 + 32;
final int _m =      77 + 32;
final int _n =      78 + 32;
final int _o =      79 + 32;
final int _p =      80 + 32;
final int _q =      81 + 32;
final int _r =      82 + 32;
final int _s =      83 + 32;
final int _t =      84 + 32;
final int _u =      85 + 32;
final int _v =      86 + 32;
final int _w =      87 + 32;
final int _x =      88 + 32;
final int _y =      89 + 32;
final int _z =      90 + 32;
boolean[] keys = new boolean[256];
//.............................................................................................................................................................
void keyPressed() {
    keys[keyCode] = true;
    if (keyCode == 27) {
        key = 0;
        stop();
    }
}
//.............................................................................................................................................................
void keyReleased() {
    keys[keyCode] = false;
}
//.............................................................................................................................................................
final boolean key(int code) {
    return keys[code];
}
//------------------------------------------------------------
//------------------------------------------------------------
void stop() {
    exit();
}
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
void fadeOff(int time_) {
    fading = true;
    fadingType = 1;
    int fadingFramesLeft = (int)(time_ * fps) / 1000;          // frames para hacer el fading..
    deltaFading = (255.0 / fadingFramesLeft);                  // incremento del alpha por frame..
}
//------------------------------------------------------------
void fadeOn(int time_) {
    fading = true;
    fadingType = -1;
    int fadingFramesLeft = (int)(time_ * fps) / 1000;          // frames para hacer el fading..
    deltaFading = (255.0 / fadingFramesLeft);                  // incremento del alpha por frame..
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
boolean collisionMouse(sprite id) {    
    return mouse.b.isTouchingBody(id.b);
}
//------------------------------------------------------------
class Mouse {
    boolean left = false;
    boolean right = false;
    boolean touch = false;
    float x;
    float y;
    float oldX;
    float oldY;
    FBody b;
    void updateSensorPosition(){
        b.setPosition(x, y);
    }
}
//------------------------------------------------------------
// modulo para el control del mouse..
void mousePressed() {
    if (mouseButton == LEFT) {
        mouse.left = true;
        mouse.touch = true;
    }
    if (mouseButton == RIGHT) {
        mouse.right = true;
        mouse.touch = true;
    }
}

void mouseReleased() {
    mouse.touch = false;
    if (mouseButton == LEFT) {
        mouse.left = false;
    }
    if (mouseButton == RIGHT) {
        mouse.right = false;
    }
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
void letMeAlone() {
    for (sprite s : sprites) {
        s.live = false;
    }
}
//------------------------------------------------------------
final int s_kill = -1;
void signal( sprite id_, int signalType_ ) {
    switch(signalType_) {
    case s_kill:
        id_.live = false;
        break;
    }
}
//------------------------------------------------------------
final boolean exists(sprite id_) {
    if (id_ != null) {
        return id_.live;
    }
    return false;
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim = new Minim(this);
//------------------------------------------------------------
AudioPlayer[] loadSounds(String nameFolder) {
    java.io.File folder = new java.io.File(dataPath("")+"/"+nameFolder);
    String[] filenames = folder.list();
    //println(filenames.length);
    //println(dataPath("")+"/"+nameFolder);
    AudioPlayer[] snd = new AudioPlayer[filenames.length];
    for (int i = 0; i < filenames.length; i++) {
        //println("Loading: "+filenames[i]);
        snd[i] = minim.loadFile(dataPath("") + "/" + nameFolder + "/" + filenames[i]);
    }
    return snd;
}
//------------------------------------------------------------
AudioPlayer loadSound(String file_) {
    return minim.loadFile(file_);
}
//------------------------------------------------------------
void soundPlay( AudioPlayer a ) {
    //a.rewind();
    a.cue(0);
    a.play();
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
class scroll extends sprite {
    float w = resolutionWidth;
    float h = resolutionHeight;
    PImage texture = null;
    float deltaX, deltaY;
    //++++++++++++++++++++++++++++++++
    public scroll(PImage texture, float deltaX, float deltaY) {
        this.texture = texture;
        this.deltaX = deltaX;
        this.deltaY = deltaY;
        priority = 1024;
    }
    //++++++++++++++++++++++++++++++++
    void frame() {
        x0 += deltaX;
        y0 += deltaY;
    }
    //++++++++++++++++++++++++++++++++
    void draw() {
        blitter.pushMatrix();
        blitter.translate(x, y, -1);
        blitter.beginShape();
        blitter.textureWrap(REPEAT);
        blitter.tint(255, 255);
        blitter.texture(texture);
        blitter.vertex(x, y, x0, y0);
        blitter.vertex(x+w, y, x0+w, y0);
        blitter.vertex(x+w, y+h, x0+w, y0+h);
        blitter.vertex(x, y+h, x0, y0+h);
        blitter.endShape();
        blitter.popMatrix();
    }
    //++++++++++++++++++++++++++++++++
}
//------------------------------------------------------------
//------------------------------------------------------------
PImage newGraph(int w, int h, color col) {
    PImage gr = createImage(w, h, ARGB);
    gr.loadPixels();
    for (int i = 0; i < gr.pixels.length; i++) {
        gr.pixels[i] = col;
    }
    gr.updatePixels();
    return gr;
}
//------------------------------------------------------------
// cambiar todos los pixels que contengan un color por otro en toda una imagen..
final void mapSetColor(PImage gr, color actual, color nuevo) {
    gr.loadPixels();
    for (int i = 0; i < gr.pixels.length; i++) {
        if (gr.pixels[i] == actual) {
            gr.pixels[i] = nuevo;
        }
    }
    gr.updatePixels();
}
//------------------------------------------------------------
// inyectar un grafico en otro CONTEMPLANDO alpha_channel..
final void putGraphic(PImage dst, int dst_offset_x, int dst_offset_y, PImage src) {
    dst.blend(src, 0, 0, src.width, src.height, dst_offset_x, dst_offset_y, src.width, src.height, BLEND);
}
//------------------------------------------------------------
//------------------------------------------------------------
// limpiar un grafico indicando un color..
void clearGraphic(PImage gr, color c) {
    gr.loadPixels();
    for (int i = 0; i < gr.pixels.length; i++) {
        gr.pixels[i] = c;
    }
    gr.updatePixels();
}
//------------------------------------------------------------
// limpiar un buffer offscreen indicando un color..
void clearGraphic(PGraphics gr, color c) {
    gr.beginDraw();
    gr.loadPixels();
    for (int i = 0; i < gr.pixels.length; i++) {
        gr.pixels[i] = c;
    }
    gr.updatePixels();
    gr.endDraw();
}
//------------------------------------------------------------
//************************************************************
//------------------------------------------------------------
//------------------------------------------------------------
class scene extends sprite{
    int st = 0;
    PImage texture;
    float w, h;
    region r;
    float xInicial;                // cord. x to paint scene image..
    float yInicial;                // cord. y yo paint scene image..
    float limiteX;
    float limiteY;
    sprite camera;
    float cameraLimit = 50;
    //.....................
    float CSX, CSY;                // camera screen x, camera screen y..
    float LSX0, LSX1;              // limit screen left, limit screen right..
    float LSY0, LSY1;              // limit screen up, limit screen down..
    //.....................
    
    //++++++++++++++++++++++++++++++++
    public scene( PImage texture, float x, float y, float w, float h ){
        this.texture = texture;
        this.xInicial = x;
        this.yInicial = y;
        this.x = 0;
        this.y = 0;
        this.w = w;
        this.h = h;
        this.r = new region(x, y, w, h);
        limiteX = texture.width  - w;
        limiteY = texture.height - h;
    }
    //++++++++++++++++++++++++++++++++
    void draw(){
        blitter.pushMatrix();
        blitter.scale(1, 1);
        blitter.rotate(0);
        blitter.tint(255, alpha);
        blitter.imageMode(CORNER);
        blitter.clip(r.x,r.y,r.w,r.h);
        blitter.image(texture, xInicial-x, yInicial-y);
        blitter.noClip();
        blitter.popMatrix();
        frame();
    }
    //++++++++++++++++++++++++++++++++
    void frame(){
        switch(st){
            //++++++++++++++++++++++++++++++++
            case 0:
                
                st = 10;
                break;
            //++++++++++++++++++++++++++++++++
            case 10:
                
                if(key(_LEFT )){x--;}
                if(key(_RIGHT)){x++;}
                if(key(_UP   )){y--;}
                if(key(_DOWN )){y++;}
                
                
                // control de movimiento por camara..
                if(camera != null){
                    CSX = camera.SX;
                    CSY = camera.SY;
                    LSX0 = xInicial + cameraLimit;
                    LSX1 = xInicial + r.w - cameraLimit;
                    LSY0 = yInicial + cameraLimit;
                    LSY1 = yInicial + r.h - cameraLimit;
                    // camera screen x exceds scene limit left..
                    if( CSX < LSX0 ){
                        x-=abs(camera.x-camera.oldX);
                    }
                    // camera screen x exceds scene limit right..
                    if( CSX > LSX1 ){
                        x+=abs(camera.x-camera.oldX);
                    }
                    // camera screen y exceds scene limit down..
                    if( CSY > LSY1 ){
                        y+=abs(camera.y-camera.oldY);
                    }
                    // camera screen y exceds scene limit up..
                    if( CSY < LSY0 ){
                        y-=abs(camera.y-camera.oldY);;
                    }
                }
                
                // scene limits control..
                if (x < 0) {
                    x = 0;
                }
                if (x > limiteX) {
                    x = limiteX;
                }
                if (y < 0) {
                    y = 0;
                }
                if (y > limiteY) {
                    y = limiteY;
                }
                break;
            //++++++++++++++++++++++++++++++++
            //++++++++++++++++++++++++++++++++
        }
    }
    //++++++++++++++++++++++++++++++++
    void setCamera(sprite cam_){
        this.camera = cam_;
    }
    //++++++++++++++++++++++++++++++++
    void setCameraLimit( int cameraLimit_ ){
        this.cameraLimit = cameraLimit_;
    }
    //++++++++++++++++++++++++++++++++
}
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------