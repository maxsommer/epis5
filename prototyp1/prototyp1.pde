Simulation sim = new Simulation();
int reassignNeeds = 0;

int windowX = 800;
int windowY = 800;

void setup(){
  
 	size(windowX,windowY,P2D);

}

void draw(){
  
 	background(255);
  
 	if(sim.isStarted()){
    		sim.update();
    		sim.render();
  	}
  	else{
    		sim.start();
 	 }
  
}
