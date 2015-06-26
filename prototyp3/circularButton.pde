//	circularButton.pde
//	runder Button

class CircularButton extends Button{

	private float radius;
	private int status;


	CircularButton( PVector _position, color _color, color _colorpressed){

		super( _position, _color, _colorpressed );
		radius		= 300;

	}	

	CircularButton( PVector _position, color _color, color _colorpressed, int _status){

		super( _position, _color, _colorpressed );
		radius		= 300;
		status 		= _status;

	}


	public void update(){

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
			fill( myColor ); 
		}else{
			fill( myColorPressed );
		}
		ellipse( position.x, position.y, radius, radius );

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