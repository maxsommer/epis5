//	Human
//	Die Klasse des Menschen

	//	int state
	//	0: gesund 
	//	1: unwissend infiziert
	//	2: unwissend infiziert und ansteckend
	//	3: wissend infiziert und ansteckend
	//	4: komplikationen
	//	5: immun
	//	6: tot


class Human{

	PVector position;
	color humanColor = color(0,255,128, 180);
	int state;

	District homeDistrict;
	District workDistrict;

	
	public Human(District d){


		homeDistrict = d;
		position = new PVector(0,0);
		reassignPosition();

		while( !simulation.checkHumanPlacement( this ) ){

			reassignPosition();

		}

	}


	//	
	public void update(){

	}


	public void render(){

		noStroke();
		fill( humanColor );
		ellipse( 
			(position.x + simulation.cam.getPosition().x) * simulation.cam.getZoom(), 
			(position.y + simulation.cam.getPosition().y) * simulation.cam.getZoom(), 
			simulation.humanSize * simulation.cam.getZoom(), 
			simulation.humanSize * simulation.cam.getZoom() 
		);

	}

	//	Dient dazu die Position zu korrigieren beim Start, sodass man nicht außerhalb eines Distrikts startet
	public void reassignPosition(){

		position.x = homeDistrict.position.x + (int)random( -homeDistrict.population/2, homeDistrict.population/2 );
		position.y = homeDistrict.position.y + (int)random( -homeDistrict.population/2, homeDistrict.population/2 );

	}

}