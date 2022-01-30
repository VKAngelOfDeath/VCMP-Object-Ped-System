# Putting the script into your own

1. Put the following code into onScriptLoad
```
dofile("scripts/waypoints/WaypointsMain.nut");
onScriptLoadWP();
NewTimer("RunWPTimerRespawn", 5000, 0); 
NewTimer("RunWPTimer", 100, 0);
CreatePeds2(500);
```

2. Put the following code into onObjectShot.
```
onObjectShotWP(object, player, weapon);
```
2. Put the following code into onObjectBump.
```
onObjectBumpWP(object, player);
```
3. Copy paste the following functions into your functions.nut or your main file. 

```
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
```
