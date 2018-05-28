// Missile
// Class

class Missile {
  
  PVector loc;
  
  Missile( float x, float y )
  {
    loc = new PVector( x, y );
  }
  
  void display()
  {
    noStroke();
    fill( 200, 0, 0 );
    rect( loc.x, loc.y, 5, 20 );
  }
  
  void move()
  {
    loc.add( 0, -25 );
  }
  
  
  
  
}