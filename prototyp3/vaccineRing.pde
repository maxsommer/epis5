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

		image( vaccineImage, position.x, position.y, radius, radius );

	}


	public void setPosition( PVector pos ){
		position = pos;
	}

}