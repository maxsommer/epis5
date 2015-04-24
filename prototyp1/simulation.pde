class Simulation{
  
	private boolean started = false;
	int numCities = 10;
	ArrayList<City> cities = new ArrayList<City>();
	ArrayList<Connection> connections = new ArrayList<Connection>();
  
	public Simulation(){

	}
  
	public void start(){
	    
		this.started = true;
		for(int i = 0; i < numCities; i++){
			cities.add(new City(cities.size()));
		}

		generateConnections();
	    
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

		for(Connection c : connections){

			c.render();

		}

	}

	public void generateConnections(){

		City currentCity = null;
		City compareCity = null;
		City nearestCity = null;
		float distance = 0;
		float distC = 0;

		for(int i = 0; i<numCities;i++){

			currentCity = cities.get(i);

			for(int j = 0; j<numCities; j++){
				compareCity = cities.get(j);

				if(distance != 0){
					distC = PVector.dist( currentCity.position, compareCity.position );

					if(distC < distance && distC != 0){
						nearestCity = compareCity;
						distance = distC;
					}
					else{
						// nicht die nächste Stadt, also weiter
					}

				}else{

					nearestCity = compareCity;
					distance = PVector.dist( currentCity.position, compareCity.position );

				}

			}

			connections.add( new Connection(connections.size(), currentCity, nearestCity ));
			distance = 0;
			distC = 0;
			nearestCity = null;

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
