//	caption.pde
//	Die Klasse Caption ist für die Legende zuständig
//	

class Caption {

  boolean healthyVisible = false;
  boolean infectedVisible = false;
  boolean vaccinedVisible = false;

  Human h1 = new Human( windowResolution.x / 7 * 2.4, windowResolution.y - 30, false );
  Human h2 = new Human( windowResolution.x / 7 * 4.4, windowResolution.y - 30, false );
  Human h5 = new Human( windowResolution.x / 7 * 3.4, windowResolution.y - 30, false );

  Caption() {

    h2.setState( 1 );
    h2.timer.reset();
    h5.setState( 4 );
    h5.timer.reset();
  }

  void update() {

    h1.update();
    h2.update();
    h5.update();
  }

  void render() {

    //	Sobald einer der drei Legendenelemente sichtbar ist
    //	soll eine halbtransparente weiße Leiste dahinter gelegt
    //	werden
    if ( healthyVisible || infectedVisible || vaccinedVisible ) {
      fill(255, 200);
      rect( 0, windowResolution.y - 60, windowResolution.x, 60 );
    }

    if ( healthyVisible ) {
      h1.render();
      fill(0);
        text( "Gesund", h1.getPosition().x  + 20, h1.getPosition().y + 2.5 );
    }

    if ( infectedVisible ) {
      h2.render();
      fill(0);
      text( "Infiziert", h2.getPosition().x  + 20, h2.getPosition().y + 2.5 );
    }

    if ( vaccinedVisible ) {
      h5.render();
      fill(0);
      text( "Geimpft", h5.getPosition().x  + 20, h5.getPosition().y + 2.5 );
    }
  }
}

