//	virusTarget.pde
//	Diese Klasse beinhaltet einzelne Ziele für das Virus wo es sich hinbewegen soll
//	

class VirusTarget{

	private PVector position;
	private float time;
	private int animationType;	// 	0: cubic, 1: exponential

	VirusTarget( PVector _position, float _time, int _animationtype ){

		position 		= _position;
		time 			= _time;
		animationType 	= _animationtype;

	}


	public PVector getTargetPosition(){
		return position;
	}


	public float getTime(){
		return time;
	}


	public int getAnimationType(){
		return animationType;
	}

}