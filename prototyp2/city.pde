//	City
//	Die Klasse unserer Stadt. Die Stadt hat mehrere Stadteile, die 
//	jeder Bewohner besuchen kann und zwischen denen er umher
//	reist.


class City{

	PVector position;
	float diameter;
	color cityColor = color( 0, 10 );

	public City(){

		position = new PVector( simulation.windowX / 2, simulation.windowY / 2 );
		diameter = simulation.windowY - 20;

	}


	public void update(){



	}


	public void render(){

		noStroke();
		fill( cityColor );
		ellipse( 
			(position.x + simulation.cam.getPosition().x) * simulation.cam.getZoom(), 
			(position.y + simulation.cam.getPosition().y) * simulation.cam.getZoom(), 
			diameter * simulation.cam.getZoom(), 
			diameter * simulation.cam.getZoom() 
		);

	}
	
}