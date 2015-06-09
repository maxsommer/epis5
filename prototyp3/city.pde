//	city.pde
//	Die Klasse City beinhaltet eine Liste mit allen Menschen der Stadt
//	und eine Instanz des Kindergartens
//	

class City{

	//	Die Stadt wird in der Mitte des Koordinatensystems platziert
	private PVector position = new PVector( windowResolution.x/2, windowResolution.y/2 );
	//	Die Liste mit den Menschen
	private ArrayList<Human> humans = new ArrayList<Human>();
	//	Wieviele Menschen soll es in wievielen Schichten geben?
	private int[] numberOfHumansPerCircle = { 10, 20, 30, 40, 50 };
	//	Wieviel Abstand soll zwischen den Schichten sein?
	private int spacing = 50;

	City(){	

		//	Stadt mit Menschen füllen

			for( int j = 0; j < numberOfHumansPerCircle.length; j++){

				//	Kreissegment für jedes Element ausrechnen
				float deg = TWO_PI/numberOfHumansPerCircle[j];

				for( int i  = 0;  i < numberOfHumansPerCircle[j]; i++){

					humans.add( 
						//	Neuer Mensch, angeordnet im Kreis
						new Human( 
							position.x + cos(deg  * i ) * (j+1) * spacing,  
							position.y + sin (deg  * i )  * (j+1) * spacing
							) 
						);

				}
			}

			humans.get( (int)random(0, humans.size()) ).infect();

	}


	public void update(){

		//	Alle Menschen updaten
		for( int i = 0; i < humans.size(); i++ ){
			Human h = humans.get( i );
			h.update();

			//	jetzt checken wir ob aufgrund der nähe eine ansteckung möglich wäre
			//	und falls ja wird "der würfel gerollt"
			for( int j = 0; j < humans.size(); j++ ){
				Human h2 = humans.get( j );
				if( h.inRange(h2) && h2.isInfecting() ){

					if( percentChance( sim.infectionRate ) ){
						h.infect();
					}

				}
			}
		}

	}


	public void render(){

		//	Alle Menschen rendern
		for( int i = 0; i < humans.size(); i++ ){
			Human h = humans.get( i );
			h.render();
		}

	}

}