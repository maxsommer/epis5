//

class VaccineRing{

	private PVector position;
	private color myColor;
	private float radius;


	VaccineRing( PVector pos ){

		position = pos;
		myColor = color( 44, 73, 153 );
		radius = 100;

	}


	public void update(){



	}


	public void render(){

		fill( myColor );
		ellipse( position.x, position.y, radius, radius );
		fill( 255 );
		ellipse( position.x, position.y, radius/3*2, radius/3*2 );

	}


	public void setPosition( PVector pos ){
		position = pos;
	}

}