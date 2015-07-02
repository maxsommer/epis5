//	myChild.pde
//	Die Klasse myChild steht für das eigene Kind
//	

class myChild extends Human{

	myChild( float posX, float posY, Simulation _sim ){
		super( posX, posY, _sim );
		radius 			= windowResolution.y/20;
		radiusExtended 	= windowResolution.y/40;
	}

	public void render(){

		noStroke();

		if(relativeToCamera){			
			if( state == 4 ){

				fill( 44, 73, 153 );
				ellipse( (position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom() );

				fill( myColorRed, myColorGreen, myColorBlue );
				ellipse( 
					(position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius) * mySim.cam.getZoom(), 
					(radius) * mySim.cam.getZoom() );

			}
			else{

				fill( myColorRed, myColorGreen, myColorBlue, myAlpha );
				ellipse( 
					(position.x - mySim.cam.getPosition().x) * mySim.cam.getZoom(), 
					(position.y - mySim.cam.getPosition().y) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom(), 
					(radius+radiusExtended) * mySim.cam.getZoom() );

			}

		}

	}

}