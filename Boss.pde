
//
//
// Boss Class

int bossSize = 200;

class Boss extends Monster
{
 
 
  Boss( float x, float y )
  {
    super( x, y ); 
    size = bossSize;
  }
 
  void display()
  {
    if ( alive ) {
      image( boss, loc.x, loc.y );
      if ( hitDecay > 0 ){
        image( blood, loc.x + 80, loc.y - 40 );
        hitDecay--;
      }
    }
    else {
      image( bossGoo, loc.x, loc.y );
      decay--;
     
      if ( decay == 0 )
      {
        monsters.remove( this );
      }
    }
  }
 
 
  void moveRandom()
  {
    if ( random( 1 ) > 0.5 ){
      loc.y = loc.y + 1;
    }
    else {
      if ( random( 1 ) > 0.5 ){
        loc.x += 2;
      }
      else
        loc.x -= 2;
    }
    if ( loc.x > width ) { loc.x = width; }
    if ( loc.x < 0 ) { loc.x = 0; }
  }
 
 
 
}