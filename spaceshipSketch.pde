// spaceship game
//
// main program

// SPRITES USED
PImage shipImage;
PImage explosion;
PImage monster;
PImage goo;
PImage boss;
PImage bossGoo;
PImage blood;

int numMonsters;
int numShips = 4;
int moveDistance = 50;

int shipSize = 50;


ArrayList<Ship> ships;
ArrayList<Missile> missiles;
ArrayList<Monster> monsters;

int gameOver;
int level;
boolean paused = false;

int killCount;

// setup function runs once at start
void setup()
{
  size( 800, 600 ); 
  fill( 200, 0, 0 );
   
  // set game mode for level 1
  gameOver = 0;
  killCount = 0;
  level = 1;
  numMonsters = 12;
 
  //create arrays
  ships = new ArrayList<Ship>();
  missiles = new ArrayList<Missile>();
  monsters = new ArrayList<Monster>();
 
  for ( int i = 0; i < numShips; i++ ){
    ships.add( new Ship( i * 110 + 120, height - height/6 ));
  }
 
  for ( int i = 0; i < numMonsters; i++ ){
    monsters.add( new Monster( i * monsterSize + 20, 40 ) );
  }

  //load graphics
  shipImage = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\newShip.png" );
  shipImage.resize( 100, 100 );

  explosion = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\explosionHD.png" );
  explosion.resize( 120, 120 );

  monster = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\spaceMonster.png" );
  monster.resize( monsterSize, monsterSize );
 

  goo = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\slime.png" ); 
  bossGoo = goo.copy();
  bossGoo.resize( bossSize, bossSize );
  goo.resize( monsterSize, monsterSize );
 
  blood = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\alienMad.png" );
  blood.resize( 35, 35 );
 
  boss = loadImage( "C:\\Users\\Jack\\workspace\\SpaceGame\\superMonster.png" );
  boss.resize( bossSize, bossSize  );
 
}


void draw()
{
  background( 0 );
 
  if ( ships.isEmpty() ){
    gameOver = 1;
  }
 
  if ( gameOver == 1 ){
    stroke(255, 0, 0);
    textSize(50);
    text( "ouchie", width/2 - 60, height/2 - height/4 );
   
    strokeWeight( 2 );
    stroke( 0, 200, 00 );
    text( "achieved level: " + level, width/4 + 20, height/2 + height/3);
    text( "ouchies slain: " + killCount, width/4, height/2 + height/3 + 60 );
   
    noFill();
    textSize(15);
    stroke(137, 137, 137);
    strokeWeight(5);
    rect( width/2 - 45, height/2, 100, 40 );
    text( "play again", width/2 - 30, height/2 + 25 );
    return;
  }
 
  if ( monsters.isEmpty()){ // all enemies slain - advance to next lvl + populate world
    level++;
     
    if ( level != 10 && level != 5 ) { 
      // populate monster waves
      for ( int i = 0; i < level-1; i++ ){
        monsters.add( new Boss( random( 0, width - bossSize), 0 ) );
        monsters.get(i).setHealth( 100 );
      }
      for ( int i = 0; i < level % 10; i++ ){
        monsters.add( new Monster( monsters.get(0).loc.x + (i * monsterSize), height/3 ));
      }
    }
    
    else if ( level != 5 ) { // lvl 10
      int monsterRow = 0;
      int j = 0;
      for ( int i = 0; i < 72; i++ ){
        monsters.add( new Monster( j * monsterSize + 20 , monsterRow ) ); 
  
        j++;
        if ( j > 11 ) {
          monsterRow += monsterSize;
          j = 0;
        }
        
      }
     
    }
    else { // lvl 5
      int monsterRow = 0;
      int j = 0;
      for ( int i = 0; i < 36; i++ ){
        monsters.add( new Monster( j * monsterSize + 20 , monsterRow ) ); 
  
        j++;
        if ( j > 11 ) {
          monsterRow += monsterSize;
          j = 0;
        }
      }
    }
    
    
  }
  else { // run regular game-mode
    
    textSize( 20 );
    text( level, width - 30, 30 );
    
    for ( int i = monsters.size() - 1; i >= 0; i-- ){
      if ( monsters.get(i).loc.y > height - monsters.get(i).size ) {
        for ( Ship s : ships ){
          s.blowUp();
        }
      }
      monsters.get( i ).moveRandom();
      monsters.get( i ).display();   
      }
  }
  
 
  for ( int i = 0; i < ships.size(); i++ ){
    Ship s = ships.get( i );
    s.display();
   
    for ( Monster mob : monsters ){   //check monsters for ship collision
      if ( s.loc.x > mob.loc.x && s.loc.x < mob.loc.x + mob.size
        && s.loc.y > mob.loc.y && s.loc.y < mob.loc.y + mob.size ){
          s.blowUp();
          mob.die();
          break;
        }
    }
        
   
  }
 
  if ( missiles.size() > 0 ) {   // if missiles in flight
 
    for ( int i = 0; i < missiles.size(); i++ ){
      Missile m = missiles.get( i );
      m.display();
      m.move();
      for ( Monster mob : monsters ){
        if ( m.loc.x > mob.loc.x && m.loc.x < mob.loc.x + mob.size
          && m.loc.y > mob.loc.y && m.loc.y < mob.loc.y + mob.size ){
            mob.hit();
            missiles.remove( m );
          }
      }
      if ( m.loc.y < 0 ){                // if missile hits ceiling
        image( explosion, m.loc.x - 55, -50 );
        if ( m.loc.y < -100 ) {
          missiles.remove( i );
        }
      }
    }
 
  }
 
   println( missiles.size() ); 
}




void keyPressed()
{
  if ( keyCode == LEFT && paused == false)
  {
    for( int i = 0; i < ships.size(); i++ ){
      ships.get( i ).addXY( -moveDistance, 0 );
      if ( ships.get( i ).loc.x < -50 ) {
        ships.get(i).addXY( +moveDistance, 0 );
        return;
      }
    }
  } 
  else if ( keyCode == RIGHT && paused == false)
  {
    for( int i =  ships.size() - 1; i >= 0; i-- ){
      ships.get( i ).addXY( moveDistance, 0 );
      if ( ships.get( i ).loc.x + shipSize > width ) {
        ships.get(i).addXY( -moveDistance, 0 );
        return;
      }
    }
  } 
  else if ( keyCode == UP && paused == false)
  {
    for( int i = 0; i < ships.size(); i++ ){
      ships.get( i ).addXY( 0, -moveDistance );
      if ( ships.get( i ).loc.y < -5 ) {
        ships.get( i ).addXY( 0, moveDistance );
        ships.get( i ).blowUp();
      }
    }
  }
  else if ( keyCode == DOWN && paused == false)
  {
    for( int i = 0; i < ships.size(); i++ ){
      ships.get( i ).addXY( 0, moveDistance );
      if ( ships.get( i ).loc.y > height - 50 ){
        ships.get( i ).addXY( 0, -moveDistance );
        return;
      }
      
    }
  }
  
  if ( keyCode == CONTROL && paused == false)
  {
    for( int i = 0; i < ships.size(); i++ ){
      ships.get( i ).shoot();
    }
  }
  if ( keyCode == 80 ) // pressing 'p' pauses the game
  {
    if ( paused == false ){
      paused = true;
      text( "PAUSED", width/2, height/2 );
      noLoop();
    } else if ( paused == true ){
      paused = false;
      loop();
    }
    
  }
}

// if left click ship - shoot
// if right click ship - warp and self-destruct
void mouseClicked()
{
  
  //                          if clicked "play again" button at gameover screen
  if ( gameOver == 1 &&
        mouseX > width/2 - 45 && mouseX < width/2 + 55 &&
        mouseY > height/2 && mouseY < height/2 + 40 )
        {
          setup();
        }
  
  if ( mouseButton == LEFT ) {
    for( int i = 0; i < ships.size(); i++ ){              // loop through ships and check if clicked them
      if ( mouseX > ships.get(i).loc.x && mouseX < (ships.get(i).loc.x + 100) 
        && mouseY > ships.get(i).loc.y && mouseY < (ships.get(i).loc.y + 100 ))
      {
        ships.get(i).shoot();
        return;
      }
    }
  }
  else {    // mouseButton == RIGHT
    for( int i = 0; i < ships.size(); i++ ){            // loop through ships and check if clicked them
      if ( mouseX > ships.get(i).loc.x && mouseX < (ships.get(i).loc.x + 100) 
        && mouseY > ships.get(i).loc.y && mouseY < (ships.get(i).loc.y + 100 ))
      {
        ships.get(i).warpAndBlow(); 
        return;
      }
    }
  }

}