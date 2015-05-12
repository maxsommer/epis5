//	District
//	Wie der Name schon sagt ist jedes District ein Stadtteil unserer Stadt.


class District{

	PVector position;
	int population;
	color districtColor = color( 0, 128, 255, 200 );

	public District( int x, int y, int _population ){

		position = new PVector(x, y);
		population = _population;

		//	solange die generierte Position für den Stadtteil (aufgrund
		//	von Überschneidung mit anderen) noch nicht gut ist, neue
		//	Position generieren
		while( !simulation.checkDistrictPlacement(this) ){
			this.reassignPlacement();
		}

	}


	public void update(){



	}


	public void render(){

		noStroke();
		fill( districtColor );
		ellipse( position.x, position.y, population, population );

	}

	public void reassignPlacement(){

		position.x = (int) random( 0, simulation.windowX );
		position.y = (int) random( 0, simulation.windowY );
		simulation.addMessage("District.position reassigned");
		simulation.reassignNeeds++;

		if( simulation.reassignNeeds > simulation.maxReassignNeeds ){
			restart();	// wenn es eine zu blöde Konstellation der Stadtteile gab, neu generieren
		}

	}
	
}