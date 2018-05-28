//
//

class Ship {
  
  PVector loc;
  int state;                       // 1 = alive, 2 = blowing up, 3 = warping, 4 = warp and destruct
  int decay = 30;
  int warpState = 0;
  
  // constructor
  Ship( float x, float y )
  {
    loc = new PVector( x, y );
    state = 1;
  }


  
  Ship createShip( float x, float y )
  {
    Ship spawn = new Ship( x, y );
    ships.add( spawn );
    return spawn;
  }
  
  // move function
  void addXY( float x, float y )
  {
     loc.add( x, y ); 
  }


  // go warp speed lol
  void warp()
  {
    state = 3;
    warpState = 15;
  }
  
  void blowUp()
  {
    state = 2; //the blow-up state
  }
  
  void warpAndBlow()
  {
    state = 4;
    warpState = 15;
  }
  
  //spawns a missile
  void shoot()
  {
    if ( state == 1 ) missiles.add( new Missile( loc.x + 47 , loc.y - 30 ));
  }

  // draw function
  void display()
  {
    if ( state == 1 )                        //default state
      image( shipImage, loc.x, loc.y );
 
    if ( state == 2 )                         //exploding
    {
      image( explosion, loc.x, loc.y );
      decay--;                            //decrease explosion time
      if ( decay == 0 ) {                  //have shown for 20 frames - disappear now
        ships.remove( this );
      }  
    }
    
    if ( state == 3 || state == 4 )          //warping or warping + self destruct
    {               
      loc.add( 0, -20 );
      image( shipImage, loc.x, loc.y );
      warpState--;
      if ( warpState == 0 )       //if done warping
      {
        if ( state == 3 ){           //go default state
          state = 1;
        }
        else  // state == 4          //go blow up
          state = 2;  
      }
    }
  }
  

  
}