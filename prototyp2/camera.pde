//	Camera
//	Mithilfe der Kamera wird es möglich eine Nahansicht zu erstellen und 
//	eine Zoomanimation zu verwirklichen

class Camera{

	PVector position, positionGoal;
	float zoom, zoomGoal, zoomSpeed, movementSpeed;

	public Camera(){

		position = new PVector(0,0);
		positionGoal = new PVector(0,0);
		zoom = 1.0;
		zoomGoal = 1.0;
		zoomSpeed = 0.02;
		movementSpeed = 2.0;

	}

	public void update(){

		//	hier wird der Zoom geupdatet.
		//	sollte die aktuelle Zoomstufe sich von der Ziel Zoomstufe 
		//	unterscheiden, so wird diese angepasst

		if( zoom <= zoomGoal + 0.05 && zoom >= zoomGoal - 0.05){

			zoom = zoomGoal;

		}
		else if( zoom < zoomGoal ){

			zoom += zoomSpeed;

		}
		else if( zoom > zoomGoal ){

			zoom -= zoomSpeed;
		}


		//	hier wird die Kameraposition geupdatet.
		if( PVector.dist(position, positionGoal) > 0.0 ){

			PVector p = PVector.sub( positionGoal, position );
			p.normalize();
			p.mult( movementSpeed );

			position.add( p );

		}

	}


	public void setZoomGoal( float z )		{	zoomGoal = z; 		}
	public void setZoom( float z )			{ 	zoom = z; 		}
	public void setPositionGoal( PVector p )	{	positionGoal = p;	}
	public void setPosition( PVector p )		{	position = p;		}


	public float getZoom()				{	return zoom;		}
	public PVector getPosition()			{	return position;	}

}