class CameraTarget{

	private float zoomTarget;
	private PVector moveTarget;
	private float time;

	CameraTarget( PVector mT, float zT, float t ){

		moveTarget = mT;
		zoomTarget = zT;
		time = t;

	}


	public PVector getMoveTarget(){
		return moveTarget;
	}


	public float getZoomTarget(){
		return zoomTarget;
	}


	public float getTime(){
		return time;
	}

}