//	Interactive Media Design, Sommersemester 2015
//	P2 Semesterprojekt: "Interaktive Simulation eines Biotops"
//	"Die Epis": Simone Haas, Nadja Lipphardt, Isabella Roscher, Max Sommer
//	
//	Das Semesterprojekt baut auf echten Daten von den Masern auf und fokussiert
//	sowohl deren Verbreitung als auch die Eindämmung dieser durch Impfung anhand
//	der Visualisierung einer Stadt (in der Umsetzung spezialisiert auf Dieburg).

//	Prototyp 3, Version 1
//	
//	In Arbeit:
//		+ Klasse Simulation
//		+ Klasse City
//		+ Klasse Human
//		
//	Zu tun:
//		+ Klasse Simulation
//		+ Klasse City
//		+ Klasse Human
//		+ Klasse myChild
//		+ Klasse Kindergarden
//		+ Klasse Camera
//		+ Simulation der Ansteckung
//		+ Simulation der Auswirkung von Impfung
//		+ GUI

//	Einstellungen
//
PVector windowResolution = new PVector( 1440, 900 );
boolean fullscreen = true;
boolean debugMode = true;

//	Hier wird unser Simulationsobjekt erstellt
//	die Parameter, die der Konstruktor erwartet sind einmal X und Y Auflösung
//	der Simulation selbst. Dadurch kann die Simulation selbst kleiner dargestellt
//	werden als das Fenster, falls das nötig werden sollte.
Simulation sim = new Simulation( windowResolution.x, windowResolution.y );


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
	sim.render();

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


boolean percentChance( float percent ){

	if( random( 0, 100 ) < percent ){
		return true;
	}

	return false;

}