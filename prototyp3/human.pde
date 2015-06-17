//	human.pde
//	Die Klasse Human sagt bereits mit dem Namen alles aus
//	

class Human{

	private PVector position = new PVector( 0, 0 );
	private float myColorRed = 0;
	private float myColorGreen = 0;
	private float myColorBlue = 200;
	private float radius = 0;
	private float radiusExtended = 0;
	private boolean relativeToCamera = true;

	//	Status der Person; 0: gesund, 1: infiziert, aber ohne anzeichen, 2: infiziert, mit anzeichen, 3: im Krankenhaus
	private int state = 0;
	private Timer timer = new Timer( 10000 + random(-5000, 5000), true );


	Human( float posX, float posY ){

		position.x 		= posX;
		position.y 		= posY;
		radius			= humanRadius;
		radiusExtended	= humanRadiusExtended;

	}

	Human( float posX, float posY , boolean _relativeToCamera){

		position.x 		= posX;
		position.y 		= posY;
		radius			= humanRadius;
		radiusExtended	= humanRadiusExtended;
		relativeToCamera	= _relativeToCamera;

	}


	public void update(){

		timer.update();

		//	Wechsel von Status 1 (Infiziert, ohne Symptome) auf 2 (Infiziert, mit Symptomen)
		if( state == 1 && !timer.paused && !timer.isAlive() ){

			timer.reset();
			timer.set( 3000 + random(-1000,1000) );
			timer.start();
			state = 2;

		}

		//	Wechsel von Status 2 (Infiziert, mit Symptomen) auf 3 (Krankenhaus)
		if(state == 2 && !timer.paused && !timer.isAlive() ){

			timer.reset();

				if( percentChance( 13 ) ){
					state = 3;
				}

		}

		//	Farbe einstellen, je nach Status

		if(state == 0){
			myColorRed = 0;
			myColorGreen = 0;
			myColorBlue = 200;
		}else if(state == 1){
			myColorRed = 0;
			myColorGreen = 200;
			myColorBlue = 200;
		}else if(state == 2){
			myColorRed = 200;
			myColorGreen = 200;
			myColorBlue = 0;
		}else if(state == 3){
			myColorRed = 200;
			myColorGreen = 0;
			myColorBlue = 0;
		}

	}


	public void render(){

		noStroke();

		if(relativeToCamera){

			fill( myColorRed, myColorGreen, myColorBlue, 120 );
			ellipse( position.x - sim.cam.getPosition().x, position.y - sim.cam.getPosition().y, radius+radiusExtended, radius+radiusExtended );

			fill( myColorRed, myColorGreen, myColorBlue );
			ellipse( position.x - sim.cam.getPosition().x, position.y - sim.cam.getPosition().y, radius, radius );

		}

		if(!relativeToCamera){

			fill( myColorRed, myColorGreen, myColorBlue, 120 );
			ellipse( position.x, position.y , radius+radiusExtended, radius+radiusExtended );

			fill( myColorRed, myColorGreen, myColorBlue );
			ellipse( position.x, position.y, radius, radius );
			
		}

	}


	public boolean inRange( Human h ){

		if( PVector.dist( this.position, h.position ) < sim.infectionRange ){

			return true;

		}

		return false;

	}


	public boolean isInfecting(  ){

		if( this.state == 1 || this.state == 2 ){
			return true;
		}

		return false;

	}


	public void infect(){

		//	es kann nur infiziert werden, wer es noch nicht ist!
		if(this.state == 0){
			this.state = 1;
			timer.start();
		}

	}


	public void setState( int _state ){
		state = _state;
	}


	public PVector getPosition(){
		return position;
	}

}