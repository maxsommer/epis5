//	circularButton.pde
//	runder Button

class CircularButton extends Button{

	private float radius;
	private int status;
	private float sizing;


	CircularButton( PVector _position, color _color, color _colorpressed){

		super( _position, _color, _colorpressed );
		radius		= 250;

	}	

	CircularButton( PVector _position, color _color, color _colorpressed, int _status){

		super( _position, _color, _colorpressed );
		radius		= 250;
		status 		= _status;

	}


	public void update(){

		sizing += 0.02;

		radius = 250 + sin( sizing ) * 35;

		if( checkPressed() ){
			changeButtonStatus( true );
		}

		if( checkReleased() ){
			myEvent.changeApplicationStatus( status );
			changeButtonStatus( false );
		}

	}


	public void render(){

		noStroke();
		if( pressed ){
			fill( myColorPressed ); 
		}else{
			fill( myColor );
		}
		ellipse( position.x, position.y, radius, radius );
		fill( 90, 90, 90, 200 );
		ellipse( position.x, position.y, radius + 50 , radius + 50 );
		image( playImage, position.x - (radius - 120)/2, position.y - (radius-100)/2, radius-100, radius-100 );

	}


	public boolean checkPressed(){

		//	Wenn die Funktion ausgeführt wird, wird überprüft ob die Maus beim Zeitpunkt
		//	des Klicks über dem Button war.
		if( 	
			PVector.dist( new PVector( mouseX, mouseY ), position ) <= radius && mousePressed
		){

			pressedBefore = true;
			return true;

		}

		return false;

	}

}