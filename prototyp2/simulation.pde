//	Simulation
//	Diese Klasse ist für das updaten und darstellen der Simulation
//	verantwortlich.


class Simulation{

	//	Interne Variablen
	int windowX, windowY;						// Fenstergröße
	ArrayList <District> districts = new ArrayList<District>();	// Liste aller Stadtteile
	ArrayList <Message> messages = new ArrayList<Message>();	// Liste aller Messages
	boolean generated = false;					// Ist wahr wenn die Simulation schon generiert wurde.
	City city;							// Stadtobjekt
	int reassignNeeds = 0;						// Wie oft mussten die Stadtteile umpositioniert werden?


	//	Parameter
	int maxNumberOfDistricts 	= 7;
	int minNumberOfDistricts 	= 2;
	int maxDistrictPopulation	= 300;
	int minDistrictPopulation	= 200;
	int defaultMessageTimer 	= 4000;
	int maxReassignNeeds		= 100;



	//	Der Konstruktor der Klasse Simulation. Hier werden alle
	//	Variablen, bei denen das nötig ist, auf einen Startwert ge-
	//	setzt.
	public Simulation(int x, int y){

		windowX = x;
		windowY = y;

	}

	//	Die Liste aller Objekte wird hier durchgegangen und deren
	//	Update-Methoden werden ausgeführt.
	public void update(){

		// 	wurde die Simulation noch nicht generiert, dann passiert
		// 	das jetzt.
		if(!generated){ 
			generateSimulation();
		}

		//	Stadt updaten
		city.update();

		//	Stadtteile updaten
		for( int i = 0; i < districts.size(); i++ ){

			District d = districts.get(i);
			d.update();
		}

		//	Messages updaten
		for( int i = 0; i < messages.size(); i++ ){

			Message m = messages.get(i);
			if(!m.isAlive()){ 
				messages.remove(i);
			}

		}

	}

	//	Hier wird die Liste aller Objekte iteriert und jedes wird
	//	gezeichnet. Außerdem lassen wir uns die Bildrate und 
	//	Anzahl der Objekte (zumindest in der Entwicklungsversion)
	// 	anzeigen.
	public void render(){

		// 	Stadt zeichnen
		city.render();

		//	Objekte zeichnen
		for( int i = 0; i < districts.size(); i++ ){

			District d = districts.get(i);
			d.render();
		}

		//	Bildrate und Objektanzahl
		if( debugMode ){

			fill( 0 );
			text( "fps:       " + (int)frameRate,  10, 20 );
			text( "objects: " + districts.size(), 10, 36 );
			text( "reassigns: " + reassignNeeds, 10, 52 );
			text( "'r' to restart", 10, 68 );
			text( "'d' toggle debug mode", 10, 84 );

		}

		//	Messages rendern
		for( int i = 0; i < messages.size(); i++ ){

			Message m = messages.get(i);
			m.render(i+1);

		}

	}

	//	Diese Methode ist dafür da alle Rahmenbedingungen
	//	für die Simulation zu generieren, wie z.B. Stadtgröße,
	//	Hygiene, etc.
	public void generateSimulation(){

		city = new City();	// Das Stadt Objekt wird erstellt
		addMessage( "City::city created" );

		//	Hier werden zufällig (zwischen Mindest- und Maximalanzahl) Stadtteile
		//	generiert. Diese sind dann jeweilig nochmal verschieden groß.
		for( int i = 0; i < (int)random( minNumberOfDistricts, maxNumberOfDistricts ); i++ ){

			//	neuer Stadteil: District( X-Position, Y-Position, Population );
			District d = new District( 	
					windowX/2 + (int)random(-city.diameter/2, city.diameter/2), 
					windowY/2 + (int)random(-city.diameter/2, city.diameter/2), 
					(int)random(minDistrictPopulation, maxDistrictPopulation) 
					);

			districts.add( d );
			addMessage( "District::district"+i+" created" );

		} 

		generated = true;		// Die Rahmenbedingungen sind alle gesetzt.

	}

	public boolean checkDistrictPlacement( District d ){

		// 	alle Objekte durchgehen
		for( int i = 0; i < districts.size(); i++ ){
			District d2 = districts.get(i);

			if( d2.position.dist( d.position ) < (d2.population/2 + d.population/2) ){

				return false;	//	Überschneidung mit anderem Stadtteil

			}

		}

		if( PVector.dist( city.position, d.position ) > city.diameter/2 ){

			return false;	// der Stadtteil wäre außerhalb der Stadt

		}

		return true;	//	Position okay, keine Überschneidung mit anderem Stadtteil

	}

	public void addMessage( String msg, int timer ){

		messages.add( new Message(msg, timer) );

	}
	public void addMessage( String msg ){

		messages.add( new Message(msg, defaultMessageTimer) );

	}

}