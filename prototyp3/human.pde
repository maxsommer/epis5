//	human.pde
//	Die Klasse Human sagt bereits mit dem Namen alles aus
//	

class Human{

	private PVector position = new PVector( 0, 0 );
	private float myColorRed = 0;
	private float myColorGreen = 0;
	private float myColorBlue = 200;
	private int radius = 20;
	private float colorPulse = 0;
	private boolean colorPulsating = false;

	//	Status der Person; 0: gesund, 1: infiziert, aber ohne anzeichen, 2: infiziert, mit anzeichen, 3: im Krankenhaus, 4: immun
	private int state = 0;
	private Timer timer = new Timer( 10000 + random(-5000, 5000), true );


	Human( float posX, float posY ){

		position.x 	= posX;
		position.y 	= posY;
		colorPulse 	= random(0,100);

	}


	public void update(){

		timer.update();

		//	Wechsel von Stufe 1 auf 2
		if( state == 1 && !timer.paused && !timer.isAlive() ){

			timer.reset();
			timer.set( 3000 + random(-1000,1000) );
			timer.start();
			state = 2;

		}

		//	Soll die Farbe der einzelnen Menschen "pulsieren", so kann man die variable einfach auf true setzen
		if(colorPulsating){
			colorPulse += 0.04;
			myColorBlue = 150 + 100*sin(colorPulse);
		}

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
			myColorGreen = 0;
			myColorBlue = 0;
		}else if(state == 3){
			myColorRed = 200;
			myColorGreen = 200;
			myColorBlue = 200;
		}else if(state == 4){
			myColorRed = 0;
			myColorGreen = 200;
			myColorBlue = 0;
		}

	}


	public void render(){

		noStroke();
		fill( myColorRed, myColorGreen, myColorBlue );
		ellipse( position.x, position.y, radius, radius );

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

}