//	simulation.pde
//	Die Klasse Simulation ist dafür zuständig die ganze Simulation
//	updaten und darstellen zu lassen. 
//	

class Simulation{

	public int id;
	PVector simResolution;
	City city;
	Camera cam;

	boolean paused = false;

	float infectionRange 	= 90; //=90;//
	float infectionRate 	= 0.03;//=0.2;//
	float vaccinationCoverage = 63;

	//	Der Konstrukt erwartet zwei Parameter, die X & Y 
	//	Auflösung mit der die Simulation laufen soll
	//	Dadurch haben wir die Möglichkeit die Simulation selbst
	//	innerhalb des Fensters der Applikation kleiner darstellen
	//	zu lassen falls wir das noch benötigen sollten
	Simulation( float resX, float resY, int _id ){
		
		simResolution 		= new PVector( 0, 0 );
		simResolution.x 	= resX;
		simResolution.y 	= resY;
		id 			= _id;
		city 			= new City( this );
		cam 			= new Camera();

	}


	//	Die update Methode wird bei jedem Drawcall einmal aufgerufen und updated
	//	alle Objekte in der Simulation, die GUI und die Kamera, etc.
	public void update(){
	
		cam.update();

		if( !paused ){
			city.update();
		}

	}

	//	die render Methode wird ebenfalls einmal pro drawcall aufgerufen und zeichnet
	//	alle Objekte, die GUI etc. auf den Bildschirm
	public void render(){

		city.render();

	}

	public PVector getResolution(){
		return simResolution;
	}

	public int getId(){
		return id;
	}

	public boolean isPaused(){
		return paused;
	}

	public void pauseSim(){
		paused = true;
		cam.pause();
	}

	public void resumeSim(){
		paused = false;
		cam.resume();
	}

}