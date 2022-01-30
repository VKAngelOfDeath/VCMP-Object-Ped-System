
function onScriptLoadWP()
{
	WaypointsList <- array(5407, null); // 9514 Append takes ages. Put total amount of waypoints here
	Peds <- []; 
	PlayerDebugView <- -1; // Index of the player we run debug with. For now debugging just works with one person.
	PlayerDistrict <- array(100, null);
	PedSpeed <- 4.0;

	dofile("scripts/waypoints/WaypointClass.nut");
	dofile("scripts/waypoints/WaypointFunctions.nut");
	dofile("scripts/waypoints/Waypoints.nut"); // paths to load.
	dofile("scripts/waypoints/PedClass.nut");

	print("Waypoints Loaded");
}


function onObjectShotWP(object, player, weapon)
{
	foreach (i, WP in WaypointsList) 
	{
		if (WP.WayPointObj != null && WP.WayPointObj.ID == object.ID) WP.onObjectShot(player, weapon);
	}

	foreach (i, Ped in Peds) 
	{
		if (Ped.Obj != null && Ped.Obj.ID == object.ID) Ped.onObjectShot(player, weapon);
	}
	
}

function onObjectBumpWP(object, player)
{
	foreach (i, WP in WaypointsList) 
	{
		if (WP.WayPointObj != null && WP.WayPointObj.ID == object.ID) WP.onObjectBump(player);
	}
	
}