//	myChild.pde
//	Die Klasse myChild steht für das eigene Kind
//	

class myChild extends Human{

	myChild( float posX, float posY, Simulation _sim ){
		super( posX, posY, _sim );
	}

	public void render(){

		noStroke();

		if(relativeToCamera){

			fill( myColorRed, myColorGreen, myColorBlue, 120 );
			rect( (position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom() - 0.5*(radius+radiusExtended)*mySim.cam.getZoom(), 
				(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom() - 0.5*(radius+radiusExtended)*mySim.cam.getZoom(), 
				(radius+radiusExtended) * mySim.cam.getZoom(), 
				(radius+radiusExtended) * mySim.cam.getZoom() );

			fill( myColorRed, myColorGreen, myColorBlue );
			rect( 
				(position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom() - 0.5*(radius)*mySim.cam.getZoom(), 
				(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom() - 0.5*(radius)*mySim.cam.getZoom(), 
				(radius) * mySim.cam.getZoom(), 
				(radius) * mySim.cam.getZoom() );

		}

	}

}