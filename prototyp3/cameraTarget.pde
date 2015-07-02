class CameraTarget{

	private float zoomTarget;
	private PVector moveTarget;
	private float time;
	private boolean isWaitTime = false;

	CameraTarget( PVector mT, float zT, float t ){

		moveTarget = mT;
		zoomTarget = zT;
		time = t;

	}


	CameraTarget( int _time ){

		time = _time;
		isWaitTime = true;

	}


	public boolean isWaitTimer(){
		return isWaitTime;
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