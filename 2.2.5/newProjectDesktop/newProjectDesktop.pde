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
    img = loadImages("character");
    //snd = loadSounds("sounds");
}
//------------------------------------------------------------
void Draw() {
    switch(st) {
    case 0:
        world.setEdges();
        world.setGravity(0, 900);
        new personaje( 100, 350 );
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
    int anima = 0;
    int animaStand[] = { 14,14,14,14,14,14,15,15,15,15,15,15 };
    int animaWalk[]  = { 6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,10 };
    int animaDesc[]  = { 19,19,19,19,19,19,20,20,20,20,20,20 };
    int tecla = 0;
    boolean flag = false;
    int jumpSt = 0;
    //++++++++++++++++++++++++++++++++
    public personaje( float x, float y ){
        this.x = x;
        this.y = y;
    }
    //++++++++++++++++++++++++++++++++
    void frame(){
        switch(st){
            //++++++++++++++++++++++++++++++++
            case 0:
                // crear mascara de colision..
                PImage ima = newGraph(50, 50, color(1,1,1));
                setGraph(ima);
                alpha = 0;
                // crear cuerpo fisico para disponer de colisiones..
                createBody(TYPE_CIRCLE);
                setMaterial(HUMAN);
                setDamping(4);
                st = 10;
                break;
            //++++++++++++++++++++++++++++++++
            case 10:
                // control de movimiento..
                tecla = 0;
                if(key(_LEFT)){
                    addVx(-150);
                    tecla = 1;
                    flag  = true;
                }
                if(key(_RIGHT)){
                    addVx(150);
                    tecla = 2;
                    flag  = false;
                }
                if(key(_UP)){
                    if( isContact(225, 315) ){
                        jumpSt = 1;
                        addVy(-2500);
                    }
                }
                
                if( !key(_LEFT) && !key(_RIGHT) ){
                    setVx( getVx() * 0.7 );
                }
                
                
                // control de animacion..
                
                if(jumpSt == 0){
                    
                    switch(tecla){
                        case 0:
                            // stand animation cycle..
                            anima = ( anima + 1 ) % animaStand.length;
                            // side mirroring image control..
                            if(flag){
                                screenDrawGraphic( img[ animaStand[ anima ] ], x, y, 0, -200, 200, 255 );
                            } else{
                                screenDrawGraphic( img[ animaStand[ anima ] ], x, y, 0, 200, 200, 255 );
                            }
                            break;
                        //++++++++++++++++++++++++++++++++
                        case 1:
                            // walk animation cycle..
                            anima = ( anima + 1 ) % animaWalk.length;
                            screenDrawGraphic( img[ animaWalk[ anima ] ], x, y, 0, -200, 200, 255 );
                            break;
                        //++++++++++++++++++++++++++++++++
                        case 2:
                            // walk animation cycle..
                            anima = ( anima + 1 ) % animaWalk.length;
                            screenDrawGraphic( img[ animaWalk[ anima ] ], x, y, 0, 200, 200, 255 );
                            break;
                        //++++++++++++++++++++++++++++++++
                        case 3:
                            // jump cycle..
                            break;
                        //++++++++++++++++++++++++++++++++
                        
                    }
                
                } else{
                    
                    switch(jumpSt){
                        //++++++++++++++++++++++++++++++++
                        case 1:
                            // side mirroring image control..
                            if(flag){
                                screenDrawGraphic( img[ 17 ], x, y, 0, -200, 200, 255 );
                            } else{
                                screenDrawGraphic( img[ 17 ], x, y, 0, 200, 200, 255 );
                            }
                            /*
                            if(anima == 0){
                                jumpSt = 2;
                            }
                            */
                            
                            if(getVy() > 0){
                                jumpSt = 2;
                            }
                            
                            break;
                        //++++++++++++++++++++++++++++++++
                        case 2:
                            anima = ( anima + 1 ) % animaDesc.length;
                            // side mirroring image control..
                            if(flag){
                                screenDrawGraphic( img[ animaDesc[ anima ] ], x, y, 0, -200, 200, 255 );
                            } else{
                                screenDrawGraphic( img[ animaDesc[ anima ] ], x, y, 0, 200, 200, 255 );
                            }
                            
                            if( isContact(225, 315) ){
                                jumpSt = 0;
                            }
                            break;
                        //++++++++++++++++++++++++++++++++
                        //++++++++++++++++++++++++++++++++
                    }
                    
                    
                }
                
                break;
            //++++++++++++++++++++++++++++++++
        }
    }
}
//------------------------------------------------------------