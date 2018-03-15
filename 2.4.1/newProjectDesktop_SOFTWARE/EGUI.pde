//------------------------------------------------------------
//------------------------------------------------------------
color c1 = #002d5a;        // azul fuerte..
color c2 = #0074d9;        // azul claro..
color c3 = #505050;        // gris fondo ventana claro..
color c4 = #323232;        // gris fondo ventana oscuro..
color c5 = #fe0000;        // rojo fuerte..
color c6 = #680000;        // rojo claro..
color c7 = #11A557;        // verde..
color c8 = #F8FC0A;        // amarillo..
color c9 = #F2A30F;        // naranja..
boolean lockUi = false;
//------------------------------------------------------------
//------------------------------------------------------------
void EGUInoEvent(){
    
}
//------------------------------------------------------------
//------------------------------------------------------------
class EGUIinputBox extends sprite {
    int st = 0;
    PImage g1, g2;
    String parameter="";
    String pwdModeParameter ="";
    int w, h;
    String title;
    int textSize = 10;
    boolean pwdMode;
    String eventName = "EGUInoEvent";
    public EGUIinputBox( String title, String str, float x, float y, int w, int h, boolean pwdMode ) {
        blitter.pushMatrix();
        blitter.textSize(textSize);
        float anchoTitulo = blitter.textWidth(title);
        blitter.popMatrix();
        this.x = x + w/2 + anchoTitulo;
        this.y = y;
        this.w = w;
        this.h = h;
        this.title = title;
        this.pwdMode = pwdMode;
    }
    void frame() {
        switch(st) {
        case 0:
            type = -1001;        // tipo de proceso UI..
            priority = 64;
            g1 = newGraph(w, h, c1);
            g2 = newGraph(w, h, c2);
            setGraph(g1);
            createBody(TYPE_BOX);
            setStatic(true);
            st = 10;
            break;
        case 10:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-1, 255, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            }
            if (collisionMouse(this) && !lockUi ) {
                graph = g2;
                if (mouse.left) {
                    keyboard.buffer = parameter;
                    st = 20;
                }
            } else {
                graph = g1;
            }
            break;
        case 20:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-1, 255, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            }
            if (!mouse.left) {
                lockUi = true;
                keyboard.setActive(true);
                st = 30;
            }
            break;
        case 30:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-1, 255, 255);
            if(pwdMode){
                pwdModeParameter = "";
                for(int i=0; i<parameter.length(); i++){
                    pwdModeParameter += "*";
                }
                screenDrawText(null, textSize, pwdModeParameter+(frameCount/10 % 2 == 0 ? "_" : ""), 3, x-(graph.width/2)+5, y-1, 255, 255);
            } else{
                screenDrawText(null, textSize, parameter+(frameCount/10 % 2 == 0 ? "_" : ""), 3, x-(graph.width/2)+5, y-1, 255, 255);
            }
            parameter = keyboard.buffer;

            if (key(_ENTER)) {
                method(eventName);
                st = 40;
            }
            break;
        case 40:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-1, 255, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-1, 255, 255);
            }
            if (!key(_ENTER)) {
                lockUi = false;
                keyboard.setActive(false);
                keyboard.clear();
                st = 10;
            }
            break;
        }
    }
    void setEvent( String methodName ){
        this.eventName = methodName;
    }
}
//------------------------------------------------------------
class EGUIbutton extends sprite {
    int st = 0;
    int value = 0;
    int w;
    int h = 18;
    PImage g1, g2, g3;
    int textSize = 14;
    String title="";
    PImage gTile;
    float size;
    String eventName = "EGUInoEvent";
    public EGUIbutton( String title, float x, float y ) {
        this.title = title;
        blitter.pushMatrix();
        blitter.textSize(textSize);
        w = (int)blitter.textWidth(title);
        blitter.popMatrix();
        this.x = x;
        this.y = y;
    }
    public EGUIbutton( PImage gTile, float size, float x, float y ) {
        this.gTile = gTile;
        this.x = x;
        this.y = y;
        this.size = size;
        this.w = gTile.width;
    }
    void frame() {
        if (gTile != null) {
            screenDrawGraphic( gTile, x, y, 0, size, size, 255 );
        }
        switch(st) {
        case 0:
            type = -1001;        // tipo de proceso UI..
            priority = 64;
            if (gTile != null) {
                g1 = newGraph(w+10, gTile.height+4, c1);
                g2 = newGraph(w+10, gTile.height+4, c2);
                g3 = newGraph(w+10, gTile.height+4, c3);
            } else {
                g1 = newGraph(w+4, h, c1);
                g2 = newGraph(w+4, h, c2);
                g3 = newGraph(w+4, h, c3);
            }
            setGraph(g1);
            createBody(TYPE_BOX);
            setStatic(true);
            st = 10;
            break;
        case 10:
            screenDrawText(null, textSize, title, 4, x, y-2, 255, 255);
            if (collisionMouse(this) && !lockUi ) {
                graph = g3;
                if (mouse.left) {
                    graph = g2;
                    value = 1;
                    //method(eventName);
                    st = 20;
                }
            } else {
                graph = g1;
            }
            break;
        case 20:
            lockUi = true;
            screenDrawText(null, textSize, title, 4, x, y-2, 255, 255);
            value = 0;
            if (!mouse.left) {
                method(eventName);
                lockUi = false;
                graph = g1;
                st = 10;
            }
            break;
        }
    }
        void setEvent( String methodName ){
        this.eventName = methodName;
    }
}
//------------------------------------------------------------
//------------------------------------------------------------
//------------------------------------------------------------