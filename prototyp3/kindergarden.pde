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

			updateInfectedKindergarden();

			//	es werden nur die Kindergartenkinder geupdated
			for( int i = 0; i < humans.size(); i++ ){
				Human h = humans.get( i );

				if( 
					isInKindergarden(i)
				){

					h.update();

					//	jetzt checken wir ob aufgrund der nähe eine ansteckung möglich wäre
					//	und falls ja wird "der würfel gerollt"
					for( int j = 0; j < humans.size(); j++ ){
						Human h2 = humans.get( j );
						if( h.inRange(h2) && h2.isInfecting() && 
							isInKindergarden(i)
						){

							if( percentChance( sim.infectionRate ) && h != humans.get(91) ){

								h.infect();

							}

						}
					}

				}

			}

	}

	public void render(){

			//	es werden nur die Kindergartenkinder gerendert
			for( int i = 0; i < humans.size(); i++ ){
				Human h = humans.get( i );

				if( 
					isInKindergarden(i)
				){

					h.render();

				}

			}

	}


	public void updateInfectedKindergarden(){

		numberInfectedKindergarden = 0;

		for( int i = 0; i < humans.size(); i++ ){

			Human h = humans.get( i );

			if( h.isInfecting() ){
				numberInfectedKindergarden++;
			}

		}

		if( numberInfectedKindergarden >= numberInfectedKindergardenTransition ){
			changeStatus( 2 );
		}

	}

	public boolean isInKindergarden(int i){
		if (
					i == 46 || i == 47 || i == 48 || i == 49 || i == 50 ||
					i == 59 || i == 60 || i == 61 || i == 62 || i == 63 || i == 64 ||
					i == 73 ||i == 74 || i == 75 || i == 76 || i == 77 || i == 78 || i == 79 ||
					i == 88 ||i == 89 || i == 90 || i == 91 || i == 92 || i == 93 || i == 94 || i == 95 ||
					i == 104 || i == 105 || i == 106 || i == 107 || i == 108 || i == 109 || i == 110 || i == 111 || i == 112 ||
					i == 121 || i == 122  || i == 123 || i == 124 || i == 125 || i == 126 || i == 127 || i == 128 ||
					i == 137 || i == 138 || i == 139 || i == 140 || i == 141 || i == 142 || i == 143 ||
					 i == 152 || i == 153 || i == 154 || i == 155 || i == 156 || i == 157 ||
					i == 166 || i == 167 || i == 168 || i == 169 || i == 170
		 )
			return true;
		return false;
	}


	public void startInfection(){

		//	hier wird ein Mensch infiziert
		humans.get( startPerson ).infect();
		caption.infectedVisible = true;

	}

}