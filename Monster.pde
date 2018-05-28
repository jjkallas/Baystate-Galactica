
// the "Ouchies"
// monster
// class


int maxHealth = 1;
int monsterSize = 60;

class Monster
{
  PVector loc;
  int health;
  boolean alive;
  int decay;
  int hitDecay;
  int size = monsterSize;
 
  Monster( float x, float y )
  {
     loc = new PVector( x, y );
     health = maxHealth;
     alive = true;
     decay = 25;
     hitDecay = 0;
  }
 
  void display()
  {
    if ( alive ) {
      image( monster, loc.x, loc.y );
      if ( hitDecay > 0 ){
        image( blood, loc.x + 10, loc.y - 25 );
        hitDecay--;
      }
    }
    else {
      image( goo, loc.x, loc.y );
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
      loc.y = loc.y + 1.5;
    }
    else {
      if ( random( 1 ) > 0.5 ){
        loc.x += 2;
      }
      else
        loc.x -= 2;
    }
    if ( loc.x > width - monsterSize ) { loc.x = width - monsterSize; }
    if ( loc.x < 0 ) { loc.x = 0; }
  }
 
 
 
  void hit()
  {
    health--;   
   
    if ( health == 0 )
    {
      die();
    }
    else
    hitDecay = 10;
}
 
  void die()
  {
    alive = false; 
    killCount++;
  }
 
  void setHealth( int hp )
  {
    health = hp;
  }
 
 
}