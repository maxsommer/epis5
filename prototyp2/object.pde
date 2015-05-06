//	Object
//	Die Klasse ist eine abstrakte Klasse, das bedeutet, man kann
//	kein Objekt von ihr erstellen. Stattdessen schreibt man Klassen,
//	die von dieser hier erben und erstellt Objekte davon.
//	Jedes Objekt, das in der Simulation vorkommt (sei es ein Mensch,
//	die Stadt oder ähnliches) wird von dieser Klasse erben.

interface Object{
	
	abstract void update();
	abstract void render();

}