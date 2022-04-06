# Disclaimer
This is not the best way to implement it. I just did it for fun and didn't spend much time thinking about it. The performance is good from what I could see when testing it.

# Adding the script

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

# Python Guide

NOTE: This is just a quick guide it's not meant for beginners. If you have any questions or if anything is unclear look into the code or feel free to ask me questions. 

1. The waypoints are generated using python. The script requires a paths.ipl file that it then uses to extract 5000-6000 pedestrian waypoints. It does not extract other type of waypoints like boat waypoints or vehicle waypoints.

It's recommended you use my paths.ipl file. In this file I adjusted the z position of a few waypoints that are below or above ground. I also made paths that are not part of the roads into boat waypoints (i excluded waypoints at the beach, etc). If you are using another file it's worth mentioning you gotta remove the first few lines of it that are not related to the waypoints. You can compare the first lines of my file to your own. I also recommend that you keep backups of your paths.ipl file so you don't ruin the game for yourself. 

2. To run the script you need to install python 2.7.5 or any version close to it. After the script finish running you can copy the the waypoints to the Waypoints.nut file. If you want to edit the IPL file you can use a tool like KED. 


# Debuging
You can debug or see the waypoints in-game by putting: PlayerDebugView to 0 inside onScriptLoadWP() in the WaypointsMain.nut file. This debug method increases the performance signficantly, I used it only to test the waypoints. A server restart is recommended after using the debug mode. 


# Possible updates that can be made
You may edit the script and the ipl file to add other types of waypoints as well or to add the pedestrian waypoints I excluded. 

