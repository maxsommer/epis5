//	button.pde
//	Diese Klasse ist für Buttons zuständig
//	

class Button{

	protected PVector position;
	protected PVector mySize;
	protected color myColor;
	protected color myColorPressed;
	protected Event myEvent;
	protected boolean pressed;
	protected boolean pressedBefore = false;

	//	Der Konstruktor erwartet eine Position, eine Farbe und ein Event
	Button( PVector _position, color _color, color _colorpressed){

		position 	= _position;
		myColor 	= _color;
		myColorPressed	= _colorpressed;
		myEvent 	= new Event();
		mySize		= new PVector( 200, 50 );
		pressed	= false;

	}


	public void update(){

		if( checkPressed() ){
			changeButtonStatus( true );
		}

		if( checkReleased() ){
			myEvent.changeApplicationStatus( 1 );
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
		rect( position.x, position.y, mySize.x, mySize.y );

	}


	public boolean checkPressed(){

		//	Wenn die Funktion ausgeführt wird, wird überprüft ob die Maus beim Zeitpunkt
		//	des Klicks über dem Button war.
		if( 	
			mouseX >= position.x && mouseX <= position.x + mySize.x &&
			mouseY >= position.y && mouseY <= position.y + mySize.y &&
			mousePressed
		){

			pressedBefore = true;
			return true;

		}

		return false;

	}


	public boolean checkReleased(){

		if(pressedBefore && !mousePressed){
			pressedBefore = false;
			return true;
		}

		return false;

	}

	public void changeButtonStatus( boolean _status ){

		pressed = _status;

	}

}