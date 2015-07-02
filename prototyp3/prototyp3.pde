//	Interactive Media Design, Sommersemester 2015
//	P2 Semesterprojekt: "Interaktive Simulation eines Biotops"
//	"Die Epis": Simone Haas, Nadja Lipphardt, Isabella Roscher, Max Sommer
//	
//	Das Semesterprojekt baut auf echten Daten von den Masern auf und fokussiert
//	sowohl deren Verbreitung als auch die Eindämmung dieser durch Impfung anhand
//	der Visualisierung einer Stadt (in der Umsetzung spezialisiert auf Dieburg).

//	Prototyp 3, Version 9.1
//
//	Ablauf der Stati:
//		-1: 	Starten der Applikation
//		0: 	Startscreen
//		1: 	Kindergarten
//		2:	Städte
//		3: 	Erkenntnis
//		4: 	Neustart der Simulation
//		5:	
//		6: 	Übergang Startscreen zu Kindergarten
//				Virus bewegt sich zum Kindergarten und steckt jemanden an
//		7:	Vorstellung des eigenen Kindes 
//				Zoom auf das Kind
//				"Das ist dein Kind"
//		8: 	Übergang Kindergarten zu Stadt
//	
//	In Arbeit:
//		+ Klasse Virus
//		+ Übergansanimationen zwischen den verschiedenen Stati
//		+ Automatischer Übergang zwischen Zustand -1 zu 0
//		+ Automatischer Übergang zwischen Zustand 2 zu 3
//		
//	Zu tun:
//		+ Sound
//			Die Simulation brauch auch noch Sounds!
//	
//		+ Anpassung der Anzahl der Menschen
//			Aktuell gibt es 217 Menschen pro Simulation. Um beeindruckender zu wirken könnten
//			wir die Anzahl der Menschen nochmals hochsetzen und diese stattdessen kleiner, mit 
//			weniger Abstand darstellen
//	
//		+ Animation für den Wechsel vom Startscreen zur Kindergartenansicht
//			Hier soll unser kleiner "Erzähler" in den Kindergarten hineinhüpfen und dann quasi
//			das erste Kind anstecken. Von da an breitet sich die Krankheit aus
//
//		+ Animation der Ansteckung
//			Ist man gesund, wird man nicht sofort und direkt komplett krank, deshalb soll es eine 
//			Übergansanimation für jeden einzelnen Menschen geben, die den Prozess zeigt
//			Dabei wird eine art Linie oder Welle  über den Menschen gezogen, die sich dann immer weiter über
//			den Kreis von ihm ausbreitet
//
//		+ Die Impfinteraktion
//			Hier wird auf das eigene Kind herangezoomt und man wird gefragt ob es geimpft werden soll oder eben
//			nicht. Das entscheidet über den weiteren Verlauf der Simulation, besonders am Ende
//
//		+ Animation des Erkenntnisscreens
//			Am Ende soll unser kleiner Virus wieder kommen und nochmals versuchen einen Menschen anzustecken
//			Wurde das eigene Kind geimpft, so versucht der kleine Virus es bei dem eigenen Kind und prallt ab. Wurde
//			das eigene Kind nicht geimpft, so zoomen wir auf einen anderen, geimpften Menschen und lassen das Virus
//			dort abprallen
//			
//		+ Realistische Werte
//			Die Simulation beruht auf einer Ansteckrate. Das bedeutet, dass es pro Frame, der angezeigt wird immer die Chance 
//			für jeden (der sich bei einem angesteckten in "Reichweite" befindet) gibt sich anzustecken mit Wahrscheinlichkeit X.
//			Die echten Daten sagen Folgendes über die Ansteckrate bei Exposition:
//				Ungeimpfte: 	95% 	- 	100%
//				1. Geimpft: 		9%
//				2. Geimpft: 	1% 	-	8%
//				 
//			Jeder Frame muss für eine echte Zeiteinheit stehen. So könnte man beispielsweise Folgendes festlegen:
//			
//				Die Simulation wird ca. 12 Tage abbilden
//				1 Sekunde der Simulation soll 4 Stunden der Wirklichkeit entsprechen
//				60 Frames / Sekunde bedeutet
//				1 Frame = 4 Stunden/60 = 4 Minuten
//				1 Frame entspricht also 4 Minuten
//				Die Ansteckrate X bedeutet also eine Wahrscheinlichkeit von X, 
//				dass eine Person innerhalb von 4 Minuten angesteckt wird
//
//		+ Gestaltung der Zeitleiste
//
//	Neuerungen:
//		+ Anpassung des Aussehens der Menschen
//			Wir müssen eine Farbpalette bestimmen und einsetzen um sowohl differenzierbar als auch
//			"fancy" zu sein. Dabei sollten wir auch darauf achten die Farben gerecht für Farbenblinde auszuwählen
//
//		+ Play Button
//		+ Übergangsanimationen
//		
//
//	Probleme:
//		+ Wird die Simulation pausiert und anschließend neu gestartet, kann es passieren
//		dass die Pausieren Funktion anschließend nicht mehr korrekt funktioniert.
//

//	Einstellungen
//
PVector windowResolution = new PVector( 1440, 900 );
boolean debugMode = true;
boolean hideCursor = false;

int framerate = 120;
boolean fullscreen = true;

//	Globale Variablen

//	-1: Grundzustand, 0: Intro, 1: Kindergarten, 2: Simulation, 3: Outro
int currentStatus			= -1;
float timeRelation			=  8.4;
//	60s = 21 tage
// 	1s = 21/60 tage 
//	1s = 0.35 * 24h
//	1s = 8,4h

float humanRadius 			= windowResolution.y/70;
float humanRadiusExtended 		= windowResolution.y/93;	
boolean startPersonGenerated	= false;				//	Wurde schon eine Startperson ausgewählt?
int startPerson 				= 0;				//	Welche ist diese Startperson?
int numberInfectedKindergarden	= 0;
int numberInfectedKindergardenTransition = 12;
float numberInfectedRightSim 		= 0;
float numberInfectedRightSimTransition = 70 ;
Timer simulationPauseTimer		= new Timer( 1500, true );
float rightTransitionOffset 		= windowResolution.x;

//	Testbutton für Touchtisch
CircularButton startButton = new CircularButton( new PVector(windowResolution.x/2, windowResolution.y/2), color( 90,90,90 ), color(40,40,40), 6 );
PImage playImage;

// 	Virus
Virus virus = new Virus( new PVector(windowResolution.x/2, windowResolution.y - 200) ); 
PImage virusImage;

//	TimeDisplay
TimeDisplay timeDisplay = new TimeDisplay();
PFont Helvetica;


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
	frameRate( framerate );
	//	Damit wird das Bild etwas weicher und die Kreise nicht so eckig
	smooth( 8 );
	//	Ellipsenursprung im Zentrum
	ellipseMode(CENTER);
	//	Schriftart laden
	Helvetica 	= loadFont("HelveticaNeue-48.vlw");
	//	Bilddateien laden
	virusImage 	= loadImage("virus.png");
	playImage 	= loadImage("play.png");
	//	textFont( Helvetica );
	//	Bei der Präsentation möchten wir keine Maus auf dem Bildschirm haben
	//	sondern stattdessen lieber nichts
	if(hideCursor){
		noCursor();
	}

}


void draw(){

	//	die draw aufrufe die dauerhaft ausgefüht werden nennt man drawcalls :)
	//	bei jedem drawcall sollt zuerst einmal das Bild wieder weiß übermalt werden
	clearScreen();

	//	auch im Hauptprogramm werden Timer benötigt.
	//	diese werden hier geupdatet
	updateTimers();

	//	mit dieser Funktion werden, je nach aktuellem Status der Applikation
	//	die nötigen Dinge geupdated und angezeigt
	updateStates();

	//	Debuginfo rendern, falls nötig
	renderDebugInfo();

}


//	Der Übergang der Stati wird hier gemanaged
//	Dadurch kann man beispielsweise für den Übergang zweier Phasen einen
//	Zoom oder eine Kamerabewegung durchführen
public void changeStatus( int newstatus ){

	currentStatus = newstatus;

	if(currentStatus == 0){

		//	Hier wird die Intro Animation des Erzählervirus abespielt
		//	Mit der Funktion moveTo kann man, wie der Name schon sagt
		//	das Virus bewegen. 
		//	
		//	Die Parameter sind folgende
		//	moveTo ( X-Position, Y-Position, Zeit, Funktion )
		//	X-Position: 	Steht für die X-Koordinate der Zielposition
		//	Y-Position: 	Steht für die Y-Koordinate der Zielposition
		//	Zeit:		Wie lange soll die Animation dauern?
		//	
		//	Funktion:	Welche Bewegungsfunktion soll benutzt werden?
		//			Entweder: cubic, wofür die 0 eingesetzt werden muss
		//			Oder: exponential, wofür die 1 eingesetzt werden muss
		//			
		//			Man auf folgender Webseite einen guten Vergleich der beiden
		//			Bewegungsfunktionen, die ich miteingebaut habe sehen: http://gizma.com/easing/
		//	
		//	Der Funktionsparameter ist optional, das heißt man muss ihn nicht unbedingt angeben, wie im Beispiel
		//	unterhalb zu sehen ist. Gibt man ihn nicht an, wird einfach davon ausgegangen dass man die cubic Funktion
		//	benutzen möchte.

		playStartScreenAnimation();

	}

	if(currentStatus == 1){

		timeDisplay.start();

		//	Heranzoomen und -bewegen	
		sim2.cam.moveTo( new PVector(windowResolution.x/4*5,windowResolution.y/4), 2.0, 1000 );

		// 	Infektion im Kindergarten beginnen
		sim2.city.kindergarden.startInfection();

		//	Die Gesunden in der Legende anzeigen 
		caption.healthyVisible = true;

	}

	if( currentStatus == 2 ){

		sim.cam.moveTo( new PVector( windowResolution.x, 0 ), 1.0, 1500 );
		sim2.cam.moveTo( new PVector( windowResolution.x, 0 ), 1.0, 1500 );

		//	Übernahme der Simulationsdaten aus dem Kindergarten
		for( int i = 0; i < sim.city.humans.size(); i++ ){

			Human h = sim2.city.humans.get(i);
			if( h.isInfecting() ){
				sim.city.humans.get(i).infect();
			}

		}

		//	Verschiebung der Kameras
		sim.cam.moveTo( new PVector( windowResolution.x/4*3, 0 ), 1.0, 1500 );
		sim2.cam.moveTo( new PVector( windowResolution.x/5*6, 0 ), 1.0, 1500 );

		sim.city.vaccinateCity();
		sim.city.startInfection();
		sim2.city.startInfection();	

		caption.vaccinedVisible = true;

	}

	if( currentStatus == 6 ){

		// Kamera nach rechts bewegen, sodass der Kindergarten ins Bild kommt
		sim2.cam.moveTo( new PVector( windowResolution.x, 0 ), 1.0, 2500 );
		simulationPauseTimer.reset();
		simulationPauseTimer.set( 2500 );
		simulationPauseTimer.start();

	}

}


public void updateTimers(){

	simulationPauseTimer.update();

	if( !simulationPauseTimer.isAlive() ){

	}

}


public void playStartScreenAnimation(){

	virus.moveTo( windowResolution.x/2 + 0, windowResolution.y/2 + 150, 1000, 0 );
	virus.moveTo( windowResolution.x/2 + 200, windowResolution.y/2 + 150, 1000, 2 );
	virus.moveTo( windowResolution.x/2 + 200, windowResolution.y/2 + 0, 1000, 3 );
	virus.moveTo( windowResolution.x/2 + 0, windowResolution.y/2 + 0, 1000, 2 );
	virus.moveTo( windowResolution.x/2 + 0, windowResolution.y/2 + 150, 1000, 3 );

}


public void updateStates(){

	switch( currentStatus ){

		case(-1):
			changeStatus(0);
		break;

		case(0):
			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			virus.update();
			virus.render();

			if( !virus.hasInQueue() ){
				playStartScreenAnimation();
			}

			//	Button 
			startButton.update();
			startButton.render();
			//	Legende
			caption.update();
			caption.render();

		break;

		case(1):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();
			//	Zeitleiste
			timeDisplay.update();
			timeDisplay.render();

		break;

		case(2):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();
			//	Zeitleiste
			timeDisplay.update();
			timeDisplay.render();

		break;

		case(3):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();
			//	Zeitleiste
			timeDisplay.update();
			timeDisplay.render();

		break;

		case(6):
		
			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();
			//	Zeitleiste
			timeDisplay.update();
			timeDisplay.render();

			if( !virus.hasInQueue() ){
				playStartScreenAnimation();
			}

			//	Button 
			startButton.update();
			startButton.render();

			if( simulationPauseTimer.completed ){
				changeStatus( 1 );
			}

		break;

	}

}


//	Wie der Name der Funktion schon sagt kann man hiermit die Simulationen
//	zurücksetzen und neu starten
public void restartSimulation(){

	virus = new Virus( new PVector(windowResolution.x/2, windowResolution.y - 200) ); 
	timeDisplay = new TimeDisplay();
	currentStatus = -1;
	numberInfectedKindergarden = 0;
	startPerson = 0;
	startPersonGenerated = false;
	sim = new Simulation( windowResolution.x / 2, windowResolution.y / 2, 1 );
	sim2 = new Simulation ( windowResolution.x / 2, windowResolution.y / 2, 2 );

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
			if(!sim.isPaused()){
				sim.pauseSim();
			}
			else{
				sim.resumeSim();
			}

			if(!sim2.isPaused()){
				sim2.pauseSim();
			}
			else{
				sim2.resumeSim();
			}

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

			if( sim.isPaused() && sim2.isPaused()){
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