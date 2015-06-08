//	timer.pde
//	Die Klasse Timer kann dazu eingesetzt werden für jeden Menschen beispielsweise
//	eine Art eigene Stoppuhr zu haben. Damit kann der Krankheitsverlauf zB simuliert werden
//	

class Timer{

	private float tStart 		= 0;
	private float tNow 		= 0;
	private float tStop		= 0;
	private boolean paused 	= false;
	private boolean infinite 	= true;


	//	Dieser Konstruktor ist der Standardkonstruktor
	//	Er ist für den Fall, dass man einen Timer möchte, 
	//	der direkt startet und "unendlich" lange läuft.
	Timer(){

		tStart		= millis();
		paused 	= false;
		infinite 		= true;

	}


	//	Hier startet der Timer auch direkt, läuft aber nur solange
	//	wie es ihm gesagt wird.
	Timer( float fTime ){

		tStart		= millis();
		tStop		= fTime;
		paused 	= false;
		infinite 		= false;

	}


	//	Für den Fall, dass man einen Timer mit vorgegebener Laufzeit
	//	und anfangs pausiert haben möchte.
	Timer( float fTime, boolean fPaused ){

		tStart		= millis();
		tStop 		= fTime;
		paused 	= fPaused;
		infinite 		= false;

	}


	public void update(){

		//	Ist der Timer nicht pausiert, so zählt er weiter
		if( paused == false ){

			tNow = millis() - tStart;

		}

	}


	public float getTimer(){
		return tNow;
	}

	public void start(){
		tStart 	= millis();
		if(paused){
			paused = false;
		}
	}

	public void pause(){
		if(!paused){
			paused = true;
		}
	}

	public void reset(){
		paused 	= true;
		tStart		= millis();
		tNow 		= 0;
		tStop		= 0;
	}

	public void set(float fTime){
		tStop = fTime;
	}

	public boolean isAlive(){

		if( !infinite ){
			if( tNow >= tStop ){
				paused = true;
				return false;
			}
		}

		return true;
	}

}