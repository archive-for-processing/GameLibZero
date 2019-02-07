//------------------------------------------------------------
//------------------------------------------------------------
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
color c10 = #4A72FC;       // lila boton resaltado..
boolean lockUi = false;
//==============================================================================================================================================
class EGUIinputBox extends sprite {
    int st = 0;
    PImage g1, g2;
    String parameter="";
    String pwdModeParameter ="";
    int w, h;
    String title;
    int textSize = 14;
    boolean pwdMode;
    String eventName;
    color titleColor = 255;
    color parameterColor = 255;
    public EGUIinputBox( String title, String str, float x, float y, int w, int h, boolean pwdMode ) {
        type = -1001;        // tipo de proceso UI..
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
        this.parameter = str;
    }
    void frame() {
        switch(st) {
        case 0:
            priority = 64;
            g1 = newGraph(w, h, c1);
            g2 = newGraph(w, h, c2);
            setGraph(g1);
            createBody(TYPE_BOX);
            setStatic(true);
            st = 10;
            break;
        case 10:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-2, titleColor, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
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
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-2, titleColor, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            }
            if (!mouse.left) {
                lockUi = true;
                keyboard.setActive(true);
                st = 30;
            }
            break;
        case 30:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-2, titleColor, 255);
            if(pwdMode){
                pwdModeParameter = "";
                for(int i=0; i<parameter.length(); i++){
                    pwdModeParameter += "*";
                }
                screenDrawText(null, textSize, pwdModeParameter+(frameCount/10 % 2 == 0 ? "_" : ""), 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            } else{
                screenDrawText(null, textSize, parameter+(frameCount/10 % 2 == 0 ? "_" : ""), 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            }
            parameter = keyboard.buffer;

            if (key(_ENTER)) {
                method(eventName);
                st = 40;
            }
            
            if(mouse.left){                    // si este control esta activo y hay mouse.left..
                if(collisionMouse(this)){      // si el click es en el mismo control..
                                               // no pasa nada..
                } else{                        // si el click es en otro control..
                    method(eventName);         // finalizo la entrada de texto de este control..
                    st = 40;
                }
            }
            
            break;
        case 40:
            screenDrawText(null, textSize, title, 5, x-graph.width/2, y-2, titleColor, 255);
            if(pwdMode){
                screenDrawText(null, textSize, pwdModeParameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
            } else{
                screenDrawText(null, textSize, parameter, 3, x-(graph.width/2)+5, y-2, parameterColor, 255);
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
    void setTitleColor(color c){
        titleColor = c;
    }
    void setParameterColor(color c){
        parameterColor = c;
    }
    void setTextSize(int size){
        this.textSize = size;
    }
}
//==============================================================================================================================================
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
    String eventName;
    public EGUIbutton( String title, float x, float y ) {
        type = -1001;        // tipo de proceso UI..
        this.title = title;
        blitter.pushMatrix();
        blitter.textSize(textSize);
        w = (int)blitter.textWidth(title) + 10;
        blitter.popMatrix();
        this.x = x;
        this.y = y;
        this.size = 100;
    }
    public EGUIbutton( PFont fnt, String title, float x, float y ) {
        type = -1001;        // tipo de proceso UI..
        this.title = title;
        blitter.pushMatrix();
        blitter.textFont(fnt);
        textSize = fnt.getSize();
        h = textSize + textSize/2;
        blitter.textSize(textSize);
        w = (int)blitter.textWidth(title) + (int)textWidth("OO");
        blitter.popMatrix();
        this.x = x;
        this.y = y;
        this.size = 100;
    }
    public EGUIbutton( PImage gTile, float size, float x, float y ) {
        type = -1001;        // tipo de proceso UI..
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
            priority = 64;
            if (gTile != null) {
                g1 = newGraph(w+10, gTile.height+4, c1);
                g2 = newGraph(w+10, gTile.height+4, c2);
                g3 = newGraph(w+10, gTile.height+4, c10);
            } else {
                g1 = newGraph(w+4, h, c1);
                g2 = newGraph(w+4, h, c2);
                g3 = newGraph(w+4, h, c10);
            }
            sizeX = sizeY = size;
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
                lockUi = false;
                graph = g1;
                method(eventName);
                st = 10;
            }
            break;
        }
    }
        void setEvent( String methodName ){
        this.eventName = methodName;
    }
}
//==============================================================================================================================================
class EGUIradioButton extends sprite {
    int st = 0;
    String option[];
    int w = 110;
    int h = 18;
    int textSize = 14;
    PImage g1, g2, g3;
    int num = 0;
    int value = 0;        // indica la opcion escogida..
    boolean collision = false;
    String eventName;
    public EGUIradioButton( String option[], float x, float y ) {
        type = -1001;        // tipo de proceso UI..
        this.option = option;
        this.x = x;
        this.y = y;
    }
    void frame() {
        switch(st) {
        case 0:
            priority = 64;
            g1 = newGraph(w-2, h, c1);
            g2 = newGraph(w-2, h, c2);
            g3 = newGraph(w-2, h, c10);
            st = 10;
            break;
        case 10:
            for ( int i=0; i<option.length; i++ ) {
                num = int((mouse.x-(x-w/2)) / w);
                collision = false;
                if (mouse.y>y-h/2 && mouse.y<y+h/2) {
                    collision = true;
                }
                
                if (collision) {
                    if(mouse.left){
                        this.st = 20;
                    }
                    if (num==i) {
                        if (mouse.left) {
                            value = num;
                            screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);        // colisiono y mouse SI encima mio y mouse.left SI..
                        } else {
                            screenDrawGraphic(g3, x + w*i, y, 0, 100, 100, 255);        // colisiono y mouse NO encima mio y mouse.left NO..
                            if(num==value){
                                screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);
                            }
                        }
                    } else {
                        screenDrawGraphic(g1, x + w*i, y, 0, 100, 100, 255);            // colisiono y mouse NO encima mio..
                    }
                    
                    if(value==i){
                        screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);
                    }
                } else {
                    if (value == i) {
                        screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);    // colision NO y seleccionado SI..
                    } else {
                        screenDrawGraphic(g1, x + w*i, y, 0, 100, 100, 255);    // colision NO y seleccionado NO..
                    }
                }   

                screenDrawText(null, textSize, option[i], 4, x + w*i, y-2, 255, 255);
            }
            
            break;
        case 20:
            for ( int i=0; i<option.length; i++ ) {
                num = int((mouse.x-(x-w/2)) / w);
                collision = false;
                if (mouse.y>y-h/2 && mouse.y<y+h/2) {
                    collision = true;
                }
                
                if (collision) {
                    if (num==i) {
                        if (mouse.left) {
                            value = num;
                            screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);        // colisiono y mouse SI encima mio y mouse.left SI..
                        } else {
                            screenDrawGraphic(g3, x + w*i, y, 0, 100, 100, 255);        // colisiono y mouse NO encima mio y mouse.left NO..
                            if(num==value){
                                screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);
                            }
                        }
                    } else {
                        screenDrawGraphic(g1, x + w*i, y, 0, 100, 100, 255);            // colisiono y mouse NO encima mio..
                    }
                    
                    if(value==i){
                        screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);
                    }
                } else {
                    if (value == i) {
                        screenDrawGraphic(g2, x + w*i, y, 0, 100, 100, 255);    // colision NO y seleccionado SI..
                    } else {
                        screenDrawGraphic(g1, x + w*i, y, 0, 100, 100, 255);    // colision NO y seleccionado NO..
                    }
                }   

                screenDrawText(null, textSize, option[i], 4, x + w*i, y-2, 255, 255);
            }
            
            if(!mouse.left){
                method(eventName);
                this.st = 10;
            }
            break;
        }
    }
    //++++++++++++++++++++++++++
    void setEvent( String methodName ){
        this.eventName = methodName;
    }
    //++++++++++++++++++++++++++
}
//==============================================================================================================================================
class EGUIlabel extends sprite {
    PFont fnt_;
    int size;
    String text;
    int cod;
    color col;
    //++++++++++++++++++++++++++
    public EGUIlabel(PFont fnt_, int size, String text, int cod, float x, float y, color col, float alpha){
        this.fnt_ = fnt_;
        this.size = size;
        this.text = text;
        this.cod = cod;
        this.x = x;
        this.y = y;
        this.col = col;
        this.alpha = alpha;
        priority = 64;
        type = -1001;        // tipo de proceso UI..
    }
    //++++++++++++++++++++++++++
    void frame(){
        screenDrawText(fnt_, size, text, cod, x, y, col, alpha);
    }
    //++++++++++++++++++++++++++
}
//==============================================================================================================================================
class EGUIcheckBox extends sprite {
    int st = 0;
    PImage g1, g2, g3;
    String title = "";
    boolean value = false;        // parametro de salida que dice como esta la caja..
    int textSize = 14;
    int w = 22;
    color color1 = c1;
    color color2 = c2;
    int size = 18;
    String eventName;
    //++++++++++++++++++++++++++
    public EGUIcheckBox( float x, float y, int size ) {
        this.x = x;
        this.y = y;
        this.size = size;
    }
    //++++++++++++++++++++++++++
    public EGUIcheckBox( float x, float y, int size, color cc1, color cc2 ) {
        this.x = x;
        this.y = y;
        this.color1 = cc1;
        this.color2 = cc2;
        this.size = size;
        g1 = newGraph(size, size, color1);
        g2 = newGraph(size, size, color2);
        g3 = newGraph(size, size, color2);
    }
    //++++++++++++++++++++++++++
    void frame() {
        switch(st) {
        case 0:
            type = -1001;        // tipo de proceso UI..
            priority = 64;
            //g1 = newGraph(size, size, color1);
            //g2 = newGraph(size, size, color2);
            //g3 = newGraph(size, size, color2);
            if(graph!=null){        // si he llamado a setValue() antes de que pase un frame.. graph ya tiene algun valor.. lo uso para el setGraph()..
                setGraph(graph);
            } else{
                setGraph(g1);
            }
            createBody(TYPE_BOX);
            setStatic(true);
            st = 10;
            break;
        //++++++++++++++++++++++++++
        case 10:
            if ( collisionMouse(this) && !lockUi ) {
                screenDrawGraphic(g3, x, y, 0, 100, 100, 64);
                if (mouse.left) {
                    
                    if(value) {
                        value = false;
                        graph = g1;
                    } else if (!value) {
                        value = true;
                        graph = g2;
                    }
                    st = 20;
                }
            }
            break;
        //++++++++++++++++++++++++++
        case 20:
            lockUi = true;
            if (!mouse.left) {
                lockUi = false;
                method(eventName);
                st = 10;
            }
            break;
        }
    }
    //++++++++++++++++++++++++++
    void setValue(boolean value) {
        if(value) {
            graph = g2;
            this.value = true;
            } else{
                graph = g1;
                this.value = false;
        }
    }
    //++++++++++++++++++++++++++
    void setColorSelected( color c ){
        this.color1 = c;
    }
    //++++++++++++++++++++++++++
    void setColorUnselected(color c){
        this.color2 = c;
    }
    //++++++++++++++++++++++++++
    void setEvent( String methodName ){
        this.eventName = methodName;
    }
    //++++++++++++++++++++++++++
}
//==============================================================================================================================================
//==============================================================================================================================================
//==============================================================================================================================================
//==============================================================================================================================================
