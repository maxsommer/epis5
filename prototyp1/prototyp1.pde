/*
/
/	to do:
/	
/	- kommentieren
/	- doppelte connection zwischen städten verhindern
/	- alle einzelnen verbindungskreise verbinden
/	
/	- menschen hinzufügen
/	- "leben" simulieren (arbeiten, zuhause sein, pendeln, ...)
/	- infektion simulieren (bei x nähe, ansteckunswahrscheinlichkeit)
/
*/

Simulation sim = new Simulation();
int reassignNeeds = 0;

int windowX = 800;
int windowY = 800;

void setup(){
  
 	size(windowX,windowY,P2D);

}

void draw(){
  
 	background(0);
  
 	if(sim.isStarted()){
    		sim.update();
    		sim.render();
  	}
  	else{
    		sim.start();
 	 }
  
}
