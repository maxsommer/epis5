//	Interactive Media Design, Sommersemester 2015
//	P2 Semesterprojekt: "Interaktive Simulation eines Biotops"
//	"Die Epis": Simone Haas, Nadja Lipphardt, Isabella Roscher, Max Sommer
//	
//	Das Semesterprojekt baut auf echten Daten von den Masern auf und fokussiert
//	sowohl deren Verbreitung als auch die Eindämmung dieser durch Impfung anhand
//	der Visualisierung einer Stadt (in der Umsetzung spezialisiert auf Dieburg).

//	Prototyp 3, Version 9.7
//
//	Ablauf der Stati:
//		-1: 	Starten der Applikation
//		0: 	Startscreen
//		5:	Maserninfo
//		6: 	Übergang Maserninfo zu Kindergarten
//				Virus bewegt sich zum Kindergarten und steckt jemanden an
//		1: 	Kindergarten
//		7:	Vorstellung des eigenen Kindes 
//				Zoom auf das Kind
//				"Das ist dein Kind"
//		9:	
//		10:	
//		2:	Städte
//		3: 	Erkenntnis
//		4: 	Neustart der Simulation
//		8: 	Übergang Kindergarten zu Stadt
//		11:	Neustarten der Applikation
//			
//		Simulationsdaten
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
//		
//	Zu tun:
//		+ Zeitleiste, gestaltet
//			Unsere Simulation hat bereits eine rudimentäre Zeitleiste integriert, da uns aber 
//			die Zeit für die Gestaltung dieser fehlte ist sie zunächst im Prototyp nicht integriert.
//
//		+ Sound
//			Die Simulation brauch auch noch Sounds!
//			Aufgrund von Schwierigkeiten mit der Minim Bibliothek und dem Abspielen von Sounds
//			ist auch das im Prototyp noch nicht vorhanden.
//
//	Neuerungen:
//		+ Animation Erkenntnisscreen
//		+ Animation Startscreen
//		+ Ablauf der Animationen, Ein- und Ausblendungen korrigiert
//		+ Texte für "Kindergarten", "Stadt Dieburg", "Impfquote 0%", "Impfquote 63%" eingefügt
//		+ Hints zur Interaktion
//		+ Restart Button
//		+ Maserninfo, Text
//

import ddf.minim.*;

//	Einstellungen
//
PVector windowResolution = new PVector( 1920, 1080 );
boolean debugMode = false;
boolean hideCursor = true;

int framerate = 120;
boolean fullscreen = true;

//	Globale Variablen

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
float numberInfectedRightSimTransition = 66 ;
Timer simulationPauseTimer		= new Timer( 1500, true );
float rightTransitionOffset 		= windowResolution.x;
boolean vaccineHintShown = false;
boolean vaccinedChildFound = false;
int vaccinedChild;
float kindergardenTextAlpha 	= 0.0;
float cityTextAlpha	 	= 0.0;

// 	Virus
Virus virus = new Virus( new PVector(windowResolution.x/2, windowResolution.y - 200) ); 
PImage virusImage;

//	Impstoff
PImage vaccineImage;

//	TimeDisplay
TimeDisplay timeDisplay = new TimeDisplay();
PFont Pistara72;
PFont Pistara48;
PFont Pistara18;
PFont HelveticaNeue48;


//	Hier wird unser Simulationsobjekt erstellt
//	die Parameter, die der Konstruktor erwartet sind einmal X und Y Auflösung
//	der Simulation selbst. Dadurch kann die Simulation selbst kleiner dargestellt
//	werden als das Fenster, falls das nötig werden sollte.
Simulation sim = new Simulation( windowResolution.x / 2, windowResolution.y / 2, 1 );
Simulation sim2 = new Simulation ( windowResolution.x / 2, windowResolution.y / 2, 2 );

Caption caption = new Caption();

//	Start und Restartbutton
CircularButton startButton = new CircularButton( new PVector(windowResolution.x/2, windowResolution.y/2), color( 90,90,90 ), color(40,40,40), 5 );
PImage playImage;
CircularButton restartButton = new CircularButton( new PVector(windowResolution.x/2, windowResolution.y/4*3), color( 90,90,90 ), color(40,40,40), 11 );
PImage replayImage;


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
	imageMode(CENTER);
	//	Schriftart laden
	Pistara18 		= loadFont("Pistara-18.vlw");
	Pistara48 		= loadFont("Pistara-48.vlw");
	Pistara72 		= loadFont("Pistara-72.vlw");
	HelveticaNeue48 	= loadFont("HelveticaNeue-48.vlw");
	//	Bilddateien laden
	virusImage 		= loadImage("virus.png");
	playImage 		= loadImage("play.png");
	replayImage 		= loadImage("replay.png");
	vaccineImage 		= loadImage("vaccine.png");

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

	//	Startscreen
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

	//	Maserninfo screen
	if( currentStatus == 5 ){

		virus.clearList();

		playInfoScreenAnimation();

		simulationPauseTimer.reset();
		simulationPauseTimer.set( 6500 );
		simulationPauseTimer.start();

	}

	//	Übergang Startscreen zu Kindvorstellung
	if( currentStatus == 6 ){

		virus = new Virus( virus.position );
		// Kamera nach rechts bewegen, sodass der Kindergarten ins Bild kommt
		// danach wird dann das eigene Kind vorgestellt in Status 1
		sim2.cam.moveTo( new PVector( windowResolution.x, 0 ), 1.0, 2000 );
		virus.moveTo( 
			sim2.city.humans.get( startPerson ).position.x + 9, 
			sim2.city.humans.get( startPerson ).position.y -2 , 
			3000 ); 
		simulationPauseTimer.reset();
		simulationPauseTimer.set( 2000 );
		simulationPauseTimer.start();

	}

	//	Kindvorstellung
	if(currentStatus == 1){

		virus.shrinkTo( 0.25 );
		//	Heranzoomen und -bewegen	
		sim2.cam.moveTo( new PVector(windowResolution.x/16*21.65,windowResolution.y/16 *5.3), 4.0, 1000 );
		simulationPauseTimer.reset();
		simulationPauseTimer.set( 3000 );
		simulationPauseTimer.start();

	}

	//	Übergang Kindvorstellung zu Kindergarten
	if( currentStatus == 7){

		sim2.cam.moveTo( new PVector(windowResolution.x/4*5,windowResolution.y/4), 2.0, 1000 );

		timeDisplay.start();

		// 	Infektion im Kindergarten beginnen
		sim2.city.kindergarden.startInfection();

		//	Die Gesunden in der Legende anzeigen 
		caption.healthyVisible = true;

	}

	//	 herauszoomen und simulation teilen
	if( currentStatus == 9 ){

		simulationPauseTimer.reset();
		simulationPauseTimer.set( 2000 );
		simulationPauseTimer.start();

		sim.city.vaccinateCity();

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

	}

	//	Übergang in Simulation ("du kannst dein kind jetzt impfen")
	if( currentStatus == 10 ){

		simulationPauseTimer.reset();
		simulationPauseTimer.set( 7000 );
		simulationPauseTimer.start();

		caption.vaccinedVisible = true;

	}

	if( currentStatus == 2 ){
		sim.city.startInfection();
		sim2.city.startInfection();	

	}

	if( currentStatus == 3 ){

		simulationPauseTimer.reset();
		simulationPauseTimer.set( 5000 );
		simulationPauseTimer.start();

			virus.position = new PVector( sim.city.humans.get( vaccinedChild ).position.x + 25 + sim.cam.position.x , sim.city.humans.get( vaccinedChild ).position.y + sim.cam.position.y );

			//playRestartScreenAnimation();


		//	Wenn das eigene Kind auf der rechten oder auf beiden Seiten geimpft wurde, dieses
		//	anzoomen
		if( 
			((sim.city.humans.get(91).state == 4) && !( sim2.city.humans.get(91).state == 4) ) ||
			((sim.city.humans.get(91).state == 4) && ( sim2.city.humans.get(91).state == 4) )
		){
			PVector pos = sim.city.humans.get(91).getPosition();
			PVector camera = sim.cam.position;
			sim.cam.moveTo( PVector.sub(pos, new PVector(windowResolution.x/8, windowResolution.x/16)), 4.0, 1500 );
			sim2.cam.moveTo( new PVector(9000, 9000), 1.0, 1500 );
			vaccinedChild = 91;

		}
		//	Wenn das eigene Kind auf der linken Seite geimpft wurde, dieses
		//	anzoomen
		else if ( sim2.city.humans.get(91).state == 4 && !( sim.city.humans.get(91).state == 4) ){
			PVector pos = sim2.city.humans.get(91).getPosition();
			PVector camera = sim2.cam.position;
			sim2.cam.moveTo( PVector.sub(pos, new PVector(windowResolution.x/8, windowResolution.x/16)), 4.0, 1500 );
			sim.cam.moveTo( new PVector(9000, 9000), 1.0, 1500 );
			vaccinedChild = 91;

		}
		//	Wenn das eigene Kind auf keine der beiden Seiten geimpft wurde
		else if(  !(sim.city.humans.get(91).state == 4) && !(sim2.city.humans.get(91).state == 4) ){
			//	einen geimpften Menschen finden 
			int i = 0;
			while( !vaccinedChildFound ){
				if( sim.city.humans.get(i).state == 4  && !(i == 0||i==8||i==75||i==76||i==90||i==92||i==100||i==116||i==107||i==108||i==208||i==216)){
					vaccinedChildFound = true;
					vaccinedChild = i;
				}
				i++;
			}

			//	und auf ihn zoomen
			PVector pos = sim.city.humans.get(i).getPosition();
			PVector camera = sim.cam.position;
			sim.cam.moveTo( PVector.sub(pos, new PVector(windowResolution.x/8, windowResolution.x/16)), 4.0, 1500 );
			sim2.cam.moveTo( new PVector(9000, 9000), 1.0, 1500 );

		}

	}

}


public void updateTimers(){

	simulationPauseTimer.update();

	simulationPauseTimer.isAlive();

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

		case( 5 ):
			virus.update();
			virus.render();

			//	Button 
			startButton.reduceSize();
			startButton.render();

			if( simulationPauseTimer.completed ){
				changeStatus( 6 );
			}else{
				showInfoScreen();
				if( !virus.hasInQueue() ){
					playInfoScreenAnimation();
				}
			}
		break;

		case(6):
		
			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();
			virus.update();
			virus.render();
			showInfoScreen();

			if( simulationPauseTimer.completed ){
				changeStatus( 1 );
			}

		break;

		case(1):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			virus.update();
			virus.render();

				textSize( 48 );
				textFont( Pistara48 );
				fill(0);
				text( thisIsYourChild, sim2.city.humans.get(91).getPosition().x - sim2.cam.position.x + windowResolution.x / 4 + 154, windowResolution.y/2 - 190 );
				textSize( 12 );

			caption.update();
			caption.render();

			if( simulationPauseTimer.completed ){
				changeStatus( 7 );
			}

		break;

		case(7):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();
			caption.update();
			caption.render();

				textSize( 48 );
				textFont( Pistara48 );
				if(kindergardenTextAlpha < 255 )
					kindergardenTextAlpha+= 0.2;
				fill(0, 255 - kindergardenTextAlpha);
				text( kindergardenText, windowResolution.x / 2 - 130, windowResolution.y/2- 400 );
				textSize( 12 );
			

			//	Zeitleiste
			//timeDisplay.update();
			//timeDisplay.render();

		break;

		case( 9 ):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();	
			caption.update();
			caption.render();

			if( simulationPauseTimer.completed ){
				changeStatus( 10 );
			}

		break;

		case( 10 ):

			sim.update();
			sim2.update();
			sim.render();
			sim2.render();		
				fill( 255, 255, 255, 180 );
				rect( 0, 0, windowResolution.x, windowResolution.y-160 );
				textFont( Pistara48 );
				textSize(48);
				fill(0);
				text( vaccineYourChild, windowResolution.x/2 - 230, windowResolution.y/2 - 360 );
				textSize( 12 );
			sim.city.humans.get(91).render();
			sim2.city.humans.get(91).render();
			caption.update();
			caption.render();

			if( simulationPauseTimer.completed ){
				changeStatus( 2 );
			}

		break;

		case(2):
			sim.update();
			sim2.update();
			sim.render();
			sim2.render();

				textSize( 48 );
				textFont( Pistara48 );
				if(cityTextAlpha < 255 )
					cityTextAlpha+= 0.35;
				fill(0, 255 - cityTextAlpha);
				text( cityText, windowResolution.x / 2 - 50, windowResolution.y/2- 400 );
				fill(0);
				textSize( 36 );
				textFont( Pistara48);
				text( zeroPercentText, windowResolution.x / 5 * 1.15, windowResolution.y/2- 400 );
				text( realPercentText, windowResolution.x / 5  * 3.35, windowResolution.y/2- 400 );
				textSize( 12 );

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

				fill( 255, 255, 255, 180 );
				rect( 0, 0, windowResolution.x, windowResolution.y );
				if( sim.city.humans.get(91).state == 4 ){
					sim.city.humans.get(91).render();
				}
				else if ( sim2.city.humans.get(91).state == 4 ){
					sim2.city.humans.get(91).render();
				}
				else{
					sim.city.humans.get(vaccinedChild).render();
				}

				textFont( Pistara72 );
				textSize( 72 );
				fill(0);
				text( vacciningHelps, windowResolution.x / 2 - 345, windowResolution.y/2- 360 );
				textSize( 12 );

			virus.update();
			virus.render();

			restartButton.update();
			restartButton.render();

		break;

	}

}


//	Wie der Name der Funktion schon sagt kann man hiermit die Simulationen
//	zurücksetzen und neu starten
public void restartSimulation(){

	virus = new Virus( new PVector(windowResolution.x/2, windowResolution.y - 200) ); 
	timeDisplay = new TimeDisplay(); 
	caption.healthyVisible = false;
	caption.vaccinedVisible = false;
	caption.infectedVisible = false;
	currentStatus = -1;
	numberInfectedKindergarden = 0;
	startPerson = 0;
	startPersonGenerated = false;
	caption = new Caption();
	vaccineHintShown = false;
	sim = new Simulation( windowResolution.x / 2, windowResolution.y / 2, 1 );
	sim2 = new Simulation ( windowResolution.x / 2, windowResolution.y / 2, 2 );
	kindergardenTextAlpha 	= 0.0;
	cityTextAlpha	 		= 0.0;

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

	}

}


public void renderDebugInfo(){

		if( debugMode ){
			textFont( Pistara18 );
			textSize( 12 );

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


public void playStartScreenAnimation(){

	virus.moveTo( 	windowResolution.x/2 + 0, 	windowResolution.y/2 +150, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 + 200, 	windowResolution.y/2 + 300, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 + 80, 	windowResolution.y/2 + 125, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 + 300, 	windowResolution.y/2 + 0, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 + 150, 	windowResolution.y/2 - 0, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 + 200, 	windowResolution.y/2 - 300, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 + 80, 	windowResolution.y/2 - 125, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 - 0, 	windowResolution.y/2 - 300, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 - 0, 	windowResolution.y/2 - 125, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 - 200, 	windowResolution.y/2 - 200, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 - 125, 	windowResolution.y/2 - 80, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 - 300, 	windowResolution.y/2 - 0, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 - 150, 	windowResolution.y/2 - 0, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 - 200, 	windowResolution.y/2 + 300, 700, 3 );
	virus.moveTo( 	windowResolution.x/2 - 80, 	windowResolution.y/2 + 125, 500, 2 );
	virus.moveTo( 	windowResolution.x/2 - 0, 	windowResolution.y/2 + 300, 700, 3 );

}


public void playRestartScreenAnimation(){

	virus.moveTo( sim.city.humans.get( vaccinedChild ).position.x + 25, sim.city.humans.get( vaccinedChild ).position.y, 500, 2 );
	virus.moveTo( sim.city.humans.get( vaccinedChild ).position.x + 300, sim.city.humans.get( vaccinedChild ).position.y, 700, 3 );

}


public void playInfoScreenAnimation(){

	virus.moveTo( windowResolution.x/2 -300 - sim2.cam.getPosition().x, windowResolution.y/2 - 230 - sim2.cam.getPosition().y, 1000 );
	virus.moveTo( windowResolution.x/2+ 0 - sim2.cam.getPosition().x, windowResolution.y/2 - 250 - sim2.cam.getPosition().y, 1000 );
	virus.moveTo( windowResolution.x/2+ 300 - sim2.cam.getPosition().x, windowResolution.y/2 - 230 - sim2.cam.getPosition().y, 1000 );
	virus.moveTo( windowResolution.x/2+ 0 - sim2.cam.getPosition().x, windowResolution.y/2 - 250 - sim2.cam.getPosition().y, 1000 );



/*
	virus.moveTo( windowResolution.x / 2 + 0, windowResolution.y / 2 + 400, 1000 );
	virus.moveTo( windowResolution.x / 2 + 300, windowResolution.y / 2 + 300, 1000 );
	virus.moveTo( windowResolution.x / 2 + 600, windowResolution.y / 2 + 400, 1000 );
	virus.moveTo( windowResolution.x / 2 + 500, windowResolution.y / 2 + 0, 1000 );
	virus.moveTo( windowResolution.x / 2 + 600, windowResolution.y / 2 - 400, 1000 );
	virus.moveTo( windowResolution.x / 2 + 300, windowResolution.y / 2 - 300, 1000 );
	virus.moveTo( windowResolution.x / 2 + 0, windowResolution.y / 2 - 400, 1000 );
	virus.moveTo( windowResolution.x / 2 - 300, windowResolution.y / 2 - 300, 1000 );
	virus.moveTo( windowResolution.x / 2 - 600, windowResolution.y / 2 - 400, 1000 );
	virus.moveTo( windowResolution.x / 2 - 500, windowResolution.y / 2 - 0, 1000 );
	virus.moveTo( windowResolution.x / 2 - 600, windowResolution.y / 2 +400, 1000 );
	virus.moveTo( windowResolution.x / 2 - 300, windowResolution.y / 2 +300, 1000 );
*/

}


public void showInfoScreen(){
	fill( 255, 50 );
	rect( 0 , 0, windowResolution.x, windowResolution.y );

	fill( 0 );
	textFont( Pistara72 );
	textSize(72);
	text( measlesInfo, windowResolution.x/2-100 - sim2.cam.getPosition().x, windowResolution.y/2 - 100 - sim2.cam.getPosition().y);
	textFont( Pistara48 );
	textSize(36);
	text( measlesInfoExtended, windowResolution.x/2-340 - sim2.cam.getPosition().x, windowResolution.y/2 - 20 - sim2.cam.getPosition().y);

}