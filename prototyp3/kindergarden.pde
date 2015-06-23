//	kindergarden.pde
//	Wie der Name schon sagt geht es hier um den Kindergarten
//	Dieser ist Teil der Stadt und bereits am Anfang sichtbar.
//	Er enthält eine bestimmte Anzahl an Kindern
//	

class Kindergarden{

	ArrayList <Human> humans;

	Kindergarden( ArrayList<Human> _humans ){

		humans = _humans;

	}

	public void update(){

		//	Wenn gerade die Kindergarten-Anzeige-Phase ist
		if( currentStatus == 1 ){

			//	es werden nur die Kindergartenkinder geupdated
			for( int i = 0; i < humans.size(); i++ ){
				Human h = humans.get( i );

				if( 
					i == 60 || i == 61 || i == 62 || i == 63 ||
					i == 74 || i == 75 || i == 76 || i == 77 || i == 78 ||
					i == 89 || i == 90 || i == 91 || i == 92 || i == 93 || i == 94 ||
					i == 105 || i == 106 || i == 107 || i == 108 || i == 109 || i == 110 || i == 111 ||
					i == 122  || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 ||
					i == 138 || i == 139 || i == 140 || i == 141 || i == 142 ||
					i == 153 || i == 154 || i == 155 || i == 156 
				){

					h.update();

					//	jetzt checken wir ob aufgrund der nähe eine ansteckung möglich wäre
					//	und falls ja wird "der würfel gerollt"
					for( int j = 0; j < humans.size(); j++ ){
						Human h2 = humans.get( j );
						if( h.inRange(h2) && h2.isInfecting() && 
							(j == 60 || j == 61 || j == 62 || j == 63 ||
							j == 74 || j == 75 || j == 76 || j == 77 || j == 78 ||
							j == 89 || j == 90 || j == 91 || j == 92 || j == 93 || j == 94 ||
							j == 105 || j == 106 || j == 107 || j == 108 || j == 109 || j == 110 || j == 111 ||
							j == 122  || j == 123 || j == 124 || j == 125 || j == 126 || j == 127 ||
							j == 138 || j == 139 || j == 140 || j == 141 || j == 142 ||
							j == 153 || j == 154 || j == 155 || j == 156)
						){

							if( percentChance( sim.infectionRate ) ){
								h.infect();
							}

						}
					}

				}

			}

		}

	}

	public void render(){

		//	Wenn der Applikationsstatus im Kindergarten ist
		if( currentStatus == 1 ){

			//	es werden nur die Kindergartenkinder gerendert
			for( int i = 0; i < humans.size(); i++ ){
				Human h = humans.get( i );

				if( 
					i == 60 || i == 61 || i == 62 || i == 63 ||
					i == 74 || i == 75 || i == 76 || i == 77 || i == 78 ||
					i == 89 || i == 90 || i == 91 || i == 92 || i == 93 || i == 94 ||
					i == 105 || i == 106 || i == 107 || i == 108 || i == 109 || i == 110 || i == 111 ||
					i == 122  || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 ||
					i == 138 || i == 139 || i == 140 || i == 141 || i == 142 ||
					i == 153 || i == 154 || i == 155 || i == 156
				){

					h.render();

				}

			}

		}

	}

}