//	camera.pde
//	Je nach Kameraposition und -zoom wird die Ansicht verändert
//	

class Camera{

	//	Liste an anstehenden bewegungen und zooms
	ArrayList<CameraTarget> cameraTargets = new ArrayList<CameraTarget>();

	//	Position der Kamera, Normalerweise links oben im Koordinatensystem
	//	Soll die Kamera bewegt werden, so setzt man mithilfe der Funktion moveTo()
	//	diese Variable und die Kamera wird anschließend beim Updaten bewegt
	private PVector position 	= new PVector(0,0);
	private PVector targetPosition 	= new PVector(0,0);
	private PVector beforePosition = new PVector(0,0);
	//	Standardwert 1.0
	//	Soll vergrößert werden, wird der Wert > 1.0
	//	Soll verkleinert werden, wird der Wert < 1.0
	//	Soll die Kamera gezoomt werden, so wird über die Funktion zoom()
	//	beim Updaten der targetZoom verändert, sodass es einen Zoomübergang gibt
	private float zoom 		= 1.0;
	private float targetZoom 	= 1.0;
	private float beforeZoom	= 1.0;
	//	Auch die Kamera bekommt einen Timer, sodass Bewegung und Zoom auch zeitlich
	//	geplant werden können
	//	Der Timer wird auf einen Startwert von 2000 gesetzt und pausiert.
	private Timer movementTimer 		= new Timer( 2000, true );
	private Timer zoomTimer 		= new Timer( 2000, true );
	private Timer waitTimer 		= new Timer( -1000, true );
	//	Ist die Kamera gerade schon in Bewegung oder Zoomt schon, so soll dies zunächst 
	//	ausgeführt werden. Deshalb gibt es hier zwei Zustandsvariablen dafür
	private boolean isMoving 		= false;
	private boolean isZooming		= false;
	private boolean isWaiting		= false;
	private boolean isPaused		= false;
	//	In diesen Variablen werden die Animationsdauern gespeichert
	//	Beispiel: Kamera soll in 2 Sekunden von 1.0 auf 0.4 zoomen
	//	zoomTime steht dann auf 2000
	private float moveTime 		= 0;
	private float zoomTime 		= 0;

	PVector direction = new PVector(0,0);
	PVector directionNormal = new PVector(0,0);


	Camera(){

	}


	public void update(){

		updateTimers();

		if( !waitTimer.isAlive() && !isPaused ){

			updateMove();
			updateZoom();

		}else{

			isWaiting = false;

		}

		//	Falls die Kamera gerade nicht in Bewegung ist, aber in der Warteschleife noch Bewegungen gespeichert sind
		//	soll auf die Warteschleife zugegriffen werden
		if( (!isMoving  && !isZooming && !isWaiting) && cameraTargets.size() > 0 ){

			//	Ist der nächste Auftrag keine Wartezeit
			if( !cameraTargets.get(0).isWaitTimer() ){

				targetPosition = cameraTargets.get(0).getMoveTarget();
				direction = PVector.sub( targetPosition, position );
				targetZoom = cameraTargets.get(0).getZoomTarget();

				zoomTime = cameraTargets.get(0).getTime();
				moveTime = zoomTime;

			}

			//	Ist der nächste Auftrag eine Wartezeit
			if( cameraTargets.get(0).isWaitTimer() ){

				waitTimer.reset();
				waitTimer.set( cameraTargets.get(0).getTime() );
				waitTimer.start();
				isWaiting = true;

			}

			cameraTargets.remove(0);

		}

	}


	public float getZoom(){
		return zoom;
	}


	public PVector getPosition(){
		return position;
	}


	public void moveTo( PVector target, float _value, float _time ){

		//	Neues Kameratarget in die Warteschleife
		cameraTargets.add( new CameraTarget( target, _value, _time ) );

	}


	public void wait( int _time ){

		//	Neue Wartezeit in die Warteschleife einfügen
		cameraTargets.add( new CameraTarget( _time ) );

	}


	public void pause(){
		movementTimer.pause();
		zoomTimer.pause();
		waitTimer.pause();
		isPaused = true;
	}


	public void resume(){
		movementTimer.resume();
		zoomTimer.resume();
		waitTimer.resume();
		isPaused = false;
	}


	private void updateMove(){

		//	Entspricht die Position nicht der Zielposition soll die Kamera offenbar bewegt werden
		if( PVector.dist( position, targetPosition ) > 0.5 ){

			if( !isMoving ){
				movementTimer.set( moveTime );
				movementTimer.start();
				isMoving = true;
				beforePosition = position;
			}

			directionNormal = direction.normalize( null );
			directionNormal.mult( 
						easeInOutCubic(
								movementTimer.getTimer(),
								0, 
								direction.mag(),
								moveTime
								) 
						);

			position = PVector.add( 
						beforePosition, 
						directionNormal
						);
		}
		else{
				movementTimer.reset();
				isMoving = false;
				beforePosition = new PVector( 0,0 );
				targetPosition = position;
		}

	}


	private void updateZoom(){

		//	Entspricht der Zoom nicht dem Zielzoom, muss gezoomt werden
		if( abs(targetZoom - zoom) > 0.01 ){
		
			if( !isZooming ){
				zoomTimer.set( zoomTime );
				zoomTimer.start();
				isZooming = true;
				beforeZoom = zoom;
			}

			zoom = 		easeInOutCubic(
								zoomTimer.getTimer(),
								beforeZoom, 
								(targetZoom-beforeZoom),
								zoomTime
								) ;
		}
		else{
				zoomTimer.reset();
				isZooming = false;
				beforeZoom = zoom;
				targetZoom = zoom;
		}

	}


	private void updateTimers(){

		movementTimer.update();
		zoomTimer.update();
		waitTimer.update();

	}


	//	Quelle: http://gizma.com/easing/
	//	Hiermit wird einfach eine flüssige Bewegung durchgeführt, die beschleunigt ist
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

}