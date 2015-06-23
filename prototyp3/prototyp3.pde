//	Interactive Media Design, Sommersemester 2015
//	P2 Semesterprojekt: "Interaktive Simulation eines Biotops"
//	"Die Epis": Simone Haas, Nadja Lipphardt, Isabella Roscher, Max Sommer
//	
//	Das Semesterprojekt baut auf echten Daten von den Masern auf und fokussiert
//	sowohl deren Verbreitung als auch die Eindämmung dieser durch Impfung anhand
//	der Visualisierung einer Stadt (in der Umsetzung spezialisiert auf Dieburg).

//	Prototyp 3, Version 4
//	
//	In Arbeit:
//		+ Klasse Simulation
//		+ Klasse City
//		+ Klasse Human
//		+ Klasse Caption
//		+ Klasse Camera
//			+ Zoom
//		+ Parallelansicht der Simulationen
//		
//	Zu tun:
//		+ Klasse Simulation
//		+ Klasse City
//		+ Klasse Human
//		+ Klasse Caption
//		+ Klasse myChild
//		+ Klasse Kindergarden
//		+ Klasse Camera
//		+ Simulation der Auswirkung von Impfung
//		+ Realistische Werte!
//		+ GUI
//
//	Neuerungen:
//		+ Es gibt jetzt einen gemeinsamen Startpunkt der beiden Simulationen
//		+ Die Animation zur Splittung der beiden Städte wird jetzt direkt automatisch abgespielt
//		+ Es gibt jetzt die Kindergartenansicht und generell verschiedene Zustände für das Programm
//		+ Mit 'n' kann man zwischen diesen Zuständen wechseln
//
//	Probleme:
//		+ Die Kamera kann nicht mehrere Bewegungen in Reihenfolge nacheinander durchführen
//		sondern springt immer direkt zum nächsten. Hier muss eine Warteschleife eingebaut werden

//	Einstellungen
//
PVector windowResolution = new PVector( 1440, 900 );
boolean fullscreen = true;
boolean debugMode = true;
boolean directStartMode = false;

//	Globale Variablen

//	0: Intro, 1: Kindergarten, 2: Simulation, 3: Outro
int currentStatus			= 0;

float humanRadius 			= windowResolution.y/60;
float humanRadiusExtended 		= windowResolution.y/120;	
boolean startPersonGenerated	= false;				//	Wurde schon eine Startperson ausgewählt?
int startPerson 				= 0;				//	Welche ist diese Startperson?


//	Hier wird unser Simulationsobjekt erstellt
//	die Parameter, die der Konstruktor erwartet sind einmal X und Y Auflösung
//	der Simulation selbst. Dadurch kann die Simulation selbst kleiner dargestellt
//	werden als das Fenster, falls das nötig werden sollte.
Simulation sim = new Simulation( windowResolution.x / 2, windowResolution.y / 2, 1 );
Simulation sim2 = new Simulation ( windowResolution.x / 2, windowResolution.y / 2, 2 );

Caption caption = new Caption();


void setup(){

	//	Fenstergröße setzen
	size( (int)windowResolution.x , (int)windowResolution.y, P2D );
	//	Bildschirm Hintergrund weiß malen
	clearScreen();	
	//	Die Framerate wird hier auf 120 gesetzt, damit will ich erst einmal 
	//	feststellen wie schnell die Simulation läuft. Für die finale Version reichen
	//	auch 60 als Framerate
	frameRate( 120 );
	//	Damit wird das Bild etwas weicher und die Kreise nicht so eckig
	smooth( 8 );
	//	Ellipsenursprung im Zentrum
	ellipseMode(CENTER);

}


void draw(){

	//	die draw aufrufe die dauerhaft ausgefüht werden nennt man drawcalls :)
	//	bei jedem drawcall sollt zuerst einmal das Bild wieder weiß übermalt werden
	clearScreen();

	//	anschließend updaten wir unsere Simulation und lassen alles darstellen
	sim.update();
	sim2.update();
	sim.render();
	sim2.render();

	//	Die Legende wird geupdatet und gerendert
	if( currentStatus == 2 ){
		caption.update();
		caption.render();
	}

	//	Debuginfo rendern, falls nötig
	renderDebugInfo();

}


public void clearScreen(){

	//	Hintergrund wird weiß überzeichnet
	background( 255 );

}


boolean sketchFullScreen(){

	//	Soll die Simulation im Vollbild ausgeführt werden muss die Variable fullscreen 
	//	einfach false gesetzt werden
	return fullscreen;

}


//	Diese Funktion "erwürfelt" quasi den Eintritt oder Nicht-Eintritt
//	eines Ereignisses mit Wahrscheinlichkeit "percent"
boolean percentChance( float percent ){

	if( random( 0, 100 ) < percent ){
		return true;
	}

	return false;

}


public void keyPressed(){

	switch(key){

		case 'r':
		case 'R':
			restartSimulation();
		break;

		case 'd':
		case 'D':
			debugMode = !debugMode;
		break;

		case 'p':
		case 'P':
			sim.paused = !sim.paused;
		break;

		case 'n':
		case 'N':
			//	Hier wird zwischen den Stati der Applikation, also in welcher Phase
			//	man sich gerade befindet umgeschaltet. Mögliche Stati sind zB
			//	Intro, Kindergarten, Simulation oder Outro
			if( currentStatus < 3 ){
				changeStatus( (currentStatus+1) );
			}
			else{
				restartSimulation();
			}
		break;

	}

}


public void renderDebugInfo(){

		if( debugMode ){

			fill( 0, 0, 230 );
			text(frameRate+"fps", 20, 20);

			if( this.paused ){
				fill( 230, 0, 0);
				text("Simulation is paused", 20, 40);

			}else{
				fill( 0, 230, 0 );
				text("Simulation is running", 20, 40);
			}

			fill( 0, 230, 0 );
			String statusWord = "";
			switch( currentStatus ){

				case(0):
					statusWord = "Intro";
				break;

				case(1):
					statusWord = "Kindergarden";
				break;

				case(2):
					statusWord = "Simulation";
				break;

				case(3):
					statusWord = "Outro";
				break;

			}
			text("Status: " + statusWord, 20, 60);

			fill( 50 );
			text("Press 'r' to restart", 20, 80);
			text("Press 'd' to toggle debug mode", 20, 100);
			text("Press 'p' to play/pause the simulation", 20, 120);
			text("Press 'n' to switch between states", 20, 140);

		}

}


//	Der Übergang der Stati wird hier gemanaged
//	Dadurch kann man beispielsweise für den Übergang zweier Phasen einen
//	Zoom oder eine Kamerabewegung durchführen
public void changeStatus( int newstatus ){

	currentStatus = newstatus;

	if(currentStatus == 1){

		//	Heranzoomen und -bewegen
		sim2.cam.zoomTo( 0.5, 2000 );
		sim2.cam.moveTo( new PVector(windowResolution.x/4,windowResolution.y/4), 1000 );

	}

	if( currentStatus == 2 ){

		//	Verschiebung der Kameras
		sim.cam.moveTo( new PVector( -windowResolution.x/4, 0 ), 1000 );
		sim2.cam.moveTo( new PVector( windowResolution.x/5, 0 ), 1000 );

	}

}


//	Wie der Name der Funktion schon sagt kann man hiermit die Simulationen
//	zurücksetzen und neu starten
public void restartSimulation(){

	currentStatus = 0;
	sim = new Simulation( windowResolution.x, windowResolution.y, 1 );
	sim2 = new Simulation( windowResolution.x, windowResolution.y, 2 );

}