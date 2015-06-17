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
	private int[] numberOfHumansPerCircle = {  6, 7, 8, 9, 10, 11, 10, 9, 8, 7, 6 };
	//	Wieviel Abstand soll zwischen den Schichten sein?
	private int spacing = 10;	//	bei der Kreisanordnung war es 50

	City(){	

		//	Stadt mit Menschen füllen
		//	Das war der Algorithmus, um die Menschen in Kreisen, in mehreren Kreisschichten anzuordnen
		/*
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
		*/

		//	Stadt mit Menschen füllen
		//	Dieses Mal versuchen wir's in Hexagonraster Anordnung im Kreis
			for( int j = 0; j < numberOfHumansPerCircle.length; j++ ){

				float lineHeight	 = ( (numberOfHumansPerCircle.length * (spacing+humanRadius+humanRadiusExtended))  )/2;

				for( int i = 0; i < numberOfHumansPerCircle[j]; i++ ){

					float lineSpacing = ( (humanRadius+humanRadiusExtended+spacing) * numberOfHumansPerCircle[j] )/2;
					
					humans.add(
						new Human(
							position.x + (i * (spacing+humanRadius+humanRadiusExtended)) - lineSpacing,
							position.y + (j * (spacing+humanRadius+humanRadiusExtended)) - lineHeight
							)
					);

				}

			}


			//	hier wird ein Mensch infiziert
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