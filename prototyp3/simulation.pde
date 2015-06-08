//	simulation.pde
//	Die Klasse Simulation ist dafür zuständig die ganze Simulation
//	updaten und darstellen zu lassen. 
//	

class Simulation{

	PVector simResolution = new PVector( 0, 0 );
	City city = new City( );

	float infectionRange 	= 50;
	float infectionRate 	= 1;

	//	Der Konstrukt erwartet zwei Parameter, die X & Y 
	//	Auflösung mit der die Simulation laufen soll
	//	Dadurch haben wir die Möglichkeit die Simulation selbst
	//	innerhalb des Fensters der Applikation kleiner darstellen
	//	zu lassen falls wir das noch benötigen sollten
	Simulation( float resX, float resY ){

		simResolution.x 	= resX;
		simResolution.y 	= resY;

	}


	//	Die update Methode wird bei jedem Drawcall einmal aufgerufen und updated
	//	alle Objekte in der Simulation, die GUI und die Kamera, etc.
	public void update(){

		city.update();

	}

	//	die render Methode wird ebenfalls einmal pro drawcall aufgerufen und zeichnet
	//	alle Objekte, die GUI etc. auf den Bildschirm
	public void render(){

		city.render();

	}

}