/* This is a main file you can use to test the script. Should be integrated
into your own main file */

function onScriptLoad()
{
	dofile("scripts/waypoints/WaypointsMain.nut");
	onScriptLoadWP();
	NewTimer("RunWPTimerRespawn", 5000, 0); 
	NewTimer("RunWPTimer", 100, 0);
	CreatePeds2(500);
}


function onObjectShot(object, player, weapon)
{
	onObjectShotWP(object, player, weapon);
}

function onObjectBump(object, player)
{
	onObjectBumpWP(object, player);
}

// Functions Used in the script that you need to include

function Random(from, to)
{
	return (rand() * (to + 1 - from)) / (RAND_MAX + 1) + from;
}

function Random2(from, to)
{
	return (rand() % (to+1-from)) + from;
}

function GetRightPos(Position, Angle, Distance) // Takes in a vector of position, Angle and Distance. Returns a vector infront of the position. Works for player.Angle
{
	Distance = Distance*1.0; // turns it into float. 
	Angle = Angle - 1.57;
	local NewX, NewY;
	NewX = (Position.x  - (Distance * sin(Angle)));
	NewY = (Position.y + Distance*cos(Angle));

	return Vector(NewX, NewY, Position.z);
}