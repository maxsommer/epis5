class Simulation{
  
	private boolean started = false;
	int numCities = 12;
	ArrayList<City> cities = new ArrayList<City>();
  
	public Simulation(){

	}
  
	public void start(){
	    
		this.started = true;
		for(int i = 0; i < numCities; i++){
			cities.add(new City());
		}
	    
	}
  
	public boolean isStarted(){

		return started;

	}
  
	public void update(){

		for(City c : cities){

			c.update();

		}

	}
  
	public void render(){

		for(City c : cities){

			c.render();

		}

	}
  
	public boolean checkCityPlacement(City c){
	    
		for(City d : cities){
		      
			if( 
			(c.position.x + c.size/2) > (d.position.x - d.size/2)
			&&
			(c.position.x - c.size/2) < (d.position.x + d.size/2)
			&&
			(c.position.y + c.size/2) > (d.position.y - d.size/2)
			&&
			(c.position.y - c.size/2) < (d.position.y + d.size/2)
			){
			        
			return false;
			        
			}

		}
    
	return true;
    
	}
  
}
