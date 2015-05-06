//	Message
//	Message-Objekte sind Meldungen, die über eine bestimmte Zeit
//	auf dem Bildschirm angezeigt werden.

class Message{

	float timer;
	String message;
	
	Message( String _message, float _timer ){

		timer		= _timer + millis();
		message 	= _message;

	}


	public void render( int place ){

		if( debugMode ){

			float alphac = (timer / millis())/2 * 255;
			fill( 0, 255, 0, alphac );
			text( message, 10, simulation.windowY - (place*16) );

		}

	}

	public boolean isAlive(){

		if( millis() > timer ){
			return false;
		}else{
			return true;
		}

	}

}