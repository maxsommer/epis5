//	timeDisplay.pde
//	Die Zeitanzeige für die Simulation
//	

class TimeDisplay{

	// 	Eigenschaften
	private PVector position;						//	Position der Anzeige
	private color myColor;							//	Farbe der Anzeige
	private Timer myTimer 		= new Timer();				//	Timer für die Messung der Realzeit
	private float myWidth = 0;						//	Breite des Zeitstrahls
	private float maxWidth = windowResolution.x / 5 - 50; 			// 	Maximale Breite des Zeitstrahls
	//	Zeitspeicherung
	private float weeks = 0;							//	Wochen	
	private float days = 0;							// 	Tage
	private float hours = 0;							//	Stunden
	private float minutes = 0;						//	Minuten


	TimeDisplay(){

		position	= new PVector( windowResolution.x / 5 * 4, windowResolution.y - 40 );
		myColor	= color(0, 200, 0);

	}


	public void start(){
		myTimer.reset();
		myTimer.start();
	}


	public void update(){

		myTimer.update();

		myWidth = myTimer.getTimer() / 1000 / 60 * maxWidth;
		//myWidth = myTimer.getTimer() / 100 ;

		//	Zeitanzeige updaten
		days = myTimer.getTimer() /  1000 / 24 * timeRelation;

	}


	public void render(){

		fill( myColor );
		rect( position.x, position.y, myWidth, 20 );
		fill(myColor, 50);
		rect( position.x, position.y, maxWidth, 20 );
		fill( 0 );
		text( "Tag " + (int)days, position.x + 50, position.y + 15);
	}

}