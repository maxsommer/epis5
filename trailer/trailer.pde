PImage vaccineImage;
PImage screenm;
float pulse = 0;


PFont Helvetica;
void setup(){

	size( 1920, 1080, P2D );
	vaccineImage 	= loadImage("vaccine.png");
	screenm 	= loadImage("screen.png");
	Helvetica 	= loadFont("HelveticaNeue-Bold-72.vlw");
	ellipseMode( CENTER );
	textFont( Helvetica );

}

void draw(){

	pulse += 0.02;

	float size = sin(pulse) * 15;

	background(255);

	image(screenm, 0,0 );

	fill(255, 180);
	rect( 0,0, 1920, 1060 );


				fill( 2, 191, 249 );
				ellipse( 
					(768 - 384*0.5), 
					(980), 
					(28+20), 
					(28+20)
					);
				fill(0);
				textSize( 18 );
				text( "gesund", 768-384*0.5  - 30, 1060 );

				fill( 239, 42, 22 );
				ellipse( 
					(1536 - 384*0.5), 
					(980), 
					(28+20), 
					(28+20)
					);
				fill(0);
				textSize( 18 );
				text( "krank", 1536-384*0.5  - 20, 1060 );


	fill(255, 120);
	rect( 0, 900, 1920, 180 );

	noStroke();
	textSize( 18 );




				fill( 44, 73, 153 );
				ellipse( (1152 - 384*0.5), 
					(980), 
					(28+20)*2 + size, 
					(28+20)*2 + size
					);

				fill( 2, 191, 249 );
				ellipse( 
					(1152 - 384*0.5), 
					(980), 
					(28)*2 + size, 
					(28)*2 + size
					);

				fill(0);
				textSize( 18 );
				text( "geimpft", 1152-384*0.5  - 30, 1060 );

		textSize(72);
		fill( 50 );
		text( "Impfe dein Kind bevor es krank wird!", 370, 540);

}

boolean sketchFullScreen(){

	//	Soll die Simulation im Vollbild ausgeführt werden muss die Variable fullscreen 
	//	einfach false gesetzt werden
	return true;

}



