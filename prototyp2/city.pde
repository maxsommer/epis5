//	City
//	Die Klasse unserer Stadt. Die Stadt hat mehrere Stadteile, die 
//	jeder Bewohner besuchen kann und zwischen denen er umher
//	reist.

class City implements Object{

	PVector position;
	float diameter;
	color cityColor = color( 255, 255, 255, 128 );

	public City(){

		position = new PVector( simulation.windowX / 2, simulation.windowY / 2 );
		diameter = simulation.windowX - 20;

	}


	public void update(){



	}


	public void render(){

		noStroke();
		fill( cityColor );
		ellipse( position.x, position.y, diameter, diameter );

	}
	
}