//	timeDisplay.pde
//	Die Zeitanzeige für die Simulation
//	

class TimeDisplay{

	// 	Eigenschaften
	private PVector position;						//	Position der Anzeige
	private color myColor;							//	Farbe der Anzeige
	private Timer myTimer 		= new Timer();				//	Timer für die Messung der Realzeit
	private float myWidth = 0;						//	Breite des Zeitstrahls
	//	Zeitspeicherung
	private float weeks = 0;							//	Wochen	
	private float days = 0;							// 	Tage
	private float hours = 0;							//	Stunden
	private float minutes = 0;							//	Minuten


	TimeDisplay(){

		position	= new PVector( windowResolution.x - 300, windowResolution.y - 100);
		myColor	= color(0, 200, 0);

	}


	public void update(){

		myTimer.update();

		myWidth = myTimer.getTimer() / 100 ;

		//	Zeitanzeige updaten
		minutes = myTimer.getTimer() /  1000 / 60 ;
		hours = myTimer.getTimer() /  1000 / 60 / 60 ;
		days = myTimer.getTimer() /  1000 / 60 / 60 / 24;
		weeks = myTimer.getTimer() /  1000 / 60 / 60 / 24 / 7;

	}


	public void render(){

		fill( myColor );
		rect( position.x, position.y, myWidth, 5 );
		//stroke();
		//text( minutes + " Minuten", , );
	}

}