//	virus.pde
//	Das kleine Erzählervirus wird hier beschrieben
//	

class Virus{

	//	Eigenschaften
	private PVector position;
	private PVector mySize;
	private color myColor;
	private Timer myTimer;


	Virus( PVector p ){

		position = p;
		mySize = new PVector( 200, 200 );
		myColor = color( 0, 0, 255 );
		myTimer = new Timer( 2000, true );

	}


	public void update(){

		

	}


	public void render(){

		//	hier Gestaltung vom Virus!
		fill( myColor );
		ellipse( (position.x - sim2.cam.getPosition().x) * sim2.cam.getZoom(), 
			(position.y - sim2.cam.getPosition().y) * sim2.cam.getZoom(), 
			(mySize.x) * sim2.cam.getZoom(), 
			(mySize.y) * sim2.cam.getZoom() );

	}

}