class City{

	int id;
  	PVector position;
  	float size;
  
  	public City(int _id){

  		id = _id;
    		size = random(10, 125);
		position = new PVector(random(size/2,windowX-size/2),random(size/2,windowY-size/2),0);

		while(sim.checkCityPlacement(this) == false){
			reassignPosition();
		}

  	}
  
	public void update(){
	    
	}
  
	public void render(){
		fill(0,128,128,128);
		noStroke();
		ellipse(position.x, position.y, size, size);

		fill(255,255,255, 128);
		ellipse(position.x, position.y, 5,5);
	}
  
	public void reassignPosition(){
		position = new PVector(random(size/2,windowX-size/2),random(size/2,windowY-size/2),0);
		println(++reassignNeeds);
	}

}