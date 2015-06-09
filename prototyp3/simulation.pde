//	simulation.pde
//	Die Klasse Simulation ist dafür zuständig die ganze Simulation
//	updaten und darstellen zu lassen. 
//	

class Simulation{

	PVector simResolution = new PVector( 0, 0 );
	City city = new City( );

	boolean paused = false;

	float infectionRange 	= 60;
	float infectionRate 	= 0.15;

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

		if( !this.paused ){
			city.update();
		}

	}

	//	die render Methode wird ebenfalls einmal pro drawcall aufgerufen und zeichnet
	//	alle Objekte, die GUI etc. auf den Bildschirm
	public void render(){

		city.render();

		if( debugMode ){

			fill( 0, 0, 230 );
			text(frameRate+"fps", 20, 20);

			if( this.paused ){
				fill( 230, 0, 0);
				text("Simulation is paused", 20, 40);

			}else{
				fill( 0, 230, 0 );
				text("Simulation is running", 20, 40);
			}

			fill( 50 );
			text("Press 'r' to restart", 20, 60);
			text("Press 'd' to toggle debug mode", 20, 80);
			text("Press 'p' to play/pause the simulation", 20, 100);

		}

	}

}