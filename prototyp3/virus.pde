//	virus.pde
//	Das kleine Erzählervirus wird hier programmiert
//	Es hat mehrere Zustände:
//	Im Status 0, der im Startscreen mit dem Startbutton ausgelöst wird, soll 
//	der Virus aufgedreht gegen den Startbutton hüpfen
//	Im Status 1, soll der Virus eine feste Animation abspielen, die zum Übergang
//	zur Kindergarten-Infektion dienen soll.
//	

class Virus{

	//	Eigenschaften
	private PVector position 		= new PVector(0,0);
	private PVector targetPosition		= new PVector(0,0);
	private PVector beforePosition		= new PVector(0,0);
	private PVector direction 		= new PVector(0,0);
	private PVector directionNormal 	= new PVector(0,0);
	private PVector mySize;
	private float moveTime 		= 0;
	private int animationType 		= 0;
	private color myColor;
	private Timer myTimer 			= new Timer( 2000, true );
	private int myStatus 			= 0;
	private boolean isMoving 		= false;
	private ArrayList<VirusTarget> moveList = new ArrayList<VirusTarget>();


	//	Konstruktor mit Startkoordinaten als Parameter
	Virus( PVector _p ){

		position 		= _p;
		targetPosition 		= position;
		mySize 			= new PVector( 100, 100 );
		myColor 		= color( 0, 0, 255 );

	}


	//	Das Verhalten und Aussehen des Virus' wird hier verändert bzw. aktualisiert
	public void update(){

		myTimer.update();
		updateMovement();

		//	Wenn der Virus sich nicht mehr in einer Animation befindet,
		//	nächste Zielposition holen und animieren
		if( !isMoving && moveList.size() > 0 ){

			targetPosition 	= moveList.get(0).getTargetPosition();
			direction = PVector.sub( targetPosition, position );

			moveTime	= moveList.get(0).getTime();
			animationType = moveList.get(0).getAnimationType();

			moveList.remove(0);

		}

	}


	public void updateMovement(){

		//	Entspricht die Position nicht der Zielposition soll das Virus noch bewegt werden
		if( PVector.dist( position, targetPosition ) > 0.5 ){

			if( !isMoving ){
				myTimer.set( moveTime );
				myTimer.start();
				isMoving = true;
				beforePosition = position;
			}

			directionNormal = direction.normalize( null );

			if( animationType == 0 ){
				directionNormal.mult( 
							easeInOutCubic(
									myTimer.getTimer(),
									0, 
									direction.mag(),
									moveTime
									) 
							);
			}
			else if( animationType == 1 ){
				directionNormal.mult( (float)
							easeInOutExponential(
									myTimer.getTimer(),
									0, 
									direction.mag(),
									moveTime
									) 
							);
			}

			position = PVector.add( 
						beforePosition, 
						directionNormal
						);
		}
		else{
				myTimer.reset();
				isMoving = false;
				beforePosition = new PVector( 0,0 );
				targetPosition = position;
		}

	}


	//	hier wird der Virus angezeigt
	public void render(){

		//	hier Gestaltung vom Virus!
		fill( myColor );
		image( virusImage,
			(position.x - sim2.cam.getPosition().x) * sim2.cam.getZoom(), 
			(position.y - sim2.cam.getPosition().y) * sim2.cam.getZoom(),
			virusImage.width / 2, 
			virusImage.height / 2
			);
		/*ellipse( (position.x - sim2.cam.getPosition().x) * sim2.cam.getZoom(), 
			(position.y - sim2.cam.getPosition().y) * sim2.cam.getZoom(), 
			(mySize.x) * sim2.cam.getZoom(), 
			(mySize.y) * sim2.cam.getZoom() );*/

	}


	public void moveTo( float _x, float _y, float _time ){

		moveList.add( new VirusTarget( new PVector(_x,_y), _time, 0 ) );

	}

	public void moveTo( float _x, float _y, float _time, int _animationType ){

		moveList.add( new VirusTarget( new PVector(_x,_y), _time, _animationType ) );

	}


	//	Quelle: http://gizma.com/easing/
	//	Hiermit wird einfach eine flüssige Bewegung durchgeführt, die beschleunigt ist (cubic)
	//	t 	= aktuelle Zeit
	//	b 	= Startwert
	//	c 	= Wertänderung
	//	d 	= Dauer 
	float easeInOutCubic(float t, float b, float c, float d) {
 		 t /= d/2;
 		 if (t < 1) return c/2*t*t*t + b;
 		 t -= 2;
 		 return c/2*(t*t*t + 2) + b;
	};

	//	Quelle: http://gizma.com/easing/
	//	Hiermit wird einfach eine flüssige Bewegung durchgeführt, die beschleunigt ist (exponentiell)
	//	t 	= aktuelle Zeit
	//	b 	= Startwert
	//	c 	= Wertänderung
	//	d 	= Dauer 
	double easeInOutExponential( float t, float b, float c, float d) {
		t /= d/2;
		if (t < 1) return c/2 * Math.pow( 2, 10 * (t - 1) ) + b;
		t--;
		return c/2 * ( -Math.pow( 2, -10 * t) + 2 ) + b;
	};

}