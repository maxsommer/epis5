//	Interactive Media Design, Sommersemester 2015
//	P2 Semesterprojekt: "Interaktive Simulation eines Biotops"
//	"Die Epis": Simone Haas, Nadja Lipphardt, Isabella Roscher, Max Sommer
//	
//	Das Semesterprojekt baut auf echten Daten von den Masern auf und fokussiert
//	sowohl deren Verbreitung als auch die Eindämmung dieser durch Impfung anhand
//	der Visualisierung einer Stadt.

//	Prototyp 2, Version 2
//	Probleme:
//		+ NullPointerException bei restart()


//	Einstellungen
PVector resolution 		= new PVector(1440, 900);
boolean fullscreen 		= true;	
boolean debugMode		= false;


//	Globale Variablen
Simulation simulation 		= new Simulation( (int)resolution.x, (int)resolution.y );

void setup(){

	size( simulation.windowX , simulation.windowY, P2D );
	background( 255 );
	frameRate( 120 );
	smooth( 8 );
	
}

void draw(){

	//	Hier wird der Bildschirm übermalt, sodass das vorherige Bild
	//	nicht noch "durchscheint".
	clearScreen();

	//	Zunächst soll die Simulation geupdated werden, danach wird
	//	alles auf den Bildschirm gezeichnet.
	simulation.update();
	simulation.render();
	
}

void keyPressed(){

	if( key == 'r' ){
		restart();
	}
	else if( key == 'd' ){
		debugMode = !debugMode;
	}

}

public void clearScreen(){ 

	background( 255 ); 

}

public void restart(){

	simulation = null;
	simulation = new Simulation( (int)resolution.x, (int)resolution.y );

}

boolean sketchFullScreen(){
	return fullscreen;
}