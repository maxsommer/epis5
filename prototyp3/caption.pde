//	caption.pde
//	Die Klasse Caption ist für die Legende zuständig
//	

class Caption{

	Human h1 = new Human( 50, windowResolution.y - 190, false );
	Human h2 = new Human( 50, windowResolution.y - 150, false );
	Human h3 = new Human( 50, windowResolution.y - 110, false );
	Human h4 = new Human( 50, windowResolution.y - 70, false );
	Human h5 = new Human( 50, windowResolution.y - 30, false );

	Caption(){

		h2.setState( 1 );
		h2.timer.reset();
		h3.setState( 2 );
		h3.timer.reset();
		h4.setState( 3 );
		h4.timer.reset();
		h5.setState( 4 );
		h5.timer.reset();

	}

	void update(){

		h1.update();
		h2.update();
		h3.update();
		h4.update();
		h5.update();

	}

	void render(){

		h1.render();
		fill(0);
		text( "Gesund", h1.getPosition().x  + 20, h1.getPosition().y + 2.5 );

		h2.render();
		fill(0);
		text( "Infiziert, ohne Symptome", h2.getPosition().x  + 20, h2.getPosition().y + 2.5 );

		h3.render();
		fill(0);
		text( "Infiziert, mit Symptomen", h3.getPosition().x  + 20, h3.getPosition().y + 2.5 );

		h4.render();
		fill(0);
		text( "Im Krankenhaus", h4.getPosition().x  + 20, h4.getPosition().y + 2.5 );

		h5.render();
		fill(0);
		text( "Geimpft", h5.getPosition().x  + 20, h5.getPosition().y + 2.5 );


	}

}