class Connection{

	int id;
	float quality;
	City c1, c2;
	
	public Connection(int _id, City _c1, City _c2){

		id = _id;
		c1 = _c1;
		c2 = _c2;
		quality = ((c1.size+ c2.size) / 2) / 15;

	}

	public void update(){

	}

	public void render(){

		noFill();
		stroke(0,128,128, 200);
		strokeWeight((int)quality);
		line(c1.position.x, c1.position.y, c2.position.x, c2.position.y);

	}

}