//	city.pde
//	Die Klasse City beinhaltet eine Liste mit allen Menschen der Stadt
//	und eine Instanz des Kindergartens
//	

class City{

	//	Die Stadt wird in der Mitte des Koordinatensystems platziert
	private PVector position = new PVector( windowResolution.x/2, windowResolution.y/2 );
	//	Die Liste mit den Menschen
	private ArrayList<Human> humans = new ArrayList<Human>();
	//	Wieviele Menschen soll es in wievielen Reihen geben?
	private int[] numberOfHumansPerCircle = {  9, 10, 11, 12, 13, 14, 15, 16, 17, 16, 15, 14, 13, 12, 11, 10, 9 };
	//	Wieviel Abstand soll zwischen den Menschen sein
	private int spacing = 7;
	//	Der Kindergarten der Stadt
	Kindergarden kindergarden = new Kindergarden( humans );

	private Simulation mySim;

	City( Simulation _sim ){	

		mySim = _sim;

		//	Stadt mit Menschen füllen
		//	Dieses Mal versuchen wir's in Hexagonraster Anordnung im Kreis
			for( int j = 0; j < numberOfHumansPerCircle.length; j++ ){

				float lineHeight	 = ( (numberOfHumansPerCircle.length * (spacing+humanRadius+humanRadiusExtended))  )/2;

				for( int i = 0; i < numberOfHumansPerCircle[j]; i++ ){

					float lineSpacing = ( (humanRadius+humanRadiusExtended+spacing) * numberOfHumansPerCircle[j] )/2;
					
					if( !(j == 8 && i == 8 ) ){
						humans.add(
							new Human(
								position.x + (i * (spacing+humanRadius+humanRadiusExtended)) - lineSpacing,
								position.y + (j * (spacing+humanRadius+humanRadiusExtended)) - lineHeight,
								_sim
								)
						);
					}else{
						humans.add(
							new myChild(
								position.x + (i * (spacing+humanRadius+humanRadiusExtended)) - lineSpacing,
								position.y + (j * (spacing+humanRadius+humanRadiusExtended)) - lineHeight,
								_sim
								)
						);
					}

				}

			}

		//	Wenn noch keine Startperson für das Virus ausgesucht wurde, wird das jetzt gemacht
		if( !startPersonGenerated ){
			startPerson = (int)random( 0, humans.size() ); 
			startPersonGenerated = true;
		}

		if( directStartMode ){
			startInfection();
		}

	}


	public void update(){

		if( this.mySim == sim2 ){
			kindergarden.update();
		}

		if( currentStatus == 2 ){

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

	}


	public void render(){

		if( this.mySim == sim2 ){
			kindergarden.render();
		}

		if( currentStatus == 2 ){

			//	Alle Menschen rendern
			for( int i = 0; i < humans.size(); i++ ){
				Human h = humans.get( i );
				h.render();
			}

		}

	}

	public void startInfection(){

		//	Alle Menschen durchgehen und, falls diese Stadt Teil der rechten Simulation ist, ca 63% impfen
		
		if( mySim.getId() == 1 ){
			for( int i = 0; i < humans.size(); i++ ){

				Human h = humans.get( i );
				//	Wahrscheinlichkeit, mit der ein Mensch geimpft ist
				//	Wird nur geimpft, wenn er nicht Startpunkt des Virus ist
				if( percentChance( 63 ) && i != startPerson ){

					h.vaccinate();

				}

			}
		}

			//	hier wird ein Mensch infiziert
			humans.get( startPerson ).infect();

	}

}