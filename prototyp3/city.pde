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
	private int spacing = 5;
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
			while(!startPersonGenerated){
				startPerson = (int)random( 0, humans.size() ); 
				int i = startPerson;
				if( 
						i == 60 || i == 61 || i == 62 || i == 63 ||
						i == 74 || i == 75 || i == 76 || i == 77 || i == 78 ||
						i == 89 || i == 90 || i == 91 || i == 92 || i == 93 || i == 94 ||
						i == 105 || i == 106 || i == 107 || i == 108 || i == 109 || i == 110 || i == 111 ||
						i == 122  || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 ||
						i == 138 || i == 139 || i == 140 || i == 141 || i == 142 ||
						i == 153 || i == 154 || i == 155 || i == 156
					){
					startPersonGenerated = true;
				}else{
					startPersonGenerated = false;
				}
			}
		}

		if( directStartMode ){
			startInfection();
		}

	}


	public void update(){

		if( this.mySim == sim2 && (currentStatus == 0 || currentStatus == 1)  ){
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

		if( this.mySim == sim2 && (currentStatus == 0 || currentStatus == 1) ){
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


		//	hier wird ein Mensch infiziert
		humans.get( startPerson ).infect();

	}

	public void vaccinateCity(){

		//	Alle Menschen durchgehen und, falls diese Stadt Teil der rechten Simulation ist, ca 63% impfen
		
		if( mySim.getId() == 1 ){
			for( int i = 0; i < humans.size(); i++ ){

				Human h = humans.get( i );
				//	Wahrscheinlichkeit, mit der ein Mensch geimpft ist
				//	Wird nur geimpft, wenn er nicht Startpunkt des Virus ist
				if( percentChance( 63 ) && i != startPerson && !( i == 60 || i == 61 || i == 62 || i == 63 ||
						i == 74 || i == 75 || i == 76 || i == 77 || i == 78 ||
						i == 89 || i == 90 || i == 91 || i == 92 || i == 93 || i == 94 ||
						i == 105 || i == 106 || i == 107 || i == 108 || i == 109 || i == 110 || i == 111 ||
						i == 122  || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 ||
						i == 138 || i == 139 || i == 140 || i == 141 || i == 142 ||
						i == 153 || i == 154 || i == 155 || i == 156) ){

					h.vaccinate();

				}

			}
		}

	}

}